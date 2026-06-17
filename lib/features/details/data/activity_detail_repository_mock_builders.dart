part of 'activity_detail_repository.dart';

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

String _locationLabelFor(ActivityItem activity) =>
    _locationLabelById[activity.id] ?? '서울 성동구, ${activity.place}';

ActivityHostProfile _hostFor(ActivityItem activity) =>
    _hostById[activity.id] ??
    const ActivityHostProfile(
      userId: 'host-default',
      name: 'Lee MinJi',
      localizedName: '이민지',
      locationLabel: 'Living in Seoul · Shindang dong',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
    );

String _descriptionFor(ActivityItem activity) =>
    _descriptionById[activity.id] ?? _defaultDescription(activity);

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
    return custom.map(_cloneReview).toList(growable: false);
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

ActivityReview _cloneReview(ActivityReview review) =>
    review.copyWith(imageUrls: List<String>.from(review.imageUrls));

String _defaultDescription(ActivityItem activity) {
  return '${activity.place}에서 함께 모여 ${activity.title}을(를) 즐기는 활동입니다. '
      '처음 참여하는 분도 흐름에 자연스럽게 적응할 수 있도록 호스트가 진행을 리드하고, '
      '참여자 간 대화와 경험 공유가 끊기지 않게 구성했습니다. '
      '가볍게 새로운 사람을 만나고 싶거나, 혼자 가기 망설여졌던 분들에게 잘 맞는 일정입니다.';
}
