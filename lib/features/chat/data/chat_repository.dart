import 'dart:io';

import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/localization/app_locale_controller.dart';
import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/network/http_transport.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../../../shared/preferences/mateya_language_preferences.dart';
import '../../../shared/time/korean_time.dart';
import 'chat_realtime_client.dart';
import '../domain/chat_models.dart';

part 'chat_repository_api.dart';
part 'chat_repository_mock.dart';
part 'chat_repository_api_support.dart';
part 'chat_repository_mock_support.dart';

class ChatRoomPageResult {
  const ChatRoomPageResult({
    required this.rooms,
    required this.hasNext,
    required this.nextPage,
  });

  final List<ChatRoom> rooms;
  final bool hasNext;
  final int? nextPage;
}

class ChatMessagePageResult {
  const ChatMessagePageResult({
    required this.groups,
    required this.hasNext,
    required this.nextPage,
  });

  final List<ChatMessageGroup> groups;
  final bool hasNext;
  final int? nextPage;
}

abstract interface class ChatRepository {
  Future<List<ChatRoom>> fetchRooms();
  Future<ChatRoom> fetchRoom(String roomId);
  Future<ChatRoomPageResult> fetchRoomsPage({required int page});
  Future<ChatMessagePageResult> fetchRoomMessagesPage({
    required String roomId,
    required int page,
  });
  Future<ChatMessageGroup> fetchMessage({
    required String roomId,
    required String messageId,
    required bool original,
  });
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  });
  Future<void> markRoomAsRead(String roomId);
  void subscribeToRoomMessages({
    required String roomId,
    required void Function(ChatMessageGroup message) onMessage,
    required void Function(String message) onError,
  });
  void unsubscribeFromRoomMessages();
  bool isRealtimeConnectedForRoom(String roomId);
  void dispose();
}
