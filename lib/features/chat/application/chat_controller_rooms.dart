part of 'chat_controller.dart';

Future<void> _chatInitialize(ChatController controller) async {
  if (controller._listPhase != AsyncPhase.idle) {
    return;
  }
  await _chatLoadRooms(controller);
}

Future<void> _chatRetryRooms(ChatController controller) {
  return _chatLoadRooms(controller);
}

Future<void> _chatRetryRoom(ChatController controller) async {
  final roomId = controller._selectedRoomId;
  if (roomId == null) {
    return;
  }
  await _chatOpenRoom(controller, roomId: roomId);
}

Future<void> _chatOpenRoom(
  ChatController controller, {
  required String roomId,
}) async {
  _chatStopRealtime(controller);
  controller._selectedRoomId = roomId;
  controller._roomPhase = AsyncPhase.loading;
  controller._roomErrorMessage = null;
  controller._draft = '';
  controller._draftAttachments = const <ChatAttachment>[];
  _chatMarkRoomAsRead(controller, roomId);
  controller._notifyChanged();

  try {
    final room = await controller._repository.fetchRoom(roomId);
    final firstPage = await controller._repository.fetchRoomMessagesPage(
      roomId: roomId,
      page: 0,
    );
    _chatReplaceRoom(controller, room.copyWith(unreadCount: 0));
    controller._hasOlderMessages = firstPage.hasNext;
    controller._nextRoomMessagesPage = firstPage.nextPage;
    try {
      await controller._repository.markRoomAsRead(roomId);
    } on ChatRepositoryException {
      controller._pushToast('읽음 상태를 서버에 반영하지 못했어요. 다음에 다시 시도합니다.');
    }
    _chatStartRealtime(controller, roomId: roomId);
    controller._roomPhase = AsyncPhase.success;
    controller._roomErrorMessage = null;
  } on ChatRepositoryException catch (error) {
    controller._roomPhase = error.type == ChatLoadFailureType.network
        ? AsyncPhase.networkError
        : AsyncPhase.serverError;
    controller._roomErrorMessage =
        error.message ??
        (error.type == ChatLoadFailureType.network
            ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
            : '채팅방을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
  } catch (_) {
    controller._roomPhase = AsyncPhase.serverError;
    controller._roomErrorMessage = '채팅방을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
  }

  controller._notifyChanged();
}

Future<void> _chatLoadMoreRooms(ChatController controller) async {
  if (controller._isLoadingMoreRooms ||
      !controller._hasMoreRooms ||
      controller._nextRoomsPage == null) {
    return;
  }

  controller._isLoadingMoreRooms = true;
  controller._notifyChanged();
  try {
    final pageResult = await controller._repository.fetchRoomsPage(
      page: controller._nextRoomsPage!,
    );
    final merged = <String, ChatRoom>{
      for (final room in controller._rooms) room.id: room,
      for (final room in pageResult.rooms) room.id: room,
    };
    controller._rooms = merged.values.toList()
      ..sort(
        (left, right) => right.lastMessageAt.compareTo(left.lastMessageAt),
      );
    controller._hasMoreRooms = pageResult.hasNext;
    controller._nextRoomsPage = pageResult.nextPage;
  } on ChatRepositoryException catch (error) {
    controller._pushToast(
      error.message ??
          (error.type == ChatLoadFailureType.network
              ? '채팅 목록을 더 불러오지 못했어요. 네트워크를 확인해 주세요.'
              : '채팅 목록을 더 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'),
    );
  } finally {
    controller._isLoadingMoreRooms = false;
    controller._notifyChanged();
  }
}

Future<void> _chatLoadOlderMessages(ChatController controller) async {
  final roomId = controller._selectedRoomId;
  final room = controller.currentRoom;
  if (roomId == null ||
      room == null ||
      controller._isLoadingOlderMessages ||
      !controller._hasOlderMessages ||
      controller._nextRoomMessagesPage == null) {
    return;
  }

  controller._isLoadingOlderMessages = true;
  controller._notifyChanged();
  try {
    final pageResult = await controller._repository.fetchRoomMessagesPage(
      roomId: roomId,
      page: controller._nextRoomMessagesPage!,
    );
    final updatedRoom = room.copyWith(
      messageGroups: <ChatMessageGroup>[
        ...pageResult.groups,
        ...room.messageGroups,
      ],
    );
    _chatReplaceRoom(controller, updatedRoom);
    controller._hasOlderMessages = pageResult.hasNext;
    controller._nextRoomMessagesPage = pageResult.nextPage;
  } on ChatRepositoryException catch (error) {
    controller._pushToast(
      error.message ??
          (error.type == ChatLoadFailureType.network
              ? '이전 메시지를 불러오지 못했어요. 네트워크를 확인해 주세요.'
              : '이전 메시지를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'),
    );
  } finally {
    controller._isLoadingOlderMessages = false;
    controller._notifyChanged();
  }
}

void _chatCloseRoom(ChatController controller) {
  _chatStopRealtime(controller);
  controller._selectedRoomId = null;
  controller._roomPhase = AsyncPhase.idle;
  controller._roomErrorMessage = null;
  controller._draft = '';
  controller._draftAttachments = const <ChatAttachment>[];
  controller._notifyChanged();
}

Future<void> _chatLoadRooms(ChatController controller) async {
  controller._listPhase = AsyncPhase.loading;
  controller._listErrorMessage = null;
  controller._notifyChanged();

  try {
    final pageResult = await controller._repository.fetchRoomsPage(page: 0);
    controller._rooms = pageResult.rooms.toList()
      ..sort(
        (left, right) => right.lastMessageAt.compareTo(left.lastMessageAt),
      );
    controller._hasMoreRooms = pageResult.hasNext;
    controller._nextRoomsPage = pageResult.nextPage;
    controller._listPhase = AsyncPhase.success;
    controller._listErrorMessage = null;
  } on ChatRepositoryException catch (error) {
    controller._listPhase = error.type == ChatLoadFailureType.network
        ? AsyncPhase.networkError
        : AsyncPhase.serverError;
    controller._listErrorMessage =
        error.message ??
        (error.type == ChatLoadFailureType.network
            ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
            : '채팅 목록을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
  } catch (_) {
    controller._listPhase = AsyncPhase.serverError;
    controller._listErrorMessage = '채팅 목록을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
  }

  controller._notifyChanged();
}

void _chatMarkRoomAsRead(ChatController controller, String roomId) {
  controller._rooms = controller._rooms
      .map((room) => room.id == roomId ? room.copyWith(unreadCount: 0) : room)
      .toList(growable: false);
}

void _chatReplaceRoom(
  ChatController controller,
  ChatRoom nextRoom, {
  bool moveToTop = false,
}) {
  final updated = controller._rooms
      .where((room) => room.id != nextRoom.id)
      .toList(growable: true);
  if (moveToTop) {
    updated.insert(0, nextRoom);
  } else {
    updated.add(nextRoom);
    updated.sort(
      (left, right) => right.lastMessageAt.compareTo(left.lastMessageAt),
    );
  }
  controller._rooms = updated;
}
