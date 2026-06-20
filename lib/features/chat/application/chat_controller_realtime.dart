part of 'chat_controller.dart';

void _chatStartRealtime(ChatController controller, {required String roomId}) {
  controller.repository.subscribeToRoomMessages(
    roomId: roomId,
    onMessage: (message) {
      if (!controller._canMutateState) {
        return;
      }
      _chatMergeRealtimeMessage(controller, roomId: roomId, message: message);
    },
    onError: (message) {
      if (!controller._canMutateState) {
        return;
      }
      controller._pushToast(message);
      controller._notifyChanged();
    },
  );
  _chatStartRealtimeFallbackPolling(controller, roomId: roomId);
}

void _chatStopRealtime(ChatController controller) {
  controller._realtimeFallbackPollTimer?.cancel();
  controller._realtimeFallbackPollTimer = null;
  controller._isPollingRealtimeFallback = false;
  controller.repository.unsubscribeFromRoomMessages();
}

void _chatMergeRealtimeMessage(
  ChatController controller, {
  required String roomId,
  required ChatMessageGroup message,
}) {
  if (!controller._canMutateState) {
    return;
  }
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

  final nextGroups = room.messageGroups.toList(growable: true);
  final mergedGroups = _chatMergeIncomingGroups(nextGroups, <ChatMessageGroup>[
    message,
  ]);

  final nextLastMessageAt = mergedGroups.isEmpty
      ? room.lastMessageAt
      : mergedGroups.last.sentAt;

  final updatedRoom = room.copyWith(
    lastMessageAt: nextLastMessageAt,
    unreadCount: 0,
    messageGroups: mergedGroups,
  );
  controller._roomPhase = AsyncPhase.success;
  controller._roomErrorMessage = null;
  _chatReplaceRoom(controller, updatedRoom, moveToTop: true);
  controller._notifyChanged();

  if (!message.isMine) {
    unawaited(controller.repository.markRoomAsRead(roomId));
  }
}

void _chatStartRealtimeFallbackPolling(
  ChatController controller, {
  required String roomId,
}) {
  controller._realtimeFallbackPollTimer?.cancel();
  if (controller.realtimeFallbackPollInterval <= Duration.zero) {
    return;
  }
  controller._realtimeFallbackPollTimer = Timer.periodic(
    controller.realtimeFallbackPollInterval,
    (_) {
      unawaited(_chatPollLatestMessages(controller, roomId: roomId));
    },
  );
}

Future<void> _chatPollLatestMessages(
  ChatController controller, {
  required String roomId,
}) async {
  if (!controller._canMutateState ||
      controller._selectedRoomId != roomId ||
      controller._roomPhase != AsyncPhase.success ||
      controller._isPollingRealtimeFallback ||
      controller.repository.isRealtimeConnectedForRoom(roomId)) {
    return;
  }

  final room = controller.currentRoom;
  if (room == null || room.id != roomId) {
    return;
  }

  controller._isPollingRealtimeFallback = true;
  try {
    final pageResult = await controller.repository.fetchRoomMessagesPage(
      roomId: roomId,
      page: 0,
    );
    if (!controller._canMutateState) {
      return;
    }
    if (controller._selectedRoomId != roomId) {
      return;
    }
    final currentRoom = controller.currentRoom;
    if (currentRoom == null || currentRoom.id != roomId) {
      return;
    }

    final mergedGroups = _chatMergeIncomingGroups(
      currentRoom.messageGroups,
      pageResult.groups,
    );
    final hasChanged =
        mergedGroups.length != currentRoom.messageGroups.length ||
        !_chatSameGroupIds(mergedGroups, currentRoom.messageGroups);
    controller._hasOlderMessages = pageResult.hasNext;
    controller._nextRoomMessagesPage = pageResult.nextPage;
    if (!hasChanged) {
      return;
    }

    final updatedRoom = currentRoom.copyWith(
      lastMessageAt: mergedGroups.isEmpty
          ? currentRoom.lastMessageAt
          : mergedGroups.last.sentAt,
      unreadCount: 0,
      messageGroups: mergedGroups,
    );
    _chatReplaceRoom(controller, updatedRoom, moveToTop: true);
    controller._notifyChanged();
  } on ChatRepositoryException {
    // REST polling fallback should not spam the user when realtime is unavailable.
  } finally {
    controller._isPollingRealtimeFallback = false;
  }
}

List<ChatMessageGroup> _chatMergeIncomingGroups(
  List<ChatMessageGroup> currentGroups,
  Iterable<ChatMessageGroup> incomingGroups,
) {
  final nextGroups = currentGroups.toList(growable: true);
  for (final incoming in incomingGroups) {
    final existingIndex = nextGroups.indexWhere(
      (group) => group.id == incoming.id,
    );
    if (existingIndex != -1) {
      final existing = nextGroups[existingIndex];
      nextGroups[existingIndex] = incoming.copyWith(
        isTranslatedVisible: existing.isTranslatedVisible,
      );
      continue;
    }

    final pendingIndex = incoming.isMine
        ? nextGroups.lastIndexWhere(
            (group) =>
                group.isMine &&
                group.id.startsWith('pending-') &&
                _chatSameBubbles(group.bubbles, incoming.bubbles),
          )
        : -1;
    if (pendingIndex != -1) {
      nextGroups[pendingIndex] = incoming;
      continue;
    }
    nextGroups.add(incoming);
  }

  return nextGroups;
}

bool _chatSameGroupIds(
  List<ChatMessageGroup> left,
  List<ChatMessageGroup> right,
) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    if (left[index].id != right[index].id) {
      return false;
    }
  }
  return true;
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
