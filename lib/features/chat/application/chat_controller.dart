import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../onboarding/domain/onboarding_flow.dart';
import '../data/chat_repository.dart';
import '../domain/chat_models.dart';

part 'chat_controller_composer.dart';
part 'chat_controller_realtime.dart';
part 'chat_controller_room.dart';
part 'chat_controller_list.dart';

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
    filtered.sort(_chatRoomSortByLatest);
    return filtered;
  }

  Future<void> initialize() => _chatInitialize(this);

  Future<void> retryRooms() => _chatRetryRooms(this);

  Future<void> retryRoom() => _chatRetryRoom(this);

  void updateFilter(ChatListFilter nextFilter) {
    if (_filter == nextFilter) {
      return;
    }
    _filter = nextFilter;
    notifyListeners();
  }

  Future<void> openRoom(String roomId) => _chatOpenRoom(this, roomId: roomId);

  Future<void> loadMoreRooms() => _chatLoadMoreRooms(this);

  Future<void> loadOlderMessages() => _chatLoadOlderMessages(this);

  void closeRoom() => _chatCloseRoom(this);

  @override
  void dispose() {
    _chatStopRealtime(this);
    _repository.dispose();
    super.dispose();
  }

  void clearToast() {
    _toastMessage = null;
  }

  void updateDraft(String value) => _chatUpdateDraft(this, value: value);

  int addDraftAttachments(List<ChatAttachment> attachments) {
    return _chatAddDraftAttachments(this, attachments: attachments);
  }

  void removeDraftAttachment(String attachmentId) {
    _chatRemoveDraftAttachment(this, attachmentId: attachmentId);
  }

  void toggleTranslation(String groupId) {
    _chatToggleTranslation(this, groupId: groupId);
  }

  Future<void> sendMessage() => _chatSendMessage(this);

  void _pushToast(String message) {
    _toastMessage = message;
    _toastVersion += 1;
  }

  void _notifyChanged() {
    notifyListeners();
  }
}
