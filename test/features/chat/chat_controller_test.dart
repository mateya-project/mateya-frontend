import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/chat/application/chat_controller.dart';
import 'package:mateya_app/features/chat/data/chat_repository.dart';
import 'package:mateya_app/features/chat/domain/chat_models.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';

void main() {
  group('ChatController', () {
    test('loads rooms and filters group/direct tabs', () async {
      final controller = ChatController(
        repository: MockChatRepository(),
        now: () => DateTime(2026, 6, 14, 10, 30),
      );

      await controller.initialize();

      expect(controller.listPhase, AsyncPhase.success);
      expect(controller.visibleRooms, hasLength(2));
      expect(controller.hasMoreRooms, isTrue);

      await controller.loadMoreRooms();
      await controller.loadMoreRooms();

      expect(controller.visibleRooms, hasLength(5));

      controller.updateFilter(ChatListFilter.group);
      expect(
        controller.visibleRooms.every(
          (room) => room.type == ChatRoomType.group,
        ),
        isTrue,
      );

      controller.updateFilter(ChatListFilter.direct);
      expect(
        controller.visibleRooms.every(
          (room) => room.type == ChatRoomType.direct,
        ),
        isTrue,
      );
    });

    test(
      'opening a room clears unread count and exposes detail state',
      () async {
        final controller = ChatController(
          repository: MockChatRepository(),
          now: () => DateTime(2026, 6, 14, 10, 30),
        );

        await controller.initialize();
        await controller.openRoom('hongdae-language');

        expect(controller.roomPhase, AsyncPhase.success);
        expect(controller.isDetailOpen, isTrue);
        expect(controller.currentRoom?.id, 'hongdae-language');
        expect(controller.currentRoom?.unreadCount, 0);
        expect(controller.hasOlderMessages, isFalse);
      },
    );

    test(
      'loading older messages prepends the next page in chronological order',
      () async {
        final controller = ChatController(
          repository: MockChatRepository(),
          now: () => DateTime(2026, 6, 14, 10, 30),
        );

        await controller.initialize();
        await controller.openRoom('gyeongbokgung-walk');

        expect(
          controller.currentRoom?.messageGroups.map((group) => group.id),
          <String>['g-2', 'g-3'],
        );
        expect(controller.hasOlderMessages, isTrue);

        await controller.loadOlderMessages();

        expect(
          controller.currentRoom?.messageGroups.map((group) => group.id),
          <String>['g-1', 'g-2', 'g-3'],
        );
        expect(controller.hasOlderMessages, isFalse);
      },
    );

    test(
      'translation toggle swaps between original and translated copy',
      () async {
        final controller = ChatController(
          repository: MockChatRepository(),
          now: () => DateTime(2026, 6, 14, 10, 30),
        );

        await controller.initialize();
        await controller.openRoom('gyeongbokgung-walk');

        final before = controller.currentRoom!.messageGroups.firstWhere(
          (group) => group.id == 'g-2',
        );
        expect(before.visibleTexts.first, 'See you all at the palace gate.');
        expect(before.translationToggleLabel, '원문 보기');

        await controller.toggleTranslation('g-2');

        final after = controller.currentRoom!.messageGroups.firstWhere(
          (group) => group.id == 'g-2',
        );
        expect(after.visibleTexts.first, '가나다라마바사');
        expect(after.translationToggleLabel, '번역 보기');
      },
    );

    test('translation toggle fetches translated message on demand', () async {
      final controller = ChatController(
        repository: _LazyTranslationChatRepository(),
        now: () => DateTime(2026, 6, 14, 10, 30),
      );

      await controller.initialize();
      await controller.openRoom('lazy-room');

      final before = controller.currentRoom!.messageGroups.single;
      expect(before.supportsTranslation, isTrue);
      expect(before.isTranslatedVisible, isFalse);
      expect(before.visibleTexts.single, 'did');

      await controller.toggleTranslation('lazy-1');

      final after = controller.currentRoom!.messageGroups.single;
      expect(after.isTranslatedVisible, isTrue);
      expect(after.visibleTexts.single, '번역된 메시지');
    });

    test(
      'sending a message appends an outgoing group and clears the draft',
      () async {
        final fixedNow = DateTime(2026, 6, 14, 10, 30);
        final controller = ChatController(
          repository: MockChatRepository(),
          now: () => fixedNow,
        );

        await controller.initialize();
        await controller.openRoom('gyeongbokgung-walk');
        controller.updateDraft('내일 1시에 정문에서 만나요.');

        await controller.sendMessage();

        expect(controller.draft, isEmpty);
        expect(controller.canSendMessage, isFalse);
        expect(controller.currentRoom?.lastMessageAt, fixedNow);
        expect(controller.currentRoom?.messageGroups.last.isMine, isTrue);
        expect(
          controller.currentRoom?.messageGroups.last.visibleTexts.single,
          '내일 1시에 정문에서 만나요.',
        );
      },
    );

    test('attachments can be added removed and sent without text', () async {
      final fixedNow = DateTime(2026, 6, 14, 10, 30);
      final controller = ChatController(
        repository: MockChatRepository(),
        now: () => fixedNow,
      );

      await controller.initialize();
      await controller.openRoom('gyeongbokgung-walk');

      final overflow = controller.addDraftAttachments(<ChatAttachment>[
        const ChatAttachment(
          id: 'a1',
          path: '/tmp/photo1.jpg',
          fileName: 'photo1.jpg',
          fileSizeBytes: 1200,
          source: ChatAttachmentSource.gallery,
        ),
        const ChatAttachment(
          id: 'a2',
          path: '/tmp/photo2.png',
          fileName: 'photo2.png',
          fileSizeBytes: 1200,
          source: ChatAttachmentSource.camera,
        ),
      ]);

      expect(overflow, 0);
      expect(controller.canSendMessage, isTrue);
      expect(controller.draftAttachments, hasLength(2));

      controller.removeDraftAttachment('a1');
      expect(controller.draftAttachments.map((item) => item.id), <String>[
        'a2',
      ]);

      await controller.sendMessage();

      expect(controller.draftAttachments, isEmpty);
      expect(
        controller.currentRoom?.messageGroups.last.bubbles.single.attachments,
        hasLength(1),
      );
      expect(
        controller
            .currentRoom
            ?.messageGroups
            .last
            .bubbles
            .single
            .attachments
            .single
            .id,
        'a2',
      );
      expect(
        controller.currentRoom?.messageGroups.last.bubbles.single.originalText,
        isNull,
      );
    });

    test('realtime message appends to the open room once', () async {
      final repository = _RealtimeChatRepository();
      final controller = ChatController(
        repository: repository,
        now: () => DateTime(2026, 6, 14, 10, 30),
      );

      await controller.initialize();
      await controller.openRoom('gyeongbokgung-walk');

      repository.emit(
        'gyeongbokgung-walk',
        ChatMessageGroup(
          id: 'ws-1',
          sender: const ChatParticipant(id: 'jiwon', name: 'Ji-Won'),
          sentAt: DateTime(2026, 6, 14, 10, 31),
          bubbles: const <ChatBubble>[ChatBubble(originalText: '실시간 메시지예요.')],
        ),
      );
      repository.emit(
        'gyeongbokgung-walk',
        ChatMessageGroup(
          id: 'ws-1',
          sender: const ChatParticipant(id: 'jiwon', name: 'Ji-Won'),
          sentAt: DateTime(2026, 6, 14, 10, 31),
          bubbles: const <ChatBubble>[ChatBubble(originalText: '실시간 메시지예요.')],
        ),
      );

      expect(
        controller.currentRoom?.messageGroups
            .where((group) => group.id == 'ws-1')
            .length,
        1,
      );
      expect(
        controller.currentRoom?.messageGroups.last.visibleTexts.single,
        '실시간 메시지예요.',
      );
    });

    test('realtime echo replaces a pending outgoing message', () async {
      final repository = _RealtimeChatRepository();
      final controller = ChatController(
        repository: repository,
        now: () => DateTime(2026, 6, 14, 10, 30),
      );

      await controller.initialize();
      await controller.openRoom('gyeongbokgung-walk');
      repository.realtimeConnected = false;
      controller.updateDraft('실시간 연결 직전 메시지');

      await controller.sendMessage();

      expect(
        controller.currentRoom?.messageGroups.last.id.startsWith('pending-'),
        isTrue,
      );

      repository.emit(
        'gyeongbokgung-walk',
        ChatMessageGroup(
          id: 'ws-confirmed',
          sender: const ChatParticipant(id: 'me', name: '나'),
          sentAt: DateTime(2026, 6, 14, 10, 30, 1),
          isMine: true,
          bubbles: const <ChatBubble>[
            ChatBubble(originalText: '실시간 연결 직전 메시지'),
          ],
        ),
      );

      expect(controller.currentRoom?.messageGroups.last.id, 'ws-confirmed');
      expect(
        controller.currentRoom?.messageGroups
            .where((group) => group.id.startsWith('pending-'))
            .isEmpty,
        isTrue,
      );
    });

    test(
      'sendMessage does not append pending when realtime echo arrives before request completion',
      () async {
        final repository = _RealtimeRaceChatRepository();
        final controller = ChatController(
          repository: repository,
          now: () => DateTime(2026, 6, 14, 10, 30),
        );

        await controller.initialize();
        await controller.openRoom('gyeongbokgung-walk');
        controller.updateDraft('레이스 조건 메시지');

        await controller.sendMessage();

        expect(
          controller.currentRoom?.messageGroups
              .where((group) => group.visibleTexts.contains('레이스 조건 메시지'))
              .length,
          1,
        );
        expect(
          controller.currentRoom?.messageGroups
              .where((group) => group.id.startsWith('pending-'))
              .isEmpty,
          isTrue,
        );
        expect(controller.currentRoom?.messageGroups.last.id, 'ws-race');
      },
    );

    test(
      'polling fallback appends messages when realtime never connects',
      () async {
        final repository = _PollingFallbackChatRepository();
        final controller = ChatController(
          repository: repository,
          now: () => DateTime(2026, 6, 14, 10, 30),
          realtimeFallbackPollInterval: const Duration(milliseconds: 10),
        );

        await controller.initialize();
        await controller.openRoom('fallback-room');
        repository.queueServerMessage(
          ChatMessageGroup(
            id: 'fallback-2',
            sender: const ChatParticipant(id: 'jiwon', name: 'Ji-Won'),
            sentAt: DateTime(2026, 6, 14, 10, 31),
            bubbles: const <ChatBubble>[
              ChatBubble(originalText: 'REST fallback 메시지예요.'),
            ],
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 40));

        expect(
          controller.currentRoom?.messageGroups.map((group) => group.id),
          <String>['fallback-1', 'fallback-2'],
        );
        expect(
          controller.currentRoom?.messageGroups.last.visibleTexts.single,
          'REST fallback 메시지예요.',
        );
      },
    );
  });
}

