part of 'activity_detail_repository.dart';

class MockActivityDetailRepository implements ActivityDetailRepository {
  @override
  Future<ActivityDetail> fetchDetail(ActivityItem activity) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return ActivityDetail(
      activity: activity,
      imageUrls: _galleryFor(activity),
      locationLabel: _locationLabelFor(activity),
      host: _hostFor(activity),
      description: _descriptionFor(activity),
      shareUrl: 'https://mateya.app/activities/${activity.id}',
      participants: _participantsFor(activity),
      pendingParticipants: _pendingParticipantsFor(activity),
      reviews: _reviewsFor(activity),
      isFavorite: activity.isFeatured,
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
  Future<ActivityDetail> requestJoin({required ActivityDetail detail}) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return detail.copyWith(
      participationState: ActivityParticipationState.requested,
    );
  }

  @override
  Future<ActivityDetail> approvePendingParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final target = detail.pendingParticipants
        .where((participant) => participant.id == participantId)
        .firstOrNull;
    if (target == null) {
      return detail;
    }
    return detail.copyWith(
      activity: detail.activity.copyWith(
        participantCount: detail.activity.participantCount + 1,
      ),
      participants: <ActivityParticipant>[...detail.participants, target],
      pendingParticipants: detail.pendingParticipants
          .where((participant) => participant.id != participantId)
          .toList(growable: false),
    );
  }

  @override
  Future<ActivityDetail> removeApprovedParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return detail.copyWith(
      activity: detail.activity.copyWith(
        participantCount: detail.activity.participantCount > 0
            ? detail.activity.participantCount - 1
            : 0,
      ),
      participants: detail.participants
          .where((participant) => participant.id != participantId)
          .toList(growable: false),
    );
  }

  @override
  Future<ActivityDetail> removePendingParticipant({
    required ActivityDetail detail,
    required String participantId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return detail.copyWith(
      pendingParticipants: detail.pendingParticipants
          .where((participant) => participant.id != participantId)
          .toList(growable: false),
    );
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
