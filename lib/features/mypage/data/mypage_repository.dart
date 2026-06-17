import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../domain/mypage_models.dart';

abstract interface class MyPageRepository {
  Future<MyPageBundle> fetchBundle({required bool isBusinessMode});

  Future<PersonalMyPageData> updatePrimaryPreferences({
    required String displayName,
    required String languageCode,
    required String countryCode,
  });

  Future<BusinessMyPageData> updateBusinessIntroduction({
    required String introduction,
    String? placeName,
    String? placeAddress,
  });

  Future<void> submitWithdrawal({
    required String agreementText,
    String? reason,
  });
}

class ApiMyPageRepository implements MyPageRepository {
  ApiMyPageRepository({
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
        otherProfile: _otherProfile,
        recentActivity: recentActivity,
        businessPage: businessPage,
        languageOptions: kMyPageLanguageOptions,
        countryOptions: kMyPageCountryOptions,
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

  ProfileSummary _buildPersonalProfile(
    Map<String, dynamic> meProfileJson,
    Map<String, dynamic> mePageJson,
  ) {
    final languageCode = (meProfileJson['primaryLanguage'] as String? ?? 'ko')
        .toLowerCase();
    final countryCode = (meProfileJson['primaryCountry'] as String? ?? 'KR')
        .toLowerCase();
    final lastLoginAt = meProfileJson['lastLoginAt'] as String?;

    return ProfileSummary(
      id: '${meProfileJson['id']}',
      name: meProfileJson['displayName'] as String? ?? '',
      residence:
          (meProfileJson['activityRegionName'] as String?) ?? '활동 지역 미설정',
      primaryLanguageCode: languageCode,
      primaryLanguageLabel: _languageLabel(languageCode),
      primaryCountryCode: countryCode,
      primaryCountryLabel: _countryLabel(countryCode),
      profileImageUrl: meProfileJson['profileImageUrl'] as String?,
      isActiveWithin30Days: _isActiveWithin30Days(
        lastLoginAt ?? mePageJson['createdAt'] as String?,
      ),
    );
  }

  BusinessMyPageData _buildBusinessPage({
    required Map<String, dynamic> userProfileJson,
    required Map<String, dynamic> hostPageJson,
    required Map<String, dynamic> businessApplicationJson,
  }) {
    final statsJson = _asMap(hostPageJson['stats']);
    final languageCode = (userProfileJson['primaryLanguage'] as String? ?? 'ko')
        .toLowerCase();
    final countryCode = (userProfileJson['primaryCountry'] as String? ?? 'KR')
        .toLowerCase();

    return BusinessMyPageData(
      profile: ProfileSummary(
        id: '${hostPageJson['businessApplicationId'] ?? userProfileJson['id']}',
        name:
            (hostPageJson['businessName'] as String?) ??
            (businessApplicationJson['businessName'] as String?) ??
            (userProfileJson['displayName'] as String? ?? ''),
        residence:
            (hostPageJson['placeAddress'] as String?) ??
            (userProfileJson['activityRegionName'] as String?) ??
            '활동 지역 미설정',
        primaryLanguageCode: languageCode,
        primaryLanguageLabel: _languageLabel(languageCode),
        primaryCountryCode: countryCode,
        primaryCountryLabel: _countryLabel(countryCode),
        profileImageUrl:
            (hostPageJson['profileImageUrl'] as String?) ??
            (userProfileJson['profileImageUrl'] as String?),
        oneLineIntroduction: hostPageJson['intro'] as String?,
        placeLabel: hostPageJson['placeName'] as String?,
      ),
      metrics: <ProfileMetric>[
        ProfileMetric(
          label: '모집중 체험',
          value: '${statsJson['recruitingExperienceCount'] as int? ?? 0}',
        ),
        ProfileMetric(
          label: '누적 참가자',
          value: '${statsJson['totalParticipantCount'] as int? ?? 0}',
        ),
        ProfileMetric(
          label: '평균 평점',
          value: _formatRating(statsJson['averageRating'] as num?),
        ),
        ProfileMetric(
          label: '받은 후기',
          value: '${statsJson['reviewCount'] as int? ?? 0}',
        ),
      ],
      activeExperiences:
          ((hostPageJson['operatingActivities'] as List<Object?>?) ??
                  const <Object?>[])
              .map(_parseActivityHistoryEntry)
              .toList(growable: false),
    );
  }

  BusinessMyPageData _fallbackBusinessPage(
    Map<String, dynamic> userProfileJson,
  ) {
    final languageCode = (userProfileJson['primaryLanguage'] as String? ?? 'ko')
        .toLowerCase();
    final countryCode = (userProfileJson['primaryCountry'] as String? ?? 'KR')
        .toLowerCase();
    return BusinessMyPageData(
      profile: ProfileSummary(
        id: '${userProfileJson['id']}',
        name: userProfileJson['displayName'] as String? ?? '',
        residence:
            (userProfileJson['activityRegionName'] as String?) ?? '활동 지역 미설정',
        primaryLanguageCode: languageCode,
        primaryLanguageLabel: _languageLabel(languageCode),
        primaryCountryCode: countryCode,
        primaryCountryLabel: _countryLabel(countryCode),
        profileImageUrl: userProfileJson['profileImageUrl'] as String?,
      ),
      metrics: const <ProfileMetric>[
        ProfileMetric(label: '모집중 체험', value: '0'),
        ProfileMetric(label: '누적 참가자', value: '0'),
        ProfileMetric(label: '평균 평점', value: '-'),
        ProfileMetric(label: '받은 후기', value: '0'),
      ],
      activeExperiences: const <ActivityHistoryEntry>[],
    );
  }

  ActivityBadge _parseBadge(Object? value) {
    final json = _asMap(value);
    final categoryCode = json['category'] as String? ?? 'PUBLIC_FACILITY';
    return ActivityBadge(
      id: '${json['id']}',
      label: json['badgeName'] as String? ?? '',
      categoryLabel: _categoryLabel(categoryCode),
    );
  }

  ActivityHistoryEntry _parseActivityHistoryEntry(Object? value) {
    final json = _asMap(value);
    final startAt = DateTime.parse(json['startAt'] as String);
    final endAt = DateTime.parse(json['endAt'] as String);
    final priceType = json['priceType'] as String? ?? 'FREE';
    final priceAmount = json['priceAmount'] as int? ?? 0;
    final participantCount = json['participantCount'] as int? ?? 0;
    final capacity = json['capacity'] as int? ?? 0;

    return ActivityHistoryEntry(
      id: '${json['id']}',
      categoryLabel: _categoryLabel(json['category'] as String?),
      title: json['title'] as String? ?? '',
      dateLabel: _formatDate(startAt),
      timeLabel: '${_formatTime(startAt)} - ${_formatTime(endAt)}',
      priceLabel: priceType == 'FREE' ? '무료' : _formatCurrency(priceAmount),
      participantLabel: '$participantCount / $capacity명',
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['reviewRating'] as num?)?.toDouble(),
      isHostedByMe: json['hostedByMe'] as bool? ?? false,
    );
  }

  bool _isActiveWithin30Days(String? isoString) {
    if (isoString == null || isoString.isEmpty) {
      return false;
    }
    final timestamp = DateTime.tryParse(isoString);
    if (timestamp == null) {
      return false;
    }
    return DateTime.now().difference(timestamp).inDays <= 30;
  }

  String _formatDate(DateTime value) {
    final month = '${value.month}'.padLeft(2, '0');
    final day = '${value.day}'.padLeft(2, '0');
    return '${value.year}.$month.$day';
  }

  String _formatTime(DateTime value) {
    final hour = '${value.hour}'.padLeft(2, '0');
    final minute = '${value.minute}'.padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatCurrency(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index += 1) {
      final reversedIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reversedIndex > 1 && reversedIndex % 3 == 1) {
        buffer.write(',');
      }
    }
    return '${buffer.toString()}원';
  }

