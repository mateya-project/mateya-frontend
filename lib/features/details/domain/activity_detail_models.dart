import '../../home/domain/home_models.dart';

enum ActivityDetailLoadFailureType { network, validation, server }

enum ReviewSortOption { latest, oldest, highestRating, lowestRating }

enum ActivityParticipationState { available, requested, joined, host }

class ActivityParticipant {
  const ActivityParticipant({
    required this.id,
    required this.name,
    required this.residenceLabel,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String residenceLabel;
  final String? avatarUrl;
}

class ActivityHostProfile {
  const ActivityHostProfile({
    required this.userId,
    required this.name,
    required this.localizedName,
    required this.locationLabel,
    this.avatarUrl,
    this.isFriend = false,
  });

  final String userId;
  final String name;
  final String localizedName;
  final String locationLabel;
  final String? avatarUrl;
  final bool isFriend;

  String get displayName {
    final primary = name.trim();
    final localized = localizedName.trim();
    if (primary.isEmpty) {
      return localized;
    }
    if (localized.isEmpty || localized == primary) {
      return primary;
    }
    return '$primary · $localized';
  }

  ActivityHostProfile copyWith({
    String? userId,
    String? name,
    String? localizedName,
    String? locationLabel,
    Object? avatarUrl = _detailSentinel,
    bool? isFriend,
  }) {
    return ActivityHostProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      localizedName: localizedName ?? this.localizedName,
      locationLabel: locationLabel ?? this.locationLabel,
      avatarUrl: avatarUrl == _detailSentinel
          ? this.avatarUrl
          : avatarUrl as String?,
      isFriend: isFriend ?? this.isFriend,
    );
  }
}

class ActivityReview {
  const ActivityReview({
    required this.id,
    required this.authorName,
    required this.submittedAt,
    required this.rating,
    required this.originalText,
    this.authorAvatarUrl,
    this.translatedText,
    this.helpfulCount = 0,
    this.isHelpfulByMe = false,
    this.isTranslationVisible = false,
    this.imageUrls = const <String>[],
  });

  final String id;
  final String authorName;
  final String? authorAvatarUrl;
  final DateTime submittedAt;
  final int rating;
  final String originalText;
  final String? translatedText;
  final int helpfulCount;
  final bool isHelpfulByMe;
  final bool isTranslationVisible;
  final List<String> imageUrls;

  bool get supportsTranslation =>
      translatedText != null && translatedText!.trim().isNotEmpty;

  String get visibleBody => isTranslationVisible && supportsTranslation
      ? translatedText!
      : originalText;

  ActivityReview copyWith({
    String? id,
    String? authorName,
    Object? authorAvatarUrl = _detailSentinel,
    DateTime? submittedAt,
    int? rating,
    String? originalText,
    Object? translatedText = _detailSentinel,
    int? helpfulCount,
    bool? isHelpfulByMe,
    bool? isTranslationVisible,
    List<String>? imageUrls,
  }) {
    return ActivityReview(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl == _detailSentinel
          ? this.authorAvatarUrl
          : authorAvatarUrl as String?,
      submittedAt: submittedAt ?? this.submittedAt,
      rating: rating ?? this.rating,
      originalText: originalText ?? this.originalText,
      translatedText: translatedText == _detailSentinel
          ? this.translatedText
          : translatedText as String?,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isHelpfulByMe: isHelpfulByMe ?? this.isHelpfulByMe,
      isTranslationVisible: isTranslationVisible ?? this.isTranslationVisible,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

class ActivityDetail {
  const ActivityDetail({
    required this.activity,
    required this.imageUrls,
    required this.locationLabel,
    required this.host,
    required this.description,
    required this.shareUrl,
    required this.participants,
    required this.pendingParticipants,
    required this.reviews,
    this.serverReviewSummary,
    this.isFavorite = false,
    this.participationState = ActivityParticipationState.available,
  });

  final ActivityItem activity;
  final List<String> imageUrls;
  final String locationLabel;
  final ActivityHostProfile host;
  final String description;
  final String shareUrl;
  final List<ActivityParticipant> participants;
  final List<ActivityParticipant> pendingParticipants;
  final List<ActivityReview> reviews;
  final ReviewSummary? serverReviewSummary;
  final bool isFavorite;
  final ActivityParticipationState participationState;

  bool get isJoined => participationState == ActivityParticipationState.joined;
  bool get isParticipationRequested =>
      participationState == ActivityParticipationState.requested;
  bool get isHostedByMe =>
      participationState == ActivityParticipationState.host;

  ActivityDetail copyWith({
    ActivityItem? activity,
    List<String>? imageUrls,
    String? locationLabel,
    ActivityHostProfile? host,
    String? description,
    String? shareUrl,
    List<ActivityParticipant>? participants,
    List<ActivityParticipant>? pendingParticipants,
    List<ActivityReview>? reviews,
    Object? serverReviewSummary = _detailSentinel,
    bool? isFavorite,
    ActivityParticipationState? participationState,
  }) {
    return ActivityDetail(
      activity: activity ?? this.activity,
      imageUrls: imageUrls ?? this.imageUrls,
      locationLabel: locationLabel ?? this.locationLabel,
      host: host ?? this.host,
      description: description ?? this.description,
      shareUrl: shareUrl ?? this.shareUrl,
      participants: participants ?? this.participants,
      pendingParticipants: pendingParticipants ?? this.pendingParticipants,
      reviews: reviews ?? this.reviews,
      serverReviewSummary: serverReviewSummary == _detailSentinel
          ? this.serverReviewSummary
          : serverReviewSummary as ReviewSummary?,
      isFavorite: isFavorite ?? this.isFavorite,
      participationState: participationState ?? this.participationState,
    );
  }
}

class ReviewSummary {
  const ReviewSummary({
    required this.averageRating,
    required this.totalCount,
    required this.ratingCounts,
  });

  final double averageRating;
  final int totalCount;
  final Map<int, int> ratingCounts;
}

class ActivityDetailRepositoryException implements Exception {
  const ActivityDetailRepositoryException(this.type, {this.message});

  final ActivityDetailLoadFailureType type;
  final String? message;
}

class HelpfulToggleState {
  const HelpfulToggleState({required this.helpful, required this.helpfulCount});

  final bool helpful;
  final int helpfulCount;
}

extension ReviewSortOptionX on ReviewSortOption {
  String get label => switch (this) {
    ReviewSortOption.latest => '최신순',
    ReviewSortOption.oldest => '오래된순',
    ReviewSortOption.highestRating => '평점 높은순',
    ReviewSortOption.lowestRating => '평점 낮은순',
  };
}

extension ActivityParticipationStateX on ActivityParticipationState {
  bool get canRequestJoin => this == ActivityParticipationState.available;

  String get ctaLabel => switch (this) {
    ActivityParticipationState.available => '참가하기',
    ActivityParticipationState.requested => '신청 완료',
    ActivityParticipationState.joined => '참가중',
    ActivityParticipationState.host => '내 모임',
  };
}

const Object _detailSentinel = Object();
