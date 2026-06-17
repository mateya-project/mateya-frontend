import 'package:flutter/foundation.dart';

import '../../onboarding/domain/onboarding_flow.dart';
import '../data/chat_repository.dart';
import '../domain/chat_models.dart';

class ChatController extends ChangeNotifier {
  ChatController({required this._repository, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final ChatRepository _repository;
  final DateTime Function() _now;

  AsyncPhase _listPhase = AsyncPhase.idle;
  AsyncPhase _roomPhase = AsyncPhase.idle;
  ChatListFilter _filter = ChatListFilter.all;
  List<ChatRoom> _rooms = const <ChatRoom>[];
  String? _selectedRoomId;
  String _draft = '';
  List<ChatAttachment> _draftAttachments = const <ChatAttachment>[];
  String? _listErrorMessage;
  String? _roomErrorMessage;
  String? _toastMessage;
  int _toastVersion = 0;
  bool _isSending = false;
  bool _isLoadingMoreRooms = false;
  bool _isLoadingOlderMessages = false;
  bool _hasMoreRooms = false;
  int? _nextRoomsPage;
  bool _hasOlderMessages = false;
  int? _nextRoomMessagesPage;

  AsyncPhase get listPhase => _listPhase;
  AsyncPhase get roomPhase => _roomPhase;
  ChatListFilter get filter => _filter;
  String? get selectedRoomId => _selectedRoomId;
  String get draft => _draft;
  List<ChatAttachment> get draftAttachments => _draftAttachments;
  String? get listErrorMessage => _listErrorMessage;
  String? get roomErrorMessage => _roomErrorMessage;
  String? get toastMessage => _toastMessage;
  int get toastVersion => _toastVersion;
  bool get isSending => _isSending;
  bool get isLoadingMoreRooms => _isLoadingMoreRooms;
  bool get isLoadingOlderMessages => _isLoadingOlderMessages;
  bool get hasMoreRooms => _hasMoreRooms;
  bool get hasOlderMessages => _hasOlderMessages;
  bool get isDetailOpen => _selectedRoomId != null;
  bool get canSendMessage =>
      !_isSending && (_draft.trim().isNotEmpty || _draftAttachments.isNotEmpty);

  ChatRoom? get currentRoom {
    if (_selectedRoomId == null) {
      return null;
    }
    return _rooms.where((room) => room.id == _selectedRoomId).firstOrNull;
  }

  List<ChatRoom> get visibleRooms {
    final filtered = switch (_filter) {
      ChatListFilter.all => _rooms,
      ChatListFilter.group =>
        _rooms.where((room) => room.type == ChatRoomType.group).toList(),
      ChatListFilter.direct =>
        _rooms.where((room) => room.type == ChatRoomType.direct).toList(),
    };
    filtered.sort(
      (left, right) => right.lastMessageAt.compareTo(left.lastMessageAt),
    );
    return filtered;
  }

  Future<void> initialize() async {
    if (_listPhase != AsyncPhase.idle) {
      return;
    }
    await _loadRooms();
  }

  Future<void> retryRooms() => _loadRooms();

  Future<void> retryRoom() async {
    final roomId = _selectedRoomId;
    if (roomId == null) {
      return;
    }
    await openRoom(roomId);
  }

  void updateFilter(ChatListFilter nextFilter) {
    if (_filter == nextFilter) {
      return;
    }
    _filter = nextFilter;
    notifyListeners();
  }

  Future<void> openRoom(String roomId) async {
    _selectedRoomId = roomId;
    _roomPhase = AsyncPhase.loading;
    _roomErrorMessage = null;
    _draft = '';
    _draftAttachments = const <ChatAttachment>[];
    _markRoomAsRead(roomId);
    notifyListeners();

    try {
      final room = await _repository.fetchRoom(roomId);
      final firstPage = await _repository.fetchRoomMessagesPage(
        roomId: roomId,
        page: 0,
      );
      _replaceRoom(room.copyWith(unreadCount: 0));
      _hasOlderMessages = firstPage.hasNext;
      _nextRoomMessagesPage = firstPage.nextPage;
      try {
        await _repository.markRoomAsRead(roomId);
      } on ChatRepositoryException {
        _pushToast('읽음 상태를 서버에 반영하지 못했어요. 다음에 다시 시도합니다.');
      }
      _roomPhase = AsyncPhase.success;
      _roomErrorMessage = null;
    } on ChatRepositoryException catch (error) {
      _roomPhase = error.type == ChatLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _roomErrorMessage =
          error.message ??
          (error.type == ChatLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '채팅방을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
    } catch (_) {
      _roomPhase = AsyncPhase.serverError;
      _roomErrorMessage = '채팅방을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }

  Future<void> loadMoreRooms() async {
    if (_isLoadingMoreRooms || !_hasMoreRooms || _nextRoomsPage == null) {
      return;
    }

    _isLoadingMoreRooms = true;
    notifyListeners();
    try {
      final pageResult = await _repository.fetchRoomsPage(
        page: _nextRoomsPage!,
      );
      final merged = <String, ChatRoom>{
        for (final room in _rooms) room.id: room,
        for (final room in pageResult.rooms) room.id: room,
      };
      _rooms = merged.values.toList()
        ..sort(
          (left, right) => right.lastMessageAt.compareTo(left.lastMessageAt),
        );
      _hasMoreRooms = pageResult.hasNext;
      _nextRoomsPage = pageResult.nextPage;
    } on ChatRepositoryException catch (error) {
      _pushToast(
        error.message ??
            (error.type == ChatLoadFailureType.network
                ? '채팅 목록을 더 불러오지 못했어요. 네트워크를 확인해 주세요.'
                : '채팅 목록을 더 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'),
      );
    } finally {
      _isLoadingMoreRooms = false;
      notifyListeners();
    }
  }

  Future<void> loadOlderMessages() async {
    final roomId = _selectedRoomId;
    final room = currentRoom;
    if (roomId == null ||
        room == null ||
        _isLoadingOlderMessages ||
        !_hasOlderMessages ||
        _nextRoomMessagesPage == null) {
      return;
    }

    _isLoadingOlderMessages = true;
    notifyListeners();
    try {
      final pageResult = await _repository.fetchRoomMessagesPage(
        roomId: roomId,
        page: _nextRoomMessagesPage!,
      );
      final updatedRoom = room.copyWith(
        messageGroups: <ChatMessageGroup>[
          ...pageResult.groups,
          ...room.messageGroups,
        ],
      );
      _replaceRoom(updatedRoom);
      _hasOlderMessages = pageResult.hasNext;
      _nextRoomMessagesPage = pageResult.nextPage;
    } on ChatRepositoryException catch (error) {
      _pushToast(
        error.message ??
            (error.type == ChatLoadFailureType.network
                ? '이전 메시지를 불러오지 못했어요. 네트워크를 확인해 주세요.'
                : '이전 메시지를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'),
      );
    } finally {
      _isLoadingOlderMessages = false;
      notifyListeners();
    }
  }

  void closeRoom() {
    _selectedRoomId = null;
    _roomPhase = AsyncPhase.idle;
    _roomErrorMessage = null;
    _draft = '';
    _draftAttachments = const <ChatAttachment>[];
    notifyListeners();
  }

  void clearToast() {
    _toastMessage = null;
  }

  void updateDraft(String value) {
    if (_draft == value) {
      return;
    }
    _draft = value;
    notifyListeners();
  }

  int addDraftAttachments(List<ChatAttachment> attachments) {
    if (attachments.isEmpty) {
      return 0;
    }

    final availableSlots = 10 - _draftAttachments.length;
    if (availableSlots <= 0) {
      return attachments.length;
    }

    final accepted = attachments.take(availableSlots).toList(growable: false);
    _draftAttachments = <ChatAttachment>[..._draftAttachments, ...accepted];
    notifyListeners();
    return attachments.length - accepted.length;
  }

  void removeDraftAttachment(String attachmentId) {
    final next = _draftAttachments
        .where((attachment) => attachment.id != attachmentId)
        .toList(growable: false);
    if (next.length == _draftAttachments.length) {
      return;
    }
    _draftAttachments = next;
    notifyListeners();
  }

  void toggleTranslation(String groupId) {
    final room = currentRoom;
    if (room == null) {
      return;
    }

    final updatedGroups = room.messageGroups
        .map((group) {
          if (group.id != groupId || !group.supportsTranslation) {
            return group;
          }
          return group.copyWith(
            isTranslatedVisible: !group.isTranslatedVisible,
          );
        })
        .toList(growable: false);

    _replaceRoom(room.copyWith(messageGroups: updatedGroups));
    notifyListeners();
  }

  Future<void> sendMessage() async {
    final room = currentRoom;
    final message = _draft.trim();
    if (room == null ||
        (message.isEmpty && _draftAttachments.isEmpty) ||
        _isSending) {
      return;
    }

    _isSending = true;
    notifyListeners();

    final now = _now();
    final pendingAttachments = _draftAttachments;
    try {
      final sentBubbles = await _repository.sendMessage(
        roomId: room.id,
        text: message,
        attachments: pendingAttachments,
      );
      final outgoingGroup = ChatMessageGroup(
        id: 'out-${now.microsecondsSinceEpoch}',
        sender: const ChatParticipant(id: 'me', name: '나'),
        sentAt: now,
        isMine: true,
        bubbles: sentBubbles,
      );

      final updatedRoom = room.copyWith(
        lastMessageAt: now,
        unreadCount: 0,
        messageGroups: <ChatMessageGroup>[...room.messageGroups, outgoingGroup],
      );

      _draft = '';
      _draftAttachments = const <ChatAttachment>[];
      _roomPhase = AsyncPhase.success;
      _roomErrorMessage = null;
      _replaceRoom(updatedRoom, moveToTop: true);
    } on ChatRepositoryException catch (error) {
      _roomPhase = AsyncPhase.validationError;
      _roomErrorMessage = error.message;
      _pushToast(
        error.message ??
            (error.type == ChatLoadFailureType.network
                ? '메시지를 전송하지 못했어요. 네트워크를 확인해 주세요.'
                : '메시지를 전송하지 못했어요. 잠시 후 다시 시도해 주세요.'),
      );
    } catch (_) {
      _roomPhase = AsyncPhase.validationError;
      _pushToast('메시지를 전송하지 못했어요. 잠시 후 다시 시도해 주세요.');
    } finally {
      _isSending = false;
    }
    notifyListeners();
  }

  Future<void> _loadRooms() async {
    _listPhase = AsyncPhase.loading;
    _listErrorMessage = null;
    notifyListeners();

    try {
      final pageResult = await _repository.fetchRoomsPage(page: 0);
      _rooms = pageResult.rooms.toList()
        ..sort(
          (left, right) => right.lastMessageAt.compareTo(left.lastMessageAt),
        );
      _hasMoreRooms = pageResult.hasNext;
      _nextRoomsPage = pageResult.nextPage;
      _listPhase = AsyncPhase.success;
      _listErrorMessage = null;
    } on ChatRepositoryException catch (error) {
      _listPhase = error.type == ChatLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _listErrorMessage =
          error.message ??
          (error.type == ChatLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '채팅 목록을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
    } catch (_) {
      _listPhase = AsyncPhase.serverError;
      _listErrorMessage = '채팅 목록을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }

  void _markRoomAsRead(String roomId) {
    _rooms = _rooms
        .map((room) => room.id == roomId ? room.copyWith(unreadCount: 0) : room)
        .toList(growable: false);
  }

  void _replaceRoom(ChatRoom nextRoom, {bool moveToTop = false}) {
    final updated = _rooms
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
    _rooms = updated;
  }

  void _pushToast(String message) {
    _toastMessage = message;
    _toastVersion += 1;
  }
}
