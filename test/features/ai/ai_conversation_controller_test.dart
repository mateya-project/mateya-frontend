import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/ai/application/ai_conversation_controller.dart';
import 'package:mateya_app/features/ai/data/ai_repository.dart';
import 'package:mateya_app/features/ai/domain/ai_models.dart';

void main() {
  test(
    'AI conversation starts from a seeded place and persists a turn',
    () async {
      final controller = AiConversationController(
        repository: MockAiRepository(),
      );

      await controller.initialize(
        seed: const AiConversationSeed(
          entryPoint: 'PLACE_DETAIL',
          anchorPlaceId: '1',
          anchorPlaceName: '경복궁',
        ),
      );
      final sent = await controller.sendMessage('이번 주말 역사 여행을 추천해줘');

      expect(sent, isTrue);
      expect(controller.current?.anchorPlaceName, '경복궁');
      expect(controller.current?.messages, hasLength(2));
      expect(controller.current?.messages.last.role, 'ASSISTANT');
      expect(controller.isSending, isFalse);
    },
  );
}
