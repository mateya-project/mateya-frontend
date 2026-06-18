import '../../app/app_config.dart';
import '../auth/auth_session.dart';
import '../network/mateya_api_client.dart';

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

const List<ActivityCategoryMetadata> kFallbackActivityCategories =
    <ActivityCategoryMetadata>[
      ActivityCategoryMetadata(
        code: 'TOURIST_ATTRACTION',
        label: '관광지',
        displayOrder: 1,
        active: true,
      ),
      ActivityCategoryMetadata(
        code: 'TRAVEL_COURSE',
        label: '여행코스',
        displayOrder: 2,
        active: true,
      ),
      ActivityCategoryMetadata(
        code: 'CULTURE_TRADITION',
        label: '문화/전통',
        displayOrder: 3,
        active: true,
      ),
      ActivityCategoryMetadata(
        code: 'EVENT_PERFORMANCE_FESTIVAL',
        label: '행사/공연/축제',
        displayOrder: 4,
        active: true,
      ),
      ActivityCategoryMetadata(
        code: 'SPORTS',
        label: '스포츠',
        displayOrder: 5,
        active: true,
      ),
      ActivityCategoryMetadata(
        code: 'ACTIVITY_LEPORTS',
        label: '액티비티/레포츠',
        displayOrder: 6,
        active: true,
      ),
      ActivityCategoryMetadata(
        code: 'PUBLIC_FACILITY',
        label: '공공시설',
        displayOrder: 7,
        active: true,
      ),
      ActivityCategoryMetadata(
        code: 'SHOPPING',
        label: '쇼핑',
        displayOrder: 8,
        active: true,
      ),
    ];

abstract interface class ActivityCategoryRepository {
  Future<List<ActivityCategoryMetadata>> fetchActivityCategories();
}

class ApiActivityCategoryRepository implements ActivityCategoryRepository {
  ApiActivityCategoryRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
  }) : _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           );

  static List<ActivityCategoryMetadata>? _cachedItems;

  final MateyaApiClient _apiClient;

  @override
  Future<List<ActivityCategoryMetadata>> fetchActivityCategories() async {
    final cachedItems = _cachedItems;
    if (cachedItems != null && cachedItems.isNotEmpty) {
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
        _cachedItems = items;
        return items;
      }
    } on MateyaApiException {
      // Keep the UI operable with the last known compatible category contract.
    } on _CategoryParseException {
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
