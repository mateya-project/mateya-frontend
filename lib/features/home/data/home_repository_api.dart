part of 'home_repository.dart';

class ApiHomeRepository implements HomeRepository {
  ApiHomeRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
  }) : _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           );

  final AuthSessionStore _sessionStore;
  final MateyaApiClient _apiClient;

  @override
  Future<List<ActivityItem>> fetchHomeActivities() async {
    try {
      final trendingData = await _apiClient.getJson(
        '/api/v1/home/trending',
        requiresAuth: true,
      );
      final experiencesData = await _apiClient.getJson(
        '/api/v1/home/experiences',
        requiresAuth: true,
      );

      final activities = <ActivityItem>[];
      final seenIds = <String>{};

      if (trendingData != null) {
        final item = _parseActivityCard(trendingData, isFeatured: true);
        activities.add(item);
        seenIds.add(item.id);
      }

      if (experiencesData is List<Object?>) {
        for (final entry in experiencesData) {
          final item = _parseActivityCard(entry, isFeatured: false);
          if (seenIds.add(item.id)) {
            activities.add(item);
          }
        }
      }

      return activities;
    } on MateyaApiException catch (error) {
      if (error.type == ApiFailureType.network) {
        throw const HomeRepositoryException(HomeLoadFailureType.network);
      }
      throw const HomeRepositoryException(HomeLoadFailureType.server);
    }
  }

  @override
  Future<ExploreActivitiesPage> fetchExploreActivities({
    required int page,
    required String keyword,
    required ExploreFilter filter,
  }) async {
    try {
      final data = await _apiClient.getJson(
        '/api/v1/activities',
        requiresAuth: true,
        queryParametersAll: _buildExploreQueryParametersAll(
          page: page,
          keyword: keyword,
          filter: filter,
        ),
      );
      final json = _asMap(data);
      final items = (json['items'] as List<Object?>? ?? const <Object?>[])
          .map((entry) => _parseActivityCard(entry, isFeatured: false))
          .toList(growable: false);
      return ExploreActivitiesPage(
        items: items,
        page: json['page'] as int? ?? page,
        size: json['size'] as int? ?? items.length,
        hasNext: json['hasNext'] as bool? ?? false,
        nextPage: json['nextPage'] as int?,
      );
    } on MateyaApiException catch (error) {
      if (error.type == ApiFailureType.network) {
        throw const HomeRepositoryException(HomeLoadFailureType.network);
      }
      throw const HomeRepositoryException(HomeLoadFailureType.server);
    }
  }

  @override
  Future<List<ActivityItem>> fetchFavoriteActivities() async {
    try {
      final data = await _apiClient.getJson(
        '/api/v1/users/me/favorite-activities',
        requiresAuth: true,
      );
      final items = data is List<Object?> ? data : const <Object?>[];
      return items
          .map((entry) => _parseActivityCard(entry, isFeatured: false))
          .toList(growable: false);
    } on MateyaApiException catch (error) {
      if (error.type == ApiFailureType.network) {
        throw const HomeRepositoryException(HomeLoadFailureType.network);
      }
      throw const HomeRepositoryException(HomeLoadFailureType.server);
    }
  }

  Map<String, List<String>> _buildExploreQueryParametersAll({
    required int page,
    required String keyword,
    required ExploreFilter filter,
  }) {
    final queryParameters = <String, List<String>>{
      'page': <String>['$page'],
      'sort': <String>[_sortToServerValue(filter.sort)],
    };
    final trimmedKeyword = keyword.trim();
    if (trimmedKeyword.isNotEmpty) {
      queryParameters['keyword'] = <String>[trimmedKeyword];
    }

    final categories = filter.categoryIds
        .where((categoryId) => categoryId != 'all')
        .toSet()
        .toList(growable: false);
    if (categories.isNotEmpty) {
      queryParameters['categories'] = categories;
    }

    if (filter.languages.isNotEmpty) {
      queryParameters['languages'] = filter.languages.toList(growable: false);
    }

    if (filter.audiences.isNotEmpty) {
      queryParameters['targets'] = filter.audiences
          .map(_audienceToServerValue)
          .toList(growable: false);
    }

    if (filter.minPrice != null) {
      queryParameters['costMin'] = <String>['${filter.minPrice}'];
    }
    if (filter.maxPrice != null) {
      queryParameters['costMax'] = <String>['${filter.maxPrice}'];
    }

    if (filter.startDate != null) {
      queryParameters['startFrom'] = <String>[
        DateTime(
          filter.startDate!.year,
          filter.startDate!.month,
          filter.startDate!.day,
        ).toIso8601String(),
      ];
    }
    if (filter.endDate != null) {
      queryParameters['startTo'] = <String>[
        DateTime(
          filter.endDate!.year,
          filter.endDate!.month,
          filter.endDate!.day,
          23,
          59,
          59,
        ).toIso8601String(),
      ];
    }

    if (filter.statuses.isNotEmpty) {
      queryParameters['statusFilters'] = filter.statuses
          .map(_statusToServerValue)
          .toList(growable: false);
    }

    final user = _sessionStore.session?.user;
    if (user?.activityLatitude != null && user?.activityLongitude != null) {
      queryParameters['latitude'] = <String>['${user!.activityLatitude!}'];
      queryParameters['longitude'] = <String>['${user.activityLongitude!}'];
      queryParameters['radiusKm'] = <String>[
        '${filter.distance.maxDistanceKm}',
      ];
    }

    return queryParameters;
  }

  ActivityItem _parseActivityCard(Object? value, {required bool isFeatured}) {
    final json = _asMap(value);

    final categoryCode = json['category'] as String? ?? 'PUBLIC_FACILITY';
    final mappedCategory =
        _categoryByServerCode[categoryCode] ?? _fallbackCategory;
    final priceType = json['priceType'] as String? ?? 'FREE';
    final priceAmount = json['priceAmount'] as int? ?? 0;

    return ActivityItem(
      id: '${json['id']}',
      categoryId: mappedCategory.id,
      categoryLabel: mappedCategory.label,
      title: json['title'] as String? ?? '',
      place:
          (json['placeName'] as String?) ??
          (json['placeAddress'] as String?) ??
          '',
      startAt: parseServerDateTime(json['startAt'] as String),
      endAt: parseServerDateTime(json['endAt'] as String),
      price: priceType == 'FREE' ? 0 : priceAmount,
      rating: (json['reviewRating'] as num?)?.toDouble() ?? 0,
      participantCount: json['participantCount'] as int? ?? 0,
      participantCapacity: json['capacity'] as int? ?? 0,
      distanceKm: ((json['distanceKm'] as num?) ?? 0).round(),
      audiences: const <ActivityAudienceOption>{
        ActivityAudienceOption.everyone,
      },
      languages: <String>{
        if ((json['language'] as String?) != null) json['language'] as String,
      },
      statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
      imageUrl: json['imageUrl'] as String?,
      isFeatured: isFeatured,
    );
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw const HomeRepositoryException(HomeLoadFailureType.server);
  }
}
