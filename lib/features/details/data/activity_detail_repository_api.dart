part of 'activity_detail_repository.dart';

class ApiActivityDetailRepository implements ActivityDetailRepository {
  ApiActivityDetailRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
    HttpTransport? transport,
  }) : _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _transport = transport ?? createHttpTransport();

  final MateyaApiClient _apiClient;
  final HttpTransport _transport;

  @override
  Future<ActivityDetail> fetchDetail(ActivityItem activity) async {
    try {
      final detailData = await _apiClient.getJson(
        '/api/v1/activities/${activity.id}',
        requiresAuth: true,
      );
      final reviewsData = await _apiClient.getJson(
        '/api/v1/activities/${activity.id}/reviews',
        requiresAuth: true,
      );
      final statsData = await _apiClient.getJson(
        '/api/v1/activities/${activity.id}/reviews/stats',
      );

      final detailJson = _asMap(detailData);
      final hostJson = _asMap(detailJson['hostProfile']);
      final reviewPageJson = _asMap(reviewsData);
      final reviewItems =
          reviewPageJson['items'] as List<Object?>? ?? const <Object?>[];
      final statsJson = _asMap(statsData);

      final images =
          ((detailJson['images'] as List<Object?>?) ?? const <Object?>[])
              .whereType<String>()
              .toList(growable: false);
      final placeName =
          (detailJson['placeName'] as String?) ??
          (detailJson['placeAddress'] as String?) ??
          activity.place;
      final placeAddress = detailJson['placeAddress'] as String?;
      final participants =
          ((detailJson['participantPreviews'] as List<Object?>?) ??
                  const <Object?>[])
              .map(_parseParticipant)
              .toList(growable: false);
      final reviews = reviewItems.map(_parseReview).toList(growable: false);

      return ActivityDetail(
        activity: activity.copyWith(
          title: detailJson['title'] as String? ?? activity.title,
          place: placeName,
          startAt: DateTime.parse(detailJson['startAt'] as String),
          endAt: DateTime.parse(detailJson['endAt'] as String),
          price: detailJson['priceAmount'] as int? ?? activity.price,
          participantCount:
              detailJson['participantCount'] as int? ??
              activity.participantCount,
          participantCapacity:
              detailJson['capacity'] as int? ?? activity.participantCapacity,
          imageUrl:
              detailJson['representativeImageUrl'] as String? ??
              activity.imageUrl,
        ),
        imageUrls: images.isEmpty
            ? <String>[
                if ((detailJson['representativeImageUrl'] as String?) != null)
                  detailJson['representativeImageUrl'] as String,
              ]
            : images,
        locationLabel: placeAddress == null || placeAddress.isEmpty
            ? placeName
            : placeAddress,
        host: ActivityHostProfile(
          userId: '${hostJson['userId']}',
          name: hostJson['displayName'] as String? ?? 'Host',
          localizedName: hostJson['displayName'] as String? ?? 'Host',
          locationLabel: _hostLocationLabel(
            countryCode: hostJson['primaryCountry'] as String?,
            languageCode: hostJson['primaryLanguage'] as String?,
          ),
          avatarUrl: hostJson['profileImageUrl'] as String?,
        ),
        description:
            (detailJson['description'] as String?) ??
            (detailJson['originalDescription'] as String?) ??
            '',
        shareUrl: 'https://mateya.app/activities/${activity.id}',
        participants: participants,
        reviews: reviews,
        serverReviewSummary: _parseReviewSummary(statsJson),
      );
    } on MateyaApiException catch (error) {
      if (error.type == ApiFailureType.network) {
        throw const ActivityDetailRepositoryException(
          ActivityDetailLoadFailureType.network,
        );
      }
      throw const ActivityDetailRepositoryException(
        ActivityDetailLoadFailureType.server,
      );
    }
  }

  @override
  Future<bool> toggleFavorite({
    required String activityId,
    required bool isFavorite,
  }) async {
    try {
      final data = await _apiClient.postJson(
        '/api/v1/activities/$activityId/favorite',
        requiresAuth: true,
      );
      final json = _asMap(data);
      return json['favorite'] as bool? ?? !isFavorite;
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<HelpfulToggleState> toggleHelpful({required String reviewId}) async {
    try {
      final data = await _apiClient.postJson(
        '/api/v1/reviews/$reviewId/helpful',
        requiresAuth: true,
      );
      final json = _asMap(data);
      return HelpfulToggleState(
        helpful: json['helpful'] as bool? ?? false,
        helpfulCount: json['helpfulCount'] as int? ?? 0,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<ActivityReview> submitReview({
    required String activityId,
    required int rating,
    required String body,
    List<String> imageUrls = const <String>[],
  }) async {
    try {
      final uploadedImageUrls = await _resolveReviewImageUrls(imageUrls);
      final data = await _apiClient.postJson(
        '/api/v1/activities/$activityId/reviews',
        requiresAuth: true,
        body: <String, Object?>{
          'rating': rating,
          'body': body,
          'imageUrls': uploadedImageUrls,
          'representativeImageIndex': uploadedImageUrls.isEmpty ? null : 0,
        },
      );
      return _parseReview(data);
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  Future<List<String>> _resolveReviewImageUrls(List<String> imageUrls) async {
    if (imageUrls.isEmpty) {
      return const <String>[];
    }

    final resolved = <String>[];
    for (final imageUrl in imageUrls) {
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        resolved.add(imageUrl);
        continue;
      }
      resolved.add(
        await _uploadReviewImage(
          imagePath: imageUrl,
          requestedFileCount: imageUrls.length,
        ),
      );
    }
    return resolved;
  }

  Future<String> _uploadReviewImage({
    required String imagePath,
    required int requestedFileCount,
  }) async {
    final file = File(imagePath);
    final fileName = imagePath.split('/').last;
    final contentType = _contentTypeFor(fileName);
    if (contentType == null) {
      throw const ActivityDetailRepositoryException(
        ActivityDetailLoadFailureType.validation,
        message: 'JPG, PNG, WEBP, GIF 형식의 리뷰 이미지만 업로드할 수 있어요.',
      );
    }

    final fileSize = await file.length();
    final fileBytes = await file.readAsBytes();
    final presignedData = await _apiClient.postJson(
      '/api/v1/uploads/images/presigned-url',
      requiresAuth: true,
      body: <String, Object?>{
        'purpose': 'REVIEW',
        'originalFilename': fileName,
        'contentType': contentType,
        'sizeBytes': fileSize,
        'requestedFileCount': requestedFileCount,
      },
    );
    final presignedJson = _asMap(presignedData);
    final uploadUrl = presignedJson['uploadUrl'] as String?;
    final objectKey = presignedJson['objectKey'] as String?;
    if (uploadUrl == null || objectKey == null) {
      throw const ActivityDetailRepositoryException(
        ActivityDetailLoadFailureType.server,
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
      throw const ActivityDetailRepositoryException(
        ActivityDetailLoadFailureType.server,
        message: '리뷰 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.',
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
      throw const ActivityDetailRepositoryException(
        ActivityDetailLoadFailureType.server,
      );
    }
    return publicUrl;
  }
}
