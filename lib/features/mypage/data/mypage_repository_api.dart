part of 'mypage_repository.dart';

class ApiMyPageRepository implements MyPageRepository {
  ApiMyPageRepository({
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
  Future<MyPageBundle> fetchBundle({required bool isBusinessMode}) async {
    final sessionUser = _sessionStore.session?.user;
    if (sessionUser == null) {
      throw const MyPageRepositoryException(MyPageLoadFailureType.server);
    }

    try {
      final results = await Future.wait<Object?>(<Future<Object?>>[
        _apiClient.getJson('/api/v1/users/me', requiresAuth: true),
        _apiClient.getJson(
          '/api/v1/users/${sessionUser.id}',
          requiresAuth: true,
        ),
        _apiClient.getJson('/api/v1/users/me/badges', requiresAuth: true),
        _apiClient.getJson(
          '/api/v1/users/me/activity-history',
          requiresAuth: true,
          queryParameters: <String, String>{'limit': '50'},
        ),
        if (isBusinessMode)
          _apiClient.getJson('/api/v1/hosts/me', requiresAuth: true),
        if (isBusinessMode)
          _apiClient.getJson(
            '/api/v1/business-applications/me',
            requiresAuth: true,
          ),
      ]);

      final meProfileJson = _asMap(results[0]);
      final mePageJson = _asMap(results[1]);
      final badgesJson = results[2] is List<Object?>
          ? results[2] as List<Object?>
          : const <Object?>[];
      final historyJson = results[3] is List<Object?>
          ? results[3] as List<Object?>
          : const <Object?>[];

      final historyEntries = historyJson
          .map(_parseActivityHistoryEntry)
          .toList(growable: false);
      final statsJson = _asMap(mePageJson['stats']);

      final personalPage = PersonalMyPageData(
        profile: _buildPersonalProfile(meProfileJson, mePageJson),
        metrics: <ProfileMetric>[
          ProfileMetric(
            label: '참가/생성 활동',
            value: '${statsJson['totalActivityCount'] as int? ?? 0}',
          ),
          ProfileMetric(
            label: '친구 수',
            value: '${statsJson['friendCount'] as int? ?? 0}',
          ),
          ProfileMetric(
            label: '작성 리뷰',
            value: '${statsJson['reviewCount'] as int? ?? 0}',
          ),
        ],
        badges: badgesJson.map(_parseBadge).toList(growable: false),
        recentActivities: historyEntries.take(3).toList(growable: false),
      );

      final recentActivity = RecentActivityData(
        stats: RecentActivityStats(
          totalCount: statsJson['totalActivityCount'] as int? ?? 0,
          hostedCount: statsJson['createdActivityCount'] as int? ?? 0,
          joinedCount: statsJson['joinedActivityCount'] as int? ?? 0,
          reviewCount: statsJson['reviewCount'] as int? ?? 0,
        ),
        activities: historyEntries,
      );

      final businessPage = isBusinessMode
          ? _buildBusinessPage(
              userProfileJson: meProfileJson,
              hostPageJson: _asMap(results[4]),
              businessApplicationJson: _asMap(results[5]),
            )
          : _fallbackBusinessPage(meProfileJson);

      return MyPageBundle(
        personalPage: personalPage,
        otherProfile: const OtherProfileData(
          profile: ProfileSummary(
            id: '',
            name: '',
            residence: '',
            primaryLanguageCode: 'ko',
            primaryLanguageLabel: '한국어',
            primaryCountryCode: 'kr',
            primaryCountryLabel: '대한민국',
          ),
          metrics: <ProfileMetric>[],
          badges: <ActivityBadge>[],
          recentActivities: <ActivityHistoryEntry>[],
          isFriend: false,
        ),
        recentActivity: recentActivity,
        businessPage: businessPage,
        languageOptions: kMyPageLanguageOptions,
        countryOptions: kMyPageCountryOptions,
        consentHistory: _consentHistory,
        blockedUsers: _blockedUsers,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<PersonalMyPageData> updatePrimaryPreferences({
    required String displayName,
    required String languageCode,
    required String countryCode,
  }) async {
    try {
      final data = await _apiClient.patchJson(
        '/api/v1/users/me/profile',
        requiresAuth: true,
        body: <String, Object?>{
          'displayName': displayName,
          'primaryLanguage': languageCode,
          'primaryCountry': countryCode.toUpperCase(),
        },
      );
      final profileJson = _asMap(data);
      final pageData = await _apiClient.getJson(
        '/api/v1/users/${_sessionStore.session!.user.id}',
        requiresAuth: true,
      );
      final pageJson = _asMap(pageData);
      final statsJson = _asMap(pageJson['stats']);
      final historyData = await _apiClient.getJson(
        '/api/v1/users/me/activity-history',
        requiresAuth: true,
        queryParameters: <String, String>{'limit': '3'},
      );
      final historyItems = historyData is List<Object?>
          ? historyData
          : const <Object?>[];
      final badgesData = await _apiClient.getJson(
        '/api/v1/users/me/badges',
        requiresAuth: true,
      );
      final badgesItems = badgesData is List<Object?>
          ? badgesData
          : const <Object?>[];

      return PersonalMyPageData(
        profile: _buildPersonalProfile(profileJson, pageJson),
        metrics: <ProfileMetric>[
          ProfileMetric(
            label: '참가/생성 활동',
            value: '${statsJson['totalActivityCount'] as int? ?? 0}',
          ),
          ProfileMetric(
            label: '친구 수',
            value: '${statsJson['friendCount'] as int? ?? 0}',
          ),
          ProfileMetric(
            label: '작성 리뷰',
            value: '${statsJson['reviewCount'] as int? ?? 0}',
          ),
        ],
        badges: badgesItems.map(_parseBadge).toList(growable: false),
        recentActivities: historyItems
            .map(_parseActivityHistoryEntry)
            .toList(growable: false),
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<BusinessMyPageData> updateBusinessIntroduction({
    required String introduction,
    String? placeName,
    String? placeAddress,
  }) async {
    try {
      final data = await _apiClient.patchJson(
        '/api/v1/hosts/me/profile',
        requiresAuth: true,
        body: <String, Object?>{
          'intro': introduction,
          'placeName': placeName,
          'placeAddress': placeAddress,
        },
      );
      return _buildBusinessPage(
        userProfileJson: _asMap(
          await _apiClient.getJson('/api/v1/users/me', requiresAuth: true),
        ),
        hostPageJson: _asMap(data),
        businessApplicationJson: _asMap(
          await _apiClient.getJson(
            '/api/v1/business-applications/me',
            requiresAuth: true,
          ),
        ),
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<String> updateProfileImage({required String imagePath}) async {
    try {
      final uploadedUrl = await _uploadProfileImage(
        apiClient: _apiClient,
        transport: _transport,
        imagePath: imagePath,
      );
      final data = await _apiClient.patchJson(
        '/api/v1/users/me/profile-image',
        requiresAuth: true,
        body: <String, Object?>{'profileImageUrl': uploadedUrl},
      );
      final profileJson = _asMap(data);
      _syncSessionUserProfile(profileJson);
      final resolvedUrl = profileJson['profileImageUrl'] as String?;
      if (resolvedUrl == null || resolvedUrl.isEmpty) {
        throw const MyPageRepositoryException(
          MyPageLoadFailureType.server,
          message: '프로필 사진 저장 결과를 확인하지 못했어요. 잠시 후 다시 시도해 주세요.',
        );
      }
      return resolvedUrl;
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<void> submitWithdrawal({
    required String agreementText,
    String? reason,
  }) async {
    try {
      await _apiClient.postJson(
        '/api/v1/users/me/withdrawal',
        requiresAuth: true,
        body: <String, Object?>{
          'agreementText': agreementText,
          'reason': reason,
        },
      );
      _sessionStore.clear();
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  void _syncSessionUserProfile(Map<String, dynamic> profileJson) {
    final current = _sessionStore.session;
    if (current == null) {
      return;
    }

    final updatedUser = current.user.copyWith(
      displayName:
          profileJson['displayName'] as String? ?? current.user.displayName,
      primaryLanguage:
          profileJson['primaryLanguage'] as String? ??
          current.user.primaryLanguage,
      primaryCountry:
          profileJson['primaryCountry'] as String? ??
          current.user.primaryCountry,
      profileImageUrl: profileJson['profileImageUrl'] as String?,
      activityRegionName:
          profileJson['activityRegionName'] as String? ??
          current.user.activityRegionName,
      activityLatitude:
          (profileJson['activityLatitude'] as num?)?.toDouble() ??
          current.user.activityLatitude,
      activityLongitude:
          (profileJson['activityLongitude'] as num?)?.toDouble() ??
          current.user.activityLongitude,
      lastLoginAt: profileJson['lastLoginAt'] == null
          ? current.user.lastLoginAt
          : DateTime.tryParse(profileJson['lastLoginAt'] as String),
      createdAt: profileJson['createdAt'] == null
          ? current.user.createdAt
          : DateTime.tryParse(profileJson['createdAt'] as String) ??
                current.user.createdAt,
    );
    _sessionStore.save(current.copyWith(user: updatedUser));
  }

  @override
  Future<void> logout() async {
    final refreshToken = _sessionStore.session?.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      _sessionStore.clear();
      return;
    }

    try {
      await _apiClient.postJson(
        '/api/v1/auth/logout',
        body: <String, Object?>{'refreshToken': refreshToken},
      );
      _sessionStore.clear();
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<OtherProfileData> fetchOtherProfile({
    required String targetUserId,
  }) async {
    try {
      final pageData = await _apiClient.getJson(
        '/api/v1/users/$targetUserId',
        requiresAuth: true,
      );
      final historyData = await _apiClient.getJson(
        '/api/v1/users/$targetUserId/activity-history',
        requiresAuth: true,
        queryParameters: <String, String>{'limit': '3'},
      );
      final pageJson = _asMap(pageData);
      final statsJson = _asMap(pageJson['stats']);
      final historyItems = historyData is List<Object?>
          ? historyData
          : const <Object?>[];

      return OtherProfileData(
        profile: _buildOtherProfile(pageJson),
        metrics: <ProfileMetric>[
          ProfileMetric(
            label: '참가/생성 활동',
            value: '${statsJson['totalActivityCount'] as int? ?? 0}',
          ),
          ProfileMetric(
            label: '친구 수',
            value: '${statsJson['friendCount'] as int? ?? 0}',
          ),
          ProfileMetric(
            label: '작성 리뷰',
            value: '${statsJson['reviewCount'] as int? ?? 0}',
          ),
        ],
        badges: const <ActivityBadge>[],
        recentActivities: historyItems
            .map(_parseActivityHistoryEntry)
            .toList(growable: false),
        isFriend: pageJson['friend'] as bool? ?? false,
      );
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }

  @override
  Future<OtherProfileData> updateFriendship({
    required String targetUserId,
    required bool isFriend,
  }) async {
    try {
      if (isFriend) {
        await _apiClient.deleteJson(
          '/api/v1/users/$targetUserId/friends',
          requiresAuth: true,
        );
      } else {
        await _apiClient.postJson(
          '/api/v1/users/$targetUserId/friends',
          requiresAuth: true,
        );
      }
      return fetchOtherProfile(targetUserId: targetUserId);
    } on MateyaApiException catch (error) {
      throw _mapApiException(error);
    }
  }
}
