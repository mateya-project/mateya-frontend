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

Future<void> _chatLoadMoreRooms(ChatController controller) async {
  final l10n = MateyaLocalizations.current;
  if (controller._isLoadingMoreRooms ||
      !controller._hasMoreRooms ||
      controller._nextRoomsPage == null) {
    return;
  }

  controller._isLoadingMoreRooms = true;
  controller._notifyChanged();
  try {
    final pageResult = await controller.repository.fetchRoomsPage(
      page: controller._nextRoomsPage!,
    );
    if (!controller._canMutateState) {
      return;
    }
    final merged = <String, ChatRoom>{
      for (final room in controller._rooms) room.id: room,
      for (final room in pageResult.rooms) room.id: room,
    };
    controller._rooms = merged.values.toList()..sort(_chatRoomSortByLatest);
    controller._hasMoreRooms = pageResult.hasNext;
    controller._nextRoomsPage = pageResult.nextPage;
  } on ChatRepositoryException catch (error) {
    controller._pushToast(
      error.message ??
          (error.type == ChatLoadFailureType.network
              ? l10n.chatListLoadMoreFailedNetwork
              : l10n.chatListLoadMoreFailedServer),
    );
  } finally {
    controller._isLoadingMoreRooms = false;
    controller._notifyChanged();
  }
}

Future<void> _chatLoadRooms(ChatController controller) async {
  final l10n = MateyaLocalizations.current;
  controller._listPhase = AsyncPhase.loading;
  controller._listErrorMessage = null;
  controller._notifyChanged();

  try {
    final pageResult = await controller.repository.fetchRoomsPage(page: 0);
    if (!controller._canMutateState) {
      return;
    }
    controller._rooms = pageResult.rooms.toList()..sort(_chatRoomSortByLatest);
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
            ? l10n.commonNetworkRetry
            : l10n.chatListLoadError);
  } catch (_) {
    controller._listPhase = AsyncPhase.serverError;
    controller._listErrorMessage = l10n.chatListLoadError;
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
    updated.sort(_chatRoomSortByLatest);
  }
  controller._rooms = updated;
}

int _chatRoomSortByLatest(ChatRoom left, ChatRoom right) =>
    _compareNullableDateDesc(left.lastMessageAt, right.lastMessageAt);

int _compareNullableDateDesc(DateTime? left, DateTime? right) {
  if (left == null && right == null) {
    return 0;
  }
  if (left == null) {
    return 1;
  }
  if (right == null) {
    return -1;
  }
  return right.compareTo(left);
}
