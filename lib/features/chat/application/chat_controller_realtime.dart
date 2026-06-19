part of 'chat_controller.dart';

void _chatStartRealtime(ChatController controller, {required String roomId}) {
  controller._repository.subscribeToRoomMessages(
    roomId: roomId,
    onMessage: (message) =>
        _chatMergeRealtimeMessage(controller, roomId: roomId, message: message),
    onError: (message) {
      controller._pushToast(message);
      controller._notifyChanged();
    },
  );
}

void _chatStopRealtime(ChatController controller) {
  controller._repository.unsubscribeFromRoomMessages();
}

void _chatMergeRealtimeMessage(
  ChatController controller, {
  required String roomId,
  required ChatMessageGroup message,
}) {
  final room = controller.currentRoom;
  if (room == null || room.id != roomId) {
    return;
  }

  final existingIndex = room.messageGroups.indexWhere(
    (group) => group.id == message.id,
  );
  if (existingIndex != -1) {
    return;
  }

  final pendingIndex = message.isMine
      ? room.messageGroups.lastIndexWhere(
          (group) =>
              group.isMine &&
              group.id.startsWith('pending-') &&
              _chatSameBubbles(group.bubbles, message.bubbles),
        )
      : -1;

  final nextGroups = room.messageGroups.toList(growable: true);
  if (pendingIndex != -1) {
    nextGroups[pendingIndex] = message;
  } else {
    nextGroups.add(message);
  }

  final nextLastMessageAt =
      room.lastMessageAt == null || message.sentAt.isAfter(room.lastMessageAt!)
      ? message.sentAt
      : room.lastMessageAt;

  final updatedRoom = room.copyWith(
    lastMessageAt: nextLastMessageAt,
    unreadCount: 0,
    messageGroups: nextGroups,
  );
  controller._roomPhase = AsyncPhase.success;
  controller._roomErrorMessage = null;
  _chatReplaceRoom(controller, updatedRoom, moveToTop: true);
  controller._notifyChanged();

  if (!message.isMine) {
    unawaited(controller._repository.markRoomAsRead(roomId));
  }
}

bool _chatSameBubbles(List<ChatBubble> left, List<ChatBubble> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    final leftBubble = left[index];
    final rightBubble = right[index];
    if (leftBubble.originalText != rightBubble.originalText ||
        leftBubble.translatedText != rightBubble.translatedText) {
      return false;
    }
    if (leftBubble.attachments.length != rightBubble.attachments.length) {
      return false;
    }
    for (
      var attachmentIndex = 0;
      attachmentIndex < leftBubble.attachments.length;
      attachmentIndex += 1
    ) {
      if (leftBubble.attachments[attachmentIndex].path !=
          rightBubble.attachments[attachmentIndex].path) {
        return false;
      }
    }
  }
  return true;
}
