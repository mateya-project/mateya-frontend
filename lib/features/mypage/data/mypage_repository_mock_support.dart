part of 'mypage_repository.dart';

PersonalMyPageData get _personalPage => PersonalMyPageData(
  profile: ProfileSummary(
    id: 'guest-me',
    name: '유나',
    englishName: 'Yuna',
    residence: '서울 성동구 성수동',
    primaryLanguageCode: 'ko',
    primaryLanguageLabel: _languageLabel('ko'),
    primaryCountryCode: 'kr',
    primaryCountryLabel: _countryLabel('kr'),
    activityCountryCode: 'kr',
    activityCountryLabel: _activityCountryLabel('kr'),
    isActiveWithin30Days: true,
  ),
  metrics: _buildPersonalMetrics(const <String, dynamic>{
    'totalActivityCount': 18,
    'friendCount': 24,
    'reviewCount': 11,
  }),
  badges: <ActivityBadge>[
    ActivityBadge(
      id: 'traditional',
      label: 'traditional!',
      categoryLabel: _categoryLabel('CULTURE_TRADITION'),
      badgeCode: 'TRADITIONAL',
    ),
    ActivityBadge(
      id: 'walk',
      label: 'tourist',
      categoryLabel: _categoryLabel('TOURIST_ATTRACTION'),
      badgeCode: 'TOURIST',
    ),
  ],
  recentActivities: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'recent-1',
      categoryLabel: _categoryLabel('CULTURE_TRADITION'),
      title: '북촌 한옥 산책',
      dateLabel: '2026.06.12',
      timeLabel: '19:30 - 21:30',
      priceLabel: _formatCurrency(10000),
      participantLabel: _participantLabel(14, 20),
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1200&q=80',
      rating: 4.9,
    ),
    ActivityHistoryEntry(
      id: 'recent-2',
      categoryLabel: _categoryLabel('SHOPPING'),
      title: '광장시장 야식 투어',
      dateLabel: '2026.06.08',
      timeLabel: '20:00 - 23:00',
      priceLabel: _formatCurrency(32000),
      participantLabel: _participantLabel(6, 10),
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
    ),
    ActivityHistoryEntry(
      id: 'recent-3',
      categoryLabel: _categoryLabel('TOURIST_ATTRACTION'),
      title: '한강 밤 산책',
      dateLabel: '2026.06.01',
      timeLabel: '20:30 - 22:30',
      priceLabel: MateyaLocalizations.current.commonFree,
      participantLabel: _participantLabel(18, 25),
      imageUrl:
          'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
    ),
  ],
);

OtherProfileData get _otherProfile => OtherProfileData(
  profile: ProfileSummary(
    id: 'other-jisoo',
    name: '지수',
    englishName: 'Jisoo',
    residence: '서울 마포구 연남동',
    primaryLanguageCode: 'en',
    primaryLanguageLabel: _languageLabel('en'),
    primaryCountryCode: 'us',
    primaryCountryLabel: _countryLabel('us'),
    activityCountryCode: 'kr',
    activityCountryLabel: _activityCountryLabel('kr'),
    profileImageUrl:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=900&q=80',
    isActiveWithin30Days: true,
  ),
  metrics: _buildPersonalMetrics(const <String, dynamic>{
    'totalActivityCount': 26,
    'friendCount': 31,
    'reviewCount': 17,
  }),
  badges: <ActivityBadge>[
    ActivityBadge(
      id: 'festival',
      label: 'festive!',
      categoryLabel: _categoryLabel('EVENT_PERFORMANCE_FESTIVAL'),
      badgeCode: 'FESTIVE',
    ),
    ActivityBadge(
      id: 'sports',
      label: 'active person',
      categoryLabel: _categoryLabel('ACTIVITY_LEPORTS'),
      badgeCode: 'ACTIVE_PERSON',
    ),
  ],
  recentActivities: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'other-recent-1',
      categoryLabel: _categoryLabel('ACTIVITY_LEPORTS'),
      title: '초보자 풋살 매칭',
      dateLabel: '2026.06.11',
      timeLabel: '18:30 - 20:30',
      priceLabel: _formatCurrency(18000),
      participantLabel: _participantLabel(9, 14),
      imageUrl:
          'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
      rating: 4.6,
    ),
    ActivityHistoryEntry(
      id: 'other-recent-2',
      categoryLabel: _categoryLabel('CULTURE_TRADITION'),
      title: '이천 도자기 핸드빌딩 체험',
      dateLabel: '2026.06.05',
      timeLabel: '13:00 - 16:00',
      priceLabel: _formatCurrency(55000),
      participantLabel: _participantLabel(7, 12),
      imageUrl:
          'https://images.unsplash.com/photo-1517048676732-d65bc937f952?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
    ),
    ActivityHistoryEntry(
      id: 'other-recent-3',
      categoryLabel: _categoryLabel('EVENT_PERFORMANCE_FESTIVAL'),
      title: '수원 야행 같이 가요',
      dateLabel: '2026.05.29',
      timeLabel: '18:00 - 22:00',
      priceLabel: _formatCurrency(15000),
      participantLabel: _participantLabel(21, 30),
      imageUrl:
          'https://images.unsplash.com/photo-1470004914212-05527e49370b?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
    ),
  ],
  isFriend: false,
);

