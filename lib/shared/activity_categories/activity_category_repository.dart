import '../../app/app_config.dart';
import '../auth/auth_session.dart';
import '../localization/mateya_localizations.dart';
import '../network/mateya_api_client.dart';
import '../preferences/mateya_language_preferences.dart';

class ActivityCategoryMetadata {
  const ActivityCategoryMetadata({
    required this.code,
    required this.label,
    required this.displayOrder,
    required this.active,
    this.children = const <ActivityCategoryDetailMetadata>[],
  });

  final String code;
  final String label;
  final int displayOrder;
  final bool active;
  final List<ActivityCategoryDetailMetadata> children;
}

class ActivityCategoryDetailMetadata {
  const ActivityCategoryDetailMetadata({
    required this.code,
    required this.label,
    required this.displayOrder,
    required this.active,
  });

  final String code;
  final String label;
  final int displayOrder;
  final bool active;
}

List<ActivityCategoryMetadata> get kFallbackActivityCategories {
  final l10n = MateyaLocalizations.current;
  return <ActivityCategoryMetadata>[
    ActivityCategoryMetadata(
      code: 'TOURIST_ATTRACTION',
      label: l10n.activityCategoryTouristAttraction,
      displayOrder: 1,
      active: true,
    ),
    ActivityCategoryMetadata(
      code: 'TRAVEL_COURSE',
      label: l10n.activityCategoryTravelCourse,
      displayOrder: 2,
      active: true,
    ),
    ActivityCategoryMetadata(
      code: 'CULTURE_TRADITION',
      label: l10n.activityCategoryCultureTradition,
      displayOrder: 3,
      active: true,
    ),
    ActivityCategoryMetadata(
      code: 'EVENT_PERFORMANCE_FESTIVAL',
      label: l10n.activityCategoryEventPerformanceFestival,
      displayOrder: 4,
      active: true,
    ),
    ActivityCategoryMetadata(
      code: 'SPORTS',
      label: l10n.activityCategorySports,
      displayOrder: 5,
      active: true,
    ),
    ActivityCategoryMetadata(
      code: 'ACTIVITY_LEPORTS',
      label: l10n.activityCategoryActivityLeports,
      displayOrder: 6,
      active: true,
    ),
    ActivityCategoryMetadata(
      code: 'PUBLIC_FACILITY',
      label: l10n.activityCategoryPublicFacility,
      displayOrder: 7,
      active: true,
    ),
    ActivityCategoryMetadata(
      code: 'SHOPPING',
      label: l10n.activityCategoryShopping,
      displayOrder: 8,
      active: true,
    ),
  ];
}

abstract interface class ActivityCategoryRepository {
  Future<List<ActivityCategoryMetadata>> fetchActivityCategories();
}

class ApiActivityCategoryRepository implements ActivityCategoryRepository {
  ApiActivityCategoryRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    DateTime Function()? now,
  }) : _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _now = now ?? DateTime.now;

  static const Duration _cacheTtl = Duration(hours: 12);
  static final Map<String, List<ActivityCategoryMetadata>> _cachedItemsByCode =
      <String, List<ActivityCategoryMetadata>>{};
  static final Map<String, DateTime> _cachedAtByCode = <String, DateTime>{};

  final MateyaApiClient _apiClient;
  final DateTime Function() _now;

  static void debugResetCache() {
    _cachedItemsByCode.clear();
    _cachedAtByCode.clear();
  }

  @override
  Future<List<ActivityCategoryMetadata>> fetchActivityCategories() async {
    final cacheKey = MateyaLanguagePreferences.instance.currentCodeOrDefault;
    final cachedItems = _cachedItemsByCode[cacheKey];
    final cachedAt = _cachedAtByCode[cacheKey];
    if (cachedItems != null &&
        cachedItems.isNotEmpty &&
        cachedAt != null &&
        _now().difference(cachedAt) < _cacheTtl) {
      return cachedItems;
    }

    try {
      final data = await _apiClient.getJson(
        '/api/v1/activity-categories',
        requiresAuth: true,
      );
      final json = _asMap(data);
      final items =
          (json['items'] as List<Object?>? ?? const <Object?>[])
              .map(_parseCategory)
              .where((category) => category.active)
              .toList(growable: false)
            ..sort(
              (left, right) => left.displayOrder.compareTo(right.displayOrder),
            );
      if (items.isNotEmpty) {
        _cachedItemsByCode[cacheKey] = items;
        _cachedAtByCode[cacheKey] = _now();
        return items;
      }
    } on MateyaApiException {
      if (cachedItems != null && cachedItems.isNotEmpty) {
        return cachedItems;
      }
      // Keep the UI operable with the last known compatible category contract.
    } on _CategoryParseException {
      if (cachedItems != null && cachedItems.isNotEmpty) {
        return cachedItems;
      }
      // Fall through to the stable fallback contract.
    }

    return kFallbackActivityCategories;
  }

  ActivityCategoryMetadata _parseCategory(Object? value) {
    final json = _asMap(value);
    final children =
        (json['children'] as List<Object?>? ?? const <Object?>[])
            .map(_parseDetail)
            .where((detail) => detail.active)
            .toList(growable: false)
          ..sort(
            (left, right) => left.displayOrder.compareTo(right.displayOrder),
          );
    return ActivityCategoryMetadata(
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      displayOrder: json['displayOrder'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
      children: children,
    );
  }

  ActivityCategoryDetailMetadata _parseDetail(Object? value) {
    final json = _asMap(value);
    return ActivityCategoryDetailMetadata(
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      displayOrder: json['displayOrder'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw const _CategoryParseException();
  }
}

class MockActivityCategoryRepository implements ActivityCategoryRepository {
  @override
  Future<List<ActivityCategoryMetadata>> fetchActivityCategories() async {
    return kFallbackActivityCategories;
  }
}

class _CategoryParseException implements Exception {
  const _CategoryParseException();
}
