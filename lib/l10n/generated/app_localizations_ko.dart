// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'MateYa';

  @override
  String get brandLockupSubtitle => '한국의 정과 문화를 나누는\n특별한 여정의 시작';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageJapanese => '일본어';

  @override
  String get languageChineseSimplified => '중국어';

  @override
  String get bottomNavigationHome => '홈';

  @override
  String get bottomNavigationExplore => '둘러보기';

  @override
  String get bottomNavigationChat => '채팅';

  @override
  String get bottomNavigationProfile => '프로필';

  @override
  String get commonConfirm => '확인';

  @override
  String get commonCancel => '취소';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonContinue => '계속';

  @override
  String get commonLater => '나중에';

  @override
  String get commonAll => '전체';

  @override
  String get commonNext => '다음';

  @override
  String get commonReset => '초기화';

  @override
  String get commonApply => '적용하기';

  @override
  String get commonProcessing => '처리 중...';

  @override
  String get commonFree => '무료';

  @override
  String get commonToday => '오늘';

  @override
  String get commonTomorrow => '내일';

  @override
  String get permissionOpenAppSettings => '앱 설정 열기';

  @override
  String get permissionOpenLocationSettings => '위치 설정 열기';

  @override
  String get locationServiceDisabledTitle => '위치 서비스가 꺼져 있어요';

  @override
  String get locationPermissionDisabledTitle => '위치 권한이 꺼져 있어요';

  @override
  String get languageDialogBarrierLabel => '언어 선택';

  @override
  String get languageDialogTitle => '언어 변경';

  @override
  String get languageDialogSupportedLanguages => '지원 언어';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get onboardingBusinessPrompt => '사업자 이신가요? ';

  @override
  String get onboardingStartAsHost => '호스트로 시작하기';

  @override
  String get onboardingConsentTitle => '메이트야 이용시 동의가 필요합니다.';

  @override
  String get onboardingAgreeAll => '모두 동의';

  @override
  String get onboardingAgreeAllHelper => '아래 필수 및 선택항목에 모두 동의합니다.';

  @override
  String onboardingRequiredAgreementLabel(Object title) {
    return '(필수) $title';
  }

  @override
  String get onboardingEnterName => '이름을 입력해 주세요';

  @override
  String get onboardingEnterPhoneNumber => '휴대폰 번호를 입력해주세요';

  @override
  String get onboardingEnterVerificationCode => '인증번호를 입력해주세요';

  @override
  String get onboardingPhoneNumberLabel => '전화번호';

  @override
  String get onboardingPhoneNumberHint => '예)01012341234';

  @override
  String get onboardingPhoneNumberHelper => '휴대폰 번호를 입력하면 인증번호를 받을 수 있어요.';

  @override
  String get onboardingVerificationCodeLabel => '인증번호';

  @override
  String get onboardingVerificationCodeHint => '인증번호 받기를 누르면 입력할 수 있어요.';

  @override
  String get onboardingResendVerificationCode => '인증번호 다시받기';

  @override
  String onboardingDebugVerificationCode(Object code) {
    return '테스트용 인증번호: $code';
  }

  @override
  String get onboardingVerify => '인증하기';

  @override
  String get onboardingRequestVerificationCode => '인증번호 받기';

  @override
  String get onboardingLocationServiceDisabledMessage =>
      '현재 위치로 동네 인증을 진행하려면 기기 위치 서비스를 켜야 합니다. 켜지 않아도 동네를 직접 입력해 가입을 계속할 수 있습니다.';

  @override
  String get onboardingLocationPermissionDisabledMessage =>
      '현재 위치 자동 인증을 사용하려면 앱 설정에서 위치 권한을 허용해야 합니다. 권한을 허용하지 않아도 직접 입력으로 가입을 계속할 수 있습니다.';

  @override
  String onboardingPreviousNeighborhood(Object name) {
    return '이전에 \"$name\"으로 등록했어요.';
  }

  @override
  String get onboardingResolvingCurrentLocation => '현재 위치를 확인하고 있어요.';

  @override
  String get onboardingCompleteNeighborhood => '동네인증 완료하기';

  @override
  String get onboardingRetryLocationPermission => '현재 위치 권한 다시 요청';

  @override
  String get onboardingRetryAfterSettingsChange => '설정 변경 후 다시 확인';

  @override
  String get onboardingRetryLocationService => '위치 서비스 다시 확인';

  @override
  String get onboardingRetryCurrentLocation => '현재 위치 다시 확인';

  @override
  String get onboardingNeedHelp => '인증이 어려워요.  ';

  @override
  String get onboardingManualInputCta => '직접 입력하기 >';

  @override
  String get onboardingLocationPermissionNoticeTitle => '위치 권한 안내';

  @override
  String get onboardingLocationPermissionNoticeMessage =>
      '동네 인증 및 내 주변 활동 추천을 위해 위치 정보가 필요합니다.\n위치 권한을 허용하지 않아도 동네를 직접 입력하여\n가입을 계속할 수 있습니다.';

  @override
  String get onboardingUseCurrentLocation => '현재 위치로 인증하기';

  @override
  String get onboardingManualInput => '직접 입력하기';

  @override
  String get onboardingManualNeighborhoodHelper =>
      '00시 00동 또는 00동 형식으로 입력해 주세요.';

  @override
  String get onboardingNeighborhoodHint => '우만동';

  @override
  String get onboardingEnterBusinessName => '상호명을 입력해 주세요';

  @override
  String get onboardingBusinessNameHint => 'NICE 평가 정보';

  @override
  String get onboardingBusinessNumberLabel => '사업자 번호';

  @override
  String get onboardingBusinessOwnerLabel => '대표자명';

  @override
  String get onboardingBusinessOwnerHint => '홍길동';

  @override
  String get onboardingBusinessOpeningDateLabel => '개업일자';

  @override
  String get onboardingBusinessOpeningDateHint => '20240131';

  @override
  String get onboardingCompleteBusinessVerification => '사업자인증 완료하기';

  @override
  String get onboardingWelcomeBack => '돌아오신걸 환영해요';

  @override
  String onboardingReturnCompleted(Object name) {
    return '$name님\n메이트야 복귀를 완료했어요';
  }

  @override
  String get onboardingLaunchApp => '메이트야 시작하기';

  @override
  String onboardingAgreementSemantics(Object label) {
    return '$label 동의';
  }

  @override
  String onboardingTermsEffectiveDate(Object date) {
    return '시행일: $date';
  }

  @override
  String get onboardingTermsContents => '목차';

  @override
  String onboardingTermsSectionTitle(int index, Object title) {
    return '제$index조 $title';
  }

  @override
  String get onboardingDefaultMemberName => '메이트야 회원';

  @override
  String onboardingLoginCompleted(Object name) {
    return '$name님\n메이트야 로그인을 완료했어요';
  }

  @override
  String onboardingSignupCompleted(Object name) {
    return '$name님\n메이트야 가입을 완료했어요';
  }

  @override
  String onboardingNeighborhoodHeadlineReturning(Object name) {
    return '돌아오신걸 환영해요\n$name님!\n동네 정보를 인증해주세요';
  }

  @override
  String get onboardingNeighborhoodHeadlineSignup => '동네 정보를 인증해주세요';

  @override
  String onboardingResolvedNeighborhoodMessage(Object name) {
    return '현재 위치가 “$name”에 있어요.';
  }

  @override
  String get onboardingNeighborhoodLabel => '동네';

  @override
  String get onboardingVerificationExpired => '인증이 만료되어 인증번호를 다시 받아야 해요.';

  @override
  String get onboardingBusinessVerificationExpired =>
      '사업자 인증이 만료되어 다시 인증해야 해요.';

  @override
  String get homeSortRecommended => '추천순';

  @override
  String get homeSortPopular => '인기순';

  @override
  String get homeSortLatest => '최신순';

  @override
  String get homeSortClosingSoon => '마감임박순';

  @override
  String get homeSortNearby => '가까운 거리순';

  @override
  String get homeAudienceEveryone => '누구나';

  @override
  String get homeAudienceForeignerFriendly => '외국인 환영';

  @override
  String get homeAudienceKoreanFriendly => '한국인 환영';

  @override
  String get homeAudienceTouristFriendly => '관광객 추천';

  @override
  String get homeAudienceBeginnerFriendly => '초보자 환영';

  @override
  String get homeStatusRecruiting => '모집 중';

  @override
  String get homeStatusClosingSoon => '곧 마감 (24시간 내)';

  @override
  String get homeStatusNewlyListed => '신규 등록 (24시간 내)';

  @override
  String get homeDistanceLocal => '내 지역';

  @override
  String get homeDistanceWithin1km => '1km 이내';

  @override
  String get homeDistanceWithin5km => '5km 이내';

  @override
  String get homeDistanceWithin10km => '10km 이내';

  @override
  String get homeSearchHeroHint => '언제든 어디서든';

  @override
  String get homeSearchHeroHelper => '누구와도 메이트가 되는 곳, 메이트야';

  @override
  String get homeLoadError => '데이터를 불러오지 못했어요.';

  @override
  String get homeSelectAtLeastOneCategory => '카테고리를 1개 이상 선택해 주세요.';

  @override
  String get homeSelectAtLeastOneLanguage => '언어를 1개 이상 선택해 주세요.';

  @override
  String get homeUnsupportedExploreLanguageFilter =>
      '둘러보기 언어 필터는 한국어, 영어, 중국어, 일본어만 지원합니다.';

  @override
  String get homeEndDateBeforeStartDateError => '종료일은 시작일보다 빠를 수 없어요.';

  @override
  String get homeMaxPriceLessThanMinPriceError => '최대 금액은 최소 금액보다 크거나 같아야 해요.';

  @override
  String get homeTrendingTitle => '인기 급상승 🔥';

  @override
  String get homeSharedExperiencesTitle => '함께할 수 있는 경험';

  @override
  String get homeExploreSearchHint => '이름, 장소를 검색해 보세요';

  @override
  String get homeExploreError => '결과를 불러오지 못했어요.';

  @override
  String get homeFavoritesLoadError => '즐겨찾기 목록을 불러오지 못했어요.';

  @override
  String get homeFavoritesTitle => '즐겨찾기 목록';

  @override
  String get homeCreateClass => '클래스 등록';

  @override
  String get homeCreateGroup => '모임 생성';

  @override
  String get homeEmptyTitle => '조건에 맞는 활동이 아직 없어요.';

  @override
  String get homeEmptyDescription => '검색어 또는 필터를 조정해서 다시 찾아보세요.';

  @override
  String get homeLoadMore => '더 불러오기';

  @override
  String homeLoadedAllActivities(int count) {
    return '$count개 활동을 모두 불러왔어요.';
  }

  @override
  String get homeFilterTitle => '필터';

  @override
  String get homeFilterSort => '정렬';

  @override
  String get homeFilterCategory => '카테고리';

  @override
  String get homeFilterAudience => '참가대상';

  @override
  String get homeFilterLanguage => '언어';

  @override
  String get homeFilterRegion => '지역';

  @override
  String get homeFilterSchedule => '일정';

  @override
  String get homeFilterStartDate => '시작일';

  @override
  String get homeFilterEndDate => '종료일';

  @override
  String get homeFilterCost => '비용';

  @override
  String get homeFilterMinPrice => '최소금액';

  @override
  String get homeFilterMaxPrice => '최대금액';

  @override
  String get homeFilterStatus => '모집상태';

  @override
  String get homeFilterNear => '내 지역';

  @override
  String get homeFilterFar => '먼 지역';

  @override
  String homeFilterDistanceFromActivityRegion(Object target) {
    return '활동 지역 기준 $target';
  }

  @override
  String homeFilterDistanceFromRegion(Object regionName, Object target) {
    return '$regionName 기준 $target';
  }

  @override
  String get commonClose => '닫기';

  @override
  String get commonEdit => '편집';

  @override
  String get commonSeeAll => '전체보기';

  @override
  String get commonSeeDetails => '자세히 보기';

  @override
  String get commonNetworkRetry => '네트워크를 확인한 뒤 다시 시도해 주세요.';

  @override
  String get countryKorea => '대한민국';

  @override
  String get countryJapan => '일본';

  @override
  String get countryChina => '중국';

  @override
  String get countryVietnam => '베트남';

  @override
  String get countryUnitedStates => '미국';

  @override
  String get countryThailand => '태국';

  @override
  String get activityCategoryTouristAttraction => '관광지';

  @override
  String get activityCategoryTravelCourse => '여행코스';

  @override
  String get activityCategoryCultureTradition => '문화/전통';

  @override
  String get activityCategoryEventPerformanceFestival => '행사/공연/축제';

  @override
  String get activityCategorySports => '스포츠';

  @override
  String get activityCategoryActivityLeports => '액티비티/레포츠';

  @override
  String get activityCategoryShopping => '쇼핑';

  @override
  String get activityCategoryPublicFacility => '공공시설';

  @override
  String get activityCategoryOther => '기타';

  @override
  String get reportSemanticsLabel => '신고하기';

  @override
  String get reportTitle => '신고하기';

  @override
  String get reportNoticeMessage =>
      '신고 이미지 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 신고 사유 텍스트 작성은 계속할 수 있습니다.';

  @override
  String get reportRecoveryMessage =>
      '신고 이미지 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.';

  @override
  String get reportFailureMessage => '사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.';

  @override
  String get reportRestoreFallbackErrorMessage =>
      '이전에 선택하던 신고 이미지를 복구하지 못했어요. 다시 선택해 주세요.';

  @override
  String reportSubmittedMessage(Object subject) {
    return '$subject 신고가 접수되었어요.';
  }

  @override
  String get reportBodyHint =>
      '신고 사유를 구체적으로 작성해주세요.\n(예: 욕설, 사기 의심, 부적절한 게시물,\n스팸, 괴롭힘 등) 신고 내용은 운영 정책에\n따라 검토됩니다.';

  @override
  String reportBodyCount(int count, int max) {
    return '$count/$max자';
  }

  @override
  String reportImageSectionTitle(int max) {
    return '이미지 (최대 $max장)';
  }

  @override
  String get reportSubmitting => '접수 중...';

  @override
  String get reportReviewNotice =>
      '접수된 신고는 영업일 기준 최대 7일 이내에 검토되며,\n허위 신고 또는 신고 사유가 불명확한 경우 처리되지 않을 수 있습니다.';

  @override
  String reportRestoredCount(int restoredCount) {
    return '이전에 선택하던 신고 이미지 $restoredCount장을 복구했어요.';
  }

  @override
  String get mypageTitle => '마이페이지';

  @override
  String get mypageLoadError => '마이페이지를 불러오지 못했어요.';

  @override
  String get mypageOtherProfileOpenHint => '프로필을 불러오고 있어요.';

  @override
  String get mypageOtherProfileLoadError => '상대 프로필을 불러오지 못했어요.';

  @override
  String get mypageEditPrimaryPreferences => '기본 정보 수정';

  @override
  String get mypageEditActivityRegion => '활동 지역 수정';

  @override
  String get mypageConsentHistoryTitle => '동의 내역';

  @override
  String get mypageOpenPrivacyPolicy => '개인정보 처리방침';

  @override
  String get mypageOpenCustomerSupport => '고객센터';

  @override
  String get mypageOpenBlockedUsers => '차단한 사용자';

  @override
  String get mypageLogout => '로그아웃';

  @override
  String get mypageOpenWithdrawal => '회원 탈퇴';

  @override
  String get mypageConsentHistoryDescription =>
      '메이트야 이용을 위해 동의한 약관과 정책 내역을 확인할 수 있어요.';

  @override
  String get mypageConsentHistoryEmpty => '아직 저장된 동의 내역이 없어요.';

  @override
  String get mypageConsentVersion => '버전';

  @override
  String get mypageConsentStatus => '상태';

  @override
  String get mypageConsentAgreed => '동의';

  @override
  String get mypageConsentDeclined => '미동의';

  @override
  String get mypageConsentDate => '동의 일시';

  @override
  String get mypageBlockedUsersTitle => '차단한 사용자';

  @override
  String get mypageBlockedUsersEmpty => '차단한 사용자가 없어요.';

  @override
  String get mypageRecentActivitiesTitle => '최근 활동';

  @override
  String get mypageRecentActivitiesDescription => '최근 참여하거나 개설한 활동을 확인해 보세요.';

  @override
  String get mypageActivitySummaryTitle => '활동 요약';

  @override
  String get mypageHostedCount => '개설';

  @override
  String get mypageJoinedCount => '참여';

  @override
  String get mypageReviewCount => '리뷰';

  @override
  String get mypageActiveMember => '활동 중인 멤버';

  @override
  String get mypageInactiveMember => '최근 활동 없음';

  @override
  String get mypageActiveWithin30Days => '30일 내 접속';

  @override
  String get mypageNoRecentActivity => '최근 접속 없음';

  @override
  String get mypageBadgeLabel => '뱃지';

  @override
  String get mypageBadgesTitle => '내 뱃지';

  @override
  String get mypageBadgesDescription => '참여한 활동 카테고리에 따라 뱃지를 받을 수 있어요.';

  @override
  String get mypageRecentActivitiesSectionTitle => '활동 이력';

  @override
  String get mypageActivityHistoryTitle => '활동 이력';

  @override
  String get mypagePrimaryPreferencesTitle => '기본 정보';

  @override
  String get mypagePrimaryPreferencesDescription => '내 언어와 국적 정보를 수정할 수 있어요.';

  @override
  String get mypageMyLanguage => '내 언어';

  @override
  String get mypageMyCountry => '내 국적';

  @override
  String get mypageEnglishNameOptional => '영문 이름 (선택)';

  @override
  String get mypageSaving => '저장 중...';

  @override
  String get mypagePrimaryPreferencesSubmit => '저장하기';

  @override
  String get mypageUpdating => '업데이트 중...';

  @override
  String get mypageBusinessIntroTitle => '소개글';

  @override
  String get mypageBusinessIntroDescription => '호스트 페이지에 노출될 한 줄 소개를 작성해 주세요.';

  @override
  String get mypageBusinessIntroHint => '어떤 경험을 제공하는지 자연스럽게 소개해 주세요.';

  @override
  String get mypageSaveIntroduction => '소개 저장';

  @override
  String get mypageActiveExperiencesTitle => '운영 중인 체험';

  @override
  String get mypageRemoveFriend => '친구 삭제';

  @override
  String get mypageBlocked => '차단됨';

  @override
  String get mypageBlockUser => '차단하기';

  @override
  String get mypageSelectLanguageAndCountry => '언어와 국가를 모두 선택해 주세요.';

  @override
  String get mypageInvalidLanguageOrCountry => '지원하지 않는 언어 또는 국가예요.';

  @override
  String get mypagePrimaryPreferencesSaved => '기본 정보가 저장되었어요.';

  @override
  String get mypagePrimaryPreferencesSaveError =>
      '기본 정보를 저장하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageFriendRemoved => '친구를 삭제했어요.';

  @override
  String get mypageFriendAdded => '친구로 추가했어요.';

  @override
  String get mypageFriendUpdateError => '친구 상태를 변경하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageBlockedUserAdded => '사용자를 차단했어요.';

  @override
  String get mypageBlockUserError => '사용자를 차단하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageUnblockedUser => '차단을 해제했어요.';

  @override
  String get mypageUnblockUserError => '차단을 해제하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageBusinessIntroRequired => '소개글을 입력해 주세요.';

  @override
  String get mypageBusinessIntroTooLong => '소개글은 300자 이하로 입력해 주세요.';

  @override
  String get mypageBusinessIntroSaved => '소개글을 저장했어요.';

  @override
  String get mypageBusinessIntroSaveError => '소개글을 저장하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageProfileImageSaved => '프로필 이미지를 저장했어요.';

  @override
  String get mypageProfileImageSaveError =>
      '프로필 이미지를 저장하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageProfileImageInvalidFormat =>
      'JPG, PNG, WEBP, GIF 형식의 이미지만 업로드할 수 있어요.';

  @override
  String get mypageProfileImageUploadError =>
      '프로필 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageProfileImageConfirmError =>
      '프로필 이미지 업로드 확인에 실패했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageActivityRegionSaved => '활동 지역을 저장했어요.';

  @override
  String get mypageActivityRegionSaveError =>
      '활동 지역을 저장하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageWithdrawalAgreementRequired => '회원 탈퇴 동의가 필요해요.';

  @override
  String get mypageWithdrawalSignatureRequired => '서명을 입력해 주세요.';

  @override
  String get mypageWithdrawalSignatureMismatch => '입력한 서명이 회원 이름과 일치하지 않아요.';

  @override
  String get mypageWithdrawalAgreementText =>
      '개인정보 관리 및 30일 후 최종 삭제 정책에 동의합니다.';

  @override
  String get mypageWithdrawalSubmitted => '탈퇴 요청이 접수되었어요.';

  @override
  String get mypageWithdrawalSubmitError =>
      '탈퇴 요청을 처리하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageLogoutError => '로그아웃하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageTermsDetailUnavailable => '약관 상세 정보를 불러올 수 없어요.';

  @override
  String get mypageSupportLinkCopied => '고객센터 링크를 복사했어요.';

  @override
  String get mypagePrivacyLinkCopied => '개인정보 처리방침 링크를 복사했어요.';

  @override
  String get mypageCurrentLocationResolveError =>
      '현재 위치를 확인하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get mypageNeighborhoodRequired => '활동 지역을 입력해 주세요.';

  @override
  String get mypageNeighborhoodLookupError => '입력한 지역을 확인하지 못했어요. 다시 확인해 주세요.';

  @override
  String get mypageNeighborhoodVerificationRequired => '확인된 활동 지역을 선택해 주세요.';

  @override
  String get mypageActivityRegionDialogDescription =>
      '현재 위치를 사용하거나 직접 입력해서 활동 지역을 설정할 수 있어요.';

  @override
  String get mypageResolvingCurrentLocation => '현재 위치를 확인하고 있어요.';

  @override
  String get mypageResolvingNeighborhood => '입력한 지역을 확인하고 있어요.';

  @override
  String get mypageConfirmManualNeighborhood => '입력한 지역으로 확인';

  @override
  String mypageSelectedActivityRegion(Object name) {
    return '선택한 활동 지역: $name';
  }

  @override
  String get mypageSaveActivityRegion => '활동 지역 저장';

  @override
  String get mypageLocationServiceDisabledMessage =>
      '현재 위치를 사용하려면 기기 위치 서비스를 켜야 해요. 직접 입력으로도 계속할 수 있습니다.';

  @override
  String get mypageLocationPermissionDisabledMessage =>
      '현재 위치를 사용하려면 앱 설정에서 위치 권한을 허용해야 해요. 직접 입력으로도 계속할 수 있습니다.';

  @override
  String get mypageProfileImageNotice => '프로필 이미지를 선택하려면 사진 보관함 접근 권한이 필요합니다.';

  @override
  String get mypageProfileImageRecovery =>
      '프로필 이미지를 선택하려면 사진 보관함 접근 권한을 허용해 주세요. 다시 시도하거나 앱 설정에서 변경할 수 있어요.';

  @override
  String get mypageProfileImageFailure => '프로필 이미지를 불러오지 못했어요. 파일 상태를 확인해 주세요.';

  @override
  String get mypageProfileImageRestoreFallback =>
      '이전에 선택하던 프로필 이미지를 복구하지 못했어요. 다시 선택해 주세요.';

  @override
  String mypageProfileImageRestoredCount(int restoredCount) {
    return '이전에 선택하던 프로필 이미지 $restoredCount장을 복구했어요.';
  }

  @override
  String get mypageWithdrawalTitle => '회원 탈퇴';

  @override
  String get mypageWithdrawalDescription =>
      '회원 탈퇴를 진행하시겠습니까?\n탈퇴 후 계정은 즉시 비활성화되며,\n30일 동안 재가입 또는 로그인 시\n탈퇴가 취소됩니다.\n\n30일이 지나면 회원 정보 및 서비스 이용 기록은 관련 법령에 따라 보관이 필요한 정보를 제외하고 영구 삭제되며 복구할 수 없습니다.';

  @override
  String get mypageWithdrawalAgreementCheckbox =>
      '개인정보 관리 및 30일 후 최종 삭제 정책에 동의합니다.';

  @override
  String get mypageWithdrawalSignatureLabel => '서명 입력';

  @override
  String mypageWithdrawalSignatureHint(Object name) {
    return '$name 입력';
  }

  @override
  String get mypageWithdrawalSubmittedNotice =>
      '탈퇴 요청이 접수되었습니다. 앱 재로그인 전까지 계정은 비활성 상태로 간주됩니다.';

  @override
  String get mypageWithdrawalRequest => '탈퇴 요청';

  @override
  String get mypageMetricActivities => '활동 수';

  @override
  String get mypageMetricFriends => '친구 수';

  @override
  String get mypageMetricReviews => '작성 리뷰';

  @override
  String get mypageMetricRecruitingExperiences => '모집중 체험';

  @override
  String get mypageMetricTotalParticipants => '누적 참가자';

  @override
  String get mypageMetricAverageRating => '평균 평점';

  @override
  String get mypageMetricReceivedReviews => '받은 후기';

  @override
  String get mypageActivityRegionUnset => '활동 지역 미설정';

  @override
  String mypageParticipantCount(int current, int capacity) {
    return '$current / $capacity명';
  }

  @override
  String get mypageConsentTypeServiceTerms => '서비스 이용 약관';

  @override
  String get mypageConsentTypePrivacyCollection => '개인정보 수집·이용 동의';

  @override
  String get mypageConsentTypeLocationService => '위치기반 서비스 이용 동의';

  @override
  String get mypageConsentTypeAgeOver14 => '만 14세 이상 확인';

  @override
  String get mypageHostBadge => 'HOST';

  @override
  String get mypageEditActivityCta => '수정하기';

  @override
  String get mypageBadgeTraditional => '전통 마스터';

  @override
  String get mypageBadgeActivePerson => '액티브 메이트';

  @override
  String get mypageBadgeFestive => '축제 러버';

  @override
  String get mypageBadgeTourist => '로컬 탐험가';

  @override
  String get mypageBadgeUnlockedTitle => '새 뱃지를 획득했어요';

  @override
  String mypageBadgeUnlockedDescription(Object category) {
    return '$category 활동 참여가 반영됐어요.';
  }

  @override
  String get galleryPermissionNoticeTitle => '사진 권한 안내';

  @override
  String get galleryPermissionSelectPhoto => '사진 선택하기';

  @override
  String get galleryPermissionRecoveryTitle => '사진 권한이 필요해요';

  @override
  String get authLoginRequired => '로그인이 필요합니다.';

  @override
  String get commonRequestError => '요청 처리 중 오류가 발생했습니다.';

  @override
  String get chatJustNow => '방금';

  @override
  String chatMinutesAgo(int count) {
    return '$count분 전';
  }

  @override
  String chatHoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String get chatYesterday => '어제';

  @override
  String get chatLastYear => '작년';

  @override
  String chatPhotoCount(int count) {
    return '사진 $count장';
  }

  @override
  String get chatViewOriginal => '원문 보기';

  @override
  String get chatViewTranslation => '번역 보기';

  @override
  String chatParticipantCount(int count) {
    return '$count명 참여';
  }

  @override
  String get chatFilterGroup => '단체';

  @override
  String get chatFilterDirect => '개인';

  @override
  String get chatListGuidance =>
      '활동에 참여하면 자동으로 단체채팅방에 가입됩니다.\n개인 채팅은 친구인 유저와 자동으로 생성됩니다.\n친구가 아닌 유저와는 채팅할 수 없습니다.';

  @override
  String get chatComposerHint => '메시지를 입력하세요';

  @override
  String get reportReasonRequired => '신고 사유를 입력해 주세요.';

  @override
  String get reportImageInvalidFormat =>
      'JPG, PNG, WEBP, GIF 형식의 신고 이미지만 업로드할 수 있어요.';

  @override
  String get reportImageUploadError => '신고 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get reportImageConfirmError =>
      '신고 이미지 업로드 확인에 실패했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get createGroupFlowTitle => '모임 만들기';

  @override
  String get createClassFlowTitle => '클래스 등록';

  @override
  String get createEntityGroup => '모임';

  @override
  String get createEntityClass => '클래스';

  @override
  String get createGroupSubmit => '모임 생성하기';

  @override
  String get createClassSubmit => '클래스 등록하기';

  @override
  String get createGroupEditTitle => '모임 수정';

  @override
  String get createClassEditTitle => '클래스 수정';

  @override
  String get createGroupUpdateSubmit => '모임 수정 완료';

  @override
  String get createClassUpdateSubmit => '클래스 수정 완료';

  @override
  String get createPaidLabel => '유료';

  @override
  String createEditCompleted(Object entity) {
    return '$entity 수정이 완료되었어요.';
  }

  @override
  String createSubmitCompleted(Object entity) {
    return '$entity 등록이 완료되었어요.';
  }

  @override
  String createChatProvisionFailed(Object entity) {
    return '$entity 등록은 완료됐지만 채팅방을 준비하지 못했어요. 잠시 후 다시 확인해 주세요.';
  }

  @override
  String createSubmitFailedNetwork(Object entity) {
    return '$entity을(를) 등록하지 못했어요. 네트워크를 확인한 뒤 다시 시도해 주세요.';
  }

  @override
  String createSubmitFailedServer(Object entity) {
    return '$entity을(를) 등록하지 못했어요. 잠시 후 다시 시도해 주세요.';
  }

  @override
  String get createDeleteFailedNetwork => '삭제하지 못했어요. 네트워크를 확인한 뒤 다시 시도해 주세요.';

  @override
  String get createDeleteFailedServer => '삭제하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String createLoadEditFailedNetwork(Object entity) {
    return '수정할 $entity 정보를 불러오지 못했어요. 네트워크를 확인한 뒤 다시 시도해 주세요.';
  }

  @override
  String createLoadEditFailedServer(Object entity) {
    return '수정할 $entity 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
  }

  @override
  String get createValidationSelectCategory => '카테고리를 1개 이상 선택해 주세요.';

  @override
  String get createValidationSelectClassCategoryFirst =>
      '클래스에 맞는 카테고리를 먼저 선택해 주세요.';

  @override
  String get createValidationSelectPlaceOrManual => '장소를 선택하거나 직접 입력해 주세요.';

  @override
  String get createValidationSelectPlace => '장소를 선택해 주세요.';

  @override
  String createValidationEnterEntityName(Object entity) {
    return '$entity 이름을 입력해 주세요.';
  }

  @override
  String get createValidationTitleMaxLength => '이름은 40자 이내로 입력해 주세요.';

  @override
  String get createValidationDescriptionMaxLength => '설명은 1000자 이내로 입력해 주세요.';

  @override
  String get createValidationSelectDate => '날짜를 선택해 주세요.';

  @override
  String get createValidationNoPastDate => '지난 날짜는 선택할 수 없어요.';

  @override
  String get createValidationSelectStartEndTime => '시작 시간과 종료 시간을 모두 선택해 주세요.';

  @override
  String get createValidationEndAfterStart => '종료 시간은 시작 시간보다 늦어야 해요.';

  @override
  String get createValidationCapacityRange =>
      '참가 인원은 최소 2명, 최대 20명까지 설정할 수 있어요.';

  @override
  String get createValidationSelectDeadline => '모집 마감 날짜와 시간을 모두 선택해 주세요.';

  @override
  String get createValidationSelectDeadlineTogether =>
      '모집 마감 날짜와 시간을 함께 선택해 주세요.';

  @override
  String get createValidationDeadlineFuture => '모집 마감은 현재 시각 이후여야 해요.';

  @override
  String get createValidationDeadlineBeforeStart => '모집 마감은 시작 시간보다 빨라야 해요.';

  @override
  String get createValidationSelectLanguage => '사용 언어를 1개 이상 선택해 주세요.';

  @override
  String get createValidationSelectPriceType => '가격 유형을 선택해 주세요.';

  @override
  String get createValidationEnterPaidPrice => '유료일 경우 금액을 입력해 주세요.';

  @override
  String get createValidationPriceRange => '금액은 1원 이상 1000000원 이하로 입력해 주세요.';

  @override
  String get createValidationRegisterImage => '대표 이미지를 1장 이상 등록해 주세요.';

  @override
  String get createGroupInfoTitle => '모임 정보를 입력해 주세요';

  @override
  String get createClassInfoTitle => '클래스 정보를 입력해 주세요';

  @override
  String get createValidationIntro => '아래 필수 정보를 모두 입력하면 바로 등록할 수 있어요.';

  @override
  String get createSelectedCategoryTitle => '선택한 카테고리';

  @override
  String get createSelectedPlaceTitle => '선택한 장소';

  @override
  String get createGroupNameLabel => '모임 이름';

  @override
  String get createClassNameLabel => '클래스 이름';

  @override
  String get createGroupNameHint => '예) 북촌 한옥 산책 같이 가요';

  @override
  String get createClassNameHint => '예) 전통 다도 원데이 클래스';

  @override
  String get createDescriptionTitle => '상세 설명';

  @override
  String get createDescriptionHint => '진행 방식, 준비물, 참가자가 알면 좋은 내용을 적어 주세요.';

  @override
  String get createDateTimeTitle => '일정';

  @override
  String get createDateLabel => '활동 날짜';

  @override
  String get createDatePlaceholder => '날짜를 선택해 주세요';

  @override
  String get createStartTimeLabel => '시작 시간';

  @override
  String get createStartTimePlaceholder => '시작 시간을 선택해 주세요';

  @override
  String get createEndTimeLabel => '종료 시간';

  @override
  String get createEndTimePlaceholder => '종료 시간을 선택해 주세요';

  @override
  String get createCapacityTitle => '참가 인원';

  @override
  String createCapacityValue(int count) {
    return '$count명';
  }

  @override
  String get createCapacityHelper => '최소 2명, 최대 20명';

  @override
  String get createDeadlineTitle => '모집 마감';

  @override
  String get createDeadlineDateLabel => '마감 날짜';

  @override
  String get createDeadlineTimeLabel => '마감 시간';

  @override
  String get createNotSelected => '선택 안 함';

  @override
  String get createLanguagesTitle => '사용 언어';

  @override
  String get createPriceTitle => '참가 비용';

  @override
  String get createPaidPriceHint => '참가 금액을 입력해 주세요';

  @override
  String get createAudienceTitle => '추천 대상';

  @override
  String get createPrimaryImageTitle => '대표 이미지';

  @override
  String get createPrimaryImageRequiredHint => '대표 이미지를 1장 이상 등록해 주세요.';

  @override
  String get createPrimaryImageSelectionHint =>
      '첫 번째 이미지가 대표로 설정되며, 이미지를 눌러 대표 이미지를 바꿀 수 있어요.';

  @override
  String get createPrimaryImageBadge => '대표';

  @override
  String get createDeleting => '삭제 중...';

  @override
  String createDeleteAction(Object entity) {
    return '$entity 삭제하기';
  }

  @override
  String get createPlaceGroupTitle => '모임 장소를 선택해 주세요';

  @override
  String get createPlaceClassTitle => '클래스 장소를 선택해 주세요';

  @override
  String get createPlaceGroupDescription =>
      '추천 장소를 고르거나 직접 입력해서 모임 장소를 정할 수 있어요.';

  @override
  String get createPlaceClassDescription =>
      '카테고리에 맞는 장소를 검색하거나 직접 입력해서 클래스 장소를 정할 수 있어요.';

  @override
  String get createClassCategoryTitle => '클래스 카테고리';

  @override
  String get createCategoryDetailTitle => '세부 카테고리';

  @override
  String get createManualPlaceTitle => '직접 입력';

  @override
  String get createManualPlaceNameHint => '장소명을 입력해 주세요';

  @override
  String get createManualPlaceAddressHint => '주소를 입력해 주세요';

  @override
  String get createOrSearchTitle => '또는 장소 검색';

  @override
  String get createPlaceSearchHint => '장소명으로 검색해 보세요';

  @override
  String get createManualPlacePreviewDescription => '직접 입력한 장소 정보로 등록됩니다.';

  @override
  String get createSearchResultsTitle => '검색 결과';

  @override
  String get createSearchEmptyTitle => '검색 결과가 없어요';

  @override
  String get createSearchEmptyBody => '다른 검색어로 다시 찾아보세요.';

  @override
  String get createSearchInitialTitle => '장소를 검색해 보세요';

  @override
  String get createSearchInitialBody => '장소명이나 주소를 입력하면 선택할 수 있는 결과를 보여드려요.';

  @override
  String get createRecommendedTitle => '추천 장소';

  @override
  String get createRefresh => '새로고침';

  @override
  String get createRecommendedEmptyTitle => '추천 장소가 아직 없어요';

  @override
  String get createRecommendedEmptyBody => '카테고리를 바꾸거나 직접 검색해 보세요.';

  @override
  String get createMapPlaceholder => '장소를 선택하면 이 영역에 위치가 표시됩니다.';

  @override
  String get createCategoryPromptTitle => '어떤 경험을 만들고 있나요?';

  @override
  String get createCategoryPromptDescription =>
      '등록하려는 모임 또는 클래스에 가장 잘 맞는 카테고리를 선택해 주세요.';

  @override
  String get createCompletedEditDescription =>
      '변경한 내용이 저장되었어요. 참가자에게 바로 반영됩니다.';

  @override
  String get createCompletedCreateDescription => '이제 메이트야에서 참가자를 모집할 수 있어요.';

  @override
  String get createBackToPrevious => '이전으로';

  @override
  String get createBackToHome => '홈으로 돌아가기';

  @override
  String get createStepCategory => '카테고리';

  @override
  String get createStepPlaceGroup => '장소';

  @override
  String get createStepPlaceClass => '장소';

  @override
  String get createStepDetailsGroup => '정보 입력';

  @override
  String get createStepDetailsClass => '정보 입력';

  @override
  String get createCompletedProgress => '완료';

  @override
  String get createCategoryTitleCultureTradition => '문화/전통';

  @override
  String get createCategoryTitleEventPerformanceFestival => '행사/공연/축제';

  @override
  String get createCategoryTitleActivityLeports => '액티비티/레포츠';

  @override
  String get createCategoryDescriptionTourist => '대표 관광지에서 함께 둘러보는 모임에 적합해요.';

  @override
  String get createCategoryDescriptionTravelCourse =>
      '이동 동선이 있는 여행형 코스에 잘 맞아요.';

  @override
  String get createCategoryDescriptionCultureTradition =>
      '전통문화, 공예, 역사 체험 같은 활동에 추천해요.';

  @override
  String get createCategoryDescriptionFestival =>
      '공연, 축제, 시즌 이벤트 참여형 활동에 적합해요.';

  @override
  String get createCategoryDescriptionSports => '운동, 경기 관람, 스포츠 기반 모임에 어울려요.';

  @override
  String get createCategoryDescriptionActivityLeports =>
      '야외 체험이나 액티브한 레포츠 활동에 적합해요.';

  @override
  String get createCategoryDescriptionPublicFacility =>
      '전시, 공공 공간, 지역 커뮤니티 활동에 추천해요.';

  @override
  String get createCategoryDescriptionShopping => '시장, 쇼핑 거리, 로컬 상점 투어에 잘 맞아요.';

  @override
  String createEventDatePickerHelp(Object entity) {
    return '$entity 날짜 선택';
  }

  @override
  String get createStartTimePickerHelp => '시작 시간 선택';

  @override
  String get createEndTimePickerHelp => '종료 시간 선택';

  @override
  String get createDeadlineDatePickerHelp => '모집 마감 날짜 선택';

  @override
  String get createDeadlineTimePickerHelp => '모집 마감 시간 선택';

  @override
  String createDeleteDialogTitle(Object entity) {
    return '$entity을(를) 삭제할까요?';
  }

  @override
  String createDeleteDialogBody(Object entity) {
    return '삭제하면 되돌릴 수 없어요.';
  }

  @override
  String get createDeleteButton => '삭제';

  @override
  String get createDeleteCompleted => '삭제가 완료되었어요.';

  @override
  String createInitializationLoadError(Object entity) {
    return '$entity 정보를 불러오지 못했어요.';
  }

  @override
  String get createInitializationRetryBody =>
      '잠시 후 다시 시도해 주세요. 문제가 계속되면 이전 화면으로 돌아가 다시 진입해 주세요.';

  @override
  String createSavingEntity(Object entity) {
    return '$entity 저장 중...';
  }

  @override
  String createSubmittingEntity(Object entity) {
    return '$entity 등록 중...';
  }

  @override
  String get createSelectPlaceAction => '장소 선택하기';

  @override
  String get createImagePickerNotice =>
      '이미지를 첨부하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 다른 정보 입력은 계속할 수 있어요.';

  @override
  String get createImagePickerRecovery =>
      '이미지 첨부를 계속하려면 사진 보관함 접근 권한이 필요합니다. 다시 시도하거나 앱 설정에서 권한을 허용해 주세요.';

  @override
  String get createImagePickerFailure =>
      '이미지를 불러오지 못했어요. 파일 상태를 확인한 뒤 다시 시도해 주세요.';

  @override
  String get createImagePickerRestoreFallback =>
      '이전에 선택하던 이미지를 복구하지 못했어요. 다시 선택해 주세요.';

  @override
  String createImagePickerRestoredCount(int count) {
    return '이전에 선택한 이미지 $count장을 복구했어요.';
  }

  @override
  String get createRecommendedLoadFailedNetwork =>
      '추천 장소를 불러오지 못했어요. 네트워크 상태를 확인해 주세요.';

  @override
  String get createRecommendedLoadFailedServer =>
      '추천 장소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get createPlaceSearchQueryRequired => '장소명을 입력해 주세요.';

  @override
  String get createPlaceSearchFailedNetwork =>
      '장소 검색에 실패했어요. 연결 상태를 확인한 뒤 다시 시도해 주세요.';

  @override
  String get createPlaceSearchFailedServer => '장소 검색에 실패했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get createPlaceCoordinateRequired => '위치 정보가 없는 장소라 선택할 수 없어요.';

  @override
  String get createPlaceMapCoordinateRequired => '위치 정보가 없는 장소라 지도에 표시할 수 없어요.';

  @override
  String createImageLimitExceeded(int max) {
    return '이미지는 최대 $max장까지 등록할 수 있어요.';
  }

  @override
  String get createImageInvalidFormat =>
      'JPG, PNG, WEBP, GIF 형식의 이미지만 등록할 수 있어요.';

  @override
  String get createImageMaxSize => '이미지 한 장당 최대 10MB까지 등록할 수 있어요.';

  @override
  String get createPlaceDescriptionFallback => '위치를 확인한 뒤 선택해 주세요.';

  @override
  String get createExistingPlaceDescription => '기존 활동 장소';

  @override
  String get createResolveServerCategoryFailed =>
      '선택한 장소에서 서버 카테고리를 확정할 수 없어요. 다른 장소를 선택해 주세요.';

  @override
  String get createUploadImageRequired => '대표 이미지를 1장 이상 등록해 주세요.';

  @override
  String get createUploadImageInvalidFormat =>
      'JPG, PNG, WEBP, GIF 형식의 이미지만 업로드할 수 있어요.';

  @override
  String get createUploadImageFailed => '이미지 업로드에 실패했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get createUploadImageConfirmFailed =>
      '이미지 업로드 확인에 실패했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get onboardingValidationNameRequired => '이름을 입력해 주세요.';

  @override
  String get onboardingValidationNameMaxLength => '이름은 30자 이내로 입력해 주세요.';

  @override
  String get onboardingValidationNameCharacters => '숫자와 특수문자 없이 이름만 입력해 주세요.';

  @override
  String get onboardingValidationPhoneRequired => '전화번호를 입력해 주세요.';

  @override
  String get onboardingValidationPhoneDigitsOnly => '전화번호는 숫자만 입력해 주세요.';

  @override
  String get onboardingValidationPhoneMaxLength => '전화번호는 최대 15자리까지 입력할 수 있어요.';

  @override
  String get onboardingValidationPhoneInvalid => '전화번호를 정확히 입력해 주세요.';

  @override
  String get onboardingValidationVerificationCodeRequired =>
      '인증번호 6자리를 입력해 주세요.';

  @override
  String get onboardingValidationVerificationExpired =>
      '인증 시간이 만료됐어요. 인증번호를 다시 받아 주세요.';

  @override
  String get onboardingValidationVerificationMismatch => '인증번호가 일치하지 않아요.';

  @override
  String get onboardingValidationBusinessNameRequired => '상호명을 입력해 주세요.';

  @override
  String get onboardingValidationOpeningDateRequired => '개업일자 8자리를 입력해 주세요.';

  @override
  String get onboardingValidationOpeningDateDigitsOnly => '개업일자는 숫자만 입력해 주세요.';

  @override
  String get onboardingValidationOpeningDateInvalid => '개업일자를 정확히 입력해 주세요.';

  @override
  String get onboardingValidationBusinessNumberRequired =>
      '사업자 번호 10자리를 정확히 입력해 주세요.';

  @override
  String get onboardingValidationBusinessNumberDigitsOnly =>
      '사업자 번호는 숫자만 입력해 주세요.';

  @override
  String get onboardingLocationErrorServiceDisabled =>
      '위치 서비스가 꺼져 있어요. 직접 입력으로 진행해 주세요.';

  @override
  String get onboardingLocationErrorPermissionDenied =>
      '위치 권한이 없으면 현재 위치 자동 인증을 사용할 수 없어요. 직접 입력은 계속 진행할 수 있고, 권한을 허용하면 다시 시도할 수 있어요.';

  @override
  String get onboardingLocationErrorPermissionPermanentlyDenied =>
      '위치 권한이 꺼져 있어 현재 위치 자동 인증을 사용할 수 없어요. 앱 설정에서 권한을 허용하거나 직접 입력으로 계속 진행해 주세요.';

  @override
  String get onboardingLocationErrorAccuracyLow => '위치 정확도가 낮아 자동 인증이 어려워요.';

  @override
  String get onboardingLocationErrorAddressNotFound =>
      '주소를 찾지 못했어요. 직접 입력으로 진행해 주세요.';

  @override
  String get onboardingLocationErrorUnknown =>
      '위치를 불러오지 못했어요. 직접 입력으로 진행해 주세요.';

  @override
  String get onboardingLocationQueryRequired => '동네명을 입력해 주세요.';

  @override
  String get onboardingLocationQueryNotFound => '입력한 동네를 찾지 못했어요.';

  @override
  String get onboardingLocationCurrentFallback => '현재 위치';

  @override
  String homeParticipantCount(int current, int capacity) {
    return '$current/$capacity 참여';
  }

  @override
  String get homeFavoritesSubtitle => '당신의 관심을 세상과 공유하세요.';

  @override
  String get homeFavoritesEmptyTitle => '아직 즐겨찾기한 활동이 없어요.';

  @override
  String get homeFavoritesEmptyDescription => '마음에 드는 활동을 저장하면 여기서 다시 볼 수 있어요.';

  @override
  String get homeNearbyCultureMap => '내 주변 전통문화';

  @override
  String get onboardingTermsPendingEffectiveDate => '확인 중';

  @override
  String get onboardingTermsServiceTitle => '서비스 이용 약관';

  @override
  String get onboardingTermsServiceSummary =>
      '메이트야 서비스 이용을 위한 기본 조건, 이용자 책임, 서비스 운영 기준을 안내합니다.';

  @override
  String get onboardingTermsServiceSection1Title => '서비스 목적';

  @override
  String get onboardingTermsServiceSection1Body =>
      '메이트야는 국내 사용자와 외국인이 모임, 클래스, 지역 기반 활동을 안전하게 탐색하고 참여할 수 있도록 연결하는 플랫폼입니다.';

  @override
  String get onboardingTermsServiceSection2Title => '회원가입 및 계정 관리';

  @override
  String get onboardingTermsServiceSection2Body =>
      '회원은 본인 명의의 정보로 가입해야 하며, 휴대전화 인증과 약관 동의를 완료해야 서비스를 이용할 수 있습니다. 계정 정보가 변경되면 최신 상태로 유지해야 합니다.';

  @override
  String get onboardingTermsServiceSection3Title => '서비스 이용 조건';

  @override
  String get onboardingTermsServiceSection3Body =>
      '회원은 관련 법령과 본 약관을 준수해야 하며, 타인의 권리를 침해하거나 서비스 운영을 방해하는 행위를 해서는 안 됩니다. 일부 기능은 본인 확인이나 추가 인증이 필요할 수 있습니다.';

  @override
  String get onboardingTermsServiceSection4Title => '금지 행위';

  @override
  String get onboardingTermsServiceSection4Body =>
      '허위 정보 등록, 타인 사칭, 불법 홍보, 음란물 또는 혐오 표현 게시, 비정상적인 자동화 접근, 운영 정책 우회를 위한 시도는 금지됩니다. 위반 시 게시물 삭제, 이용 제한, 계정 정지 조치가 이루어질 수 있습니다.';

  @override
  String get onboardingTermsServiceSection5Title => '서비스 중단 및 변경';

  @override
  String get onboardingTermsServiceSection5Body =>
      '메이트야는 점검, 장애 대응, 정책 변경 또는 외부 제휴 사정에 따라 서비스 일부를 변경하거나 일시 중단할 수 있습니다. 중요한 변경은 앱 내 공지 또는 적절한 수단으로 안내합니다.';

  @override
  String get onboardingTermsServiceSection6Title => '책임 제한';

  @override
  String get onboardingTermsServiceSection6Body =>
      '메이트야는 천재지변, 통신 장애, 이용자 귀책 사유로 발생한 손해에 대해 법령이 허용하는 범위에서 책임을 제한할 수 있습니다. 다만 회사의 고의 또는 중대한 과실이 있는 경우에는 예외로 합니다.';

  @override
  String get onboardingTermsServiceSection7Title => '문의처';

  @override
  String get onboardingTermsServiceSection7Body =>
      '서비스 이용 중 문의가 필요하면 앱 내 고객지원 채널 또는 운영팀 이메일을 통해 접수할 수 있으며, 접수된 내용은 운영 정책에 따라 순차적으로 처리됩니다.';

  @override
  String get onboardingTermsPrivacyTitle => '개인정보 제3자 제공 동의';

  @override
  String get onboardingTermsPrivacySummary =>
      '활동 운영, 예약 진행, 고객 응대에 필요한 범위에서 개인정보가 제3자에게 제공되는 기준을 설명합니다.';

  @override
  String get onboardingTermsPrivacySection1Title => '제공받는 자';

  @override
  String get onboardingTermsPrivacySection1Body =>
      '메이트야 내 모임/클래스를 운영하는 호스트 또는 서비스 운영에 필요한 제휴 사업자';

  @override
  String get onboardingTermsPrivacySection2Title => '제공 목적';

  @override
  String get onboardingTermsPrivacySection2Body =>
      '참여 신청 확인, 호스트와의 원활한 일정 조율, 현장 운영 지원, 고객 문의 대응 및 분쟁 처리';

  @override
  String get onboardingTermsPrivacySection3Title => '제공 항목';

  @override
  String get onboardingTermsPrivacySection3Body =>
      '이름, 휴대전화 번호, 활동 신청 정보, 대표 언어, 참여 이력 중 서비스 제공에 필요한 최소 항목';

  @override
  String get onboardingTermsPrivacySection4Title => '보유 및 이용 기간';

  @override
  String get onboardingTermsPrivacySection4Body =>
      '제공 목적 달성 시까지 또는 관련 법령상 보존 의무 기간까지 보관되며, 이후에는 지체 없이 삭제하거나 익명화합니다.';

  @override
  String get onboardingTermsPrivacySection5Title => '동의 거부 권리 및 불이익';

  @override
  String get onboardingTermsPrivacySection5Body =>
      '회원은 개인정보 제3자 제공 동의를 거부할 수 있습니다. 다만 활동 참여, 예약 확인, 호스트와의 연락이 필요한 일부 서비스 이용이 제한될 수 있습니다.';

  @override
  String get onboardingTermsLocationTitle => '위치기반서비스 이용약관';

  @override
  String get onboardingTermsLocationSummary =>
      '현재 위치와 활동 지역 정보를 활용해 주변 모임과 추천 결과를 제공하는 방식 및 보호 기준을 안내합니다.';

  @override
  String get onboardingTermsLocationSection1Title => '목적';

  @override
  String get onboardingTermsLocationSection1Body =>
      '본 약관은 메이트야가 제공하는 위치기반서비스의 이용조건과 절차, 회사와 이용자의 권리 및 의무, 위치정보 보호 기준을 안내하는 데 목적이 있습니다.';

  @override
  String get onboardingTermsLocationSection2Title => '위치정보 수집 및 이용';

  @override
  String get onboardingTermsLocationSection2Body =>
      '회사는 이용자가 요청한 기능 범위 안에서 현재 위치 또는 활동 지역 정보를 활용하며, 다음 목적에 한해 위치정보를 이용합니다.';

  @override
  String get onboardingTermsLocationSection2Point1 => '동네 인증과 활동 지역 확인';

  @override
  String get onboardingTermsLocationSection2Point2 => '주변 모임 추천 및 거리 기반 정렬';

  @override
  String get onboardingTermsLocationSection2Point3 =>
      '지역 맞춤형 콘텐츠와 안전한 참여 경험 제공';

  @override
  String get onboardingTermsLocationSection3Title => '보유 및 이용기간';

  @override
  String get onboardingTermsLocationSection3Body =>
      '실시간 위치정보는 즉시성 기능 처리 후 보관하지 않습니다. 다만 활동 지역 인증 결과와 같이 서비스 운영에 필요한 최소 정보는 관련 법령 또는 내부 운영 기준에 따라 필요한 기간 동안 보관한 뒤 지체 없이 삭제하거나 익명화합니다.';

  @override
  String get onboardingTermsLocationSection4Title => '이용자의 권리';

  @override
  String get onboardingTermsLocationSection4Body =>
      '이용자는 언제든지 단말기 설정 또는 앱 내 권한 설정을 통해 위치정보 제공 동의를 철회할 수 있으며, 위치기반서비스 이용 여부를 선택할 수 있습니다. 동의 철회 시 일부 추천 기능이나 동네 인증 기능 이용이 제한될 수 있습니다.';

  @override
  String get onboardingTermsLocationSection5Title => '회사의 의무';

  @override
  String get onboardingTermsLocationSection5Body =>
      '회사는 위치정보를 관련 법령과 내부 보안 기준에 따라 안전하게 관리하며, 이용 목적 범위를 벗어난 사용이나 별도 동의 없는 제3자 제공을 하지 않습니다. 또한 이용자의 문의와 민원을 신속하게 확인하고 필요한 조치를 안내합니다.';

  @override
  String get onboardingTermsLocationSection6Title => '문의처';

  @override
  String get onboardingTermsLocationSection6Body =>
      '위치기반서비스 이용과 관련한 문의는 앱 내 고객지원 채널 또는 운영팀 문의 창구를 통해 접수할 수 있습니다. 접수된 문의는 내부 정책에 따라 순차적으로 처리됩니다.';

  @override
  String get onboardingTermsAgeTitle => '만 14세 이상 확인';

  @override
  String get onboardingTermsAgeSummary =>
      '메이트야 회원가입은 만 14세 이상만 가능하며, 연령 확인과 관련한 이용 제한 기준을 안내합니다.';

  @override
  String get onboardingTermsAgeSection1Title => '연령 확인';

  @override
  String get onboardingTermsAgeSection1Body =>
      '회원은 회원가입 시 본인이 만 14세 이상임을 확인하고 이에 동의해야 합니다.';

  @override
  String get onboardingTermsAgeSection2Title => '가입 제한';

  @override
  String get onboardingTermsAgeSection2Body =>
      '만 14세 미만 사용자는 메이트야 회원가입 및 서비스 이용이 제한됩니다.';

  @override
  String get onboardingTermsAgeSection3Title => '허위 확인에 대한 조치';

  @override
  String get onboardingTermsAgeSection3Body =>
      '연령을 허위로 확인하여 가입한 사실이 확인되면 서비스 이용 제한, 계정 해지 또는 필요한 추가 확인 절차가 진행될 수 있습니다.';

  @override
  String get chatAttachmentRecoveryFailed =>
      '이전에 선택하던 사진을 복구하지 못했어요. 다시 선택해 주세요.';

  @override
  String get chatAttachmentSheetTitle => '사진 첨부';

  @override
  String get chatAttachmentSheetDescription =>
      '앨범에서 여러 장을 고르거나 카메라로 바로 촬영해 보낼 수 있어요.';

  @override
  String get chatAttachmentGalleryTitle => '앨범에서 선택';

  @override
  String get chatAttachmentGallerySubtitle => '여러 장을 한 번에 고를 수 있습니다.';

  @override
  String get chatAttachmentCameraTitle => '카메라로 촬영';

  @override
  String get chatAttachmentCameraSubtitle => '사진 1장을 바로 찍어 첨부합니다.';

  @override
  String get chatAttachmentGuideFormats =>
      '허용 형식: JPG, PNG, WEBP, GIF, HEIC, HEIF';

  @override
  String get chatAttachmentGuideMaxSize => '최대 크기: 10MB';

  @override
  String chatAttachmentGuideMaxCount(int count) {
    return '메시지당 최대 $count장';
  }

  @override
  String get chatAttachmentPhotoPermissionTitle => '사진 권한 안내';

  @override
  String get chatAttachmentCameraPermissionTitle => '카메라 권한 안내';

  @override
  String get chatAttachmentPhotoPermissionMessage =>
      '채팅에서 사진을 첨부하려면 사진 보관함 접근 권한이 필요합니다. 권한을 거부하셔도 텍스트 채팅은 계속 이용할 수 있습니다.';

  @override
  String get chatAttachmentCameraPermissionMessage =>
      '채팅에서 사진을 바로 촬영해 보내려면 카메라 권한이 필요합니다. 권한을 거부하셔도 텍스트 채팅은 계속 이용할 수 있습니다.';

  @override
  String get chatAttachmentPhotoSelect => '사진 선택하기';

  @override
  String get chatAttachmentOpenCamera => '카메라 열기';

  @override
  String get chatAttachmentPhotoRecoveryTitle => '사진 권한이 필요해요';

  @override
  String get chatAttachmentCameraRecoveryTitle => '카메라 권한이 필요해요';

  @override
  String get chatAttachmentPhotoRecoveryMessage =>
      '사진 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 텍스트 채팅은 계속할 수 있고, 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.';

  @override
  String get chatAttachmentCameraRecoveryMessage =>
      '사진 촬영 첨부를 사용하려면 카메라 권한이 필요합니다. 권한이 없어도 텍스트 채팅은 계속할 수 있고, 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.';

  @override
  String get chatAttachmentLoadFailed => '사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.';

  @override
  String chatAttachmentAddedCount(int count) {
    return '사진 $count장을 첨부했어요.';
  }

  @override
  String chatAttachmentRejectedTypeCount(int count) {
    return '지원하지 않는 형식의 사진 $count장은 제외했어요.';
  }

  @override
  String chatAttachmentRejectedSizeCount(int count) {
    return '10MB를 초과한 사진 $count장은 제외했어요.';
  }

  @override
  String chatAttachmentOverflowCount(int count) {
    return '사진은 최대 $count장까지 첨부할 수 있어요.';
  }

  @override
  String get chatAttachmentPhotoOnly => '사진';

  @override
  String get chatAttachmentInvalidFormat =>
      'JPG, PNG, WEBP, GIF, HEIC, HEIF 형식의 이미지만 전송할 수 있어요.';

  @override
  String get chatAttachmentUploadFailed =>
      '채팅 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get chatListLoadError => '채팅 목록을 불러오지 못했어요.';

  @override
  String get chatListEmptyTitle => '표시할 채팅방이 없어요.';

  @override
  String get chatListEmptyBody => '필터를 바꾸거나 새로운 대화를 시작해 보세요.';

  @override
  String get chatListLoadMoreHint => '스크롤하면 채팅방을 더 불러옵니다.';

  @override
  String get chatListLoadMoreFailedNetwork =>
      '채팅 목록을 더 불러오지 못했어요. 네트워크를 확인해 주세요.';

  @override
  String get chatListLoadMoreFailedServer =>
      '채팅 목록을 더 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get chatRoomMissing => '채팅방 정보를 찾을 수 없어요.';

  @override
  String get chatBackToList => '목록으로';

  @override
  String get chatRoomLoadError => '채팅방을 불러오지 못했어요.';

  @override
  String get chatOlderMessagesHint => '위로 스크롤하면 이전 메시지를 더 불러옵니다.';

  @override
  String get chatOlderMessagesFailedNetwork =>
      '이전 메시지를 불러오지 못했어요. 네트워크를 확인해 주세요.';

  @override
  String get chatOlderMessagesFailedServer =>
      '이전 메시지를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get chatReadSyncFailed => '읽음 상태를 서버에 반영하지 못했어요. 다음에 다시 시도합니다.';

  @override
  String get chatSendFailedNetwork => '메시지를 전송하지 못했어요. 네트워크를 확인해 주세요.';

  @override
  String get chatSendFailedServer => '메시지를 전송하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get chatMe => '나';

  @override
  String get chatDefaultDirectRoomTitle => '1:1 채팅';

  @override
  String get chatDefaultGroupRoomTitle => '채팅방';

  @override
  String get chatRealtimeConnectionError => '실시간 채팅 연결에 실패했어요.';

  @override
  String get chatRealtimeMessageError => '실시간 채팅 메시지를 처리하지 못했어요.';

  @override
  String get homeActivityRegionFallback => '활동 지역';

  @override
  String get homeNearbyMapLoadError => '지도 장소를 불러오지 못했어요.';

  @override
  String get homeNearbyMapCurrentLocationLabel => '현재 위치 기준';

  @override
  String get homeNearbyMapSearchHint => '무엇을 찾아볼까요?';

  @override
  String get homeNearbyMapEmptyTitle => '주변 장소를 찾지 못했어요';

  @override
  String get homeNearbyMapEmptyBody => '검색어를 바꾸거나 현재 위치를 다시 불러와 보세요.';

  @override
  String get homeNearbyMapListTitle => '주변 장소 목록';

  @override
  String homeNearbyMapPlaceCount(int count) {
    return '$count곳';
  }

  @override
  String get homeNearbyMapListButton => '목록보기';

  @override
  String get homeNearbyMapBadgeFallback => '주변 장소';

  @override
  String get homeNearbyMapParseError => '장소 데이터를 해석하지 못했어요.';

  @override
  String get homeNearbyMapLocationLoadError => '현재 위치를 가져오지 못했어요.';

  @override
  String get homeNearbyMapLocationRefreshError => '현재 위치를 다시 가져오지 못했어요.';

  @override
  String get homeNearbyMapLocationRequired => '지도를 보려면 위치 정보를 먼저 확인해 주세요.';

  @override
  String get homeNearbyMapPlacesLoadError => '장소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsActivityRequired => '활동 정보를 먼저 불러와야 합니다.';

  @override
  String get detailsFavoriteToggleError =>
      '즐겨찾기 상태를 변경하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsJoinAlreadyRequested => '이미 참여 신청한 활동입니다.';

  @override
  String get detailsJoinAlreadyJoined => '이미 참여 중인 활동입니다.';

  @override
  String get detailsJoinHostedByMe => '내가 만든 활동입니다.';

  @override
  String get detailsJoinRequestError => '참여 신청을 완료하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsParticipantRemoveError =>
      '참여자를 삭제하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsPendingCancelError => '신청을 취소하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsPendingApproveError => '참여 신청을 승인하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsReviewRequired => '후기 정보를 먼저 불러와야 합니다.';

  @override
  String get detailsHelpfulToggleError =>
      '도움이 돼요 상태를 변경하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsReviewValidationRequired => '별점과 후기를 입력해 주세요.';

  @override
  String get detailsReviewSubmitError => '후기를 등록하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsLoadError => '활동 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsReviewSortLatest => '최신순';

  @override
  String get detailsReviewSortOldest => '오래된순';

  @override
  String get detailsReviewSortHighestRating => '평점 높은순';

  @override
  String get detailsReviewSortLowestRating => '평점 낮은순';

  @override
  String get detailsJoinAvailable => '참가하기';

  @override
  String get detailsJoinRequested => '신청 완료';

  @override
  String get detailsJoinJoined => '참가중';

  @override
  String get detailsJoinHost => '내 모임';

  @override
  String detailsReviewSummary(Object average, int count) {
    return '$average (후기 $count개)';
  }

  @override
  String detailsParticipantSummary(int current, int capacity) {
    return '$current/$capacity 참여';
  }

  @override
  String detailsParticipantsJoined(int count) {
    return '$count명 참여중';
  }

  @override
  String detailsParticipantsRemaining(int count) {
    return '$count명 남았어요';
  }

  @override
  String get detailsRecruitmentClosed => '모집 마감';

  @override
  String get detailsIntroduction => '활동 소개';

  @override
  String detailsReviewsTitle(int count) {
    return '후기 $count개';
  }

  @override
  String get detailsReviewsEmpty => '아직 등록된 후기가 없어요. 첫 후기를 남겨보세요.';

  @override
  String get detailsPriceLabel => '체험료';

  @override
  String get detailsJoinRequesting => '신청 중...';

  @override
  String detailsReviewRatingSummary(int count) {
    return '전체 $count개 후기';
  }

  @override
  String detailsReviewRating(int rating) {
    return '$rating점';
  }

  @override
  String detailsReviewHelpfulCount(int count) {
    return '$count명에게 도움이 됨';
  }

  @override
  String get detailsReviewViewOriginal => '원문 보기';

  @override
  String get detailsReviewViewTranslation => '번역 보기';

  @override
  String get detailsRepresentativeImage => '대표';

  @override
  String get detailsReviewGalleryNotice =>
      '후기에 사진을 첨부하려면 사진 보관함 접근 권한이 필요합니다. 권한을 거부하셔도 후기 텍스트 작성과 평점 등록은 계속할 수 있습니다.';

  @override
  String get detailsReviewGalleryRecovery =>
      '후기 사진 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 텍스트 후기와 평점 등록은 계속할 수 있고, 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.';

  @override
  String get detailsReviewGalleryFailure =>
      '사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.';

  @override
  String get detailsReviewGalleryRestoreError =>
      '이전에 선택하던 후기 이미지를 복구하지 못했어요. 다시 선택해 주세요.';

  @override
  String detailsReviewRestoredCount(int restoredCount) {
    return '이전에 선택하던 후기 이미지 $restoredCount장을 복구했어요.';
  }

  @override
  String get detailsReviewSubmitted => '후기를 등록했어요.';

  @override
  String get detailsReviewComposerTitle => '후기 작성하기';

  @override
  String get detailsReviewComposerHint =>
      '활동에서 좋았던 점이나 다음 참가자에게 도움이 될\n내용을 남겨 주세요.';

  @override
  String detailsBodyCount(int count, int max) {
    return '$count/$max자';
  }

  @override
  String detailsReviewImageSectionTitle(int max) {
    return '이미지 (최대 $max장)';
  }

  @override
  String get detailsReviewSubmitting => '작성 중...';

  @override
  String get detailsReviewSubmit => '작성하기';

  @override
  String get detailsReviewImageGuide =>
      '첫 번째 사진이 대표 이미지가 되며,\n길게 눌러 순서를 바꿀 수 있어요.';

  @override
  String get detailsShareCopied => '공유 링크를 복사했어요. 원하는 메신저에 바로 붙여넣을 수 있습니다.';

  @override
  String get detailsReportActivityReload => '활동 정보를 다시 불러온 뒤 신고해 주세요.';

  @override
  String get detailsParticipantsListTitle => '참여 유저 목록';

  @override
  String get detailsParticipantRemoved => '참여자를 삭제했어요.';

  @override
  String get detailsPendingParticipantsListTitle => '신청 유저 목록';

  @override
  String get detailsPendingCancelled => '신청을 취소했어요.';

  @override
  String get detailsParticipantSwipeHint => '슬라이드 해서 삭제하거나 취소할 수 있어요';

  @override
  String detailsReviewListReportSubject(Object title) {
    return '$title 리뷰 목록';
  }

  @override
  String get detailsReviewLoadMoreHint => '스크롤하면 후기를 더 불러옵니다.';

  @override
  String get detailsReviewImageInvalidFormat =>
      'JPG, PNG, WEBP, GIF 형식의 리뷰 이미지만 업로드할 수 있어요.';

  @override
  String get detailsReviewImageUploadError =>
      '리뷰 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get detailsMe => '나';

  @override
  String get commonInvalidServerResponse => '서버 응답 형식이 올바르지 않습니다.';

  @override
  String onboardingVerificationResendLimitNotice(int count) {
    return '인증번호는 하루 최대 5번까지 다시 받을 수 있어요. 현재 $count회 요청했어요.';
  }

  @override
  String get onboardingVerificationResendLimitReached =>
      '인증번호는 하루 최대 5번까지 다시 받을 수 있어요.';

  @override
  String get onboardingVerificationSent => '인증번호를 발송했어요.';

  @override
  String get onboardingVerificationResent => '인증번호를 다시 보냈어요.';

  @override
  String get onboardingBusinessVerificationCompleted =>
      '사업자 인증이 완료됐어요. 휴대폰 인증을 이어서 진행해 주세요.';

  @override
  String get onboardingConsentRequired => '필수 약관에 모두 동의해 주세요.';

  @override
  String get homeExploreLoadMoreFailedNetwork =>
      '추가 결과를 불러오지 못했어요. 네트워크를 확인해 주세요.';

  @override
  String get homeExploreLoadMoreFailedServer =>
      '추가 결과를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
}
