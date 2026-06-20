import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../home/domain/home_models.dart';
import '../../onboarding/domain/onboarding_flow.dart';
import '../../../shared/localization/mateya_localizations.dart';
import '../data/activity_detail_repository.dart';
import '../domain/activity_detail_models.dart';

class ActivityDetailController extends ChangeNotifier {
  ActivityDetailController({required this.repository, required this.activity});

  static const int reviewPageSize = 8;
  static const int reviewPreviewLimit = 5;

  final ActivityDetailRepository repository;
  final ActivityItem activity;

  AsyncPhase _phase = AsyncPhase.idle;
  bool _isMutatingFavorite = false;
  bool _isRequestingJoin = false;
  final Set<String> _helpfulReviewIdsInFlight = <String>{};
  bool _isSubmittingReview = false;
  String? _armedParticipantRemovalId;
  ActivityDetail? _detail;
  ReviewSortOption _reviewSort = ReviewSortOption.latest;
  int _visibleReviewCount = reviewPageSize;
  String? _errorMessage;

  AsyncPhase get phase => _phase;
  ActivityDetail? get detail => _detail;
  ReviewSortOption get reviewSort => _reviewSort;
  String? get errorMessage => _errorMessage;
  bool get isMutatingFavorite => _isMutatingFavorite;
  bool get isRequestingJoin => _isRequestingJoin;
  bool get isSubmittingReview => _isSubmittingReview;
  String? get armedParticipantRemovalId => _armedParticipantRemovalId;
  bool isHelpfulMutationInFlight(String reviewId) =>
      _helpfulReviewIdsInFlight.contains(reviewId);

  Future<void> initialize() async {
    if (_phase != AsyncPhase.idle) {
      return;
    }
    await _loadDetail();
  }

  Future<void> retry() => _loadDetail();

  ReviewSummary get reviewSummary {
    final serverSummary = _detail?.serverReviewSummary;
    if (serverSummary != null) {
      return serverSummary;
    }

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

  Future<String?> toggleFavorite() async {
    final current = _detail;
    final l10n = MateyaLocalizations.current;
    if (current == null) {
      return l10n.detailsActivityRequired;
    }
    if (_isMutatingFavorite) {
      return null;
    }

    _isMutatingFavorite = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nextFavorite = await repository.toggleFavorite(
        activityId: current.activity.id,
        isFavorite: current.isFavorite,
      );
      _detail = current.copyWith(isFavorite: nextFavorite);
      return null;
    } on ActivityDetailRepositoryException catch (error) {
      _errorMessage = error.message ?? l10n.detailsFavoriteToggleError;
      return _errorMessage;
    } finally {
      _isMutatingFavorite = false;
      notifyListeners();
    }
  }

