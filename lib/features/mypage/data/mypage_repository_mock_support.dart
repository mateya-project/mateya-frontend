part of 'mypage_repository.dart';

const PersonalMyPageData _personalPage = PersonalMyPageData(
  profile: ProfileSummary(
    id: 'guest-me',
    name: '유나',
    englishName: 'Yuna',
    residence: '서울 성동구 성수동',
    primaryLanguageCode: 'ko',
    primaryLanguageLabel: '한국어',
    primaryCountryCode: 'kr',
    primaryCountryLabel: '대한민국',
    activityCountryCode: 'kr',
    activityCountryLabel: 'Korea',
    isActiveWithin30Days: true,
  ),
  metrics: <ProfileMetric>[
    ProfileMetric(label: '활동 수', value: '18'),
    ProfileMetric(label: '친구 수', value: '24'),
    ProfileMetric(label: '작성 리뷰', value: '11'),
  ],
  badges: <ActivityBadge>[
    ActivityBadge(
      id: 'traditional',
      label: 'traditional!',
      categoryLabel: '문화/전통',
      badgeCode: 'TRADITIONAL',
    ),
    ActivityBadge(
      id: 'walk',
      label: 'tourist',
      categoryLabel: '관광지',
      badgeCode: 'TOURIST',
    ),
  ],
  recentActivities: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'recent-1',
      categoryLabel: '문화/전통',
      title: '북촌 한옥 산책',
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
      categoryLabel: '쇼핑',
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
      categoryLabel: '관광지',
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
    englishName: 'Jisoo',
    residence: '서울 마포구 연남동',
    primaryLanguageCode: 'en',
    primaryLanguageLabel: '영어',
    primaryCountryCode: 'us',
    primaryCountryLabel: '미국',
    activityCountryCode: 'kr',
    activityCountryLabel: 'Korea',
    profileImageUrl:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=900&q=80',
    isActiveWithin30Days: true,
  ),
  metrics: <ProfileMetric>[
    ProfileMetric(label: '활동 수', value: '26'),
    ProfileMetric(label: '친구 수', value: '31'),
    ProfileMetric(label: '작성 리뷰', value: '17'),
  ],
  badges: <ActivityBadge>[
    ActivityBadge(
      id: 'festival',
      label: 'festive!',
      categoryLabel: '행사/공연/축제',
      badgeCode: 'FESTIVE',
    ),
    ActivityBadge(
      id: 'sports',
      label: 'active person',
      categoryLabel: '액티비티/레포츠',
      badgeCode: 'ACTIVE_PERSON',
    ),
  ],
  recentActivities: <ActivityHistoryEntry>[
    ActivityHistoryEntry(
      id: 'other-recent-1',
      categoryLabel: '액티비티/레포츠',
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
      categoryLabel: '문화/전통',
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
      categoryLabel: '행사/공연/축제',
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

const List<ConsentHistoryEntry> _consentHistory = <ConsentHistoryEntry>[
  ConsentHistoryEntry(
    id: 'service-terms',
    title: '서비스 이용 약관',
    agreed: true,
    agreedAtLabel: '2026.06.18',
    versionLabel: 'v1',
  ),
  ConsentHistoryEntry(
    id: 'privacy-third-party',
    title: '개인정보 수집·이용 동의',
    agreed: true,
    agreedAtLabel: '2026.06.18',
    versionLabel: 'v1',
  ),
  ConsentHistoryEntry(
    id: 'location-based-service',
    title: '위치기반 서비스 이용 동의',
    agreed: true,
    agreedAtLabel: '2026.06.18',
    versionLabel: 'v1',
  ),
  ConsentHistoryEntry(
    id: 'age-over-14',
    title: '만 14세 이상 확인',
    agreed: true,
    agreedAtLabel: '2026.06.18',
    versionLabel: 'v1',
  ),
];

const List<BlockedUserSummary> _blockedUsers = <BlockedUserSummary>[
  BlockedUserSummary(
    id: 'blocked-1',
    name: 'Lee MinJi 이민지',
    residence: 'Living in Seoul · Shindang dong',
    profileImageUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=240&q=80',
  ),
  BlockedUserSummary(
    id: 'blocked-2',
    name: 'Park Jun 박준',
    residence: 'Living in Seoul · Yeouido dong',
    profileImageUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=240&q=80',
  ),
  BlockedUserSummary(
    id: 'blocked-3',
    name: 'Chloe 윤채',
    residence: 'Living in Seoul · Hapjeong dong',
    profileImageUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=240&q=80',
  ),
];

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
      categoryLabel: '문화/전통',
      title: '북촌 한옥 산책',
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
      categoryLabel: '문화/전통',
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
      categoryLabel: '쇼핑',
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
      categoryLabel: '관광지',
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
      categoryLabel: '관광지',
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
    activityCountryCode: 'kr',
    activityCountryLabel: 'Korea',
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
      categoryLabel: '문화/전통',
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
      categoryLabel: '쇼핑',
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
      categoryLabel: '관광지',
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
