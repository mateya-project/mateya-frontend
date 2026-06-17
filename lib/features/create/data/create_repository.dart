import 'dart:io';

import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/http_transport.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../domain/create_models.dart';

abstract interface class CreateRepository {
  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  });

  Future<List<CreatePlaceSuggestion>> searchPlaces({
    required String query,
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  });

  Future<CreateSubmitResult> submit(CreateSubmissionDraft draft);

  Future<void> delete({required String id, required CreateFlowType flowType});
}

enum CreateRepositoryFailureType { network, server }

class CreateRepositoryException implements Exception {
  const CreateRepositoryException(this.type, {this.message});

  final CreateRepositoryFailureType type;
  final String? message;
}

class ApiCreateRepository implements CreateRepository {
  ApiCreateRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    HttpTransport? transport,
  }) : _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _transport = transport ?? createHttpTransport();

  final AuthSessionStore _sessionStore;
  final MateyaApiClient _apiClient;
  final HttpTransport _transport;

  @override
  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  }) async {
    final categoryCode = _resolveServerCategoryCode(
      explicitCategoryIds: categoryIds,
    );
    final sessionUser = _sessionStore.session?.user;
    final latitude = sessionUser?.activityLatitude;
    final longitude = sessionUser?.activityLongitude;
    if (categoryCode == null || latitude == null || longitude == null) {
      return const <CreatePlaceSuggestion>[];
    }

    try {
      final data = await _apiClient.getJson(
        '/api/v1/places/recommendations',
        requiresAuth: true,
        queryParameters: <String, String>{
          'category': categoryCode,
          'latitude': '$latitude',
          'longitude': '$longitude',
        },
      );
      final items = data is List<Object?> ? data : const <Object?>[];
      return items
          .map(_parsePlaceSuggestion)
          .where((place) => place.hasCoordinates)
          .toList(growable: false);
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<List<CreatePlaceSuggestion>> searchPlaces({
    required String query,
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  }) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return const <CreatePlaceSuggestion>[];
    }

    try {
      final categoryCode = _resolveServerCategoryCode(
        explicitCategoryIds: categoryIds,
      );
      final queryParameters = <String, String>{
        'keyword': trimmedQuery,
        ...?categoryCode == null
            ? null
            : <String, String>{'category': categoryCode},
      };
      final data = await _apiClient.getJson(
        '/api/v1/places/search',
        requiresAuth: true,
        queryParameters: queryParameters,
      );
      final json = _asMap(data);
      final items = json['items'] as List<Object?>? ?? const <Object?>[];
      return items
          .map(_parsePlaceSuggestion)
          .where((place) => place.hasCoordinates)
          .toList(growable: false);
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<CreateSubmitResult> submit(CreateSubmissionDraft draft) async {
    final categoryCode = _resolveServerCategoryCode(
      explicitCategoryIds: draft.categoryIds,
      fallbackPlaceCategoryCode: draft.place.serverCategoryCode,
    );
    if (categoryCode == null) {
      throw const CreateRepositoryException(
        CreateRepositoryFailureType.server,
        message: '선택한 장소에서 서버 카테고리를 확정할 수 없어요. 다른 장소를 선택해 주세요.',
      );
    }

    final imageUrls = await _uploadImages(draft.images);
    final representativeImageIndex = draft.images.indexWhere(
      (image) => image.isPrimary,
    );

    try {
      final data = await _apiClient.postJson(
        draft.flowType == CreateFlowType.classRegistration
            ? '/api/v1/classes'
            : '/api/v1/activities',
        requiresAuth: true,
        body: <String, Object?>{
          'category': categoryCode,
          'placeId': int.tryParse(draft.place.id),
          'placeName': draft.place.name,
          'placeAddress': draft.place.address,
          'latitude': draft.place.latitude,
          'longitude': draft.place.longitude,
          'title': draft.title,
          'description': draft.description.isEmpty ? null : draft.description,
          'startAt': draft.eventStartsAt.toIso8601String(),
          'endAt': draft.eventEndsAt.toIso8601String(),
          'recruitmentDeadlineAt':
              (draft.registrationDeadlineAt ?? draft.eventStartsAt)
                  .toIso8601String(),
          'capacity': draft.participantCapacity,
          'languages': draft.languageCodes.toList(growable: false),
          'priceType': draft.priceType == CreatePriceType.free
              ? 'FREE'
              : 'PAID',
          'priceAmount': draft.priceType == CreatePriceType.free
              ? 0
              : (draft.price ?? 0),
          'targets': draft.audienceIds
              .map(_audienceToServerValue)
              .toList(growable: false),
          'imageUrls': imageUrls,
          'representativeImageIndex': representativeImageIndex < 0
              ? null
              : representativeImageIndex,
        },
      );
      final json = _asMap(data);
      return CreateSubmitResult(
        id: '${json['id']}',
        flowType: draft.flowType,
        title: json['title'] as String? ?? draft.title,
        placeName:
            (json['placeName'] as String?) ??
            (json['placeAddress'] as String?) ??
            draft.place.name,
        eventStartsAt: DateTime.parse(
          json['startAt'] as String? ?? draft.eventStartsAt.toIso8601String(),
        ),
        chatStatus: ChatProvisionStatus.created,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<void> delete({
    required String id,
    required CreateFlowType flowType,
  }) async {
    try {
      await _apiClient.deleteJson('/api/v1/activities/$id', requiresAuth: true);
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  Future<List<String>> _uploadImages(List<CreateImageAsset> images) async {
    if (images.isEmpty) {
      throw const CreateRepositoryException(
        CreateRepositoryFailureType.server,
        message: '대표 이미지를 1장 이상 등록해 주세요.',
      );
    }

    final uploadedUrls = <String>[];
    for (final image in images) {
      final contentType = _contentTypeFor(image.name);
      if (contentType == null) {
        throw const CreateRepositoryException(
          CreateRepositoryFailureType.server,
          message: 'JPG, PNG, WEBP, GIF 형식의 이미지만 업로드할 수 있어요.',
        );
      }

      final fileBytes = await File(image.path).readAsBytes();
      final presignedData = await _apiClient.postJson(
        '/api/v1/uploads/images/presigned-url',
        requiresAuth: true,
        body: <String, Object?>{
          'purpose': 'ACTIVITY',
          'originalFilename': image.name,
          'contentType': contentType,
          'sizeBytes': image.sizeBytes,
          'requestedFileCount': images.length,
        },
      );
      final presignedJson = _asMap(presignedData);
      final uploadUrl = presignedJson['uploadUrl'] as String?;
      final objectKey = presignedJson['objectKey'] as String?;
      if (uploadUrl == null || objectKey == null) {
        throw const CreateRepositoryException(
          CreateRepositoryFailureType.server,
        );
      }

      final uploadResponse = await _transport.send(
        method: 'PUT',
        uri: Uri.parse(uploadUrl),
        headers: _flattenHeaders(
          presignedJson['headers'] as Map<String, dynamic>? ??
              const <String, dynamic>{},
          fallbackContentType: contentType,
        ),
        bodyBytes: fileBytes,
      );
      if (uploadResponse.statusCode < 200 || uploadResponse.statusCode >= 300) {
        throw const CreateRepositoryException(
          CreateRepositoryFailureType.server,
          message: '이미지 업로드에 실패했어요. 잠시 후 다시 시도해 주세요.',
        );
      }

      final confirmedData = await _apiClient.postJson(
        '/api/v1/uploads/images/confirm',
        requiresAuth: true,
        body: <String, Object?>{'objectKey': objectKey},
      );
      final confirmedJson = _asMap(confirmedData);
      final publicUrl = confirmedJson['publicUrl'] as String?;
      if (publicUrl == null || publicUrl.isEmpty) {
        throw const CreateRepositoryException(
          CreateRepositoryFailureType.server,
          message: '이미지 업로드 확인에 실패했어요. 잠시 후 다시 시도해 주세요.',
        );
      }
      uploadedUrls.add(publicUrl);
    }

    return uploadedUrls;
  }

  CreatePlaceSuggestion _parsePlaceSuggestion(Object? value) {
    final json = _asMap(value);
    final serverCategoryCode = json['category'] as String?;
    final clientCategoryId = serverCategoryCode == null
        ? null
        : _clientCategoryIdByServerCode[serverCategoryCode];

    return CreatePlaceSuggestion(
      id: '${json['id']}',
      name:
          (json['name'] as String?) ?? (json['originalName'] as String?) ?? '',
      address: json['address'] as String? ?? '',
      description: _composePlaceDescription(json),
      distanceKm: ((json['distanceKm'] as num?) ?? 0).round(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      categoryIds: clientCategoryId == null
          ? const <String>{}
          : <String>{clientCategoryId},
      serverCategoryCode: serverCategoryCode,
    );
  }

  String _composePlaceDescription(Map<String, dynamic> json) {
    final parts = <String>[
      if ((json['categoryDetailName'] as String?)?.isNotEmpty ?? false)
        json['categoryDetailName'] as String,
      if ((json['regionSido'] as String?)?.isNotEmpty ?? false)
        json['regionSido'] as String,
      if ((json['regionSigungu'] as String?)?.isNotEmpty ?? false)
        json['regionSigungu'] as String,
    ];
    return parts.isEmpty ? '위치를 확인한 뒤 선택해 주세요.' : parts.join(' · ');
  }

  String? _resolveServerCategoryCode({
    required Set<String> explicitCategoryIds,
    String? fallbackPlaceCategoryCode,
  }) {
    if (fallbackPlaceCategoryCode != null &&
        fallbackPlaceCategoryCode.isNotEmpty) {
      return fallbackPlaceCategoryCode;
    }
    final selectedId = explicitCategoryIds.firstOrNull;
    if (selectedId == null) {
      return null;
    }
    return _serverCategoryCodeByClientCategoryId[selectedId];
  }

  Map<String, String> _flattenHeaders(
    Map<String, dynamic> rawHeaders, {
    required String fallbackContentType,
  }) {
    final headers = <String, String>{};
    rawHeaders.forEach((key, value) {
      if (value is List<Object?>) {
        final joined = value.whereType<String>().join(', ');
        if (joined.isNotEmpty) {
          headers[key] = joined;
        }
        return;
      }
      if (value is String && value.isNotEmpty) {
        headers[key] = value;
      }
    });
    headers.putIfAbsent('Content-Type', () => fallbackContentType);
    return headers;
  }

  String? _contentTypeFor(String fileName) {
    final normalized = fileName.toLowerCase();
    if (normalized.endsWith('.jpg') || normalized.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    if (normalized.endsWith('.png')) {
      return 'image/png';
    }
    if (normalized.endsWith('.webp')) {
      return 'image/webp';
    }
    if (normalized.endsWith('.gif')) {
      return 'image/gif';
    }
    return null;
  }

  CreateRepositoryException _mapApiException(MateyaApiException error) {
    if (error.type == ApiFailureType.network) {
      return CreateRepositoryException(
        CreateRepositoryFailureType.network,
        message: error.message,
      );
    }
    return CreateRepositoryException(
      CreateRepositoryFailureType.server,
      message: error.message,
    );
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw const CreateRepositoryException(CreateRepositoryFailureType.server);
  }
}

class MockCreateRepository implements CreateRepository {
  @override
  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    final candidates =
        _placeSuggestions.where((place) {
            if (flowType == CreateFlowType.classRegistration) {
              return true;
            }
            if (categoryIds.isEmpty) {
              return true;
            }
            return place.categoryIds.any(categoryIds.contains);
          }).toList()
          ..sort((left, right) => left.distanceKm.compareTo(right.distanceKm));
    return candidates.take(3).toList(growable: false);
  }

  @override
  Future<List<CreatePlaceSuggestion>> searchPlaces({
    required String query,
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    final normalized = query.trim().toLowerCase();
    if (normalized == 'network-error') {
      throw const CreateRepositoryException(
        CreateRepositoryFailureType.network,
      );
    }

    final filtered = _placeSuggestions.where((place) {
      final matchesQuery =
          place.name.toLowerCase().contains(normalized) ||
          place.address.toLowerCase().contains(normalized) ||
          place.description.toLowerCase().contains(normalized);
      if (!matchesQuery) {
        return false;
      }
      if (flowType == CreateFlowType.classRegistration || categoryIds.isEmpty) {
        return true;
      }
      return place.categoryIds.any(categoryIds.contains);
    }).toList();

    filtered.sort((left, right) {
      final leftStartsWith = left.name.toLowerCase().startsWith(normalized);
      final rightStartsWith = right.name.toLowerCase().startsWith(normalized);
      if (leftStartsWith != rightStartsWith) {
        return leftStartsWith ? -1 : 1;
      }
      return left.distanceKm.compareTo(right.distanceKm);
    });

    return filtered;
  }

  @override
  Future<CreateSubmitResult> submit(CreateSubmissionDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 720));
    return CreateSubmitResult(
      id: 'created-${DateTime.now().microsecondsSinceEpoch}',
      flowType: draft.flowType,
      title: draft.title,
      placeName: draft.place.name,
      eventStartsAt: draft.eventStartsAt,
      chatStatus: ChatProvisionStatus.created,
    );
  }

  @override
  Future<void> delete({
    required String id,
    required CreateFlowType flowType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 360));
  }
}

const Map<String, String> _serverCategoryCodeByClientCategoryId =
    <String, String>{
      'traditional': 'CULTURE_TRADITION',
      'sports': 'SPORTS',
      'festival': 'EVENT_PERFORMANCE_FESTIVAL',
      'food': 'SHOPPING',
      'language': 'PUBLIC_FACILITY',
      'walk': 'TOURIST_ATTRACTION',
      'craft': 'CULTURE_TRADITION',
      'etc': 'PUBLIC_FACILITY',
    };

const Map<String, String> _clientCategoryIdByServerCode = <String, String>{
  'TOURIST_ATTRACTION': 'walk',
  'TRAVEL_COURSE': 'walk',
  'CULTURE_TRADITION': 'traditional',
  'EVENT_PERFORMANCE_FESTIVAL': 'festival',
  'SPORTS': 'sports',
  'ACTIVITY_LEPORTS': 'sports',
  'PUBLIC_FACILITY': 'etc',
  'SHOPPING': 'food',
};

String _audienceToServerValue(String audienceId) => switch (audienceId) {
  'everyone' => 'ANYONE',
  'foreigner' => 'FOREIGNER_WELCOME',
  'korean' => 'KOREAN_WELCOME',
  'tourist' => 'TOURIST_RECOMMENDED',
  'beginner' => 'BEGINNER_WELCOME',
  _ => 'ANYONE',
};

const List<CreatePlaceSuggestion> _placeSuggestions = <CreatePlaceSuggestion>[
  CreatePlaceSuggestion(
    id: 'gyeongbokgung',
    name: '경복궁 흥례문 광장',
    address: '서울 종로구 사직로 161',
    description: '전통문화 모임과 관광형 클래스에 적합한 대표 장소',
    distanceKm: 1,
    latitude: 37.579617,
    longitude: 126.977041,
    categoryIds: <String>{'traditional', 'walk'},
    serverCategoryCode: 'CULTURE_TRADITION',
  ),
  CreatePlaceSuggestion(
    id: 'bukchon',
    name: '북촌문화센터',
    address: '서울 종로구 계동길 37',
    description: '한옥, 공예, 전통문화 체험 운영에 적합한 공간',
    distanceKm: 2,
    latitude: 37.582604,
    longitude: 126.983998,
    categoryIds: <String>{'traditional', 'craft'},
    serverCategoryCode: 'CULTURE_TRADITION',
  ),
  CreatePlaceSuggestion(
    id: 'seoul-forest',
    name: '서울숲 가족마당',
    address: '서울 성동구 뚝섬로 273',
    description: '산책형 모임과 야외 액티비티에 적합한 공원형 장소',
    distanceKm: 1,
    latitude: 37.544557,
    longitude: 127.037442,
    categoryIds: <String>{'walk', 'sports'},
    serverCategoryCode: 'TOURIST_ATTRACTION',
  ),
  CreatePlaceSuggestion(
    id: 'ttukseom-sports',
    name: '뚝섬한강공원 수변무대',
    address: '서울 광진구 강변북로 139',
    description: '러닝, 피크닉, 한강 액티비티에 적합한 장소',
    distanceKm: 3,
    latitude: 37.531011,
    longitude: 127.066887,
    categoryIds: <String>{'sports', 'walk'},
    serverCategoryCode: 'SPORTS',
  ),
  CreatePlaceSuggestion(
    id: 'gwangjang',
    name: '광장시장 동문 입구',
    address: '서울 종로구 창경궁로 88',
    description: '음식 체험과 관광형 모임 수요가 높은 위치',
    distanceKm: 4,
    latitude: 37.570404,
    longitude: 126.999177,
    categoryIds: <String>{'food', 'walk'},
    serverCategoryCode: 'SHOPPING',
  ),
  CreatePlaceSuggestion(
    id: 'hongdae-language',
    name: '홍대입구 글로벌 라운지',
    address: '서울 마포구 양화로 188',
    description: '언어교환과 소규모 커뮤니티 클래스 진행에 적합',
    distanceKm: 5,
    latitude: 37.557317,
    longitude: 126.924107,
    categoryIds: <String>{'language', 'etc'},
    serverCategoryCode: 'PUBLIC_FACILITY',
  ),
  CreatePlaceSuggestion(
    id: 'suwon-festival',
    name: '수원 화성행궁 광장',
    address: '경기 수원시 팔달구 정조로 825',
    description: '지역축제 연계 모임과 야외 행사에 적합한 장소',
    distanceKm: 9,
    latitude: 37.281962,
    longitude: 127.014306,
    categoryIds: <String>{'festival', 'traditional'},
    serverCategoryCode: 'EVENT_PERFORMANCE_FESTIVAL',
  ),
  CreatePlaceSuggestion(
    id: 'icheon-ceramic',
    name: '이천 예스파크 공방동',
    address: '경기 이천시 신둔면 경충대로 3151',
    description: '공예 클래스와 체험형 수업에 적합한 전문 공간',
    distanceKm: 10,
    latitude: 37.293792,
    longitude: 127.409215,
    categoryIds: <String>{'craft'},
    serverCategoryCode: 'CULTURE_TRADITION',
  ),
];
