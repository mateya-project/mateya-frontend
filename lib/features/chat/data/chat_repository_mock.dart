part of 'chat_repository.dart';

class MockChatRepository implements ChatRepository {
  @override
  Future<List<ChatRoom>> fetchRooms() async {
    final result = await fetchRoomsPage(page: 0);
    return result.rooms;
  }

  @override
  Future<ChatRoomPageResult> fetchRoomsPage({required int page}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    const pageSize = 2;
    final start = page * pageSize;
    if (start >= _mockRooms.length) {
      return const ChatRoomPageResult(
        rooms: <ChatRoom>[],
        hasNext: false,
        nextPage: null,
      );
    }
    final end = (start + pageSize).clamp(0, _mockRooms.length);
    final hasNext = end < _mockRooms.length;
    return ChatRoomPageResult(
      rooms: _mockRooms
          .sublist(start, end)
          .map(_cloneRoom)
          .toList(growable: false),
      hasNext: hasNext,
      nextPage: hasNext ? page + 1 : null,
    );
  }

  @override
  Future<ChatRoom> fetchRoom(String roomId) async {
    final pageResult = await fetchRoomMessagesPage(roomId: roomId, page: 0);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final room = _mockRooms.where((item) => item.id == roomId).firstOrNull;
    if (room == null) {
      throw const ChatRepositoryException(ChatLoadFailureType.server);
    }
    return _cloneRoom(room).copyWith(messageGroups: pageResult.groups);
  }

  @override
  Future<ChatMessagePageResult> fetchRoomMessagesPage({
    required String roomId,
    required int page,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final room = _mockRooms.where((item) => item.id == roomId).firstOrNull;
    if (room == null) {
      throw const ChatRepositoryException(ChatLoadFailureType.server);
    }
    const pageSize = 2;
    final groups = room.messageGroups;
    final reversed = groups.reversed.toList(growable: false);
    final start = page * pageSize;
    if (start >= reversed.length) {
      return const ChatMessagePageResult(
        groups: <ChatMessageGroup>[],
        hasNext: false,
        nextPage: null,
      );
    }
    final end = (start + pageSize).clamp(0, reversed.length);
    final pageGroups = reversed
        .sublist(start, end)
        .reversed
        .map(_cloneGroup)
        .toList(growable: false);
    final hasNext = end < reversed.length;
    return ChatMessagePageResult(
      groups: pageGroups,
      hasNext: hasNext,
      nextPage: hasNext ? page + 1 : null,
    );
  }

  @override
  Future<ChatMessageGroup> fetchMessage({
    required String roomId,
    required String messageId,
    required bool original,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final room = _mockRooms.where((item) => item.id == roomId).firstOrNull;
    final group = room?.messageGroups
        .where((item) => item.id == messageId)
        .firstOrNull;
    if (group == null) {
      throw const ChatRepositoryException(ChatLoadFailureType.server);
    }
    if (original) {
      return _cloneGroup(group).copyWith(isTranslatedVisible: false);
    }
    return _cloneGroup(group).copyWith(isTranslatedVisible: true);
  }

  @override
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return <ChatBubble>[
      ChatBubble(
        originalText: text.trim().isEmpty ? null : text.trim(),
        attachments: attachments,
      ),
    ];
  }

  @override
  Future<void> markRoomAsRead(String roomId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }

  @override
  void subscribeToRoomMessages({
    required String roomId,
    required void Function(ChatMessageGroup message) onMessage,
    required void Function(String message) onError,
  }) {}

  @override
  void unsubscribeFromRoomMessages() {}

  @override
  bool isRealtimeConnectedForRoom(String roomId) => false;

  @override
  void dispose() {}
}