  String _formatRating(num? value) {
    if (value == null) {
      return '-';
    }
    return value.toStringAsFixed(1);
  }

  String _languageLabel(String code) {
    final normalized = code.toLowerCase();
    return kMyPageLanguageOptions
            .where((option) => option.code == normalized)
            .firstOrNull
            ?.label ??
        normalized.toUpperCase();
  }

  String _countryLabel(String code) {
    final normalized = code.toLowerCase();
    return kMyPageCountryOptions
            .where((option) => option.code == normalized)
            .firstOrNull
            ?.label ??
        normalized.toUpperCase();
  }

  String _categoryLabel(String? code) => switch (code) {
    'TOURIST_ATTRACTION' => '관광/산책',
    'TRAVEL_COURSE' => '관광/산책',
    'CULTURE_TRADITION' => '전통문화',
    'EVENT_PERFORMANCE_FESTIVAL' => '지역축제',
    'SPORTS' => '스포츠/액티비티',
    'ACTIVITY_LEPORTS' => '스포츠/액티비티',
    'SHOPPING' => '음식체험',
    'PUBLIC_FACILITY' => '기타',
    _ => '기타',
  };

  MyPageRepositoryException _mapApiException(MateyaApiException error) {
    if (error.type == ApiFailureType.network) {
      return MyPageRepositoryException(
        MyPageLoadFailureType.network,
        message: error.message,
      );
    }
    return MyPageRepositoryException(
      MyPageLoadFailureType.server,
      message: error.message,
    );
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return const <String, dynamic>{};
  }
}

