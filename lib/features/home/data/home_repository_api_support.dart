part of 'home_repository.dart';

const ActivityCategory _fallbackCategory = ActivityCategory(
  id: 'PUBLIC_FACILITY',
  label: '공공시설',
);

const Map<String, ActivityCategory> _categoryByServerCode =
    <String, ActivityCategory>{
      'TOURIST_ATTRACTION': ActivityCategory(
        id: 'TOURIST_ATTRACTION',
        label: '관광지',
      ),
      'TRAVEL_COURSE': ActivityCategory(id: 'TRAVEL_COURSE', label: '여행코스'),
      'CULTURE_TRADITION': ActivityCategory(
        id: 'CULTURE_TRADITION',
        label: '문화/전통',
      ),
      'EVENT_PERFORMANCE_FESTIVAL': ActivityCategory(
        id: 'EVENT_PERFORMANCE_FESTIVAL',
        label: '행사/공연/축제',
      ),
      'SPORTS': ActivityCategory(id: 'SPORTS', label: '스포츠'),
      'ACTIVITY_LEPORTS': ActivityCategory(
        id: 'ACTIVITY_LEPORTS',
        label: '액티비티/레포츠',
      ),
      'PUBLIC_FACILITY': ActivityCategory(id: 'PUBLIC_FACILITY', label: '공공시설'),
      'SHOPPING': ActivityCategory(id: 'SHOPPING', label: '쇼핑'),
    };

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
