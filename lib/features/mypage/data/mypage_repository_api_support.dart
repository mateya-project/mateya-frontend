part of 'mypage_repository.dart';

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
    residence: (meProfileJson['activityRegionName'] as String?) ?? '활동 지역 미설정',
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

ProfileSummary _buildOtherProfile(Map<String, dynamic> pageJson) {
  final languageCode = (pageJson['primaryLanguage'] as String? ?? 'ko')
      .toLowerCase();
  final countryCode = (pageJson['primaryCountry'] as String? ?? 'KR')
      .toLowerCase();
  return ProfileSummary(
    id: '${pageJson['id']}',
    name: pageJson['displayName'] as String? ?? '',
    residence: (pageJson['activityRegionName'] as String?) ?? '활동 지역 미설정',
    primaryLanguageCode: languageCode,
    primaryLanguageLabel: _languageLabel(languageCode),
    primaryCountryCode: countryCode,
    primaryCountryLabel: _countryLabel(countryCode),
    profileImageUrl: pageJson['profileImageUrl'] as String?,
    isActiveWithin30Days: pageJson['activeWithin30Days'] as bool? ?? false,
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

BusinessMyPageData _fallbackBusinessPage(Map<String, dynamic> userProfileJson) {
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

ConsentHistoryEntry _parseConsentHistoryEntry(Object? value) {
  final json = _asMap(value);
  final agreedAt = DateTime.tryParse(json['agreedAt'] as String? ?? '');
  return ConsentHistoryEntry(
    id: (json['type'] as String? ?? '').toLowerCase(),
    title: json['title'] as String? ?? '',
    agreed: json['agreed'] as bool? ?? false,
    agreedAtLabel: agreedAt == null ? '-' : _formatDate(agreedAt),
    versionLabel: json['version'] as String? ?? '',
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

BlockedUserSummary _parseBlockedUserSummary(Object? value) {
  final json = _asMap(value);
  return BlockedUserSummary(
    id: '${json['userId'] ?? ''}',
    name: json['displayName'] as String? ?? '',
    residence: (json['activityRegionName'] as String?) ?? '활동 지역 미설정',
    profileImageUrl: json['profileImageUrl'] as String?,
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
