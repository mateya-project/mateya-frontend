import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../home/domain/home_models.dart';
import '../../onboarding/domain/onboarding_flow.dart';
import '../data/activity_detail_repository.dart';
import '../domain/activity_detail_models.dart';

class ActivityDetailController extends ChangeNotifier {
  ActivityDetailController({
    required this.repository,
    required this.activity,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  static const int reviewPageSize = 8;
  static const int reviewPreviewLimit = 5;

  final ActivityDetailRepository repository;
  final ActivityItem activity;
  final DateTime Function() _now;

  AsyncPhase _phase = AsyncPhase.idle;
  ActivityDetail? _detail;
  ReviewSortOption _reviewSort = ReviewSortOption.latest;
  int _visibleReviewCount = reviewPageSize;
  String? _errorMessage;

  AsyncPhase get phase => _phase;
  ActivityDetail? get detail => _detail;
  ReviewSortOption get reviewSort => _reviewSort;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    if (_phase != AsyncPhase.idle) {
      return;
    }
    await _loadDetail();
  }

  Future<void> retry() => _loadDetail();

  ReviewSummary get reviewSummary {
    final reviews = _detail?.reviews ?? const <ActivityReview>[];
    if (reviews.isEmpty) {
      return const ReviewSummary(
        averageRating: 0,
        totalCount: 0,
        ratingCounts: <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      );
    }

    final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    var sum = 0;
    for (final review in reviews) {
      counts[review.rating] = (counts[review.rating] ?? 0) + 1;
      sum += review.rating;
    }

    return ReviewSummary(
      averageRating: sum / reviews.length,
      totalCount: reviews.length,
      ratingCounts: counts,
    );
  }

  List<ActivityReview> get previewReviews =>
      sortedReviews.take(reviewPreviewLimit).toList(growable: false);

  List<ActivityReview> get visibleReviews =>
      sortedReviews.take(_visibleReviewCount).toList(growable: false);

  bool get canLoadMoreReviews => visibleReviews.length < sortedReviews.length;

  List<ActivityReview> get sortedReviews {
    final reviews = List<ActivityReview>.from(
      _detail?.reviews ?? const <ActivityReview>[],
    );
    reviews.sort((left, right) {
      return switch (_reviewSort) {
        ReviewSortOption.latest => right.submittedAt.compareTo(
          left.submittedAt,
        ),
        ReviewSortOption.oldest => left.submittedAt.compareTo(
          right.submittedAt,
        ),
        ReviewSortOption.highestRating =>
          right.rating.compareTo(left.rating) != 0
              ? right.rating.compareTo(left.rating)
              : right.submittedAt.compareTo(left.submittedAt),
        ReviewSortOption.lowestRating =>
          left.rating.compareTo(right.rating) != 0
              ? left.rating.compareTo(right.rating)
              : right.submittedAt.compareTo(left.submittedAt),
      };
    });
    return reviews;
  }

  void updateReviewSort(ReviewSortOption value) {
    if (_reviewSort == value) {
      return;
    }
    _reviewSort = value;
    _visibleReviewCount = math.min(reviewPageSize, sortedReviews.length);
    notifyListeners();
  }

  void loadMoreReviews() {
    if (!canLoadMoreReviews) {
      return;
    }
    _visibleReviewCount = math.min(
      _visibleReviewCount + reviewPageSize,
      sortedReviews.length,
    );
    notifyListeners();
  }

  void toggleFavorite() {
    final current = _detail;
    if (current == null) {
      return;
    }
    _detail = current.copyWith(isFavorite: !current.isFavorite);
    notifyListeners();
  }

  void toggleJoin() {
    final current = _detail;
    if (current == null) {
      return;
    }

    final nextJoined = !current.isJoined;
    var nextCount = current.activity.participantCount;
    var nextParticipants = List<ActivityParticipant>.from(current.participants);
    final hasMe = nextParticipants.any((participant) => participant.id == 'me');

    if (nextJoined) {
      if (nextCount < current.activity.participantCapacity) {
        nextCount += 1;
      }
      if (!hasMe) {
        nextParticipants = <ActivityParticipant>[
          const ActivityParticipant(id: 'me', name: '나'),
          ...nextParticipants,
        ];
      }
    } else {
      if (nextCount > 0) {
        nextCount -= 1;
      }
      nextParticipants = nextParticipants
          .where((participant) => participant.id != 'me')
          .toList(growable: false);
    }

    _detail = current.copyWith(
      isJoined: nextJoined,
      activity: current.activity.copyWith(participantCount: nextCount),
      participants: nextParticipants,
    );
    notifyListeners();
  }

  void toggleHostFriend() {
    final current = _detail;
    if (current == null) {
      return;
    }
    _detail = current.copyWith(
      host: current.host.copyWith(isFriend: !current.host.isFriend),
    );
    notifyListeners();
  }

  void toggleHelpful(String reviewId) {
    final current = _detail;
    if (current == null) {
      return;
    }
    final nextReviews = current.reviews
        .map((review) {
          if (review.id != reviewId) {
            return review;
          }
          final nextHelpful = !review.isHelpfulByMe;
          return review.copyWith(
            isHelpfulByMe: nextHelpful,
            helpfulCount: nextHelpful
                ? review.helpfulCount + 1
                : math.max(0, review.helpfulCount - 1),
          );
        })
        .toList(growable: false);
    _detail = current.copyWith(reviews: nextReviews);
    notifyListeners();
  }

  void toggleTranslation(String reviewId) {
    final current = _detail;
    if (current == null) {
      return;
    }
    final nextReviews = current.reviews
        .map((review) {
          if (review.id != reviewId || !review.supportsTranslation) {
            return review;
          }
          return review.copyWith(
            isTranslationVisible: !review.isTranslationVisible,
          );
        })
        .toList(growable: false);
    _detail = current.copyWith(reviews: nextReviews);
    notifyListeners();
  }

  bool submitReview({
    required int rating,
    required String body,
    List<String> imageUrls = const <String>[],
  }) {
    final current = _detail;
    if (current == null) {
      return false;
    }
    final trimmed = body.trim();
    if (rating < 1 || rating > 5 || trimmed.isEmpty) {
      return false;
    }

    final review = ActivityReview(
      id: 'review-${_now().microsecondsSinceEpoch}',
      authorName: '나',
      submittedAt: _now(),
      rating: rating,
      originalText: trimmed,
      helpfulCount: 0,
      imageUrls: imageUrls,
    );
    final nextReviews = <ActivityReview>[review, ...current.reviews];
    _detail = current.copyWith(reviews: nextReviews);
    _reviewSort = ReviewSortOption.latest;
    _visibleReviewCount = math.min(
      math.max(_visibleReviewCount, reviewPageSize),
      nextReviews.length,
    );
    notifyListeners();
    return true;
  }

  Future<void> _loadDetail() async {
    _phase = AsyncPhase.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await repository.fetchDetail(activity);
      _phase = AsyncPhase.success;
      _visibleReviewCount = math.min(reviewPageSize, _detail!.reviews.length);
    } on ActivityDetailRepositoryException catch (error) {
      _phase = error.type == ActivityDetailLoadFailureType.network
          ? AsyncPhase.networkError
          : AsyncPhase.serverError;
      _errorMessage = error.type == ActivityDetailLoadFailureType.network
          ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
          : '활동 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    } catch (_) {
      _phase = AsyncPhase.serverError;
      _errorMessage = '활동 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }
}
