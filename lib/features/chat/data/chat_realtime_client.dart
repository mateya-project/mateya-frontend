import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/logging/app_logger.dart';
import '../domain/chat_models.dart';

typedef ChatRealtimeMessageCallback = void Function(ChatMessageGroup message);
typedef ChatRealtimeErrorCallback = void Function(String message);

class ChatRealtimeClient {
  ChatRealtimeClient({
    AuthSessionStore? sessionStore,
    AppLogger? logger,
    DateTime Function()? now,
  }) : _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _logger = logger ?? AppLogger.instance,
       _now = now ?? DateTime.now;

  static const Duration _reconnectDelay = Duration(seconds: 3);
  static const Duration _heartbeatInterval = Duration(seconds: 10);
  static const Duration _connectionTimeout = Duration(seconds: 5);
  static const Duration _realtimeUnavailableCooldown = Duration(minutes: 5);
  static const String _subscriptionDestinationPrefix = '/topic/chat.rooms.';

  final AuthSessionStore _sessionStore;
  final AppLogger _logger;
  final DateTime Function() _now;

  StompClient? _client;
  StompUnsubscribe? _unsubscribe;
  String? _roomId;
  ChatRealtimeMessageCallback? _onMessage;
  ChatRealtimeErrorCallback? _onError;
  bool _hasConnectedInCurrentSession = false;
  bool _hasReportedInitialConnectionFailure = false;
  DateTime? _realtimeUnavailableUntil;

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
    _hasConnectedInCurrentSession = false;
    _hasReportedInitialConnectionFailure = false;
    _logger.info(
      'Chat realtime subscription requested',
      context: _logContext(
        roomId,
        reconnectDelay: _reconnectDelay.inSeconds,
        url: _webSocketUrl(),
      ),
    );

    if (_isRealtimeTemporarilyUnavailable) {
      _logger.info(
        'Chat realtime skipped because websocket is temporarily unavailable',
        context: _logContext(
          roomId,
          url: _webSocketUrl(),
          nextRetryAt: _realtimeUnavailableUntil?.toIso8601String(),
        ),
      );
      return;
    }

