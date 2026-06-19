enum HomeSection { home, explore, favorites, nearbyCultureMap, chat, profile }

enum HomeLoadFailureType { network, server }

enum ActivitySortOption { recommended, popular, latest, closingSoon, nearby }

enum ActivityAudienceOption {
  everyone,
  foreignerFriendly,
  koreanFriendly,
  touristFriendly,
  beginnerFriendly,
}

enum ActivityStatusOption { recruiting, closingSoon, newlyListed }

enum DistanceRangeOption { local, within1km, within5km, within10km }

class ActivityCategory {
  const ActivityCategory({
    required this.id,
    required this.label,
    this.isAll = false,
  });

  final String id;
  final String label;
  final bool isAll;
}

class ActivityLanguageOption {
  const ActivityLanguageOption({required this.code, required this.label});

  final String code;
  final String label;
}

class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.categoryId,
    required this.categoryLabel,
    required this.title,
    required this.place,
    required this.startAt,
    required this.endAt,
    required this.price,
    required this.rating,
    required this.participantCount,
    required this.participantCapacity,
    required this.distanceKm,
    required this.audiences,
    required this.languages,
    required this.statuses,
    this.imageUrl,
    this.isFeatured = false,
  });

  final String id;
  final String categoryId;
  final String categoryLabel;
  final String title;
  final String place;
  final DateTime startAt;
  final DateTime endAt;
  final int price;
  final double rating;
  final int participantCount;
  final int participantCapacity;
  final int distanceKm;
  final Set<ActivityAudienceOption> audiences;
  final Set<String> languages;
  final Set<ActivityStatusOption> statuses;
  final String? imageUrl;
  final bool isFeatured;

  ActivityItem copyWith({
    String? id,
    String? categoryId,
    String? categoryLabel,
    String? title,
    String? place,
    DateTime? startAt,
    DateTime? endAt,
    int? price,
    double? rating,
    int? participantCount,
    int? participantCapacity,
    int? distanceKm,
    Set<ActivityAudienceOption>? audiences,
    Set<String>? languages,
    Set<ActivityStatusOption>? statuses,
    Object? imageUrl = _sentinel,
    bool? isFeatured,
  }) {
    return ActivityItem(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      title: title ?? this.title,
      place: place ?? this.place,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      participantCount: participantCount ?? this.participantCount,
      participantCapacity: participantCapacity ?? this.participantCapacity,
      distanceKm: distanceKm ?? this.distanceKm,
      audiences: audiences ?? this.audiences,
      languages: languages ?? this.languages,
      statuses: statuses ?? this.statuses,
      imageUrl: imageUrl == _sentinel ? this.imageUrl : imageUrl as String?,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}

class ExploreFilter {
  const ExploreFilter({
    this.sort = ActivitySortOption.recommended,
    this.categoryIds = const <String>{'all'},
    this.audiences = const <ActivityAudienceOption>{
      ActivityAudienceOption.everyone,
    },
    this.languages = const <String>{'ko'},
    this.distance = DistanceRangeOption.local,
    this.startDate,
    this.endDate,
    this.minPrice,
    this.maxPrice,
    this.statuses = const <ActivityStatusOption>{},
  });

  final ActivitySortOption sort;
  final Set<String> categoryIds;
  final Set<ActivityAudienceOption> audiences;
  final Set<String> languages;
  final DistanceRangeOption distance;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? minPrice;
  final int? maxPrice;
  final Set<ActivityStatusOption> statuses;

  bool get isDefault =>
      sort == ActivitySortOption.recommended &&
      categoryIds.length == 1 &&
      categoryIds.contains('all') &&
      audiences.length == 1 &&
      audiences.contains(ActivityAudienceOption.everyone) &&
      languages.length == 1 &&
      languages.contains('ko') &&
      distance == DistanceRangeOption.local &&
      startDate == null &&
      endDate == null &&
      minPrice == null &&
      maxPrice == null &&
      statuses.isEmpty;

  ExploreFilter copyWith({
    ActivitySortOption? sort,
    Set<String>? categoryIds,
    Set<ActivityAudienceOption>? audiences,
    Set<String>? languages,
    DistanceRangeOption? distance,
    Object? startDate = _sentinel,
    Object? endDate = _sentinel,
    Object? minPrice = _sentinel,
    Object? maxPrice = _sentinel,
    Set<ActivityStatusOption>? statuses,
  }) {
    return ExploreFilter(
      sort: sort ?? this.sort,
      categoryIds: categoryIds ?? this.categoryIds,
      audiences: audiences ?? this.audiences,
      languages: languages ?? this.languages,
      distance: distance ?? this.distance,
      startDate: startDate == _sentinel
          ? this.startDate
          : startDate as DateTime?,
      endDate: endDate == _sentinel ? this.endDate : endDate as DateTime?,
      minPrice: minPrice == _sentinel ? this.minPrice : minPrice as int?,
      maxPrice: maxPrice == _sentinel ? this.maxPrice : maxPrice as int?,
      statuses: statuses ?? this.statuses,
    );
  }
}

class HomeRepositoryException implements Exception {
  const HomeRepositoryException(this.type);

  final HomeLoadFailureType type;
}

class ExploreActivitiesPage {
  const ExploreActivitiesPage({
    required this.items,
    required this.page,
    required this.size,
    required this.hasNext,
    required this.nextPage,
  });

  final List<ActivityItem> items;
  final int page;
  final int size;
  final bool hasNext;
  final int? nextPage;
}

const Object _sentinel = Object();

const Set<String> kSupportedExploreLanguageCodes = <String>{
  'ko',
  'en',
  'zh',
  'ja',
};

const List<ActivityLanguageOption> kPrimaryLanguages = <ActivityLanguageOption>[
  ActivityLanguageOption(code: 'ko', label: '한국어'),
  ActivityLanguageOption(code: 'en', label: '영어'),
  ActivityLanguageOption(code: 'ja', label: '일본어'),
  ActivityLanguageOption(code: 'zh', label: '중국어'),
];

extension ActivitySortOptionX on ActivitySortOption {
  String get label => switch (this) {
    ActivitySortOption.recommended => '추천순',
    ActivitySortOption.popular => '인기순',
    ActivitySortOption.latest => '최신순',
    ActivitySortOption.closingSoon => '마감임박순',
    ActivitySortOption.nearby => '가까운 거리순',
  };
}

extension ActivityAudienceOptionX on ActivityAudienceOption {
  String get label => switch (this) {
    ActivityAudienceOption.everyone => '누구나',
    ActivityAudienceOption.foreignerFriendly => '외국인 환영',
    ActivityAudienceOption.koreanFriendly => '한국인 환영',
    ActivityAudienceOption.touristFriendly => '관광객 추천',
    ActivityAudienceOption.beginnerFriendly => '초보자 환영',
  };
}

extension ActivityStatusOptionX on ActivityStatusOption {
  String get label => switch (this) {
    ActivityStatusOption.recruiting => '모집 중',
    ActivityStatusOption.closingSoon => '곧 마감 (24시간 내)',
    ActivityStatusOption.newlyListed => '신규 등록 (24시간 내)',
  };
}

extension DistanceRangeOptionX on DistanceRangeOption {
  String get label => switch (this) {
    DistanceRangeOption.local => '내 지역',
    DistanceRangeOption.within1km => '1km 이내',
    DistanceRangeOption.within5km => '5km 이내',
    DistanceRangeOption.within10km => '10km 이내',
  };

  int get maxDistanceKm => switch (this) {
    DistanceRangeOption.local => 0,
    DistanceRangeOption.within1km => 1,
    DistanceRangeOption.within5km => 5,
    DistanceRangeOption.within10km => 10,
  };
}

extension ActivityItemX on ActivityItem {
  bool matchesKeyword(String keyword) {
    if (keyword.trim().isEmpty) {
      return true;
    }
    final normalized = keyword.trim().toLowerCase();
    return title.toLowerCase().contains(normalized) ||
        place.toLowerCase().contains(normalized);
  }

  bool matchesFilter(ExploreFilter filter) {
    final categoryMatch =
        filter.categoryIds.contains('all') ||
        filter.categoryIds.contains(categoryId);
    final audienceMatch =
        filter.audiences.isEmpty || audiences.any(filter.audiences.contains);
    final languageMatch =
        filter.languages.isEmpty || languages.any(filter.languages.contains);
    final statusMatch =
        filter.statuses.isEmpty || statuses.any(filter.statuses.contains);
    final dateMatch =
        (filter.startDate == null ||
            !startAt.isBefore(
              DateTime(
                filter.startDate!.year,
                filter.startDate!.month,
                filter.startDate!.day,
              ),
            )) &&
        (filter.endDate == null ||
            !startAt.isAfter(
              DateTime(
                filter.endDate!.year,
                filter.endDate!.month,
                filter.endDate!.day,
                23,
                59,
                59,
              ),
            ));
    final priceMatch =
        (filter.minPrice == null || price >= filter.minPrice!) &&
        (filter.maxPrice == null || price <= filter.maxPrice!);
    final distanceMatch = distanceKm <= filter.distance.maxDistanceKm;

    return categoryMatch &&
        audienceMatch &&
        languageMatch &&
        statusMatch &&
        dateMatch &&
        priceMatch &&
        distanceMatch;
  }
}
