import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../../home/domain/home_models.dart';
import '../domain/activity_detail_models.dart';

abstract interface class ActivityDetailRepository {
  Future<ActivityDetail> fetchDetail(ActivityItem activity);
}

class ApiActivityDetailRepository implements ActivityDetailRepository {
  ApiActivityDetailRepository({
    MateyaApiClient? apiClient,
    AuthSessionStore? sessionStore,
  }) : _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           );

  final MateyaApiClient _apiClient;

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

  ActivityParticipant _parseParticipant(Object? value) {
    final json = _asMap(value);
    return ActivityParticipant(
      id: '${json['userId']}',
      name: json['displayName'] as String? ?? '',
      avatarUrl: json['profileImageUrl'] as String?,
    );
  }

  ActivityReview _parseReview(Object? value) {
    final json = _asMap(value);
    final originalBody = json['originalBody'] as String?;
    final translatedBody = json['body'] as String?;
    final visibleTranslation =
        translatedBody != null &&
            originalBody != null &&
            translatedBody != originalBody
        ? translatedBody
        : null;

    return ActivityReview(
      id: '${json['id']}',
      authorName: json['authorDisplayName'] as String? ?? '',
      authorAvatarUrl: json['authorProfileImageUrl'] as String?,
      submittedAt: DateTime.parse(json['createdAt'] as String),
      rating: json['rating'] as int? ?? 0,
      originalText: originalBody ?? translatedBody ?? '',
      translatedText: visibleTranslation,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      imageUrls: ((json['imageUrls'] as List<Object?>?) ?? const <Object?>[])
          .whereType<String>()
          .toList(growable: false),
    );
  }

  ReviewSummary _parseReviewSummary(Map<String, dynamic> json) {
    final distribution =
        json['ratingDistribution'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    final ratingCounts = <int, int>{
      for (var rating = 1; rating <= 5; rating += 1)
        rating: distribution['$rating'] as int? ?? 0,
    };
    return ReviewSummary(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      totalCount: json['totalCount'] as int? ?? 0,
      ratingCounts: ratingCounts,
    );
  }

  String _hostLocationLabel({
    required String? countryCode,
    required String? languageCode,
  }) {
    final normalizedCountry = (countryCode ?? '').toUpperCase();
    final normalizedLanguage = (languageCode ?? '').toLowerCase();
    final countryLabel = switch (normalizedCountry) {
      'KR' => 'Korea',
      'US' => 'United States',
      'JP' => 'Japan',
      'CN' => 'China',
      'VN' => 'Vietnam',
      _ => normalizedCountry.isEmpty ? 'Mateya' : normalizedCountry,
    };
    final languageLabel = switch (normalizedLanguage) {
      'ko' => 'Korean',
      'en' => 'English',
      'ja' => 'Japanese',
      'zh' => 'Chinese',
      _ => normalizedLanguage.isEmpty ? 'Host' : normalizedLanguage,
    };
    return 'Language $languageLabel · $countryLabel';
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw const ActivityDetailRepositoryException(
      ActivityDetailLoadFailureType.server,
    );
  }
}

class MockActivityDetailRepository implements ActivityDetailRepository {
  @override
  Future<ActivityDetail> fetchDetail(ActivityItem activity) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return ActivityDetail(
      activity: activity,
      imageUrls: _galleryFor(activity),
      locationLabel:
          _locationLabelById[activity.id] ?? '서울 성동구, ${activity.place}',
      host:
          _hostById[activity.id] ??
          const ActivityHostProfile(
            name: 'Lee MinJi',
            localizedName: '이민지',
            locationLabel: 'Living in Seoul · Shindang dong',
            avatarUrl:
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
          ),
      description:
          _descriptionById[activity.id] ?? _defaultDescription(activity),
      shareUrl: 'https://mateya.app/activities/${activity.id}',
      participants: _participantsFor(activity),
      reviews: _reviewsFor(activity),
      isFavorite: activity.isFeatured,
      isJoined: activity.participantCount >= activity.participantCapacity,
    );
  }
}

List<String> _galleryFor(ActivityItem activity) {
  final primary = activity.imageUrl;
  final extras = _galleryExtrasById[activity.id] ?? const <String>[];
  final coverImages = primary == null ? null : <String>[primary];
  final gallery = <String>[
    ...?coverImages,
    ...extras,
  ].take(5).toList(growable: false);
  return gallery.isEmpty ? const <String>[''] : gallery;
}

List<ActivityParticipant> _participantsFor(ActivityItem activity) {
  final base = _participantPool
      .take(activity.participantCount)
      .toList(growable: false);
  if (base.isEmpty) {
    return const <ActivityParticipant>[];
  }
  return List<ActivityParticipant>.generate(
    base.length,
    (index) => base[index],
    growable: false,
  );
}