class MockMyPageRepository implements MyPageRepository {
  @override
  Future<MyPageBundle> fetchBundle({required bool isBusinessMode}) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    return const MyPageBundle(
      personalPage: _personalPage,
      otherProfile: _otherProfile,
      recentActivity: _recentActivity,
      businessPage: _businessPage,
      languageOptions: kMyPageLanguageOptions,
      countryOptions: kMyPageCountryOptions,
    );
  }

  @override
  Future<PersonalMyPageData> updatePrimaryPreferences({
    required String displayName,
    required String languageCode,
    required String countryCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    final language = kMyPageLanguageOptions
        .where((item) => item.code == languageCode)
        .firstOrNull;
    final country = kMyPageCountryOptions
        .where((item) => item.code == countryCode)
        .firstOrNull;
    return _personalPage.copyWith(
      profile: _personalPage.profile.copyWith(
        primaryLanguageCode: languageCode,
        primaryLanguageLabel: language?.label ?? languageCode,
        primaryCountryCode: countryCode,
        primaryCountryLabel: country?.label ?? countryCode,
      ),
    );
  }

  @override
  Future<BusinessMyPageData> updateBusinessIntroduction({
    required String introduction,
    String? placeName,
    String? placeAddress,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return _businessPage.copyWith(
      profile: _businessPage.profile.copyWith(
        oneLineIntroduction: introduction,
        placeLabel: placeName ?? _businessPage.profile.placeLabel,
      ),
    );
  }

  @override
  Future<void> submitWithdrawal({
    required String agreementText,
    String? reason,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
  }
}

const PersonalMyPageData _personalPage = PersonalMyPageData(
  profile: ProfileSummary(
    id: 'guest-me',
    name: '유나',
    residence: '서울 성동구 성수동',
    primaryLanguageCode: 'ko',
    primaryLanguageLabel: '한국어',
    primaryCountryCode: 'kr',
    primaryCountryLabel: '대한민국',
    profileImageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=900&q=80',
    isActiveWithin30Days: true,
  ),
  metrics: <ProfileMetric>[
    ProfileMetric(label: '참가/생성 활동', value: '18'),
    ProfileMetric(label: '친구 수', value: '24'),
    ProfileMetric(label: '작성 리뷰', value: '11'),
  ],
  badges: <ActivityBadge>[
    ActivityBadge(
      id: 'traditional',
      label: 'traditional!',
      categoryLabel: '전통문화',
    ),
    ActivityBadge(id: 'food', label: 'food lover', categoryLabel: '음식체험'),
    ActivityBadge(
      id: 'language',
      label: 'language sharing',
      categoryLabel: '언어교환',
    ),
    ActivityBadge(id: 'walk', label: 'tourist', categoryLabel: '관광/산책'),
  ],
  recentActivities: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'recent-1',
      categoryLabel: '언어교환',
      title: '홍대 영어-한국어 언어교환',
      dateLabel: '2026.06.12',
      timeLabel: '19:30 - 21:30',
      priceLabel: '10,000원',
      participantLabel: '14 / 20명',
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1200&q=80',
      rating: 4.9,
    ),
    ActivityHistoryEntry(
      id: 'recent-2',
      categoryLabel: '음식체험',
      title: '광장시장 야식 투어',
      dateLabel: '2026.06.08',
      timeLabel: '20:00 - 23:00',
      priceLabel: '32,000원',
      participantLabel: '6 / 10명',
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
    ),
    ActivityHistoryEntry(
      id: 'recent-3',
      categoryLabel: '관광/산책',
      title: '한강 밤 산책',
      dateLabel: '2026.06.01',
      timeLabel: '20:30 - 22:30',
      priceLabel: '무료',
      participantLabel: '18 / 25명',
      imageUrl:
          'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
    ),
  ],
);

