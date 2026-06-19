import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mateya_app/features/create/domain/create_models.dart';
import 'package:mateya_app/features/create/presentation/widgets/create_overview_steps.dart';

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
}

void _noop() {}
