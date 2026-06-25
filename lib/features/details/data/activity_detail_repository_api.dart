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
       _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _transport = transport ?? createHttpTransport();

  final MateyaApiClient _apiClient;
  final AuthSessionStore _sessionStore;
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
        requiresAuth: true,
      );

      final detailJson = _asMap(detailData);
      final manageJson = await _fetchParticipantManageJsonIfNeeded(
        activityId: activity.id,
        detailJson: detailJson,
      );
      final reviewPageJson = _asMap(reviewsData);
      final reviewItems =
          reviewPageJson['items'] as List<Object?>? ?? const <Object?>[];
      final statsJson = _asMap(statsData);
      final participants = _parseParticipants(
        manageJson?['approvedParticipants'] ??
            detailJson['participantPreviews'],
      );
      final pendingParticipants = _parseParticipants(
        manageJson?['pendingParticipants'],
      );
      final reviews = reviewItems.map(_parseReview).toList(growable: false);
      return _buildActivityDetail(
        activity: activity,
        detailJson: detailJson,
        participants: participants,
        pendingParticipants: pendingParticipants,
        reviews: reviews,
        reviewSummary: _parseReviewSummary(statsJson),
        participantCountOverride: manageJson?['participantCount'] as int?,
        participantCapacityOverride: manageJson?['capacity'] as int?,
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
  Future<ActivityDetail> requestJoin({required ActivityDetail detail}) async {
    try {
      final data = await _apiClient.postJson(
        '/api/v1/activities/${detail.activity.id}/participants',
        requiresAuth: true,
      );
      return _mergeActivityDetail(
        current: detail,
        detailJson: _asMap(data),
        participationState: ActivityParticipationState.requested,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<ActivityDetail> approvePendingParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    try {
      final data = await _apiClient.postJson(
        '/api/v1/activities/${detail.activity.id}/participants/$participantId/approve',
        requiresAuth: true,
      );
      return _mergeHostedParticipantDetail(
        current: detail,
        detailJson: _asMap(data),
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<ActivityDetail> removeApprovedParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    try {
      final data = await _apiClient.deleteJson(
        '/api/v1/activities/${detail.activity.id}/participants/$participantId',
        requiresAuth: true,
      );
      return _mergeHostedParticipantDetail(
        current: detail,
        detailJson: _asMap(data),
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<ActivityDetail> removePendingParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    try {
      final data = await _apiClient.deleteJson(
        '/api/v1/activities/${detail.activity.id}/participant-requests/$participantId',
        requiresAuth: true,
      );
      return _mergeHostedParticipantDetail(
        current: detail,
        detailJson: _asMap(data),
      );
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
  Future<ActivityReview> fetchReview({
    required String reviewId,
    required bool original,
  }) async {
    try {
      final data = await _apiClient.getJson(
        '/api/v1/reviews/$reviewId',
        requiresAuth: true,
        queryParameters: <String, String>{'original': '$original'},
      );
      return _parseReview(data);
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

  @override
  Future<ActivityReview> updateReview({
    required String reviewId,
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
      final data = await _apiClient.patchJson(
        '/api/v1/reviews/$reviewId',
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

  @override
  Future<void> deleteReview({required String reviewId}) async {
    try {
      await _apiClient.deleteJson(
        '/api/v1/reviews/$reviewId',
        requiresAuth: true,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  ActivityDetail _buildActivityDetail({
    required ActivityItem activity,
    required Map<String, dynamic> detailJson,
    required List<ActivityParticipant> participants,
    required List<ActivityParticipant> pendingParticipants,
    required List<ActivityReview> reviews,
    required ReviewSummary reviewSummary,
    int? participantCountOverride,
    int? participantCapacityOverride,
  }) {
    final hostJson = _asMap(detailJson['hostProfile']);
    final placeName =
        (detailJson['placeName'] as String?) ??
        (detailJson['placeAddress'] as String?) ??
        activity.place;
    final placeAddress = detailJson['placeAddress'] as String?;
    final images =
        ((detailJson['images'] as List<Object?>?) ?? const <Object?>[])
            .whereType<String>()
            .toList(growable: false);

    return ActivityDetail(
      activity: activity.copyWith(
        title: detailJson['title'] as String? ?? activity.title,
        place: placeName,
        startAt: parseServerDateTime(detailJson['startAt'] as String),
        endAt: parseServerDateTime(detailJson['endAt'] as String),
        price: detailJson['priceAmount'] as int? ?? activity.price,
        participantCount:
            participantCountOverride ??
            detailJson['participantCount'] as int? ??
            activity.participantCount,
        participantCapacity:
            participantCapacityOverride ??
            detailJson['capacity'] as int? ??
            activity.participantCapacity,
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
        localizedName: hostJson['englishName'] as String? ?? '',
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
      pendingParticipants: pendingParticipants,
      reviews: reviews,
      serverReviewSummary: reviewSummary,
      isFavorite: detailJson['favorited'] as bool? ?? false,
      participationState: _resolveParticipationState(
        detailJson: detailJson,
        hostJson: hostJson,
      ),
    );
  }

  ActivityDetail _mergeActivityDetail({
    required ActivityDetail current,
    required Map<String, dynamic> detailJson,
    required ActivityParticipationState participationState,
    List<ActivityParticipant>? participantsOverride,
    List<ActivityParticipant>? pendingParticipantsOverride,
    int? participantCountOverride,
    int? participantCapacityOverride,
  }) {
    final hostJson = _asMap(detailJson['hostProfile']);
    final participants =
        participantsOverride ??
        _parseParticipants(detailJson['participantPreviews']);
    final placeName =
        (detailJson['placeName'] as String?) ??
        (detailJson['placeAddress'] as String?) ??
        current.activity.place;
    final placeAddress = detailJson['placeAddress'] as String?;
    final images =
        ((detailJson['images'] as List<Object?>?) ?? const <Object?>[])
            .whereType<String>()
            .toList(growable: false);

    return current.copyWith(
      activity: current.activity.copyWith(
        title: detailJson['title'] as String? ?? current.activity.title,
        place: placeName,
        startAt: parseServerDateTime(detailJson['startAt'] as String),
        endAt: parseServerDateTime(detailJson['endAt'] as String),
        price: detailJson['priceAmount'] as int? ?? current.activity.price,
        participantCount:
            participantCountOverride ??
            detailJson['participantCount'] as int? ??
            current.activity.participantCount,
        participantCapacity:
            participantCapacityOverride ??
            detailJson['capacity'] as int? ??
            current.activity.participantCapacity,
        imageUrl:
            detailJson['representativeImageUrl'] as String? ??
            current.activity.imageUrl,
      ),
      imageUrls: images.isEmpty ? current.imageUrls : images,
      locationLabel: placeAddress == null || placeAddress.isEmpty
          ? placeName
          : placeAddress,
      host: current.host.copyWith(
        userId: '${hostJson['userId']}',
        name: hostJson['displayName'] as String? ?? current.host.name,
        localizedName:
            hostJson['englishName'] as String? ?? current.host.localizedName,
        locationLabel: _hostLocationLabel(
          countryCode: hostJson['primaryCountry'] as String?,
          languageCode: hostJson['primaryLanguage'] as String?,
        ),
        avatarUrl: hostJson['profileImageUrl'] as String?,
      ),
      description:
          (detailJson['description'] as String?) ??
          (detailJson['originalDescription'] as String?) ??
          current.description,
      participants: participants,
      pendingParticipants:
          pendingParticipantsOverride ?? current.pendingParticipants,
      isFavorite: detailJson['favorited'] as bool? ?? current.isFavorite,
      participationState: _resolveParticipationState(
        detailJson: detailJson,
        hostJson: hostJson,
        fallback: participationState,
      ),
    );
  }

  ActivityParticipationState _resolveParticipationState({
    required Map<String, dynamic> detailJson,
    required Map<String, dynamic> hostJson,
    ActivityParticipationState? fallback,
  }) {
    final hostedByMe = detailJson['hostedByMe'] as bool?;
    if (hostedByMe == true) {
      return ActivityParticipationState.host;
    }
    final status = (detailJson['participationStatus'] as String?)
        ?.toUpperCase();
    switch (status) {
      case 'PENDING':
        return ActivityParticipationState.requested;
      case 'JOINED':
        return ActivityParticipationState.joined;
      case 'NONE':
        return ActivityParticipationState.available;
    }

    final viewerUserId = _sessionStore.session?.user.id;
    if (viewerUserId == null) {
      return fallback ?? ActivityParticipationState.available;
    }
    return '${hostJson['userId']}' == '$viewerUserId'
        ? ActivityParticipationState.host
        : fallback ?? ActivityParticipationState.available;
  }

  Future<Map<String, dynamic>?> _fetchParticipantManageJsonIfNeeded({
    required String activityId,
    required Map<String, dynamic> detailJson,
  }) async {
    if ((detailJson['hostedByMe'] as bool?) != true) {
      return null;
    }
    final data = await _apiClient.getJson(
      '/api/v1/activities/$activityId/participants/manage',
      requiresAuth: true,
    );
    return _asMap(data);
  }

  Future<ActivityDetail> _mergeHostedParticipantDetail({
    required ActivityDetail current,
    required Map<String, dynamic> detailJson,
  }) async {
    final manageJson = await _fetchParticipantManageJsonIfNeeded(
      activityId: current.activity.id,
      detailJson: detailJson,
    );
    return _mergeActivityDetail(
      current: current,
      detailJson: detailJson,
      participationState: ActivityParticipationState.host,
      participantsOverride: _parseParticipants(
        manageJson?['approvedParticipants'] ??
            detailJson['participantPreviews'],
      ),
      pendingParticipantsOverride: _parseParticipants(
        manageJson?['pendingParticipants'],
      ),
      participantCountOverride: manageJson?['participantCount'] as int?,
      participantCapacityOverride: manageJson?['capacity'] as int?,
    );
  }
}
