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
        expect(before.visibleTexts.first, '가나다라마바사');

        controller.toggleTranslation('g-2');

        final after = controller.currentRoom!.messageGroups.firstWhere(
          (group) => group.id == 'g-2',
        );
        expect(after.visibleTexts.first, 'See you all at the palace gate.');
        expect(after.translationToggleLabel, '원문 보기');
      },
    );

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
  });
}