    final stompConnectHeaders = <String, String>{};
    late final StompClient client;
    client = StompClient(
      config: StompConfig(
        url: _webSocketUrl(),
        reconnectDelay: _reconnectDelay,
        heartbeatIncoming: _heartbeatInterval,
        heartbeatOutgoing: _heartbeatInterval,
        connectionTimeout: _connectionTimeout,
        stompConnectHeaders: stompConnectHeaders,
        beforeConnect: () async {
          final currentAccessToken = _sessionStore.session?.accessToken;
          if (currentAccessToken == null || currentAccessToken.isEmpty) {
            _logger.warning(
              'Chat realtime connect cancelled because access token is missing',
              context: _logContext(roomId, url: _webSocketUrl()),
            );
            client.deactivate();
            _reportConnectionError(
              MateyaLocalizations.current.chatRealtimeConnectionError,
            );
            return;
          }

          stompConnectHeaders
            ..clear()
            ..['Authorization'] = 'Bearer $currentAccessToken';
          _logger.debug(
            'Chat realtime before connect',
            context: _logContext(
              roomId,
              hasAuthorizationHeader: true,
              destination: _subscriptionDestination(roomId),
            ),
          );
        },
        onConnect: (_) {
          _hasConnectedInCurrentSession = true;
          _hasReportedInitialConnectionFailure = false;
          _realtimeUnavailableUntil = null;
          _logger.info(
            'Chat realtime connected',
            context: _logContext(
              roomId,
              destination: _subscriptionDestination(roomId),
            ),
          );
          _unsubscribe?.call();
          _unsubscribe = client.subscribe(
            destination: _subscriptionDestination(roomId),
            callback: (frame) => _handleFrame(frame, parseMessage),
          );
          _logger.info(
            'Chat realtime subscription established',
            context: _logContext(
              roomId,
              destination: _subscriptionDestination(roomId),
            ),
          );
        },
        onDisconnect: (frame) {
          _logger.info(
            'Chat realtime STOMP disconnected',
            context: _logContext(
              roomId,
              command: frame.command,
              body: _trimFrameBody(frame.body),
            ),
          );
        },
        onStompError: (frame) {
          _logger.warning(
            'Chat realtime STOMP error received',
            context: _logContext(
              roomId,
              command: frame.command,
              headerKeys: frame.headers.isEmpty ? null : frame.headers.keys,
              body: _trimFrameBody(frame.body),
            ),
          );
          _reportConnectionError(
            frame.body ??
                MateyaLocalizations.current.chatRealtimeConnectionError,
          );
          _pauseRealtimeAfterInitialFailure(roomId, error: frame.body);
        },
        onWebSocketError: (error) {
          if (_pauseRealtimeAfterInitialFailure(roomId, error: error)) {
            return;
          }
          _logInitialConnectionWarning(
            roomId,
            'Chat realtime WebSocket error received',
            error,
          );
        },
        onWebSocketDone: () {
          if (_pauseRealtimeAfterInitialFailure(roomId)) {
            return;
          }
          _logger.info(
            'Chat realtime WebSocket done',
            context: _logContext(roomId),
          );
        },
        onUnhandledFrame: (frame) {
          _logger.warning(
            'Chat realtime unhandled frame received',
            context: _logContext(
              roomId,
              command: frame.command,
              headerKeys: frame.headers.isEmpty ? null : frame.headers.keys,
              body: _trimFrameBody(frame.body),
            ),
          );
        },
        onUnhandledMessage: (frame) {
          _logger.warning(
            'Chat realtime unhandled message received',
            context: _logContext(
              roomId,
              command: frame.command,
              headerKeys: frame.headers.isEmpty ? null : frame.headers.keys,
              body: _trimFrameBody(frame.body),
            ),
          );
        },
        onUnhandledReceipt: (frame) {
          _logger.warning(
            'Chat realtime unhandled receipt received',
            context: _logContext(
              roomId,
              command: frame.command,
              headerKeys: frame.headers.isEmpty ? null : frame.headers.keys,
              body: _trimFrameBody(frame.body),
            ),
          );
        },
        onDebugMessage: (message) {
          if (!_shouldLogDebugMessage(message)) {
            return;
          }
          _logger.debug(
            'Chat realtime debug message received',
            context: _logContext(roomId, message: message),
          );
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
    _hasConnectedInCurrentSession = false;
    _hasReportedInitialConnectionFailure = false;
    if (roomId != null) {
      _logger.info('Chat realtime disconnected', context: _logContext(roomId));
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
      _reportError(MateyaLocalizations.current.chatRealtimeMessageError);
    }
  }

  void _reportError(String message) {
    if (_roomId == null) {
      return;
    }
    _onError?.call(message);
  }

  void _reportConnectionError(String message) {
    if (_roomId == null) {
      return;
    }
    if (_hasConnectedInCurrentSession) {
      _logger.info(
        'Chat realtime connection error suppressed after successful connect',
        context: _logContext(_roomId!, message: message),
      );
      return;
    }
    if (_hasReportedInitialConnectionFailure) {
      _logger.debug(
        'Chat realtime duplicate initial connection error suppressed',
        context: _logContext(_roomId!, message: message),
      );
      return;
    }
    _hasReportedInitialConnectionFailure = true;
    _reportError(message);
  }

  Map<String, Object?> _logContext(
    String roomId, {
    String? destination,
    String? command,
    Iterable<String>? headerKeys,
    String? body,
    String? message,
    String? url,
    String? nextRetryAt,
    bool? hasAuthorizationHeader,
    int? reconnectDelay,
  }) {
    final context = <String, Object?>{'roomId': roomId};
    if (destination != null) {
      context['destination'] = destination;
    }
    if (command != null) {
      context['command'] = command;
    }
    if (headerKeys != null) {
      context['headerKeys'] = headerKeys.toSet().toList(growable: false);
    }
    if (body != null) {
      context['bodyLength'] = body.length;
    }
    if (message != null) {
      context['messageLength'] = message.length;
    }
    if (url != null) {
      context['url'] = url;
    }
    if (hasAuthorizationHeader != null) {
      context['hasAuthorizationHeader'] = hasAuthorizationHeader;
    }
    if (reconnectDelay != null) {
      context['reconnectDelaySeconds'] = reconnectDelay;
    }
    if (nextRetryAt != null) {
      context['nextRetryAt'] = nextRetryAt;
    }
    return context;
  }

  String _subscriptionDestination(String roomId) =>
      '$_subscriptionDestinationPrefix$roomId';

  String? _trimFrameBody(String? body) {
    if (body == null) {
      return null;
    }
    const maxLength = 240;
    final trimmed = body.trim();
    if (trimmed.length <= maxLength) {
      return trimmed;
    }
    return '${trimmed.substring(0, maxLength)}...';
  }

  bool _shouldLogDebugMessage(String message) {
    const interestingTokens = <String>[
      'opening web socket',
      'connected',
      'subscrib',
      'stomp',
      'error',
      'disconnect',
      'reconnect',
      'heartbeat',
    ];
    final normalized = message.toLowerCase();
    return interestingTokens.any(normalized.contains);
  }

  String _webSocketUrl() {
    return buildChatWebSocketUrl(AppConfig.apiBaseUrl);
  }

  bool get _isRealtimeTemporarilyUnavailable {
    final until = _realtimeUnavailableUntil;
    if (until == null) {
      return false;
    }
    return until.isAfter(_now());
  }

  void _logInitialConnectionWarning(
    String roomId,
    String message,
    Object error,
  ) {
    if (_hasConnectedInCurrentSession || _hasReportedInitialConnectionFailure) {
      _logger.debug(
        'Chat realtime repeated connection error suppressed',
        context: _logContext(roomId, message: '$error', url: _webSocketUrl()),
      );
      return;
    }
    _logger.warning(
      message,
      error: error,
      context: _logContext(roomId, url: _webSocketUrl()),
    );
  }

  bool _pauseRealtimeAfterInitialFailure(String roomId, {Object? error}) {
    if (_hasConnectedInCurrentSession || _roomId != roomId) {
      return false;
    }

    final now = _now();
    final wasAlreadyUnavailable =
        _realtimeUnavailableUntil != null &&
        _realtimeUnavailableUntil!.isAfter(now);
    _realtimeUnavailableUntil = now.add(_realtimeUnavailableCooldown);
    _unsubscribe?.call();
    _unsubscribe = null;
    final client = _client;
    _client = null;
    client?.deactivate();

    if (wasAlreadyUnavailable) {
      return true;
    }

    _logger.warning(
      'Chat realtime disabled after initial websocket failure',
      error: error,
      context: _logContext(
        roomId,
        url: _webSocketUrl(),
        nextRetryAt: _realtimeUnavailableUntil?.toIso8601String(),
      ),
    );
    return true;
  }
}

String buildChatWebSocketUrl(String apiBaseUrl) {
  final uri = Uri.parse(apiBaseUrl.trim());
  final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
  if (uri.hasPort) {
    return Uri(
      scheme: scheme,
      host: uri.host,
      port: uri.port,
      path: '/ws',
    ).toString();
  }
  return Uri(scheme: scheme, host: uri.host, path: '/ws').toString();
}
