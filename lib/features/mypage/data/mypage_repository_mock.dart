part of 'mypage_repository.dart';

class MockMyPageRepository implements MyPageRepository {
  @override
  Future<MyPageBundle> fetchBundle({required bool isBusinessMode}) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    return MyPageBundle(
      personalPage: _personalPage,
      otherProfile: _otherProfile,
      recentActivity: _recentActivity,
      businessPage: _businessPage,
      languageOptions: kMyPageLanguageOptions,
      countryOptions: kMyPageCountryOptions,
      consentHistory: _consentHistory,
      blockedUsers: _blockedUsers,
    );
  }

  @override
  Future<OtherProfileData> fetchOtherProfile({
    required String targetUserId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return _otherProfile;
  }

  @override
  Future<List<BlockedUserSummary>> fetchBlockedUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return _blockedUsers;
  }

  @override
  Future<PersonalMyPageData> updatePrimaryPreferences({
    required String displayName,
    String? englishName,
    required String languageCode,
    required String countryCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    final language = kMyPageLanguageOptions
        .where((item) => item.code == languageCode)
        .firstOrNull;
    final country = kMyPageCountryOptions
        .where((item) => item.code == countryCode)
        .firstOrNull;
    return _personalPage.copyWith(
      profile: _personalPage.profile.copyWith(
        englishName: englishName,
        primaryLanguageCode: languageCode,
        primaryLanguageLabel: language?.label ?? languageCode,
        primaryCountryCode: countryCode,
        primaryCountryLabel: country?.label ?? countryCode,
      ),
    );
  }

  @override
  Future<BusinessMyPageData> updateBusinessIntroduction({
    required String introduction,
    String? placeName,
    String? placeAddress,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return _businessPage.copyWith(
      profile: _businessPage.profile.copyWith(
        oneLineIntroduction: introduction,
        placeLabel: placeName ?? _businessPage.profile.placeLabel,
      ),
    );
  }

  @override
  Future<String> updateProfileImage({required String imagePath}) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return _personalPage.profile.profileImageUrl ??
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80';
  }

  @override
  Future<String> updateActivityRegion({
    required NeighborhoodSelection neighborhood,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return neighborhood.displayName;
  }

  @override
  Future<void> submitWithdrawal({
    required String agreementText,
    String? reason,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
  }

  @override
  Future<OtherProfileData> updateFriendship({
    required String targetUserId,
    required bool isFriend,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return _otherProfile.copyWith(isFriend: !isFriend);
  }

  @override
  Future<void> blockUser({required String targetUserId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
  }

  @override
  Future<void> unblockUser({required String targetUserId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
  }
}
