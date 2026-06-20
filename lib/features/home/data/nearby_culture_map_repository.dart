import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/logging/app_logger.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../domain/nearby_culture_map_models.dart';

abstract interface class NearbyCultureMapRepository {
  Future<List<NearbyCultureMapPlace>> fetchPlaces({
    required double latitude,
    required double longitude,
    required String categoryCode,
    required String keyword,
    String? categoryDetailCode,
    int radiusKm = 10,
    int limit = 20,
  });
}

class ApiNearbyCultureMapRepository implements NearbyCultureMapRepository {
  ApiNearbyCultureMapRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    AppLogger? logger,
  }) : _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _loggerOverride = logger;

  final MateyaApiClient _apiClient;
  final AppLogger? _loggerOverride;
  AppLogger get _logger => _loggerOverride ?? AppLogger.instance;

  @override
  Future<List<NearbyCultureMapPlace>> fetchPlaces({
    required double latitude,
    required double longitude,
    required String categoryCode,
    required String keyword,
    String? categoryDetailCode,
    int radiusKm = 10,
    int limit = 20,
  }) async {
    _logger.info(
      'Requesting nearby culture map places',
      context: <String, Object?>{
        'categoryCode': categoryCode,
        'categoryDetailCode': categoryDetailCode,
        'hasKeyword': keyword.trim().isNotEmpty,
        'radiusKm': radiusKm,
        'limit': limit,
      },
    );
    try {
      final data = await _apiClient.getJson(
        '/api/v1/places/map',
        requiresAuth: true,
        queryParameters: <String, String>{
          'latitude': '$latitude',
          'longitude': '$longitude',
          'category': categoryCode,
          'radiusKm': '$radiusKm',
          'limit': '$limit',
          if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
          if (categoryDetailCode != null &&
              categoryDetailCode.trim().isNotEmpty)
            'categoryDetailCode': categoryDetailCode.trim(),
        },
      );
      final items = data is List<Object?> ? data : const <Object?>[];
      final places = items
          .map(_parseNearbyCultureMapPlace)
          .where((place) => place.hasCoordinates)
          .toList(growable: false);
      _logger.info(
        'Nearby culture map place request completed',
        context: <String, Object?>{
          'categoryCode': categoryCode,
          'categoryDetailCode': categoryDetailCode,
          'count': places.length,
        },
      );
      return places;
    } on MateyaApiException catch (error) {
      _logger.warning(
        'Nearby culture map place request failed',
        error: error,
        context: <String, Object?>{
          'categoryCode': categoryCode,
          'categoryDetailCode': categoryDetailCode,
          'hasKeyword': keyword.trim().isNotEmpty,
          'radiusKm': radiusKm,
          'limit': limit,
          'failureType': error.type.name,
          'statusCode': error.statusCode,
          'correlationId': error.correlationId,
          'message': error.message,
        },
      );
      throw NearbyCultureMapRepositoryException(
        error.type == ApiFailureType.network
            ? NearbyCultureMapLoadFailureType.network
            : NearbyCultureMapLoadFailureType.server,
        error.message,
      );
    }
  }
}

class MockNearbyCultureMapRepository implements NearbyCultureMapRepository {
  @override
  Future<List<NearbyCultureMapPlace>> fetchPlaces({
    required double latitude,
    required double longitude,
    required String categoryCode,
    required String keyword,
    String? categoryDetailCode,
    int radiusKm = 10,
    int limit = 20,
  }) async {
    final normalizedKeyword = keyword.trim().toLowerCase();
    final filtered = _mockNearbyPlaces
        .where((place) {
          final categoryMatches =
              place.categoryCode == null || place.categoryCode == categoryCode;
          final detailMatches =
              categoryDetailCode == null ||
              categoryDetailCode.isEmpty ||
              place.categoryDetailCode == categoryDetailCode;
          final keywordMatches =
              normalizedKeyword.isEmpty ||
              place.name.toLowerCase().contains(normalizedKeyword) ||
              place.address.toLowerCase().contains(normalizedKeyword);
          return categoryMatches && detailMatches && keywordMatches;
        })
        .take(limit)
        .toList(growable: false);
    return filtered;
  }
}

NearbyCultureMapPlace _parseNearbyCultureMapPlace(Object? value) {
  final json = _asMap(value);
  return NearbyCultureMapPlace(
    id: '${json['id']}',
    name: (json['name'] as String?) ?? (json['originalName'] as String?) ?? '',
    address: json['address'] as String? ?? '',
    distanceKm: ((json['distanceKm'] as num?) ?? 0).toDouble(),
    imageUrl: json['imageUrl'] as String?,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    categoryCode: json['category'] as String?,
    categoryDetailCode: json['categoryDetailCode'] as String?,
    categoryDetailName: json['categoryDetailName'] as String?,
    regionSido: json['regionSido'] as String?,
    regionSigungu: json['regionSigungu'] as String?,
  );
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  throw NearbyCultureMapRepositoryException(
    NearbyCultureMapLoadFailureType.server,
    MateyaLocalizations.current.homeNearbyMapParseError,
  );
}

const List<NearbyCultureMapPlace> _mockNearbyPlaces = <NearbyCultureMapPlace>[
  NearbyCultureMapPlace(
    id: 'mock-gyeongbokgung',
    name: '경복궁',
    address: '서울 종로구 사직로 161',
    distanceKm: 1.2,
    latitude: 37.579617,
    longitude: 126.977041,
    imageUrl: 'https://example.com/place.jpg',
    thumbnailUrl: 'https://example.com/place-thumb.jpg',
    categoryCode: 'CULTURE_TRADITION',
    categoryDetailCode: 'HERITAGE',
    categoryDetailName: '국가유산',
    regionSido: '서울특별시',
    regionSigungu: '종로구',
  ),
  NearbyCultureMapPlace(
    id: 'mock-bukchon',
    name: '북촌한옥마을',
    address: '서울 종로구 계동길 37',
    distanceKm: 1.9,
    latitude: 37.582604,
    longitude: 126.983998,
    imageUrl: 'https://example.com/bukchon.jpg',
    thumbnailUrl: 'https://example.com/bukchon-thumb.jpg',
    categoryCode: 'CULTURE_TRADITION',
    categoryDetailCode: 'HERITAGE',
    categoryDetailName: '한옥마을',
    regionSido: '서울특별시',
    regionSigungu: '종로구',
  ),
];