class _RealtimeChatRepository extends MockChatRepository {
  void Function(ChatMessageGroup message)? _onMessage;
  bool realtimeConnected = true;
  String? _roomId;

  @override
  void subscribeToRoomMessages({
    required String roomId,
    required void Function(ChatMessageGroup message) onMessage,
    required void Function(String message) onError,
  }) {
    _roomId = roomId;
    _onMessage = onMessage;
  }

  @override
  void unsubscribeFromRoomMessages() {
    _roomId = null;
    _onMessage = null;
  }

  @override
  bool isRealtimeConnectedForRoom(String roomId) {
    return realtimeConnected && _roomId == roomId && _onMessage != null;
  }

  void emit(String roomId, ChatMessageGroup message) {
    if (_roomId != roomId) {
      return;
    }
    _onMessage?.call(message);
  }
}

class _RealtimeRaceChatRepository extends _RealtimeChatRepository {
  _RealtimeRaceChatRepository() {
    realtimeConnected = false;
  }

  @override
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  }) async {
    final trimmed = text.trim();
    emit(
      roomId,
      ChatMessageGroup(
        id: 'ws-race',
        sender: const ChatParticipant(id: 'me', name: '나'),
        sentAt: DateTime(2026, 6, 14, 10, 30, 1),
        isMine: true,
        bubbles: <ChatBubble>[ChatBubble(originalText: trimmed)],
      ),
    );
    return <ChatBubble>[ChatBubble(originalText: trimmed)];
  }
}

