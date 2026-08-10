import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/ai/data/ai_repository.dart';
import 'package:mateya_app/features/ai/domain/ai_models.dart';
import 'package:mateya_app/features/ai/presentation/ai_conversation_flow_page.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';

void main() {
  testWidgets('AI room remains usable on a compact screen with large text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: MateyaLocalizations.delegates,
        supportedLocales: MateyaLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: AiConversationFlowPage(
          repository: MockAiRepository(),
          seed: const AiConversationSeed(
            entryPoint: 'PLACE_DETAIL',
            anchorPlaceId: '1',
            anchorPlaceName: '경복궁',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.bySemanticsLabel(RegExp('사진 첨부|Attach photo')), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('AI 메시지 보내기|Send AI message')),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
