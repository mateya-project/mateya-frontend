part of 'chat_controller.dart';

void _chatUpdateDraft(ChatController controller, {required String value}) {
  if (controller._draft == value) {
    return;
  }
  controller._draft = value;
  controller._notifyChanged();
}

int _chatAddDraftAttachments(
  ChatController controller, {
  required List<ChatAttachment> attachments,
}) {
  if (attachments.isEmpty) {
    return 0;
  }

  final availableSlots = 10 - controller._draftAttachments.length;
  if (availableSlots <= 0) {
    return attachments.length;
  }

  final accepted = attachments.take(availableSlots).toList(growable: false);
  controller._draftAttachments = <ChatAttachment>[
    ...controller._draftAttachments,
    ...accepted,
  ];
  controller._notifyChanged();
  return attachments.length - accepted.length;
}

void _chatRemoveDraftAttachment(
  ChatController controller, {
  required String attachmentId,
}) {
  final next = controller._draftAttachments
      .where((attachment) => attachment.id != attachmentId)
      .toList(growable: false);
  if (next.length == controller._draftAttachments.length) {
    return;
  }
  controller._draftAttachments = next;
  controller._notifyChanged();
}

void _chatToggleTranslation(
  ChatController controller, {
  required String groupId,
}) {
  final room = controller.currentRoom;
  if (room == null) {
    return;
  }

  final updatedGroups = room.messageGroups
      .map((group) {
        if (group.id != groupId || !group.supportsTranslation) {
          return group;
        }
        return group.copyWith(isTranslatedVisible: !group.isTranslatedVisible);
      })
      .toList(growable: false);

  _chatReplaceRoom(controller, room.copyWith(messageGroups: updatedGroups));
  controller._notifyChanged();
}

Future<void> _chatSendMessage(ChatController controller) async {
  final l10n = MateyaLocalizations.current;
  final room = controller.currentRoom;
  final message = controller._draft.trim();
  if (room == null ||
      (message.isEmpty && controller._draftAttachments.isEmpty) ||
      controller._isSending) {
    return;
  }

  controller._isSending = true;
  controller._notifyChanged();

  final now = controller._now();
  final pendingAttachments = controller._draftAttachments;
  final shouldWaitForRealtime = controller.repository
      .isRealtimeConnectedForRoom(room.id);
  try {
    final sentBubbles = await controller.repository.sendMessage(
      roomId: room.id,
      text: message,
      attachments: pendingAttachments,
    );

    controller._draft = '';
    controller._draftAttachments = const <ChatAttachment>[];
    controller._roomPhase = AsyncPhase.success;
    controller._roomErrorMessage = null;
    if (!shouldWaitForRealtime) {
      final current = controller.currentRoom ?? room;
      final outgoingGroup = ChatMessageGroup(
        id: 'pending-${now.microsecondsSinceEpoch}',
        sender: ChatParticipant(id: 'me', name: l10n.chatMe),
        sentAt: now,
        isMine: true,
        bubbles: sentBubbles,
      );
      final updatedRoom = current.copyWith(
        lastMessageAt: now,
        unreadCount: 0,
        messageGroups: <ChatMessageGroup>[
          ...current.messageGroups,
          outgoingGroup,
        ],
      );
      _chatReplaceRoom(controller, updatedRoom, moveToTop: true);
    }
  } on ChatRepositoryException catch (error) {
    controller._roomPhase = AsyncPhase.validationError;
    controller._roomErrorMessage = error.message;
    controller._pushToast(
      error.message ??
          (error.type == ChatLoadFailureType.network
              ? l10n.chatSendFailedNetwork
              : l10n.chatSendFailedServer),
    );
  } catch (_) {
    controller._roomPhase = AsyncPhase.validationError;
    controller._pushToast(l10n.chatSendFailedServer);
  } finally {
    controller._isSending = false;
  }
  controller._notifyChanged();
}
