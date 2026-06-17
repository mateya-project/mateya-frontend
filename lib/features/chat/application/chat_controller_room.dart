part of 'chat_controller.dart';

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
