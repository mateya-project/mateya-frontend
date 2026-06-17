import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../domain/home_models.dart';

part 'home_repository_api.dart';
part 'home_repository_mock.dart';
part 'home_repository_support.dart';

abstract interface class HomeRepository {
  Future<List<ActivityItem>> fetchHomeActivities();

  Future<ExploreActivitiesPage> fetchExploreActivities({
    required int page,
    required String keyword,
    required ExploreFilter filter,
  });
}
