import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/application/home_controller.dart';
import 'package:mateya_app/features/home/data/home_repository.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';

void main() {
  group('HomeController', () {
    test(
      'loads home activities and the first explore page separately',
      () async {
        final controller = HomeController(
          repository: _FakeHomeRepository.success(),
          categoryRepository: MockActivityCategoryRepository(),
          flowKind: FlowKind.guest,
          searchDebounceDuration: Duration.zero,
        );

        await controller.initialize();
        await controller.ensureExploreLoaded();

        expect(controller.homePhase, AsyncPhase.success);
        expect(controller.featuredActivity?.id, 'featured');
        expect(controller.explorePhase, AsyncPhase.success);
        expect(controller.exploreActivities, hasLength(20));
        expect(controller.hasMoreExplore, isTrue);
      },
    );

    test('loadMoreExplore appends the next server page', () async {
      final controller = HomeController(
        repository: _FakeHomeRepository.success(),
        categoryRepository: MockActivityCategoryRepository(),
        flowKind: FlowKind.guest,
        searchDebounceDuration: Duration.zero,
      );

      await controller.initialize();
      await controller.ensureExploreLoaded();
      await controller.loadMoreExplore();

      expect(controller.exploreActivities, hasLength(25));
      expect(controller.hasMoreExplore, isFalse);
      expect(controller.exploreActivities.last.id, 'item-23');
    });

    test(
      'search and category filters reload explore results from page 0',
      () async {
        final controller = HomeController(
          repository: _FakeHomeRepository.success(),
          categoryRepository: MockActivityCategoryRepository(),
          flowKind: FlowKind.guest,
          searchDebounceDuration: Duration.zero,
        );

        await controller.initialize();
        controller.updateSearchQuery('한강');
        await controller.refreshExplore();
        controller.applyFilter(
          controller.filter.copyWith(
            categoryIds: <String>{'TOURIST_ATTRACTION'},
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(controller.exploreActivities.map((item) => item.id), <String>[
          'walk-1',
        ]);
        expect(controller.hasMoreExplore, isFalse);
      },
    );

    test('unsupported explore languages return validation error', () async {
      final controller = HomeController(
        repository: _FakeHomeRepository.success(),
        categoryRepository: MockActivityCategoryRepository(),
        flowKind: FlowKind.host,
        searchDebounceDuration: Duration.zero,
      );

      await controller.initialize();
      controller.applyFilter(
        controller.filter.copyWith(languages: <String>{'ko', 'vi'}),
      );

      expect(controller.explorePhase, AsyncPhase.validationError);
      expect(controller.exploreErrorMessage, contains('한국어'));
    });

    test('maps repository failure to network phase', () async {
      final controller = HomeController(
        repository: _FakeHomeRepository.failure(HomeLoadFailureType.network),
        categoryRepository: MockActivityCategoryRepository(),
        flowKind: FlowKind.host,
        searchDebounceDuration: Duration.zero,
      );

      await controller.initialize();

      expect(controller.homePhase, AsyncPhase.networkError);
      expect(controller.homeErrorMessage, contains('네트워크'));
    });
  });
}

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository.success() : _failureType = null;

  _FakeHomeRepository.failure(this._failureType);

  final HomeLoadFailureType? _failureType;

  @override
  Future<List<ActivityItem>> fetchHomeActivities() async {
    if (_failureType != null) {
      throw HomeRepositoryException(_failureType);
    }

    return <ActivityItem>[
      _activity(
        id: 'featured',
        title: '대표 활동',
        categoryId: 'SPORTS',
        categoryLabel: '스포츠',
        isFeatured: true,
      ),
      _activity(
        id: 'walk-1',
        title: '한강 밤 산책',
        categoryId: 'TOURIST_ATTRACTION',
        categoryLabel: '관광지',
        languages: <String>{'ko', 'en'},
      ),
      for (var index = 0; index < 10; index += 1)
        _activity(
          id: 'home-$index',
          title: '홈 샘플 활동 $index',
          categoryId: index.isEven ? 'CULTURE_TRADITION' : 'SHOPPING',
          categoryLabel: index.isEven ? '문화/전통' : '쇼핑',
          startAt: DateTime(2026, 6, 13 + index, 10),
        ),
    ];
  }

  @override
  Future<ExploreActivitiesPage> fetchExploreActivities({
    required int page,
    required String keyword,
    required ExploreFilter filter,
  }) async {
    if (_failureType != null) {
      throw HomeRepositoryException(_failureType);
    }

    final filtered = _exploreActivities
        .where((item) => item.matchesKeyword(keyword))
        .where((item) => item.matchesFilter(filter))
        .toList(growable: false);
    const pageSize = 20;
    final startIndex = page * pageSize;
    if (startIndex >= filtered.length) {
      return const ExploreActivitiesPage(
        items: <ActivityItem>[],
        page: 0,
        size: pageSize,
        hasNext: false,
        nextPage: null,
      );
    }

    final endIndex = (startIndex + pageSize).clamp(0, filtered.length);
    final hasNext = endIndex < filtered.length;
    return ExploreActivitiesPage(
      items: filtered.sublist(startIndex, endIndex),
      page: page,
      size: pageSize,
      hasNext: hasNext,
      nextPage: hasNext ? page + 1 : null,
    );
  }

  @override
  Future<List<ActivityItem>> fetchFavoriteActivities() async {
    if (_failureType != null) {
      throw HomeRepositoryException(_failureType);
    }
    return const <ActivityItem>[];
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

final List<ActivityItem> _exploreActivities = <ActivityItem>[
  _buildExploreActivity(
    id: 'walk-1',
    title: '한강 밤 산책',
    categoryId: 'TOURIST_ATTRACTION',
    categoryLabel: '관광지',
    languages: <String>{'ko', 'en'},
  ),
  for (var index = 0; index < 24; index += 1)
    _buildExploreActivity(
      id: 'item-$index',
      title: '탐색 활동 $index',
      categoryId: index.isEven ? 'CULTURE_TRADITION' : 'SHOPPING',
      categoryLabel: index.isEven ? '문화/전통' : '쇼핑',
      startAt: DateTime(2026, 6, 15 + index, 10),
    ),
];

ActivityItem _buildExploreActivity({
  required String id,
  required String title,
  required String categoryId,
  required String categoryLabel,
  Set<String> languages = const <String>{'ko'},
  DateTime? startAt,
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
    audiences: const <ActivityAudienceOption>{ActivityAudienceOption.everyone},
    languages: languages,
    statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
  );
}