List<ConsentHistoryEntry> get _consentHistory {
  final l10n = MateyaLocalizations.current;
  return <ConsentHistoryEntry>[
    ConsentHistoryEntry(
      id: 'service-terms',
      title: l10n.mypageConsentTypeServiceTerms,
      agreed: true,
      agreedAtLabel: '2026.06.18',
      versionLabel: 'v1',
    ),
    ConsentHistoryEntry(
      id: 'privacy-third-party',
      title: l10n.mypageConsentTypePrivacyCollection,
      agreed: true,
      agreedAtLabel: '2026.06.18',
      versionLabel: 'v1',
    ),
    ConsentHistoryEntry(
      id: 'location-based-service',
      title: l10n.mypageConsentTypeLocationService,
      agreed: true,
      agreedAtLabel: '2026.06.18',
      versionLabel: 'v1',
    ),
    ConsentHistoryEntry(
      id: 'age-over-14',
      title: l10n.mypageConsentTypeAgeOver14,
      agreed: true,
      agreedAtLabel: '2026.06.18',
      versionLabel: 'v1',
    ),
  ];
}

List<BlockedUserSummary> get _blockedUsers => <BlockedUserSummary>[
  const BlockedUserSummary(
    id: 'blocked-1',
    name: 'Lee MinJi 이민지',
    residence: 'Living in Seoul · Shindang dong',
    profileImageUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=240&q=80',
  ),
  const BlockedUserSummary(
    id: 'blocked-2',
    name: 'Park Jun 박준',
    residence: 'Living in Seoul · Yeouido dong',
    profileImageUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=240&q=80',
  ),
  const BlockedUserSummary(
    id: 'blocked-3',
    name: 'Chloe 윤채',
    residence: 'Living in Seoul · Hapjeong dong',
    profileImageUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=240&q=80',
  ),
];

