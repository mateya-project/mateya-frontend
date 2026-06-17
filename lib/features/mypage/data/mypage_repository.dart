import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../domain/mypage_models.dart';

part 'mypage_repository_api.dart';
part 'mypage_repository_mock.dart';
part 'mypage_repository_support.dart';

abstract interface class MyPageRepository {
  Future<MyPageBundle> fetchBundle({required bool isBusinessMode});

  Future<OtherProfileData> fetchOtherProfile({required String targetUserId});

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

  Future<void> submitWithdrawal({
    required String agreementText,
    String? reason,
  });

  Future<OtherProfileData> updateFriendship({
    required String targetUserId,
    required bool isFriend,
  });
}
