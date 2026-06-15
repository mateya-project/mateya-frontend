import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mateya_app/features/create/application/create_controller.dart';
import 'package:mateya_app/features/create/data/create_repository.dart';
import 'package:mateya_app/features/create/domain/create_models.dart';

void main() {
  group('CreateController', () {
    test(
      'group flow stays on category step until a category is selected',
      () async {
        final controller = CreateController(
          repository: MockCreateRepository(),
          flowType: CreateFlowType.group,
          now: () => DateTime(2026, 6, 14, 9),
        );

        await controller.continueFlow();

        expect(controller.step, CreateStep.category);
        expect(controller.errorFor('categories'), isNotNull);

        controller.toggleCategory('traditional');
        await controller.continueFlow();

        expect(controller.step, CreateStep.place);

        controller.dispose();
      },
    );

    test('class flow can submit after required fields are filled', () async {
      final controller = CreateController(
        repository: MockCreateRepository(),
        flowType: CreateFlowType.classRegistration,
        now: () => DateTime(2026, 6, 14, 9),
      );

      await controller.initialize();
      controller.selectPlace(controller.recommendedPlaces.first);
      await controller.continueFlow();

      expect(controller.step, CreateStep.details);

      controller.updateTitle('전통 다도 입문 클래스');
      controller.updateDescription('기초 다도 예절과 차 우리는 법을 함께 배웁니다.');
      controller.updateEventDate(DateTime(2026, 6, 20));
      controller.updateStartTime(const TimeOfDay(hour: 14, minute: 0));
      controller.updateEndTime(const TimeOfDay(hour: 16, minute: 0));
      controller.updateParticipantCapacity(8);
      controller.toggleLanguage('ko');
      controller.toggleLanguage('en');
      controller.updatePriceType(CreatePriceType.free);

      expect(controller.canContinueCurrentStep, isTrue);

      await controller.continueFlow();

      expect(controller.step, CreateStep.completed);
      expect(controller.submitResult, isNotNull);
      expect(
        controller.submitResult?.flowType,
        CreateFlowType.classRegistration,
      );

      controller.dispose();
    });
  });
}
