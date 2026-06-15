enum MyPageAsyncPhase {
  idle,
  loading,
  success,
  validationError,
  networkError,
  serverError,
}

enum MyPageRoute {
  personalHome,
  otherProfile,
  recentActivities,
  primaryPreferences,
  withdrawal,
  businessHome,
}

enum MyPageLoadFailureType { network, server }

class ProfileSummary {
  const ProfileSummary({
    required this.id,
    required this.name,
    required this.residence,
    required this.primaryLanguageCode,
    required this.primaryLanguageLabel,
    required this.primaryCountryCode,
    required this.primaryCountryLabel,
    this.profileImageUrl,
    this.isActiveWithin30Days = false,
    this.oneLineIntroduction,
    this.placeLabel,
  });

  final String id;
  final String name;
  final String residence;
  final String primaryLanguageCode;
  final String primaryLanguageLabel;
  final String primaryCountryCode;
  final String primaryCountryLabel;
  final String? profileImageUrl;
  final bool isActiveWithin30Days;
  final String? oneLineIntroduction;
  final String? placeLabel;

  ProfileSummary copyWith({
    String? id,
    String? name,
    String? residence,
    String? primaryLanguageCode,
    String? primaryLanguageLabel,
    String? primaryCountryCode,
    String? primaryCountryLabel,
    Object? profileImageUrl = _sentinel,
    bool? isActiveWithin30Days,
    Object? oneLineIntroduction = _sentinel,
    Object? placeLabel = _sentinel,
  }) {
    return ProfileSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      residence: residence ?? this.residence,
      primaryLanguageCode: primaryLanguageCode ?? this.primaryLanguageCode,
      primaryLanguageLabel: primaryLanguageLabel ?? this.primaryLanguageLabel,
      primaryCountryCode: primaryCountryCode ?? this.primaryCountryCode,
      primaryCountryLabel: primaryCountryLabel ?? this.primaryCountryLabel,
      profileImageUrl: profileImageUrl == _sentinel
          ? this.profileImageUrl
          : profileImageUrl as String?,
      isActiveWithin30Days: isActiveWithin30Days ?? this.isActiveWithin30Days,
      oneLineIntroduction: oneLineIntroduction == _sentinel
          ? this.oneLineIntroduction
          : oneLineIntroduction as String?,
      placeLabel: placeLabel == _sentinel
          ? this.placeLabel
          : placeLabel as String?,
    );
  }
}

class ProfileMetric {
  const ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;
}

class ActivityBadge {
  const ActivityBadge({
    required this.id,
    required this.label,
    required this.categoryLabel,
  });

  final String id;
  final String label;
  final String categoryLabel;
}

class ActivityHistoryEntry {
  const ActivityHistoryEntry({
    required this.id,
    required this.categoryLabel,
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    required this.priceLabel,
    required this.participantLabel,
    required this.imageUrl,
    this.rating,
    this.isHostedByMe = false,
  });

  final String id;
  final String categoryLabel;
  final String title;
  final String dateLabel;
  final String timeLabel;
  final String priceLabel;
  final String participantLabel;
  final String imageUrl;
  final double? rating;
  final bool isHostedByMe;
}

class PersonalMyPageData {
  const PersonalMyPageData({
    required this.profile,
    required this.metrics,
    required this.badges,
    required this.recentActivities,
  });

  final ProfileSummary profile;
  final List<ProfileMetric> metrics;
  final List<ActivityBadge> badges;
  final List<ActivityHistoryEntry> recentActivities;

  PersonalMyPageData copyWith({
    ProfileSummary? profile,
    List<ProfileMetric>? metrics,
    List<ActivityBadge>? badges,
    List<ActivityHistoryEntry>? recentActivities,
  }) {
    return PersonalMyPageData(
      profile: profile ?? this.profile,
      metrics: metrics ?? this.metrics,
      badges: badges ?? this.badges,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}

class OtherProfileData {
  const OtherProfileData({
    required this.profile,
    required this.metrics,
    required this.badges,
    required this.recentActivities,
    required this.isFriend,
  });

  final ProfileSummary profile;
  final List<ProfileMetric> metrics;
  final List<ActivityBadge> badges;
  final List<ActivityHistoryEntry> recentActivities;
  final bool isFriend;

  OtherProfileData copyWith({
    ProfileSummary? profile,
    List<ProfileMetric>? metrics,
    List<ActivityBadge>? badges,
    List<ActivityHistoryEntry>? recentActivities,
    bool? isFriend,
  }) {
    return OtherProfileData(
      profile: profile ?? this.profile,
      metrics: metrics ?? this.metrics,
      badges: badges ?? this.badges,
      recentActivities: recentActivities ?? this.recentActivities,
      isFriend: isFriend ?? this.isFriend,
    );
  }
}

class RecentActivityStats {
  const RecentActivityStats({
    required this.totalCount,
    required this.hostedCount,
    required this.joinedCount,
    required this.reviewCount,
  });

  final int totalCount;
  final int hostedCount;
  final int joinedCount;
  final int reviewCount;
}

class RecentActivityData {
  const RecentActivityData({required this.stats, required this.activities});

  final RecentActivityStats stats;
  final List<ActivityHistoryEntry> activities;
}

class BusinessMyPageData {
  const BusinessMyPageData({
    required this.profile,
    required this.metrics,
    required this.activeExperiences,
  });

  final ProfileSummary profile;
  final List<ProfileMetric> metrics;
  final List<ActivityHistoryEntry> activeExperiences;

  BusinessMyPageData copyWith({
    ProfileSummary? profile,
    List<ProfileMetric>? metrics,
    List<ActivityHistoryEntry>? activeExperiences,
  }) {
    return BusinessMyPageData(
      profile: profile ?? this.profile,
      metrics: metrics ?? this.metrics,
      activeExperiences: activeExperiences ?? this.activeExperiences,
    );
  }
}

class SelectionOption {
  const SelectionOption({required this.code, required this.label});

  final String code;
  final String label;
}

class MyPageBundle {
  const MyPageBundle({
    required this.personalPage,
    required this.otherProfile,
    required this.recentActivity,
    required this.businessPage,
    required this.languageOptions,
    required this.countryOptions,
  });

  final PersonalMyPageData personalPage;
  final OtherProfileData otherProfile;
  final RecentActivityData recentActivity;
  final BusinessMyPageData businessPage;
  final List<SelectionOption> languageOptions;
  final List<SelectionOption> countryOptions;
}

class MyPageRepositoryException implements Exception {
  const MyPageRepositoryException(this.type);

  final MyPageLoadFailureType type;
}

const List<SelectionOption> kMyPageLanguageOptions = <SelectionOption>[
  SelectionOption(code: 'ko', label: '한국어'),
  SelectionOption(code: 'en', label: '영어'),
  SelectionOption(code: 'ja', label: '일본어'),
  SelectionOption(code: 'zh', label: '중국어'),
  SelectionOption(code: 'vi', label: '베트남어'),
  SelectionOption(code: 'es', label: '스페인어'),
];

const List<SelectionOption> kMyPageCountryOptions = <SelectionOption>[
  SelectionOption(code: 'kr', label: '대한민국'),
  SelectionOption(code: 'jp', label: '일본'),
  SelectionOption(code: 'cn', label: '중국'),
  SelectionOption(code: 'vn', label: '베트남'),
  SelectionOption(code: 'us', label: '미국'),
  SelectionOption(code: 'th', label: '태국'),
];

const Object _sentinel = Object();
