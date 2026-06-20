import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mateya_app/features/create/application/create_controller.dart';
import 'package:mateya_app/features/create/data/create_repository.dart';
import 'package:mateya_app/features/create/domain/create_models.dart';
import 'package:mateya_app/features/create/presentation/widgets/create_overview_steps.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';

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

      expect(find.text('모임 유형'), findsOneWidget);
      expect(find.text('모임 장소'), findsOneWidget);
      expect(find.text('모임 상세'), findsOneWidget);
      expect(find.text('step1'), findsOneWidget);
      expect(find.text('step2'), findsOneWidget);
      expect(find.text('step3'), findsOneWidget);
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

    expect(find.text('모임 유형'), findsNothing);
    expect(find.text('클래스 장소'), findsOneWidget);
    expect(find.text('클래스 상세'), findsOneWidget);
    expect(find.text('step1'), findsOneWidget);
    expect(find.text('step2'), findsOneWidget);
    expect(find.text('step3'), findsNothing);
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

    expect(find.text('무엇을 경험하고 싶나요?'), findsOneWidget);
    expect(find.text('모임 목적에 맞는 카테고리를 선택해주세요.'), findsOneWidget);
    expect(find.text('문화 · 전통'), findsOneWidget);
    expect(find.text('행사 · 공연 · 축제'), findsOneWidget);
    expect(find.text('액티비티 · 레포츠'), findsOneWidget);

    final cultureCard = find.ancestor(
      of: find.text('문화 · 전통'),
      matching: find.byType(InkWell),
    );

    await tester.ensureVisible(cultureCard.first);
    await tester.tap(cultureCard.first);
    await tester.pumpAndSettle();

    expect(controller.selectedCategoryId, 'CULTURE_TRADITION');
  });
}

void _noop() {}
