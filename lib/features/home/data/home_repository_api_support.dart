part of 'home_repository.dart';

ActivityCategory _categoryForServerCode(String code) {
  for (final category in kFallbackActivityCategories) {
    if (category.code == code) {
      return ActivityCategory(id: category.code, label: category.label);
    }
  }
  return ActivityCategory(
    id: 'PUBLIC_FACILITY',
    label: _fallbackCategoryLabel('PUBLIC_FACILITY'),
  );
}

String _fallbackCategoryLabel(String code) {
  for (final category in kFallbackActivityCategories) {
    if (category.code == code) {
      return category.label;
    }
  }
  return MateyaLocalizations.current.activityCategoryPublicFacility;
}

String _sortToServerValue(ActivitySortOption value) => switch (value) {
  ActivitySortOption.recommended => 'recommended',
  ActivitySortOption.popular => 'popular',
  ActivitySortOption.latest => 'latest',
  ActivitySortOption.closingSoon => 'deadline',
  ActivitySortOption.nearby => 'distance',
};

String _audienceToServerValue(ActivityAudienceOption value) => switch (value) {
  ActivityAudienceOption.everyone => 'ANYONE',
  ActivityAudienceOption.foreignerFriendly => 'FOREIGNER_WELCOME',
  ActivityAudienceOption.koreanFriendly => 'KOREAN_WELCOME',
  ActivityAudienceOption.touristFriendly => 'TOURIST_RECOMMENDED',
  ActivityAudienceOption.beginnerFriendly => 'BEGINNER_WELCOME',
};

String _statusToServerValue(ActivityStatusOption value) => switch (value) {
  ActivityStatusOption.recruiting => 'recruiting',
  ActivityStatusOption.closingSoon => 'closing-soon',
  ActivityStatusOption.newlyListed => 'new',
};
