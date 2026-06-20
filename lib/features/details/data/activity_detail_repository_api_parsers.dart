part of 'activity_detail_repository.dart';

ActivityParticipant _parseParticipant(Object? value) {
  final json = _asMap(value);
  return ActivityParticipant(
    id: '${json['userId']}',
    name: json['displayName'] as String? ?? '',
    residenceLabel:
        json['activityRegionName'] as String? ??
        json['residence'] as String? ??
        'Living in Seoul',
    avatarUrl: json['profileImageUrl'] as String?,
  );
}

List<ActivityParticipant> _parseParticipants(Object? value) {
  final items = value is List<Object?> ? value : const <Object?>[];
  return items.map(_parseParticipant).toList(growable: false);
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
    authorUserId: '${json['userId'] ?? ''}',
    authorName: json['authorDisplayName'] as String? ?? '',
    authorAvatarUrl: json['authorProfileImageUrl'] as String?,
    submittedAt: parseServerDateTime(json['createdAt'] as String),
    rating: json['rating'] as int? ?? 0,
    originalText: originalBody ?? translatedBody ?? '',
    translatedText: visibleTranslation,
    isTranslationVisible: visibleTranslation != null,
    helpfulCount: json['helpfulCount'] as int? ?? 0,
    isHelpfulByMe: json['helpfulByMe'] as bool? ?? false,
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

ActivityDetailRepositoryException _mapApiException(MateyaApiException error) {
  if (error.type == ApiFailureType.network) {
    return const ActivityDetailRepositoryException(
      ActivityDetailLoadFailureType.network,
    );
  }
  if (error.type == ApiFailureType.validation) {
    return ActivityDetailRepositoryException(
      ActivityDetailLoadFailureType.validation,
      message: error.message,
    );
  }
  return ActivityDetailRepositoryException(
    ActivityDetailLoadFailureType.server,
    message: error.message,
  );
}
