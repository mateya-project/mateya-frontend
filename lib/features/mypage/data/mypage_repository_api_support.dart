part of 'mypage_repository.dart';

ProfileSummary _buildPersonalProfile(
  Map<String, dynamic> meProfileJson,
  Map<String, dynamic> mePageJson,
) {
  final languageCode = (meProfileJson['primaryLanguage'] as String? ?? 'ko')
      .toLowerCase();
  final countryCode = (meProfileJson['primaryCountry'] as String? ?? 'KR')
      .toLowerCase();
  final activityCountryCode = _activityCountryCode(meProfileJson);
  final lastLoginAt = meProfileJson['lastLoginAt'] as String?;

  return ProfileSummary(
    id: '${meProfileJson['id']}',
    name: meProfileJson['displayName'] as String? ?? '',
    englishName: meProfileJson['englishName'] as String?,
    residence: _activityRegionOrFallback(
      meProfileJson['activityRegionName'] as String?,
    ),
    primaryLanguageCode: languageCode,
    primaryLanguageLabel: _languageLabel(languageCode),
    primaryCountryCode: countryCode,
    primaryCountryLabel: _countryLabel(countryCode),
    activityCountryCode: activityCountryCode,
    activityCountryLabel: _activityCountryLabel(activityCountryCode),
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
  final activityCountryCode = _activityCountryCode(pageJson);
  return ProfileSummary(
    id: '${pageJson['id']}',
    name: pageJson['displayName'] as String? ?? '',
    englishName: pageJson['englishName'] as String?,
    residence: _activityRegionOrFallback(
      pageJson['activityRegionName'] as String?,
    ),
    primaryLanguageCode: languageCode,
    primaryLanguageLabel: _languageLabel(languageCode),
    primaryCountryCode: countryCode,
    primaryCountryLabel: _countryLabel(countryCode),
    activityCountryCode: activityCountryCode,
    activityCountryLabel: _activityCountryLabel(activityCountryCode),
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
  final activityCountryCode = _activityCountryCode(userProfileJson);

  return BusinessMyPageData(
    profile: ProfileSummary(
      id: '${hostPageJson['businessApplicationId'] ?? userProfileJson['id']}',
      name:
          (hostPageJson['businessName'] as String?) ??
          (businessApplicationJson['businessName'] as String?) ??
          (userProfileJson['displayName'] as String? ?? ''),
      englishName: userProfileJson['englishName'] as String?,
      residence:
          (hostPageJson['placeAddress'] as String?) ??
          _activityRegionOrFallback(
            userProfileJson['activityRegionName'] as String?,
          ),
      primaryLanguageCode: languageCode,
      primaryLanguageLabel: _languageLabel(languageCode),
      primaryCountryCode: countryCode,
      primaryCountryLabel: _countryLabel(countryCode),
      activityCountryCode: activityCountryCode,
      activityCountryLabel: _activityCountryLabel(activityCountryCode),
      profileImageUrl:
          (hostPageJson['profileImageUrl'] as String?) ??
          (userProfileJson['profileImageUrl'] as String?),
      oneLineIntroduction: hostPageJson['intro'] as String?,
      placeLabel: hostPageJson['placeName'] as String?,
    ),
    metrics: _buildBusinessMetrics(statsJson),
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
  final activityCountryCode = _activityCountryCode(userProfileJson);
  return BusinessMyPageData(
    profile: ProfileSummary(
      id: '${userProfileJson['id']}',
      name: userProfileJson['displayName'] as String? ?? '',
      englishName: userProfileJson['englishName'] as String?,
      residence: _activityRegionOrFallback(
        userProfileJson['activityRegionName'] as String?,
      ),
      primaryLanguageCode: languageCode,
      primaryLanguageLabel: _languageLabel(languageCode),
      primaryCountryCode: countryCode,
      primaryCountryLabel: _countryLabel(countryCode),
      activityCountryCode: activityCountryCode,
      activityCountryLabel: _activityCountryLabel(activityCountryCode),
      profileImageUrl: userProfileJson['profileImageUrl'] as String?,
    ),
    metrics: _buildBusinessMetrics(const <String, dynamic>{}),
    activeExperiences: const <ActivityHistoryEntry>[],
  );
}

ActivityBadge _parseBadge(Object? value) {
  final json = _asMap(value);
  final categoryCode = json['category'] as String? ?? 'PUBLIC_FACILITY';
  final earned = json['earned'] as bool? ?? true;
  return ActivityBadge(
    id: '${json['id']}',
    label: json['badgeName'] as String? ?? '',
    categoryLabel: _categoryLabel(categoryCode),
    badgeCode: _resolveBadgeCode(json),
    isEarned: earned,
    imageUrl: _resolveBadgeImageUrl(json['badgeImageUrl'] as String?),
  );
}

String? _resolveBadgeCode(Map<String, dynamic> json) {
  final candidates = <Object?>[
    json['badgeCode'],
    json['badgeKey'],
    json['code'],
    json['key'],
  ];
  for (final candidate in candidates) {
    if (candidate is! String) {
      continue;
    }
    final trimmed = candidate.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return null;
}

String? _resolveBadgeImageUrl(String? rawUrl) {
  final trimmed = rawUrl?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  final uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return null;
  }
  if (uri.hasScheme) {
    return trimmed;
  }
  return Uri.parse(AppConfig.apiBaseUrl).resolveUri(uri).toString();
}

ConsentHistoryEntry _parseConsentHistoryEntry(Object? value) {
  final json = _asMap(value);
  final agreedAt = tryParseServerDateTime(json['agreedAt']);
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
  final startAt = parseServerDateTime(json['startAt'] as String);
  final endAt = parseServerDateTime(json['endAt'] as String);
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
    priceLabel: priceType == 'FREE'
        ? MateyaLocalizations.current.commonFree
        : _formatCurrency(priceAmount),
    participantLabel: _participantLabel(participantCount, capacity),
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
    residence: _activityRegionOrFallback(json['activityRegionName'] as String?),
    profileImageUrl: json['profileImageUrl'] as String?,
  );
}

String _activityRegionOrFallback(String? regionName) {
  final trimmed = regionName?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return MateyaLocalizations.current.mypageActivityRegionUnset;
  }
  return trimmed;
}

List<ProfileMetric> _buildPersonalMetrics(Map<String, dynamic> statsJson) {
  final l10n = MateyaLocalizations.current;
  return <ProfileMetric>[
    ProfileMetric(
      label: l10n.mypageMetricActivities,
      value: '${statsJson['totalActivityCount'] as int? ?? 0}',
    ),
    ProfileMetric(
      label: l10n.mypageMetricFriends,
      value: '${statsJson['friendCount'] as int? ?? 0}',
    ),
    ProfileMetric(
      label: l10n.mypageMetricReviews,
      value: '${statsJson['reviewCount'] as int? ?? 0}',
    ),
  ];
}

List<ProfileMetric> _buildBusinessMetrics(Map<String, dynamic> statsJson) {
  final l10n = MateyaLocalizations.current;
  return <ProfileMetric>[
    ProfileMetric(
      label: l10n.mypageMetricRecruitingExperiences,
      value: '${statsJson['recruitingExperienceCount'] as int? ?? 0}',
    ),
    ProfileMetric(
      label: l10n.mypageMetricTotalParticipants,
      value: '${statsJson['totalParticipantCount'] as int? ?? 0}',
    ),
    ProfileMetric(
      label: l10n.mypageMetricAverageRating,
      value: _formatRating(statsJson['averageRating'] as num?),
    ),
    ProfileMetric(
      label: l10n.mypageMetricReceivedReviews,
      value: '${statsJson['reviewCount'] as int? ?? 0}',
    ),
  ];
}

bool _isActiveWithin30Days(String? isoString) {
  if (isoString == null || isoString.isEmpty) {
    return false;
  }
  final timestamp = tryParseServerDateTime(isoString);
  if (timestamp == null) {
    return false;
  }
  return mateyaNowInKst().difference(timestamp).inDays <= 30;
}

String _formatDate(DateTime value) {
  return DateFormat.yMd(_intlLocale()).format(value);
}

String _formatTime(DateTime value) {
  final hour = '${value.hour}'.padLeft(2, '0');
  final minute = '${value.minute}'.padLeft(2, '0');
  return '$hour:$minute';
}

String _formatCurrency(int amount) {
  return NumberFormat.currency(
    locale: _intlLocale(),
    symbol: '₩ ',
    decimalDigits: 0,
  ).format(amount);
}

String _formatRating(num? value) {
  if (value == null) {
    return '-';
  }
  return value.toStringAsFixed(1);
}

String _participantLabel(int participantCount, int capacity) {
  return MateyaLocalizations.current.mypageParticipantCount(
    participantCount,
    capacity,
  );
}

String _intlLocale() {
  final locale = MateyaLocalizations.locale;
  if (locale.scriptCode case final String scriptCode
      when scriptCode.isNotEmpty) {
    return '${locale.languageCode}_$scriptCode';
  }
  if (locale.countryCode case final String countryCode
      when countryCode.isNotEmpty) {
    return '${locale.languageCode}_$countryCode';
  }
  return locale.languageCode;
}

String _languageLabel(String code) {
  final normalized = code.toLowerCase();
  return kMyPageLanguageOptions
          .where((option) => option.code == normalized)
          .firstOrNull
          ?.label ??
      normalized.toUpperCase();
}

String? _activityCountryCode(Map<String, dynamic> json) {
  final code = (json['activityCountry'] as String?)?.trim();
  if (code == null || code.isEmpty) {
    return null;
  }
  return code.toLowerCase();
}

String? _activityCountryLabel(String? code) {
  if (code == null || code.isEmpty) {
    return null;
  }
  final l10n = MateyaLocalizations.current;
  return switch (code.toUpperCase()) {
    'KR' => l10n.countryKorea,
    'JP' => l10n.countryJapan,
    'CN' => l10n.countryChina,
    'VN' => l10n.countryVietnam,
    'US' => l10n.countryUnitedStates,
    'TH' => l10n.countryThailand,
    _ => code.toUpperCase(),
  };
}

String _countryLabel(String code) {
  final normalized = code.toLowerCase();
  return kMyPageCountryOptions
          .where((option) => option.code == normalized)
          .firstOrNull
          ?.label ??
      normalized.toUpperCase();
}

String _categoryLabel(String? code) {
  final l10n = MateyaLocalizations.current;
  return switch (code) {
    'TOURIST_ATTRACTION' => l10n.activityCategoryTouristAttraction,
    'TRAVEL_COURSE' => l10n.activityCategoryTravelCourse,
    'CULTURE_TRADITION' => l10n.activityCategoryCultureTradition,
    'EVENT_PERFORMANCE_FESTIVAL' =>
      l10n.activityCategoryEventPerformanceFestival,
    'SPORTS' => l10n.activityCategorySports,
    'ACTIVITY_LEPORTS' => l10n.activityCategoryActivityLeports,
    'SHOPPING' => l10n.activityCategoryShopping,
    'PUBLIC_FACILITY' => l10n.activityCategoryPublicFacility,
    _ => l10n.activityCategoryOther,
  };
}

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
