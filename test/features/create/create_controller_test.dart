import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mateya_app/features/create/application/create_controller.dart';
import 'package:mateya_app/features/create/data/create_repository.dart';
import 'package:mateya_app/features/create/domain/create_models.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';

void main() {
  group('CreateController', () {
    test(
      'group flow stays on category step until a category is selected',
      () async {
        final controller = CreateController(
          repository: MockCreateRepository(),
          categoryRepository: MockActivityCategoryRepository(),
          flowType: CreateFlowType.group,
          now: () => DateTime(2026, 6, 14, 9),
        );

        await controller.continueFlow();

        expect(controller.step, CreateStep.category);
        expect(controller.errorFor('categories'), isNotNull);

        controller.toggleCategory('CULTURE_TRADITION');
        await controller.continueFlow();

        expect(controller.step, CreateStep.place);

        controller.dispose();
      },
    );

    test('class flow can submit after required fields are filled', () async {
      final controller = CreateController(
        repository: MockCreateRepository(),
        categoryRepository: MockActivityCategoryRepository(),
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

    test('manual class place requires a category selection', () async {
      final controller = CreateController(
        repository: MockCreateRepository(),
        categoryRepository: MockActivityCategoryRepository(),
        flowType: CreateFlowType.classRegistration,
        now: () => DateTime(2026, 6, 14, 9),
      );

      controller.updateManualPlaceName('성수 티 스튜디오');
      controller.updateManualPlaceAddress('서울 성동구 성수일로 32');

      await controller.continueFlow();

      expect(controller.step, CreateStep.place);
      expect(controller.errorFor('categories'), isNotNull);

      controller.dispose();
    });

    test(
      'class category detail reloads recommendations with detail code',
      () async {
        final repository = _FakeCreateRepository();
        final controller = CreateController(
          repository: repository,
          categoryRepository: MockActivityCategoryRepository(),
          flowType: CreateFlowType.classRegistration,
          now: () => DateTime(2026, 6, 14, 9),
        );

        await controller.chooseCategory('CULTURE_TRADITION');
        expect(repository.lastRecommendedCategoryIds, <String>{
          'CULTURE_TRADITION',
        });
        expect(repository.lastRecommendedCategoryDetailCode, isNull);

        await controller.chooseCategoryDetail('HANOK');

        expect(repository.lastRecommendedCategoryDetailCode, 'HANOK');
        expect(controller.selectedCategoryDetailCode, 'HANOK');

        controller.dispose();
      },
    );
  });
}

class _FakeCreateRepository extends MockCreateRepository {
  Set<String> lastRecommendedCategoryIds = const <String>{};
  String? lastRecommendedCategoryDetailCode;

  @override
  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
    String? categoryDetailCode,
  }) async {
    lastRecommendedCategoryIds = categoryIds;
    lastRecommendedCategoryDetailCode = categoryDetailCode;
    return const <CreatePlaceSuggestion>[
      CreatePlaceSuggestion(
        id: 'bukchon',
        name: '북촌문화센터',
        address: '서울 종로구 계동길 37',
        description: '한옥 체험',
        distanceKm: 2,
        latitude: 37.582604,
        longitude: 126.983998,
        categoryIds: <String>{'CULTURE_TRADITION'},
        serverCategoryCode: 'CULTURE_TRADITION',
        categoryDetailCode: 'HANOK',
        categoryDetailName: '한옥',
      ),
    ];
  }
}
