import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/logging/app_logger.dart';
import '../domain/chat_models.dart';

typedef ChatRealtimeMessageCallback = void Function(ChatMessageGroup message);
typedef ChatRealtimeErrorCallback = void Function(String message);

class ChatRealtimeClient {
  ChatRealtimeClient({AuthSessionStore? sessionStore, AppLogger? logger})
    : _sessionStore = sessionStore ?? AuthSessionStore.instance,
      _logger = logger ?? AppLogger.instance;

  final AuthSessionStore _sessionStore;
  final AppLogger _logger;

  StompClient? _client;
  StompUnsubscribe? _unsubscribe;
  String? _roomId;
  ChatRealtimeMessageCallback? _onMessage;
  ChatRealtimeErrorCallback? _onError;

  bool isConnectedForRoom(String roomId) =>
      _roomId == roomId && (_client?.connected ?? false);

  void subscribeToRoom({
    required String roomId,
    required ChatRealtimeMessageCallback onMessage,
    required ChatRealtimeErrorCallback onError,
    required ChatMessageGroup Function(Map<String, dynamic>) parseMessage,
  }) {
    if (_roomId == roomId && _client != null) {
      _onMessage = onMessage;
      _onError = onError;
      _logger.debug(
        'Chat realtime subscription callback updated',
        context: <String, Object?>{'roomId': roomId},
      );
      return;
    }

    disconnect();

    final accessToken = _sessionStore.session?.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      _logger.warning(
        'Chat realtime subscription skipped because access token is missing',
        context: <String, Object?>{'roomId': roomId},
      );
      return;
    }

    _roomId = roomId;
    _onMessage = onMessage;
    _onError = onError;
    _logger.info(
      'Chat realtime subscription requested',
      context: <String, Object?>{'roomId': roomId},
    );

    late final StompClient client;
    client = StompClient(
      config: StompConfig(
        url: _webSocketUrl(),
        reconnectDelay: const Duration(seconds: 3),
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
        connectionTimeout: const Duration(seconds: 5),
        stompConnectHeaders: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
        onConnect: (_) {
          _logger.info(
            'Chat realtime connected',
            context: <String, Object?>{'roomId': roomId},
          );
          _unsubscribe?.call();
          _unsubscribe = client.subscribe(
            destination: '/topic/chat.rooms.$roomId',
            callback: (frame) => _handleFrame(frame, parseMessage),
          );
        },
        onStompError: (frame) {
          _logger.warning(
            'Chat realtime STOMP error received',
            context: <String, Object?>{
              'roomId': roomId,
              'command': frame.command,
            },
          );
          _reportError(frame.body ?? '실시간 채팅 연결에 실패했어요.');
        },
        onWebSocketError: (error) {
          _logger.warning(
            'Chat realtime WebSocket error received',
            error: error,
            context: <String, Object?>{'roomId': roomId},
          );
          _reportError('실시간 채팅 연결에 실패했어요.');
        },
      ),
    );

    _client = client;
    client.activate();
  }

  void disconnect() {
    final roomId = _roomId;
    _unsubscribe?.call();
    _unsubscribe = null;
    _client?.deactivate();
    _client = null;
    _roomId = null;
    _onMessage = null;
    _onError = null;
    if (roomId != null) {
      _logger.info(
        'Chat realtime disconnected',
        context: <String, Object?>{'roomId': roomId},
      );
    }
  }

  void _handleFrame(
    StompFrame frame,
    ChatMessageGroup Function(Map<String, dynamic>) parseMessage,
  ) {
    final body = frame.body;
    if (body == null || body.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid chat payload');
      }
      _onMessage?.call(parseMessage(decoded));
    } catch (error, stackTrace) {
      _logger.warning(
        'Chat realtime message parsing failed',
        error: error,
        stackTrace: stackTrace,
        context: <String, Object?>{'roomId': _roomId},
      );
      _reportError('실시간 채팅 메시지를 처리하지 못했어요.');
    }
  }

  void _reportError(String message) {
    if (_roomId == null) {
      return;
    }
    _onError?.call(message);
  }

  String _webSocketUrl() {
    final uri = Uri.parse(AppConfig.apiBaseUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    return uri.replace(scheme: scheme, path: '/ws').toString();
  }
}
