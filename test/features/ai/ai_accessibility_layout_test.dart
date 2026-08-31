import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/ai/data/ai_repository.dart';
import 'package:mateya_app/features/ai/domain/ai_models.dart';
import 'package:mateya_app/features/ai/presentation/ai_conversation_flow_page.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';

void main() {
  testWidgets('AI room header is optically centered and hint stays one line', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: MateyaLocalizations.delegates,
        supportedLocales: MateyaLocalizations.supportedLocales,
        home: AiConversationFlowPage(
          repository: MockAiRepository(includeRecommendationOnCreate: true),
          seed: const AiConversationSeed(
            entryPoint: 'PLACE_DETAIL',
            anchorPlaceId: '1',
            anchorPlaceName: '경복궁',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final headerRect = tester.getRect(
      find.byKey(const ValueKey<String>('ai-room-header-lockup')),
    );
    expect(headerRect.center.dx, lessThan(tester.view.physicalSize.width / 2));
    expect(
      tester
          .widget<TextField>(
            find.byKey(const ValueKey<String>('ai-message-composer')),
          )
          .decoration
          ?.hintMaxLines,
      1,
    );

    expect(find.byType(Image), findsOneWidget);
    final scoreDetails = find.text('85점');
    expect(scoreDetails, findsOneWidget);
    await tester.ensureVisible(scoreDetails);
    await tester.tap(scoreDetails);
    await tester.pumpAndSettle();
    expect(find.text('추천 점수 산정 기준'), findsOneWidget);
    expect(find.text('사용자 적합도'), findsOneWidget);
    expect(find.text('관광 분산 기여도'), findsOneWidget);
  });

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
