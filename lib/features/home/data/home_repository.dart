import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/activity_categories/activity_category_repository.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../../../shared/time/korean_time.dart';
import '../domain/home_models.dart';

part 'home_repository_api.dart';
part 'home_repository_api_support.dart';
part 'home_repository_mock.dart';
part 'home_repository_mock_support.dart';

abstract interface class HomeRepository {
  Future<List<ActivityItem>> fetchHomeActivities();

  Future<ExploreActivitiesPage> fetchExploreActivities({
    required int page,
    required String keyword,
    required ExploreFilter filter,
  });

  Future<List<ActivityItem>> fetchFavoriteActivities();
}