class _PollingFallbackChatRepository implements ChatRepository {
  static const _roomId = 'fallback-room';

  final List<ChatMessageGroup> _groups = <ChatMessageGroup>[
    ChatMessageGroup(
      id: 'fallback-1',
      sender: const ChatParticipant(id: 'me', name: '나'),
      sentAt: DateTime(2026, 6, 14, 10, 30),
      isMine: true,
      bubbles: const <ChatBubble>[ChatBubble(originalText: '기존 메시지')],
    ),
  ];

  @override
  Future<List<ChatRoom>> fetchRooms() async => <ChatRoom>[_room()];

  @override
  Future<ChatRoom> fetchRoom(String roomId) async => _room();

  @override
  Future<ChatRoomPageResult> fetchRoomsPage({required int page}) async {
    return ChatRoomPageResult(
      rooms: page == 0 ? <ChatRoom>[_room()] : const <ChatRoom>[],
      hasNext: false,
      nextPage: null,
    );
  }

  @override
  Future<ChatMessagePageResult> fetchRoomMessagesPage({
    required String roomId,
    required int page,
  }) async {
    return ChatMessagePageResult(
      groups: page == 0
          ? List<ChatMessageGroup>.from(_groups)
          : const <ChatMessageGroup>[],
      hasNext: false,
      nextPage: null,
    );
  }

