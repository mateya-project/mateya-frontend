part of 'home_repository.dart';

final ActivityCategory _fallbackCategory = ActivityCategory(
  id: 'PUBLIC_FACILITY',
  label: _fallbackCategoryLabel('PUBLIC_FACILITY'),
);

final Map<String, ActivityCategory> _categoryByServerCode =
    Map<String, ActivityCategory>.unmodifiable(<String, ActivityCategory>{
      for (final category in kFallbackActivityCategories)
        category.code: ActivityCategory(
          id: category.code,
          label: category.label,
        ),
    });

String _fallbackCategoryLabel(String code) {
  for (final category in kFallbackActivityCategories) {
    if (category.code == code) {
      return category.label;
    }
  }
  return '공공시설';
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
