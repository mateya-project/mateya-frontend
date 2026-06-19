import 'dart:io';

import '../../../app/app_config.dart';
import '../../onboarding/domain/onboarding_flow.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/http_transport.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../../../shared/time/korean_time.dart';
import '../domain/mypage_models.dart';

part 'mypage_repository_api.dart';
part 'mypage_repository_api_upload_support.dart';
part 'mypage_repository_mock.dart';
part 'mypage_repository_api_support.dart';
part 'mypage_repository_mock_support.dart';

abstract interface class MyPageRepository {
  Future<MyPageBundle> fetchBundle({required bool isBusinessMode});

  Future<OtherProfileData> fetchOtherProfile({required String targetUserId});

  Future<List<BlockedUserSummary>> fetchBlockedUsers();

  Future<PersonalMyPageData> updatePrimaryPreferences({
    required String displayName,
    required String languageCode,
    required String countryCode,
  });

  Future<BusinessMyPageData> updateBusinessIntroduction({
    required String introduction,
    String? placeName,
    String? placeAddress,
  });

  Future<String> updateProfileImage({required String imagePath});

  Future<String> updateActivityRegion({
    required NeighborhoodSelection neighborhood,
  });

  Future<void> submitWithdrawal({
    required String agreementText,
    String? reason,
  });

  Future<void> logout();

  Future<OtherProfileData> updateFriendship({
    required String targetUserId,
    required bool isFriend,
  });

  Future<void> blockUser({required String targetUserId});

  Future<void> unblockUser({required String targetUserId});
}
