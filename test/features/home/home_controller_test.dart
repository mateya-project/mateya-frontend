import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/application/home_controller.dart';
import 'package:mateya_app/features/home/data/home_repository.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';

void main() {
  group('HomeController', () {
    test(
      'loads activities and exposes featured plus paginated explore items',
      () async {
        final controller = HomeController(
          repository: _FakeHomeRepository.success(),
          flowKind: FlowKind.guest,
        );

        await controller.initialize();

        expect(controller.phase, AsyncPhase.success);
        expect(controller.featuredActivity?.id, 'featured');
        expect(controller.paginatedExplore.totalCount, 12);
        expect(controller.paginatedExplore.pageCount, 2);
        expect(controller.paginatedExplore.items, hasLength(10));
      },
    );

    test('search and category filters reduce explore results', () async {
      final controller = HomeController(
        repository: _FakeHomeRepository.success(),
        flowKind: FlowKind.guest,
      );

      await controller.initialize();
      controller.updateSearchQuery('한강');
      controller.applyFilter(
        controller.filter.copyWith(categoryIds: <String>{'walk'}),
      );

      expect(
        controller.filteredExploreActivities.map((item) => item.id),
        <String>['walk-1'],
      );
    });

    test('invalid filter draft returns validation error', () async {
      final controller = HomeController(
        repository: _FakeHomeRepository.success(),
        flowKind: FlowKind.host,
      );

      await controller.initialize();
      controller.applyFilter(
        controller.filter.copyWith(minPrice: 50000, maxPrice: 10000),
      );

      expect(controller.phase, AsyncPhase.validationError);
      expect(controller.errorMessage, isNotNull);
    });

    test('maps repository failure to network phase', () async {
      final controller = HomeController(
        repository: _FakeHomeRepository.failure(HomeLoadFailureType.network),
        flowKind: FlowKind.host,
      );

      await controller.initialize();

      expect(controller.phase, AsyncPhase.networkError);
      expect(controller.errorMessage, contains('네트워크'));
    });
  });
}

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository.success() : _failureType = null;

  _FakeHomeRepository.failure(this._failureType);

  final HomeLoadFailureType? _failureType;

  @override
  Future<List<ActivityItem>> fetchActivities() async {
    if (_failureType != null) {
      throw HomeRepositoryException(_failureType);
    }

    return <ActivityItem>[
      _activity(
        id: 'featured',
        title: '대표 활동',
        categoryId: 'sports',
        categoryLabel: '스포츠/액티비티',
        isFeatured: true,
      ),
      _activity(
        id: 'walk-1',
        title: '한강 밤 산책',
        categoryId: 'walk',
        categoryLabel: '관광/산책',
        languages: <String>{'ko', 'en'},
      ),
      for (var index = 0; index < 10; index += 1)
        _activity(
          id: 'item-$index',
          title: '샘플 활동 $index',
          categoryId: index.isEven ? 'traditional' : 'food',
          categoryLabel: index.isEven ? '전통문화' : '음식체험',
          startAt: DateTime(2026, 6, 13 + index, 10),
        ),
    ];
  }

  ActivityItem _activity({
    required String id,
    required String title,
    required String categoryId,
    required String categoryLabel,
    Set<String> languages = const <String>{'ko'},
    DateTime? startAt,
    bool isFeatured = false,
  }) {
    final start = startAt ?? DateTime(2026, 6, 13, 10);
    return ActivityItem(
      id: id,
      categoryId: categoryId,
      categoryLabel: categoryLabel,
      title: title,
      place: '서울',
      startAt: start,
      endAt: start.add(const Duration(hours: 2)),
      price: 10000,
      rating: 4.8,
      participantCount: 5,
      participantCapacity: 10,
      distanceKm: 0,
      audiences: const <ActivityAudienceOption>{
        ActivityAudienceOption.everyone,
      },
      languages: languages,
      statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
      isFeatured: isFeatured,
    );
  }
}
