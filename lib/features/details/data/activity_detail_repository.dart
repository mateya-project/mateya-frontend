import 'dart:io';

import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/http_transport.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../../../shared/time/korean_time.dart';
import '../../home/domain/home_models.dart';
import '../domain/activity_detail_models.dart';

part 'activity_detail_repository_api.dart';
part 'activity_detail_repository_api_parsers.dart';
part 'activity_detail_repository_api_upload_support.dart';
part 'activity_detail_repository_mock.dart';
part 'activity_detail_repository_mock_builders.dart';
part 'activity_detail_repository_mock_fixtures.dart';

abstract interface class ActivityDetailRepository {
  Future<ActivityDetail> fetchDetail(ActivityItem activity);

  Future<bool> toggleFavorite({
    required String activityId,
    required bool isFavorite,
  });

  Future<ActivityDetail> requestJoin({required ActivityDetail detail});

  Future<ActivityDetail> approvePendingParticipant({
    required ActivityDetail detail,
    required String participantId,
  });

  Future<ActivityDetail> removeApprovedParticipant({
    required ActivityDetail detail,
    required String participantId,
  });

  Future<ActivityDetail> removePendingParticipant({
    required ActivityDetail detail,
    required String participantId,
  });

  Future<HelpfulToggleState> toggleHelpful({required String reviewId});

  Future<ActivityReview> submitReview({
    required String activityId,
    required int rating,
    required String body,
    List<String> imageUrls,
  });
}