  Future<String?> requestJoin() async {
    final current = _detail;
    final l10n = MateyaLocalizations.current;
    if (current == null) {
      return l10n.detailsActivityRequired;
    }
    if (_isRequestingJoin) {
      return null;
    }
    switch (current.participationState) {
      case ActivityParticipationState.available:
        break;
      case ActivityParticipationState.requested:
        return l10n.detailsJoinAlreadyRequested;
      case ActivityParticipationState.joined:
        return l10n.detailsJoinAlreadyJoined;
      case ActivityParticipationState.host:
        return l10n.detailsJoinHostedByMe;
    }

    _isRequestingJoin = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await repository.requestJoin(detail: current);
      return null;
    } on ActivityDetailRepositoryException catch (error) {
      _errorMessage = error.message ?? l10n.detailsJoinRequestError;
      return _errorMessage;
    } finally {
      _isRequestingJoin = false;
      notifyListeners();
    }
  }

  void armParticipantRemoval(String participantId) {
    _armedParticipantRemovalId = _armedParticipantRemovalId == participantId
        ? null
        : participantId;
    notifyListeners();
  }

  Future<String?> removeApprovedParticipant(String participantId) async {
    final current = _detail;
    final l10n = MateyaLocalizations.current;
    if (current == null) {
      return l10n.detailsActivityRequired;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await repository.removeApprovedParticipant(
        detail: current,
        participantId: participantId,
      );
      _armedParticipantRemovalId = null;
      return null;
    } on ActivityDetailRepositoryException catch (error) {
      _errorMessage = error.message ?? l10n.detailsParticipantRemoveError;
      return _errorMessage;
    } finally {
      notifyListeners();
    }
  }

  Future<String?> removePendingParticipant(String participantId) async {
    final current = _detail;
    final l10n = MateyaLocalizations.current;
    if (current == null) {
      return l10n.detailsActivityRequired;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await repository.removePendingParticipant(
        detail: current,
        participantId: participantId,
      );
      return null;
    } on ActivityDetailRepositoryException catch (error) {
      _errorMessage = error.message ?? l10n.detailsPendingCancelError;
      return _errorMessage;
    } finally {
      notifyListeners();
    }
  }

  Future<String?> approvePendingParticipant(String participantId) async {
    final current = _detail;
    final l10n = MateyaLocalizations.current;
    if (current == null) {
      return l10n.detailsActivityRequired;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await repository.approvePendingParticipant(
        detail: current,
        participantId: participantId,
      );
      return null;
    } on ActivityDetailRepositoryException catch (error) {
      _errorMessage = error.message ?? l10n.detailsPendingApproveError;
      return _errorMessage;
    } finally {
      notifyListeners();
    }
  }

  void restoreApprovedParticipant(ActivityParticipant participant) {
    final current = _detail;
    if (current == null) {
      return;
    }
    _detail = current.copyWith(
      participants: <ActivityParticipant>[participant, ...current.participants],
      activity: current.activity.copyWith(
        participantCount: current.activity.participantCount + 1,
      ),
    );
    notifyListeners();
  }

  void restorePendingParticipant(ActivityParticipant participant) {
    final current = _detail;
    if (current == null) {
      return;
    }
    _detail = current.copyWith(
      pendingParticipants: <ActivityParticipant>[
        participant,
        ...current.pendingParticipants,
      ],
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

  Future<String?> toggleHelpful(String reviewId) async {
    final current = _detail;
    final l10n = MateyaLocalizations.current;
    if (current == null) {
      return l10n.detailsReviewRequired;
    }
    if (_helpfulReviewIdsInFlight.contains(reviewId)) {
      return null;
    }

    _helpfulReviewIdsInFlight.add(reviewId);
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.toggleHelpful(reviewId: reviewId);
      final nextReviews = current.reviews
          .map((review) {
            if (review.id != reviewId) {
              return review;
            }
            return review.copyWith(
              isHelpfulByMe: result.helpful,
              helpfulCount: result.helpfulCount,
            );
          })
          .toList(growable: false);
      _detail = current.copyWith(reviews: nextReviews);
      return null;
    } on ActivityDetailRepositoryException catch (error) {
      _errorMessage = error.message ?? l10n.detailsHelpfulToggleError;
      return _errorMessage;
    } finally {
      _helpfulReviewIdsInFlight.remove(reviewId);
      notifyListeners();
    }
  }

  Future<void> toggleTranslation(String reviewId) async {
    final current = _detail;
    if (current == null) {
      return;
    }
    final targetReview = current.reviews
        .where((review) => review.id == reviewId)
        .firstOrNull;
    if (targetReview == null || !targetReview.supportsTranslation) {
      return;
    }
    if (targetReview.isTranslationVisible) {
      final nextReviews = current.reviews
          .map((review) {
            if (review.id != reviewId) {
              return review;
            }
            return review.copyWith(isTranslationVisible: false);
          })
          .toList(growable: false);
      _detail = current.copyWith(reviews: nextReviews);
      notifyListeners();
      return;
    }

    ActivityReview resolvedReview = targetReview;
    if (targetReview.translatedText == null ||
        targetReview.translatedText!.trim().isEmpty) {
      try {
        resolvedReview = await repository.fetchReview(
          reviewId: reviewId,
          original: false,
        );
      } on ActivityDetailRepositoryException catch (error) {
        _errorMessage = error.message;
        notifyListeners();
        return;
      }
    }

    final nextReviews = current.reviews
        .map((review) {
          if (review.id != reviewId) {
            return review;
          }
          final translatedText = resolvedReview.translatedText;
          final hasTranslatedText =
              translatedText != null && translatedText.trim().isNotEmpty;
          return review.copyWith(
            translatedText: hasTranslatedText ? translatedText : null,
            canToggleTranslation: resolvedReview.canToggleTranslation,
            isTranslationVisible: hasTranslatedText,
          );
        })
        .toList(growable: false);
    _detail = current.copyWith(reviews: nextReviews);
    notifyListeners();
  }

  Future<String?> submitReview({
    required int rating,
    required String body,
    List<String> imageUrls = const <String>[],
  }) async {
    final current = _detail;
    final l10n = MateyaLocalizations.current;
    if (current == null) {
      return l10n.detailsActivityRequired;
    }
    final trimmed = body.trim();
    if (rating < 1 || rating > 5 || trimmed.isEmpty) {
      return l10n.detailsReviewValidationRequired;
    }
    if (_isSubmittingReview) {
      return null;
    }

    _isSubmittingReview = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final review = await repository.submitReview(
        activityId: current.activity.id,
        rating: rating,
        body: trimmed,
        imageUrls: imageUrls,
      );
      final nextReviews = <ActivityReview>[review, ...current.reviews];
      ReviewSummary? nextSummary;
      final summary = current.serverReviewSummary;
      if (summary != null) {
        final nextTotal = summary.totalCount + 1;
        final nextAverage = nextTotal == 0
            ? 0
            : ((summary.averageRating * summary.totalCount) + rating) /
                  nextTotal;
        final nextCounts = <int, int>{...summary.ratingCounts};
        nextCounts[rating] = (nextCounts[rating] ?? 0) + 1;
        nextSummary = ReviewSummary(
          averageRating: nextAverage.toDouble(),
          totalCount: nextTotal,
          ratingCounts: nextCounts,
        );
      }

      _detail = current.copyWith(
        reviews: nextReviews,
        serverReviewSummary: nextSummary,
      );
      _reviewSort = ReviewSortOption.latest;
      _visibleReviewCount = math.min(
        math.max(_visibleReviewCount, reviewPageSize),
        nextReviews.length,
      );
      return null;
    } on ActivityDetailRepositoryException catch (error) {
      _errorMessage = error.message ?? l10n.detailsReviewSubmitError;
      return _errorMessage;
    } finally {
      _isSubmittingReview = false;
      notifyListeners();
    }
  }

  Future<void> _loadDetail() async {
    final l10n = MateyaLocalizations.current;
    _phase = AsyncPhase.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await repository.fetchDetail(activity);
      _phase = AsyncPhase.success;
      _visibleReviewCount = math.min(reviewPageSize, _detail!.reviews.length);
    } on ActivityDetailRepositoryException catch (error) {
      _phase = switch (error.type) {
        ActivityDetailLoadFailureType.network => AsyncPhase.networkError,
        ActivityDetailLoadFailureType.validation => AsyncPhase.validationError,
        ActivityDetailLoadFailureType.server => AsyncPhase.serverError,
      };
      _errorMessage =
          error.message ??
          (error.type == ActivityDetailLoadFailureType.network
              ? l10n.commonNetworkRetry
              : l10n.detailsLoadError);
    } catch (_) {
      _phase = AsyncPhase.serverError;
      _errorMessage = l10n.detailsLoadError;
    }

    notifyListeners();
  }
}