  @override
  Future<ChatMessageGroup> fetchMessage({
    required String roomId,
    required String messageId,
    required bool original,
  }) async {
    return _groups.firstWhere((group) => group.id == messageId);
  }

  @override
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  }) async {
    return <ChatBubble>[
      ChatBubble(originalText: text.trim().isEmpty ? null : text.trim()),
    ];
  }

  @override
  Future<void> markRoomAsRead(String roomId) async {}

  @override
  void subscribeToRoomMessages({
    required String roomId,
    required void Function(ChatMessageGroup message) onMessage,
    required void Function(String message) onError,
  }) {}

  @override
  void unsubscribeFromRoomMessages() {}

  @override
  bool isRealtimeConnectedForRoom(String roomId) => false;

  @override
  void dispose() {}

  void queueServerMessage(ChatMessageGroup group) {
    _groups.add(group);
  }

  ChatRoom _room() {
    return ChatRoom(
      id: _roomId,
      type: ChatRoomType.group,
      title: '폴백 테스트',
      imageUrl: null,
      participantCount: 2,
      lastMessageAt: _groups.last.sentAt,
      unreadCount: 0,
      messageGroups: List<ChatMessageGroup>.from(_groups),
    );
  }
}

class _LazyTranslationChatRepository implements ChatRepository {
  @override
  Future<List<ChatRoom>> fetchRooms() async => <ChatRoom>[
    ChatRoom(
      id: 'lazy-room',
      type: ChatRoomType.direct,
      title: '지연 번역 채팅',
      imageUrl: null,
      participantCount: 2,
      lastMessageAt: DateTime(2026, 6, 14, 10, 30),
      unreadCount: 0,
      messageGroups: const <ChatMessageGroup>[],
    ),
  ];

  @override
  Future<ChatRoom> fetchRoom(String roomId) async => ChatRoom(
    id: 'lazy-room',
    type: ChatRoomType.direct,
    title: '지연 번역 채팅',
    imageUrl: null,
    participantCount: 2,
    lastMessageAt: DateTime(2026, 6, 14, 10, 30),
    unreadCount: 0,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'lazy-1',
        sender: const ChatParticipant(id: 'other', name: '최성현'),
        sentAt: DateTime(2026, 6, 14, 10, 30),
        canToggleTranslation: true,
        bubbles: const <ChatBubble>[ChatBubble(originalText: 'did')],
      ),
    ],
  );

  @override
  Future<ChatRoomPageResult> fetchRoomsPage({required int page}) async {
    final rooms = await fetchRooms();
    return ChatRoomPageResult(rooms: rooms, hasNext: false, nextPage: null);
  }

  @override
  Future<ChatMessagePageResult> fetchRoomMessagesPage({
    required String roomId,
    required int page,
  }) async {
    return ChatMessagePageResult(
      groups: page == 0
          ? <ChatMessageGroup>[
              ChatMessageGroup(
                id: 'lazy-1',
                sender: ChatParticipant(id: 'other', name: '최성현'),
                sentAt: DateTime(2026, 6, 14, 10, 30),
                canToggleTranslation: true,
                bubbles: <ChatBubble>[ChatBubble(originalText: 'did')],
              ),
            ]
          : const <ChatMessageGroup>[],
      hasNext: false,
      nextPage: null,
    );
  }

  @override
  Future<ChatMessageGroup> fetchMessage({
    required String roomId,
    required String messageId,
    required bool original,
  }) async {
    return ChatMessageGroup(
      id: 'lazy-1',
      sender: const ChatParticipant(id: 'other', name: '최성현'),
      sentAt: DateTime(2026, 6, 14, 10, 30),
      canToggleTranslation: true,
      isTranslatedVisible: !original,
      bubbles: <ChatBubble>[
        ChatBubble(
          originalText: 'did',
          translatedText: original ? null : '번역된 메시지',
        ),
      ],
    );
  }

  @override
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  }) async => <ChatBubble>[ChatBubble(originalText: text)];

  @override
  Future<void> markRoomAsRead(String roomId) async {}

  @override
  void subscribeToRoomMessages({
    required String roomId,
    required void Function(ChatMessageGroup message) onMessage,
    required void Function(String message) onError,
  }) {}

  @override
  void unsubscribeFromRoomMessages() {}

  @override
  bool isRealtimeConnectedForRoom(String roomId) => false;

  @override
  void dispose() {}
}
