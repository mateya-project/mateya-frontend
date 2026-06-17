part of 'home_repository.dart';

class MockHomeRepository implements HomeRepository {
  @override
  Future<List<ActivityItem>> fetchHomeActivities() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return _mockActivities;
  }

  @override
  Future<ExploreActivitiesPage> fetchExploreActivities({
    required int page,
    required String keyword,
    required ExploreFilter filter,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));

    final filtered = _sortActivities(
      _mockActivities
          .where((item) => !item.isFeatured)
          .where((item) => item.matchesKeyword(keyword))
          .where((item) => item.matchesFilter(filter))
          .toList(),
      filter.sort,
    );

    const pageSize = 20;
    final startIndex = page * pageSize;
    if (startIndex >= filtered.length) {
      return ExploreActivitiesPage(
        items: const <ActivityItem>[],
        page: page,
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
}
