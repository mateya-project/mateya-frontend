part of 'create_repository.dart';

class ApiCreateRepository implements CreateRepository {
  ApiCreateRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    HttpTransport? transport,
    NeighborhoodLocationRepository? locationRepository,
    AppLogger? logger,
  }) : _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _transport = transport ?? createHttpTransport(),
       _locationRepository =
           locationRepository ?? DeviceNeighborhoodLocationRepository(),
       _loggerOverride = logger;

  final AuthSessionStore _sessionStore;
  final MateyaApiClient _apiClient;
  final HttpTransport _transport;
  final NeighborhoodLocationRepository _locationRepository;
  final AppLogger? _loggerOverride;
  AppLogger get _logger => _loggerOverride ?? AppLogger.instance;

  @override
  Future<CreateEditableDraft> fetchEditableDraft({
    required String id,
    required CreateFlowType flowType,
  }) async {
    try {
      final data = await _apiClient.getJson(
        '/api/v1/activities/$id',
        requiresAuth: true,
      );
      final json = _asMap(data);
      final categoryCode = json['category'] as String?;
      final categoryId = categoryCode == null
          ? null
          : _clientCategoryIdByServerCode[categoryCode];
      final startAt = parseServerDateTime(json['startAt'] as String);
      final endAt = parseServerDateTime(json['endAt'] as String);
      final deadlineAt = json['recruitmentDeadlineAt'] == null
          ? null
          : parseServerDateTime(json['recruitmentDeadlineAt'] as String);
      final imageUrls =
          ((json['images'] as List<Object?>?) ?? const <Object?>[])
              .whereType<String>()
              .toList(growable: false);

      return CreateEditableDraft(
        activityId: id,
        flowType: flowType,
        categoryIds: categoryId == null
            ? const <String>{}
            : <String>{categoryId},
        categoryDetailCode: null,
        place: CreatePlaceSuggestion(
          id: '${json['placeId'] ?? id}',
          name:
              (json['placeName'] as String?) ??
              (json['placeAddress'] as String?) ??
              '',
          address: json['placeAddress'] as String? ?? '',
          description:
              MateyaLocalizations.current.createExistingPlaceDescription,
          distanceKm: 0,
          latitude: (json['latitude'] as num?)?.toDouble(),
          longitude: (json['longitude'] as num?)?.toDouble(),
          categoryIds: categoryId == null
              ? const <String>{}
              : <String>{categoryId},
          serverCategoryCode: categoryCode,
        ),
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        eventDate: DateTime(startAt.year, startAt.month, startAt.day),
        startTime: TimeOfDay(hour: startAt.hour, minute: startAt.minute),
        endTime: TimeOfDay(hour: endAt.hour, minute: endAt.minute),
        participantCapacity: json['capacity'] as int? ?? 2,
        registrationDeadlineDate: deadlineAt == null
            ? null
            : DateTime(deadlineAt.year, deadlineAt.month, deadlineAt.day),
        registrationDeadlineTime: deadlineAt == null
            ? null
            : TimeOfDay(hour: deadlineAt.hour, minute: deadlineAt.minute),
        languageCodes:
            ((json['languages'] as List<Object?>?) ?? const <Object?>[])
                .whereType<String>()
                .toSet(),
        priceType: (json['priceType'] as String?) == 'FREE'
            ? CreatePriceType.free
            : CreatePriceType.paid,
        priceText: ((json['priceAmount'] as int?) ?? 0) == 0
            ? ''
            : '${json['priceAmount']}',
        audienceIds: ((json['targets'] as List<Object?>?) ?? const <Object?>[])
            .whereType<String>()
            .map(_audienceFromServerValue)
            .whereType<String>()
            .toSet(),
        images: imageUrls
            .asMap()
            .entries
            .map(
              (entry) => CreateImageAsset(
                id: 'remote-${entry.key}',
                path: entry.value,
                name: _remoteImageName(entry.value),
                sizeBytes: 0,
                isPrimary:
                    entry.value == json['representativeImageUrl'] ||
                    (json['representativeImageUrl'] == null && entry.key == 0),
              ),
            )
            .toList(growable: false),
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
    String? categoryDetailCode,
  }) async {
    final categoryCode = _resolveServerCategoryCode(
      explicitCategoryIds: categoryIds,
    );
    if (categoryCode == null) {
      _logger.warning(
        'Skipping recommended place request because category code is missing',
        context: <String, Object?>{
          'flowType': flowType.name,
          'categoryIds': categoryIds.toList(growable: false),
        },
      );
      return const <CreatePlaceSuggestion>[];
    }

    var locationSource = 'session';
    final sessionUser = _sessionStore.session?.user;
    var latitude = sessionUser?.activityLatitude;
    var longitude = sessionUser?.activityLongitude;
    var district = sessionUser?.activityRegionName;

    if (latitude == null || longitude == null) {
      _logger.info(
        'Falling back to device location for recommended places because session coordinates are missing',
        context: <String, Object?>{
          'flowType': flowType.name,
          'hasRegionName': district?.isNotEmpty ?? false,
        },
      );
      locationSource = 'device';
      final resolved = await _locationRepository.resolveCurrentNeighborhood();
      if (!resolved.isSuccess || resolved.selection == null) {
        _logger.warning(
          'Skipping recommended place request because no location could be resolved',
          context: <String, Object?>{
            'flowType': flowType.name,
            'failureType': resolved.failure?.type.name,
            'message': resolved.failure?.message,
          },
        );
        return const <CreatePlaceSuggestion>[];
      }
      latitude = resolved.selection!.latitude;
      longitude = resolved.selection!.longitude;
      district = resolved.selection!.displayName;
    }

    try {
      final data = await _apiClient.getJson(
        '/api/v1/places/recommendations',
        requiresAuth: true,
        queryParameters: <String, String>{
          'category': categoryCode,
          if (categoryDetailCode != null && categoryDetailCode.isNotEmpty)
            'categoryDetailCode': categoryDetailCode,
          'latitude': '$latitude',
          'longitude': '$longitude',
        },
      );
      final items = data is List<Object?> ? data : const <Object?>[];
      final places = items
          .map(_parsePlaceSuggestion)
          .where((place) => place.hasCoordinates)
          .toList(growable: false);
      _logger.info(
        'Recommended places loaded',
        context: <String, Object?>{
          'flowType': flowType.name,
          'categoryCode': categoryCode,
          'categoryDetailCode': categoryDetailCode,
          'locationSource': locationSource,
          'district': district,
          'count': places.length,
        },
      );
      return places;
    } on MateyaApiException catch (error) {
      _logger.warning(
        'Recommended place request failed',
        error: error,
        context: <String, Object?>{
          'flowType': flowType.name,
          'categoryCode': categoryCode,
          'categoryDetailCode': categoryDetailCode,
          'locationSource': locationSource,
          'district': district,
          'failureType': error.type.name,
          'statusCode': error.statusCode,
          'correlationId': error.correlationId,
        },
      );
      throw _mapApiException(error);
    }
  }

  @override
  Future<List<CreatePlaceSuggestion>> searchPlaces({
    required String query,
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
    String? categoryDetailCode,
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
        if (categoryDetailCode != null && categoryDetailCode.isNotEmpty)
          'categoryDetailCode': categoryDetailCode,
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
  Future<CreateSubmitResult> submit(
    CreateSubmissionDraft draft, {
    String? editingId,
  }) async {
    final categoryCode = _resolveServerCategoryCode(
      explicitCategoryIds: draft.categoryIds,
      fallbackPlaceCategoryCode: draft.place.serverCategoryCode,
    );
    if (categoryCode == null) {
      throw CreateRepositoryException(
        CreateRepositoryFailureType.server,
        message: MateyaLocalizations.current.createResolveServerCategoryFailed,
      );
    }

    final imageUrls = await _uploadImages(draft.images);
    final representativeImageIndex = draft.images.indexWhere(
      (image) => image.isPrimary,
    );

    try {
      final requestBody = <String, Object?>{
        'category': categoryCode,
        'placeId': int.tryParse(draft.place.id),
        'placeName': draft.place.name,
        'placeAddress': draft.place.address,
        'latitude': draft.place.latitude,
        'longitude': draft.place.longitude,
        'title': draft.title,
        'description': draft.description.isEmpty ? null : draft.description,
        'startAt': _toApiInstantString(draft.eventStartsAt),
        'endAt': _toApiInstantString(draft.eventEndsAt),
        'recruitmentDeadlineAt': _toApiInstantString(
          draft.registrationDeadlineAt ??
              draft.eventStartsAt.subtract(const Duration(minutes: 1)),
        ),
        'capacity': draft.participantCapacity,
        'languages': draft.languageCodes.toList(growable: false),
        'priceType': draft.priceType == CreatePriceType.free ? 'FREE' : 'PAID',
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
      };
      final data = editingId == null
          ? await _apiClient.postJson(
              draft.flowType == CreateFlowType.classRegistration
                  ? '/api/v1/classes'
                  : '/api/v1/activities',
              requiresAuth: true,
              body: requestBody,
            )
          : await _apiClient.patchJson(
              '/api/v1/activities/$editingId',
              requiresAuth: true,
              body: requestBody,
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
        eventStartsAt: json['startAt'] == null
            ? draft.eventStartsAt
            : parseServerDateTime(json['startAt'] as String),
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
      throw CreateRepositoryException(
        CreateRepositoryFailureType.server,
        message: MateyaLocalizations.current.createUploadImageRequired,
      );
    }

    final uploadedUrls = <String>[];
    for (final image in images) {
      if (image.isRemote) {
        uploadedUrls.add(image.path);
        continue;
      }

      final contentType = _contentTypeFor(image.name);
      if (contentType == null) {
        throw CreateRepositoryException(
          CreateRepositoryFailureType.server,
          message: MateyaLocalizations.current.createUploadImageInvalidFormat,
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
        throw CreateRepositoryException(
          CreateRepositoryFailureType.server,
          message: MateyaLocalizations.current.createUploadImageFailed,
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
        throw CreateRepositoryException(
          CreateRepositoryFailureType.server,
          message: MateyaLocalizations.current.createUploadImageConfirmFailed,
        );
      }
      uploadedUrls.add(publicUrl);
    }

    return uploadedUrls;
  }
}
