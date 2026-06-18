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
        pendingParticipants: const <ActivityParticipant>[],
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
      final uploadedImageUrls = await _resolveReviewImageUrls(
        imageUrls: imageUrls,
        apiClient: _apiClient,
        transport: _transport,
      );
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
}