List<ActivityReview> _reviewsFor(ActivityItem activity) {
  final custom = _reviewSeedsById[activity.id];
  if (custom != null) {
    return custom;
  }
  return <ActivityReview>[
    ActivityReview(
      id: '${activity.id}-review-1',
      authorName: 'Emma',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=240&q=80',
      submittedAt: activity.startAt.subtract(const Duration(days: 18)),
      rating: 5,
      originalText:
          '${activity.title}에서 정말 편하게 어울릴 수 있었어요. 처음 참여했는데도 진행이 자연스럽고 호스트가 분위기를 잘 만들어줬습니다.',
      translatedText:
          'It was easy to connect with everyone during ${activity.title}. The host kept the pace friendly for first-timers.',
      helpfulCount: 14,
    ),
    ActivityReview(
      id: '${activity.id}-review-2',
      authorName: '민수',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
      submittedAt: activity.startAt.subtract(const Duration(days: 27)),
      rating: 4,
      originalText: '장소 안내가 정확했고 시간 관리도 깔끔했습니다. 다음에는 친구랑 같이 또 참여하고 싶어요.',
      helpfulCount: 6,
    ),
    ActivityReview(
      id: '${activity.id}-review-3',
      authorName: 'Sora',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=240&q=80',
      submittedAt: activity.startAt.subtract(const Duration(days: 35)),
      rating: 5,
      originalText: '사진보다 현장 분위기가 더 좋았어요. 초보자 기준 설명이 잘 되어 있어서 부담 없이 즐겼습니다.',
      translatedText:
          'The actual atmosphere was better than the photos, and the activity felt approachable for beginners.',
      helpfulCount: 8,
    ),
    ActivityReview(
      id: '${activity.id}-review-4',
      authorName: '지안',
      submittedAt: activity.startAt.subtract(const Duration(days: 44)),
      rating: 4,
      originalText: '참여자 구성이 다양해서 대화가 재미있었습니다. 다만 끝나는 시간이 조금 아쉬웠어요.',
      helpfulCount: 3,
    ),
    ActivityReview(
      id: '${activity.id}-review-5',
      authorName: 'Noah',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=240&q=80',
      submittedAt: activity.startAt.subtract(const Duration(days: 52)),
      rating: 5,
      originalText:
          'The meetup felt well paced and welcoming. I would recommend it to anyone visiting Seoul for the first time.',
      translatedText: '진행 속도가 좋고 분위기가 편안해서, 서울을 처음 방문한 사람에게도 추천하고 싶어요.',
      helpfulCount: 11,
    ),
    ActivityReview(
      id: '${activity.id}-review-6',
      authorName: '하린',
      submittedAt: activity.startAt.subtract(const Duration(days: 61)),
      rating: 3,
      originalText: '전반적으로 만족했지만, 다음에는 준비물 안내가 조금 더 있으면 좋겠습니다.',
      helpfulCount: 1,
    ),
  ];
}

String _defaultDescription(ActivityItem activity) {
  return '${activity.place}에서 함께 모여 ${activity.title}을(를) 즐기는 활동입니다. '
      '처음 참여하는 분도 흐름에 자연스럽게 적응할 수 있도록 호스트가 진행을 리드하고, '
      '참여자 간 대화와 경험 공유가 끊기지 않게 구성했습니다. '
      '가볍게 새로운 사람을 만나고 싶거나, 혼자 가기 망설여졌던 분들에게 잘 맞는 일정입니다.';
}

const List<ActivityParticipant> _participantPool = <ActivityParticipant>[
  ActivityParticipant(
    id: 'p1',
    name: 'Min',
    avatarUrl:
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p2',
    name: 'Jisu',
    avatarUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p3',
    name: 'Daniel',
    avatarUrl:
        'https://images.unsplash.com/photo-1504593811423-6dd665756598?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p4',
    name: 'Ari',
    avatarUrl:
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p5',
    name: 'Yuna',
    avatarUrl:
        'https://images.unsplash.com/photo-1521119989659-a83eee488004?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p6',
    name: 'Jun',
    avatarUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p7',
    name: 'Mia',
    avatarUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p8',
    name: 'Leo',
    avatarUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p9',
    name: 'Hana',
    avatarUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=240&q=80',
  ),
  ActivityParticipant(
    id: 'p10',
    name: 'Chris',
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
    name: 'Lee MinJi',
    localizedName: '이민지',
    locationLabel: 'Living in Seoul · Shindang dong',
    avatarUrl:
        'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=300&q=80',
  ),
  'river-bus': const ActivityHostProfile(
    name: 'Park Jun',
    localizedName: '박준',
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
      helpfulCount: 2,
    ),
  ],
};
