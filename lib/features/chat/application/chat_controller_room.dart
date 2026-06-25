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
  final l10n = MateyaLocalizations.current;
  _chatStopRealtime(controller);
  controller._selectedRoomId = roomId;
  controller._roomPhase = AsyncPhase.loading;
  controller._roomErrorMessage = null;
  controller._draft = '';
  controller._draftAttachments = const <ChatAttachment>[];
  _chatMarkRoomAsRead(controller, roomId);
  controller._notifyChanged();

  try {
    final room = await controller.repository.fetchRoom(roomId);
    if (!controller._canMutateState) {
      return;
    }
    final firstPage = await controller.repository.fetchRoomMessagesPage(
      roomId: roomId,
      page: 0,
    );
    if (!controller._canMutateState) {
      return;
    }
    _chatReplaceRoom(controller, room.copyWith(unreadCount: 0));
    controller._hasOlderMessages = firstPage.hasNext;
    controller._nextRoomMessagesPage = firstPage.nextPage;
    try {
      await controller.repository.markRoomAsRead(roomId);
      if (!controller._canMutateState) {
        return;
      }
    } on ChatRepositoryException {
      controller._pushToast(l10n.chatReadSyncFailed);
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
            ? l10n.commonNetworkRetry
            : l10n.chatRoomLoadError);
  } catch (_) {
    controller._roomPhase = AsyncPhase.serverError;
    controller._roomErrorMessage = l10n.chatRoomLoadError;
  }

  controller._notifyChanged();
}

Future<void> _chatLoadOlderMessages(ChatController controller) async {
  final l10n = MateyaLocalizations.current;
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
    final pageResult = await controller.repository.fetchRoomMessagesPage(
      roomId: roomId,
      page: controller._nextRoomMessagesPage!,
    );
    if (!controller._canMutateState) {
      return;
    }
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
              ? l10n.chatOlderMessagesFailedNetwork
              : l10n.chatOlderMessagesFailedServer),
    );
  } finally {
    controller._isLoadingOlderMessages = false;
    controller._notifyChanged();
  }
}

void _chatCloseRoom(ChatController controller) {
  _chatResetSelectedRoom(controller);
}

void _chatResetSelectedRoom(ChatController controller, {bool notify = true}) {
  _chatStopRealtime(controller);
  controller._selectedRoomId = null;
  controller._roomPhase = AsyncPhase.idle;
  controller._roomErrorMessage = null;
  controller._draft = '';
  controller._draftAttachments = const <ChatAttachment>[];
  controller._hasOlderMessages = false;
  controller._nextRoomMessagesPage = null;
  controller._isLoadingOlderMessages = false;
  if (notify) {
    controller._notifyChanged();
  }
}