RecentActivityData get _recentActivity => RecentActivityData(
  stats: const RecentActivityStats(
    totalCount: 18,
    hostedCount: 5,
    joinedCount: 13,
    reviewCount: 11,
  ),
  activities: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'list-1',
      categoryLabel: _categoryLabel('CULTURE_TRADITION'),
      title: '북촌 한옥 산책',
      dateLabel: '2026.06.12',
      timeLabel: '19:30 - 21:30',
      priceLabel: _formatCurrency(10000),
      participantLabel: _participantLabel(14, 20),
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1200&q=80',
      rating: 4.9,
    ),
    ActivityHistoryEntry(
      id: 'list-2',
      categoryLabel: _categoryLabel('CULTURE_TRADITION'),
      title: '북촌 한옥 티 클래스',
      dateLabel: '2026.06.10',
      timeLabel: '14:00 - 16:00',
      priceLabel: _formatCurrency(45000),
      participantLabel: _participantLabel(11, 16),
      imageUrl:
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
      isHostedByMe: true,
    ),
    ActivityHistoryEntry(
      id: 'list-3',
      categoryLabel: _categoryLabel('SHOPPING'),
      title: '광장시장 야식 투어',
      dateLabel: '2026.06.08',
      timeLabel: '20:00 - 23:00',
      priceLabel: _formatCurrency(32000),
      participantLabel: _participantLabel(6, 10),
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
    ),
    ActivityHistoryEntry(
      id: 'list-4',
      categoryLabel: _categoryLabel('TOURIST_ATTRACTION'),
      title: '한강 밤 산책',
      dateLabel: '2026.06.01',
      timeLabel: '20:30 - 22:30',
      priceLabel: MateyaLocalizations.current.commonFree,
      participantLabel: _participantLabel(18, 25),
      imageUrl:
          'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
    ),
    ActivityHistoryEntry(
      id: 'list-5',
      categoryLabel: _categoryLabel('TOURIST_ATTRACTION'),
      title: '망원시장 먹거리 산책',
      dateLabel: '2026.05.26',
      timeLabel: '11:00 - 14:00',
      priceLabel: _formatCurrency(22000),
      participantLabel: _participantLabel(8, 12),
      imageUrl:
          'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
      isHostedByMe: true,
    ),
  ],
);

BusinessMyPageData get _businessPage => BusinessMyPageData(
  profile: ProfileSummary(
    id: 'host-studio',
    name: '성수 티 스튜디오',
    activityCountryCode: 'kr',
    activityCountryLabel: _activityCountryLabel('kr'),
    residence: '서울 성동구 성수일로 32',
    primaryLanguageCode: 'ko',
    primaryLanguageLabel: _languageLabel('ko'),
    primaryCountryCode: 'kr',
    primaryCountryLabel: _countryLabel('kr'),
    profileImageUrl:
        'https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=900&q=80',
    oneLineIntroduction: '외국인과 로컬이 함께 어울리는 전통 티 클래스와 산책형 체험을 운영하고 있어요.',
    placeLabel: '성수 티하우스',
  ),
  metrics: _buildBusinessMetrics(const <String, dynamic>{
    'recruitingExperienceCount': 6,
    'totalParticipantCount': 182,
    'averageRating': 4.8,
    'reviewCount': 64,
  }),
  activeExperiences: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'host-1',
      categoryLabel: _categoryLabel('CULTURE_TRADITION'),
      title: '북촌 한옥 티 클래스',
      dateLabel: '매주 수/토',
      timeLabel: '14:00 - 16:00',
      priceLabel: _formatCurrency(45000),
      participantLabel: _participantLabel(11, 16),
      imageUrl:
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
      isHostedByMe: true,
    ),
    ActivityHistoryEntry(
      id: 'host-2',
      categoryLabel: _categoryLabel('SHOPPING'),
      title: '김치 만들기 원데이 클래스',
      dateLabel: '매주 금요일',
      timeLabel: '18:30 - 20:30',
      priceLabel: _formatCurrency(39000),
      participantLabel: _participantLabel(8, 12),
      imageUrl:
          'https://images.unsplash.com/photo-1516684732162-798a0062be99?auto=format&fit=crop&w=1200&q=80',
      rating: 4.9,
      isHostedByMe: true,
    ),
    ActivityHistoryEntry(
      id: 'host-3',
      categoryLabel: _categoryLabel('TOURIST_ATTRACTION'),
      title: '성수 골목 로컬 워킹 투어',
      dateLabel: '매주 일요일',
      timeLabel: '10:00 - 12:30',
      priceLabel: _formatCurrency(25000),
      participantLabel: _participantLabel(10, 14),
      imageUrl:
          'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
      isHostedByMe: true,
    ),
  ],
);
