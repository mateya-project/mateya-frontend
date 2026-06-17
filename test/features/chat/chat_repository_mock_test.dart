import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/chat/data/chat_repository.dart';
import 'package:mateya_app/features/chat/domain/chat_models.dart';

void main() {
  group('MockChatRepository', () {
    test('room list pagination keeps chronological room slices', () async {
      final repository = MockChatRepository();

      final firstPage = await repository.fetchRoomsPage(page: 0);
      final secondPage = await repository.fetchRoomsPage(page: 1);
      final thirdPage = await repository.fetchRoomsPage(page: 2);

      expect(firstPage.rooms.map((room) => room.id), <String>[
        'gyeongbokgung-walk',
        'hongdae-language',
      ]);
      expect(firstPage.hasNext, isTrue);
      expect(firstPage.nextPage, 1);

      expect(secondPage.rooms.map((room) => room.id), <String>[
        'itaewon-dinner',
        'han-river-group',
      ]);
      expect(secondPage.hasNext, isTrue);
      expect(secondPage.nextPage, 2);

      expect(thirdPage.rooms.map((room) => room.id), <String>['pottery-class']);
      expect(thirdPage.hasNext, isFalse);
      expect(thirdPage.nextPage, isNull);
    });

    test(
      'message pagination returns latest page in chronological order',
      () async {
        final repository = MockChatRepository();

        final firstPage = await repository.fetchRoomMessagesPage(
          roomId: 'gyeongbokgung-walk',
          page: 0,
        );
        final secondPage = await repository.fetchRoomMessagesPage(
          roomId: 'gyeongbokgung-walk',
          page: 1,
        );

        expect(firstPage.groups.map((group) => group.id), <String>[
          'g-2',
          'g-3',
        ]);
        expect(firstPage.hasNext, isTrue);
        expect(firstPage.nextPage, 1);

        expect(secondPage.groups.map((group) => group.id), <String>['g-1']);
        expect(secondPage.hasNext, isFalse);
        expect(secondPage.nextPage, isNull);
      },
    );

    test('fetchRoom returns a deep clone of mock fixtures', () async {
      final repository = MockChatRepository();

      final firstRoom = await repository.fetchRoom('gyeongbokgung-walk');
      firstRoom.messageGroups.first.bubbles.first.attachments.add(
        const ChatAttachment(
          id: 'local-only',
          path: '/tmp/local-only.jpg',
          fileName: 'local-only.jpg',
          fileSizeBytes: 100,
          source: ChatAttachmentSource.gallery,
        ),
      );

      final secondRoom = await repository.fetchRoom('gyeongbokgung-walk');

      expect(secondRoom.messageGroups.first.bubbles.first.attachments, isEmpty);
      expect(secondRoom.messageGroups.map((group) => group.id), <String>[
        'g-2',
        'g-3',
      ]);
    });
  });
}
