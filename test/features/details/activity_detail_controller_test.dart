import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/application/activity_detail_controller.dart';
import 'package:mateya_app/features/details/data/activity_detail_repository.dart';
import 'package:mateya_app/features/details/domain/activity_detail_models.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';

void main() {
  group('ActivityDetailController', () {
    test('loads detail and exposes summary plus preview reviews', () async {
      final controller = ActivityDetailController(
        repository: _FakeActivityDetailRepository.success(),
        activity: _seedActivity(),
      );

      await controller.initialize();

      expect(controller.phase, AsyncPhase.success);
      expect(controller.detail, isNotNull);
      expect(controller.reviewSummary.totalCount, 9);
      expect(controller.previewReviews, hasLength(5));
      expect(
        controller.visibleReviews,
        hasLength(ActivityDetailController.reviewPageSize),
      );
      expect(controller.canLoadMoreReviews, isTrue);
    });

    test(
      'sort and loadMoreReviews update review list order and size',
      () async {
        final controller = ActivityDetailController(
          repository: _FakeActivityDetailRepository.success(),
          activity: _seedActivity(),
        );

        await controller.initialize();
        controller.updateReviewSort(ReviewSortOption.lowestRating);
        controller.loadMoreReviews();

        expect(controller.reviewSort, ReviewSortOption.lowestRating);
        expect(controller.visibleReviews, hasLength(9));
        expect(controller.visibleReviews.first.rating, 1);
        expect(controller.canLoadMoreReviews, isFalse);
      },
    );

    test(
      'submitReview inserts latest review and toggles helpful state',
      () async {
        final controller = ActivityDetailController(
          repository: _FakeActivityDetailRepository.success(),
          activity: _seedActivity(),
          now: () => DateTime(2026, 6, 14, 9, 30),
        );

        await controller.initialize();

        final didSubmit = controller.submitReview(
          rating: 5,
          body: '다음에도 또 참여하고 싶은 일정이었어요.',
          imageUrls: const <String>['/tmp/review-a.jpg'],
        );

        expect(didSubmit, isTrue);
        expect(controller.reviewSort, ReviewSortOption.latest);
        expect(controller.visibleReviews.first.authorName, '나');
        expect(controller.visibleReviews.first.imageUrls, hasLength(1));

        final targetReviewId = controller.visibleReviews[1].id;
        final before = controller.visibleReviews[1].helpfulCount;
        controller.toggleHelpful(targetReviewId);

        final updated = controller.visibleReviews.firstWhere(
          (review) => review.id == targetReviewId,
        );
        expect(updated.isHelpfulByMe, isTrue);
        expect(updated.helpfulCount, before + 1);
      },
    );

    test('maps repository failure to network error phase', () async {
      final controller = ActivityDetailController(
        repository: _FakeActivityDetailRepository.failure(
          ActivityDetailLoadFailureType.network,
        ),
        activity: _seedActivity(),
      );

      await controller.initialize();

      expect(controller.phase, AsyncPhase.networkError);
      expect(controller.errorMessage, contains('네트워크'));
    });
  });
}

class _FakeActivityDetailRepository implements ActivityDetailRepository {
  _FakeActivityDetailRepository.success() : _failureType = null;

  _FakeActivityDetailRepository.failure(this._failureType);

  final ActivityDetailLoadFailureType? _failureType;

  @override
  Future<ActivityDetail> fetchDetail(ActivityItem activity) async {
    if (_failureType != null) {
      throw ActivityDetailRepositoryException(_failureType);
    }

    return ActivityDetail(
      activity: activity,
      imageUrls: const <String>['https://example.com/hero.jpg'],
      locationLabel: '서울 서초구, 예술의전당',
      host: const ActivityHostProfile(
        name: 'Host',
        localizedName: '호스트',
        locationLabel: 'Living in Seoul · Seocho',
      ),
      description: '상세 설명',
      shareUrl: 'https://mateya.app/activities/test-1',
      participants: const <ActivityParticipant>[
        ActivityParticipant(id: 'p1', name: 'A'),
        ActivityParticipant(id: 'p2', name: 'B'),
      ],
      reviews: <ActivityReview>[
        for (var index = 0; index < 9; index += 1)
          ActivityReview(
            id: 'review-$index',
            authorName: '작성자$index',
            submittedAt: DateTime(2026, 6, 14).subtract(Duration(days: index)),
            rating: index == 8 ? 1 : 5 - (index % 5),
            originalText: '후기 본문 $index',
            helpfulCount: index,
          ),
      ],
    );
  }
}

ActivityItem _seedActivity() {
  return ActivityItem(
    id: 'test-1',
    categoryId: 'sports',
    categoryLabel: '스포츠/액티비티',
    title: '테스트 활동',
    place: '서울',
    startAt: DateTime(2026, 6, 20, 20),
    endAt: DateTime(2026, 6, 20, 22),
    price: 15000,
    rating: 4.8,
    participantCount: 4,
    participantCapacity: 10,
    distanceKm: 1,
    audiences: const <ActivityAudienceOption>{ActivityAudienceOption.everyone},
    languages: const <String>{'ko'},
    statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
  );
}
