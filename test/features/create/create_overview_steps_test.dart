import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mateya_app/features/create/application/create_controller.dart';
import 'package:mateya_app/features/create/data/create_repository.dart';
import 'package:mateya_app/features/create/domain/create_models.dart';
import 'package:mateya_app/features/create/presentation/widgets/create_overview_steps.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';

void main() {
  testWidgets(
    'group progress header renders meeting steps and completed state',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CreateFlowProgressHeader(
              flowType: CreateFlowType.group,
              steps: <CreateStep>[
                CreateStep.category,
                CreateStep.place,
                CreateStep.details,
              ],
              currentStep: CreateStep.place,
              onBack: _noop,
            ),
          ),
        ),
      );

      expect(find.text('카테고리'), findsOneWidget);
      expect(find.text('장소'), findsOneWidget);
      expect(find.text('정보 입력'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    },
  );

  testWidgets('class progress header omits the category step', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CreateFlowProgressHeader(
            flowType: CreateFlowType.classRegistration,
            steps: <CreateStep>[CreateStep.place, CreateStep.details],
            currentStep: CreateStep.details,
            onBack: _noop,
          ),
        ),
      ),
    );

    expect(find.text('카테고리'), findsNothing);
    expect(find.text('장소'), findsOneWidget);
    expect(find.text('정보 입력'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsNothing);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('category step renders card-based category selector', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = CreateController(
      repository: MockCreateRepository(),
      categoryRepository: MockActivityCategoryRepository(),
      flowType: CreateFlowType.group,
    );

    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CategoryStepView(controller: controller)),
      ),
    );

    expect(find.text('어떤 경험을 만들고 있나요?'), findsOneWidget);
    expect(
      find.text('등록하려는 모임 또는 클래스에 가장 잘 맞는 카테고리를 선택해 주세요.'),
      findsOneWidget,
    );
    expect(find.text('문화/전통'), findsOneWidget);
    expect(find.text('행사/공연/축제'), findsOneWidget);
    expect(find.text('액티비티/레포츠'), findsOneWidget);

    final cultureCard = find.ancestor(
      of: find.text('문화/전통'),
      matching: find.byType(InkWell),
    );

    await tester.ensureVisible(cultureCard.first);
    await tester.tap(cultureCard.first);
    await tester.pumpAndSettle();

    expect(controller.selectedCategoryId, 'CULTURE_TRADITION');
  });

  testWidgets(
    'group category step does not overflow in English on phone width',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = CreateController(
        repository: MockCreateRepository(),
        categoryRepository: MockActivityCategoryRepository(),
        flowType: CreateFlowType.group,
      );

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: MateyaLocalizations.supportedLocales,
          localizationsDelegates: MateyaLocalizations.delegates,
          home: Scaffold(body: CategoryStepView(controller: controller)),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        find.text('What kind of experience are you creating?'),
        findsOneWidget,
      );
    },
  );

  testWidgets('category titles align within the same row on phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = CreateController(
      repository: MockCreateRepository(),
      categoryRepository: MockActivityCategoryRepository(),
      flowType: CreateFlowType.group,
    );

    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CategoryStepView(controller: controller)),
      ),
    );
    await tester.pump();

    final cultureTop = tester.getTopLeft(find.text('문화/전통')).dy;
    final festivalTop = tester.getTopLeft(find.text('행사/공연/축제')).dy;

    expect(cultureTop, moreOrLessEquals(festivalTop, epsilon: 1));
  });
}

void _noop() {}