const OtherProfileData _otherProfile = OtherProfileData(
  profile: ProfileSummary(
    id: 'other-jisoo',
    name: '지수',
    residence: '서울 마포구 연남동',
    primaryLanguageCode: 'en',
    primaryLanguageLabel: '영어',
    primaryCountryCode: 'us',
    primaryCountryLabel: '미국',
    profileImageUrl:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=900&q=80',
    isActiveWithin30Days: true,
  ),
  metrics: <ProfileMetric>[
    ProfileMetric(label: '참가/생성 활동', value: '26'),
    ProfileMetric(label: '친구 수', value: '31'),
    ProfileMetric(label: '작성 리뷰', value: '17'),
  ],
  badges: <ActivityBadge>[
    ActivityBadge(id: 'festival', label: 'festive!', categoryLabel: '지역축제'),
    ActivityBadge(
      id: 'sports',
      label: 'active person',
      categoryLabel: '스포츠/액티비티',
    ),
    ActivityBadge(id: 'craft', label: 'craftsman', categoryLabel: '공예'),
  ],
  recentActivities: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'other-recent-1',
      categoryLabel: '스포츠/액티비티',
      title: '초보자 풋살 매칭',
      dateLabel: '2026.06.11',
      timeLabel: '18:30 - 20:30',
      priceLabel: '18,000원',
      participantLabel: '9 / 14명',
      imageUrl:
          'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
      rating: 4.6,
    ),
    ActivityHistoryEntry(
      id: 'other-recent-2',
      categoryLabel: '공예',
      title: '이천 도자기 핸드빌딩 체험',
      dateLabel: '2026.06.05',
      timeLabel: '13:00 - 16:00',
      priceLabel: '55,000원',
      participantLabel: '7 / 12명',
      imageUrl:
          'https://images.unsplash.com/photo-1517048676732-d65bc937f952?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
    ),
    ActivityHistoryEntry(
      id: 'other-recent-3',
      categoryLabel: '지역축제',
      title: '수원 야행 같이 가요',
      dateLabel: '2026.05.29',
      timeLabel: '18:00 - 22:00',
      priceLabel: '15,000원',
      participantLabel: '21 / 30명',
      imageUrl:
          'https://images.unsplash.com/photo-1470004914212-05527e49370b?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
    ),
  ],
  isFriend: false,
);

