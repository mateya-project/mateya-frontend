part of 'activity_detail_repository.dart';

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
            userId: 'host-default',
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

  @override
  Future<bool> toggleFavorite({
    required String activityId,
    required bool isFavorite,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return !isFavorite;
  }

  @override
  Future<HelpfulToggleState> toggleHelpful({required String reviewId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return const HelpfulToggleState(helpful: true, helpfulCount: 1);
  }

  @override
  Future<ActivityReview> submitReview({
    required String activityId,
    required int rating,
    required String body,
    List<String> imageUrls = const <String>[],
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return ActivityReview(
      id: 'review-${DateTime.now().microsecondsSinceEpoch}',
      authorName: '나',
      submittedAt: DateTime.now(),
      rating: rating,
      originalText: body.trim(),
      imageUrls: imageUrls,
    );
  }
}
