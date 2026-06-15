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

  AsyncPhase get listPhase => _listPhase;
  AsyncPhase get roomPhase => _roomPhase;
  ChatListFilter get filter => _filter;
  String? get selectedRoomId => _selectedRoomId;
  String get draft => _draft;
  List<ChatAttachment> get draftAttachments => _draftAttachments;
  String? get listErrorMessage => _listErrorMessage;
  String? get roomErrorMessage => _roomErrorMessage;
  bool get isDetailOpen => _selectedRoomId != null;
  bool get canSendMessage =>
      _draft.trim().isNotEmpty || _draftAttachments.isNotEmpty;

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
      _replaceRoom(room.copyWith(unreadCount: 0));
      _roomPhase = AsyncPhase.success;
      _roomErrorMessage = null;
    } on ChatRepositoryException catch (error) {
      _roomPhase = error.type == ChatLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _roomErrorMessage = error.type == ChatLoadFailureType.network
          ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
          : '채팅방을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    } catch (_) {
      _roomPhase = AsyncPhase.serverError;
      _roomErrorMessage = '채팅방을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }

  void closeRoom() {
    _selectedRoomId = null;
    _roomPhase = AsyncPhase.idle;
    _roomErrorMessage = null;
    _draft = '';
    _draftAttachments = const <ChatAttachment>[];
    notifyListeners();
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

  void sendMessage() {
    final room = currentRoom;
    final message = _draft.trim();
    if (room == null || (message.isEmpty && _draftAttachments.isEmpty)) {
      return;
    }

    final now = _now();
    final outgoingGroup = ChatMessageGroup(
      id: 'out-${now.microsecondsSinceEpoch}',
      sender: const ChatParticipant(id: 'me', name: '나'),
      sentAt: now,
      isMine: true,
      bubbles: <ChatBubble>[
        ChatBubble(
          originalText: message.isEmpty ? null : message,
          attachments: _draftAttachments,
        ),
      ],
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
    notifyListeners();
  }

  Future<void> _loadRooms() async {
    _listPhase = AsyncPhase.loading;
    _listErrorMessage = null;
    notifyListeners();

    try {
      _rooms = await _repository.fetchRooms();
      _rooms = _rooms.toList()
        ..sort(
          (left, right) => right.lastMessageAt.compareTo(left.lastMessageAt),
        );
      _listPhase = AsyncPhase.success;
      _listErrorMessage = null;
    } on ChatRepositoryException catch (error) {
      _listPhase = error.type == ChatLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _listErrorMessage = error.type == ChatLoadFailureType.network
          ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
          : '채팅 목록을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
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
}