const RecentActivityData _recentActivity = RecentActivityData(
  stats: RecentActivityStats(
    totalCount: 18,
    hostedCount: 5,
    joinedCount: 13,
    reviewCount: 11,
  ),
  activities: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'list-1',
      categoryLabel: '언어교환',
      title: '홍대 영어-한국어 언어교환',
      dateLabel: '2026.06.12',
      timeLabel: '19:30 - 21:30',
      priceLabel: '10,000원',
      participantLabel: '14 / 20명',
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1200&q=80',
      rating: 4.9,
    ),
    ActivityHistoryEntry(
      id: 'list-2',
      categoryLabel: '전통문화',
      title: '북촌 한옥 티 클래스',
      dateLabel: '2026.06.10',
      timeLabel: '14:00 - 16:00',
      priceLabel: '45,000원',
      participantLabel: '11 / 16명',
      imageUrl:
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
      isHostedByMe: true,
    ),
    ActivityHistoryEntry(
      id: 'list-3',
      categoryLabel: '음식체험',
      title: '광장시장 야식 투어',
      dateLabel: '2026.06.08',
      timeLabel: '20:00 - 23:00',
      priceLabel: '32,000원',
      participantLabel: '6 / 10명',
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
    ),
    ActivityHistoryEntry(
      id: 'list-4',
      categoryLabel: '관광/산책',
      title: '한강 밤 산책',
      dateLabel: '2026.06.01',
      timeLabel: '20:30 - 22:30',
      priceLabel: '무료',
      participantLabel: '18 / 25명',
      imageUrl:
          'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
    ),
    ActivityHistoryEntry(
      id: 'list-5',
      categoryLabel: '관광/산책',
      title: '망원시장 먹거리 산책',
      dateLabel: '2026.05.26',
      timeLabel: '11:00 - 14:00',
      priceLabel: '22,000원',
      participantLabel: '8 / 12명',
      imageUrl:
          'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
      isHostedByMe: true,
    ),
  ],
);

const BusinessMyPageData _businessPage = BusinessMyPageData(
  profile: ProfileSummary(
    id: 'host-studio',
    name: '성수 티 스튜디오',
    residence: '서울 성동구 성수일로 32',
    primaryLanguageCode: 'ko',
    primaryLanguageLabel: '한국어',
    primaryCountryCode: 'kr',
    primaryCountryLabel: '대한민국',
    profileImageUrl:
        'https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=900&q=80',
    oneLineIntroduction: '외국인과 로컬이 함께 어울리는 전통 티 클래스와 산책형 체험을 운영하고 있어요.',
    placeLabel: '성수 티하우스',
  ),
  metrics: <ProfileMetric>[
    ProfileMetric(label: '모집중 체험', value: '6'),
    ProfileMetric(label: '누적 참가자', value: '182'),
    ProfileMetric(label: '평균 평점', value: '4.8'),
    ProfileMetric(label: '받은 후기', value: '64'),
  ],
  activeExperiences: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'host-1',
      categoryLabel: '전통문화',
      title: '북촌 한옥 티 클래스',
      dateLabel: '매주 수/토',
      timeLabel: '14:00 - 16:00',
      priceLabel: '45,000원',
      participantLabel: '11 / 16명',
      imageUrl:
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
      isHostedByMe: true,
    ),
    ActivityHistoryEntry(
      id: 'host-2',
      categoryLabel: '음식체험',
      title: '김치 만들기 원데이 클래스',
      dateLabel: '매주 금요일',
      timeLabel: '18:30 - 20:30',
      priceLabel: '39,000원',
      participantLabel: '8 / 12명',
      imageUrl:
          'https://images.unsplash.com/photo-1516684732162-798a0062be99?auto=format&fit=crop&w=1200&q=80',
      rating: 4.9,
      isHostedByMe: true,
    ),
    ActivityHistoryEntry(
      id: 'host-3',
      categoryLabel: '관광/산책',
      title: '성수 골목 로컬 워킹 투어',
      dateLabel: '매주 일요일',
      timeLabel: '10:00 - 12:30',
      priceLabel: '25,000원',
      participantLabel: '10 / 14명',
      imageUrl:
          'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
      isHostedByMe: true,
    ),
  ],
);
