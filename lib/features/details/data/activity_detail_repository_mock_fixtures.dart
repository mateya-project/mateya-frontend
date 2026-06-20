part of 'activity_detail_repository.dart';

const List<ActivityParticipant> _participantPool = <ActivityParticipant>[
  ActivityParticipant(
    id: 'p1',
    name: 'Min',
    residenceLabel: 'Living in Seoul · Shindang dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p2',
    name: 'Jisu',
    residenceLabel: 'Living in Seoul · Yongsan dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p3',
    name: 'Daniel',
    residenceLabel: 'Living in Seoul · Seongsu dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1504593811423-6dd665756598?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p4',
    name: 'Ari',
    residenceLabel: 'Living in Seoul · Hannam dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p5',
    name: 'Yuna',
    residenceLabel: 'Living in Seoul · Mangwon dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1521119989659-a83eee488004?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p6',
    name: 'Jun',
    residenceLabel: 'Living in Seoul · Yeouido dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p7',
    name: 'Mia',
    residenceLabel: 'Living in Seoul · Hapjeong dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p8',
    name: 'Leo',
    residenceLabel: 'Living in Seoul · Itaewon dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p9',
    name: 'Hana',
    residenceLabel: 'Living in Seoul · Jamsil dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p10',
    name: 'Chris',
    residenceLabel: 'Living in Seoul · Sindang dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=240&q=80',
  ),
];

final Map<String, List<String>> _galleryExtrasById = <String, List<String>>{
  'featured-hike': <String>[
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1464823063530-08f10ed1a2dd?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1465311440653-ba9b1d9b0f5b?auto=format&fit=crop&w=1200&q=80',
  ],
  'river-bus': <String>[
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1473116763249-2faaef81ccda?auto=format&fit=crop&w=1200&q=80',
  ],
  'night-walk': <String>[
    'https://images.unsplash.com/photo-1519501025264-65ba15a82390?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?auto=format&fit=crop&w=1200&q=80',
  ],
};

final Map<String, String> _locationLabelById = <String, String>{
  'featured-hike': '서울 서대문구, 안산 자락길 입구',
  'river-bus': '서울 영등포구, 여의도 한강공원',
  'night-walk': '서울 용산구, 잠수교 산책로',
};

final Map<String, String> _descriptionById = <String, String>{
  'featured-hike':
      '서울 한복판에서 잠시 벗어나 가볍게 몸을 풀고, 산행 후 막걸리 한 잔으로 하루를 마무리하는 코스입니다. '
      '초보자도 무리 없이 따라올 수 있는 난이도로 진행하고, 중간중간 쉬는 시간을 충분히 확보합니다. '
      '정상 도착보다 함께 걷는 경험과 대화를 더 중요하게 생각하는 모임이라 처음 만나는 사람과도 부담 없이 어울릴 수 있습니다.',
  'river-bus':
      '여의도에서 한강 바람을 느끼며 수상 버스를 체험한 뒤, 근처 산책로와 노을 포인트까지 함께 둘러보는 일정입니다. '
      '전통적인 서울 여행 코스보다 조금 더 여유로운 로컬 감도를 원하는 분들에게 잘 맞습니다.',
};

final Map<String, ActivityHostProfile>
_hostById = <String, ActivityHostProfile>{
  'featured-hike': const ActivityHostProfile(
    userId: 'host-featured-hike',
    name: '이민지',
    localizedName: 'Lee MinJi',
    locationLabel: 'Living in Seoul · Shindang dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=300&q=80',
  ),
  'river-bus': const ActivityHostProfile(
    userId: 'host-river-bus',
    name: '박준',
    localizedName: 'Park Jun',
    locationLabel: 'Living in Seoul · Yeouido dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80',
  ),
};

final Map<String, List<ActivityReview>>
_reviewSeedsById = <String, List<ActivityReview>>{
  'featured-hike': <ActivityReview>[
    ActivityReview(
      id: 'featured-hike-review-1',
      authorName: 'Jade',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=240&q=80',
      submittedAt: DateTime(2026, 5, 23),
      rating: 5,
      originalText:
          '걷는 속도를 계속 맞춰줘서 처음 만난 사람들과도 편하게 이야기할 수 있었어요. 정상보다 과정이 즐거운 모임이었습니다.',
      translatedText:
          'The host kept everyone at the same pace, so it was easy to relax and talk even as a first-timer.',
      isTranslationVisible: true,
      helpfulCount: 18,
      imageUrls: <String>[
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=900&q=80',
      ],
    ),
    ActivityReview(
      id: 'featured-hike-review-2',
      authorName: '서연',
      submittedAt: DateTime(2026, 5, 17),
      rating: 5,
      originalText: '마무리 막걸리 장소까지 동선이 좋았고, 사진 스팟도 자연스럽게 챙겨줘서 만족했습니다.',
      helpfulCount: 11,
    ),
    ActivityReview(
      id: 'featured-hike-review-3',
      authorName: 'Oliver',
      submittedAt: DateTime(2026, 5, 9),
      rating: 4,
      originalText:
          'Great route and friendly pacing. Bring water because the final incline is still a workout.',
      translatedText: '코스와 진행 분위기는 좋았어요. 마지막 오르막은 은근히 힘드니 물은 꼭 챙기면 좋겠습니다.',
      isTranslationVisible: true,
      helpfulCount: 7,
    ),
    ActivityReview(
      id: 'featured-hike-review-4',
      authorName: '유진',
      submittedAt: DateTime(2026, 4, 29),
      rating: 5,
      originalText: '외국인 참여자와 한국인 참여자가 자연스럽게 섞여서 대화할 수 있었던 점이 특히 좋았습니다.',
      helpfulCount: 5,
    ),
    ActivityReview(
      id: 'featured-hike-review-5',
      authorName: 'Mika',
      submittedAt: DateTime(2026, 4, 12),
      rating: 5,
      originalText:
          'I joined alone and still felt included right away. The meetup was calm, social, and well organized.',
      translatedText: '혼자 참여했는데도 바로 어울릴 수 있었어요. 차분하고 사교적인 분위기로 잘 운영된 모임이었습니다.',
      isTranslationVisible: true,
      helpfulCount: 9,
    ),
    ActivityReview(
      id: 'featured-hike-review-6',
      authorName: '정우',
      submittedAt: DateTime(2026, 3, 28),
      rating: 4,
      originalText: '초보자 기준 안내가 충분했고 쉬는 타이밍도 적절했습니다.',
      helpfulCount: 4,
    ),
    ActivityReview(
      id: 'featured-hike-review-7',
      authorName: 'Hina',
      submittedAt: DateTime(2026, 3, 7),
      rating: 5,
      originalText:
          'The photos at the top were worth it, and the group energy stayed positive the whole time.',
      translatedText: '정상에서 찍은 사진도 좋았고, 모임 전체 분위기가 끝까지 밝게 유지돼서 좋았습니다.',
      isTranslationVisible: true,
      helpfulCount: 2,
    ),
  ],
};
