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
    controller._rooms = merged.values.toList()..sort(_chatRoomSortByLatest);
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

Future<void> _chatLoadRooms(ChatController controller) async {
  controller._listPhase = AsyncPhase.loading;
  controller._listErrorMessage = null;
  controller._notifyChanged();

  try {
    final pageResult = await controller._repository.fetchRoomsPage(page: 0);
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
    updated.sort(_chatRoomSortByLatest);
  }
  controller._rooms = updated;
}

int _chatRoomSortByLatest(ChatRoom left, ChatRoom right) =>
    right.lastMessageAt.compareTo(left.lastMessageAt);
