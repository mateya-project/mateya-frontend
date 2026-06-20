import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/chat/application/chat_controller.dart';
import 'package:mateya_app/features/chat/data/chat_repository.dart';
import 'package:mateya_app/features/chat/domain/chat_models.dart';
import 'package:mateya_app/features/chat/presentation/screens/chat_flow_page.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  Future<void> pumpChatPage(
    WidgetTester tester, {
    required ChatController controller,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: ChatFlowPage(
            controller: controller,
            onHomeTap: () {},
            onExploreTap: () {},
            onPlusTap: () {},
            onProfileTap: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('chat list screen does not overflow on compact heights', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = ChatController(repository: _TestChatRepository());
    addTearDown(controller.dispose);

    await controller.initialize();
    await pumpChatPage(tester, controller: controller);
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
    expect(find.byType(ChatFlowPage), findsOneWidget);
  });

  testWidgets('chat detail screen does not overflow on compact heights', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = ChatController(repository: _TestChatRepository());
    addTearDown(controller.dispose);

    await controller.initialize();
    await controller.openRoom('direct-room');
    await pumpChatPage(tester, controller: controller);
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
    expect(find.byType(ChatFlowPage), findsOneWidget);

    controller.closeRoom();
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

class _TestChatRepository implements ChatRepository {
  final List<ChatRoom> _rooms = <ChatRoom>[
    ChatRoom(
      id: 'group-room',
      type: ChatRoomType.group,
      title: '경복궁 산책 모임',
      imageUrl: null,
      participantCount: 8,
      lastMessageAt: DateTime(2026, 6, 20, 13, 20),
      unreadCount: 1,
      messageGroups: <ChatMessageGroup>[
        ChatMessageGroup(
          id: 'group-message',
          sender: const ChatParticipant(id: 'user-1', name: '지원'),
          sentAt: DateTime(2026, 6, 20, 13, 20),
          bubbles: const <ChatBubble>[ChatBubble(originalText: '곧 출발할게요.')],
        ),
      ],
    ),
    ChatRoom(
      id: 'direct-room',
      type: ChatRoomType.direct,
      title: 'Nicolas',
      imageUrl: null,
      participantCount: 2,
      lastMessageAt: DateTime(2026, 6, 20, 13, 10),
      unreadCount: 0,
      messageGroups: <ChatMessageGroup>[
        ChatMessageGroup(
          id: 'direct-message',
          sender: const ChatParticipant(id: 'me', name: '나'),
          sentAt: DateTime(2026, 6, 20, 13, 10),
          isMine: true,
          bubbles: const <ChatBubble>[
            ChatBubble(originalText: '채팅 테스트 메시지입니다.'),
          ],
        ),
      ],
    ),
  ];

  @override
  Future<List<ChatRoom>> fetchRooms() async => _rooms.map(_cloneRoom).toList();

  @override
  Future<ChatRoomPageResult> fetchRoomsPage({required int page}) async {
    if (page > 0) {
      return const ChatRoomPageResult(
        rooms: <ChatRoom>[],
        hasNext: false,
        nextPage: null,
      );
    }
    return ChatRoomPageResult(
      rooms: _rooms.map(_cloneRoom).toList(),
      hasNext: false,
      nextPage: null,
    );
  }

  @override
  Future<ChatRoom> fetchRoom(String roomId) async {
    final room = _rooms.firstWhere((item) => item.id == roomId);
    return _cloneRoom(room);
  }

  @override
  Future<ChatMessagePageResult> fetchRoomMessagesPage({
    required String roomId,
    required int page,
  }) async {
    final room = _rooms.firstWhere((item) => item.id == roomId);
    return ChatMessagePageResult(
      groups: page == 0
          ? room.messageGroups.map(_cloneGroup).toList()
          : const <ChatMessageGroup>[],
      hasNext: false,
      nextPage: null,
    );
  }

  @override
  Future<List<ChatBubble>> sendMessage({
    required String roomId,
    required String text,
    required List<ChatAttachment> attachments,
  }) async {
    return <ChatBubble>[
      ChatBubble(
        originalText: text.trim().isEmpty ? null : text.trim(),
        attachments: attachments,
      ),
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
}

ChatRoom _cloneRoom(ChatRoom room) {
  return room.copyWith(
    messageGroups: room.messageGroups.map(_cloneGroup).toList(),
  );
}

ChatMessageGroup _cloneGroup(ChatMessageGroup group) {
  return group.copyWith(
    sender: group.sender.copyWith(),
    bubbles: group.bubbles.map((bubble) => bubble.copyWith()).toList(),
  );
}
