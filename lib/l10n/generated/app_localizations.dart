import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'MateYa'**
  String get appTitle;

  /// No description provided for @brandLockupSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'한국의 정과 문화를 나누는\n특별한 여정의 시작'**
  String get brandLockupSubtitle;

  /// No description provided for @languageKorean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @languageEnglish.
  ///
  /// In ko, this message translates to:
  /// **'영어'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In ko, this message translates to:
  /// **'일본어'**
  String get languageJapanese;

  /// No description provided for @languageChineseSimplified.
  ///
  /// In ko, this message translates to:
  /// **'중국어'**
  String get languageChineseSimplified;

  /// No description provided for @bottomNavigationHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get bottomNavigationHome;

  /// No description provided for @bottomNavigationExplore.
  ///
  /// In ko, this message translates to:
  /// **'둘러보기'**
  String get bottomNavigationExplore;

  /// No description provided for @bottomNavigationChat.
  ///
  /// In ko, this message translates to:
  /// **'채팅'**
  String get bottomNavigationChat;

  /// No description provided for @bottomNavigationProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get bottomNavigationProfile;

  /// No description provided for @commonConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get commonRetry;

  /// No description provided for @commonContinue.
  ///
  /// In ko, this message translates to:
  /// **'계속'**
  String get commonContinue;

  /// No description provided for @commonLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get commonLater;

  /// No description provided for @commonAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get commonAll;

  /// No description provided for @commonNext.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get commonNext;

  /// No description provided for @commonReset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get commonReset;

  /// No description provided for @commonApply.
  ///
  /// In ko, this message translates to:
  /// **'적용하기'**
  String get commonApply;

  /// No description provided for @commonProcessing.
  ///
  /// In ko, this message translates to:
  /// **'처리 중...'**
  String get commonProcessing;

  /// No description provided for @commonFree.
  ///
  /// In ko, this message translates to:
  /// **'무료'**
  String get commonFree;

  /// No description provided for @commonToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get commonToday;

  /// No description provided for @commonTomorrow.
  ///
  /// In ko, this message translates to:
  /// **'내일'**
  String get commonTomorrow;

  /// No description provided for @permissionOpenAppSettings.
  ///
  /// In ko, this message translates to:
  /// **'앱 설정 열기'**
  String get permissionOpenAppSettings;

  /// No description provided for @permissionOpenLocationSettings.
  ///
  /// In ko, this message translates to:
  /// **'위치 설정 열기'**
  String get permissionOpenLocationSettings;

  /// No description provided for @locationServiceDisabledTitle.
  ///
  /// In ko, this message translates to:
  /// **'위치 서비스가 꺼져 있어요'**
  String get locationServiceDisabledTitle;

  /// No description provided for @locationPermissionDisabledTitle.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 꺼져 있어요'**
  String get locationPermissionDisabledTitle;

  /// No description provided for @languageDialogBarrierLabel.
  ///
  /// In ko, this message translates to:
  /// **'언어 선택'**
  String get languageDialogBarrierLabel;

  /// No description provided for @languageDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'언어 변경'**
  String get languageDialogTitle;

  /// No description provided for @languageDialogSupportedLanguages.
  ///
  /// In ko, this message translates to:
  /// **'지원 언어'**
  String get languageDialogSupportedLanguages;

  /// No description provided for @onboardingStart.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get onboardingStart;

  /// No description provided for @onboardingBusinessPrompt.
  ///
  /// In ko, this message translates to:
  /// **'사업자 이신가요? '**
  String get onboardingBusinessPrompt;

  /// No description provided for @onboardingStartAsHost.
  ///
  /// In ko, this message translates to:
  /// **'호스트로 시작하기'**
  String get onboardingStartAsHost;

  /// No description provided for @onboardingConsentTitle.
  ///
  /// In ko, this message translates to:
  /// **'메이트야 이용시 동의가 필요합니다.'**
  String get onboardingConsentTitle;

  /// No description provided for @onboardingAgreeAll.
  ///
  /// In ko, this message translates to:
  /// **'모두 동의'**
  String get onboardingAgreeAll;

  /// No description provided for @onboardingAgreeAllHelper.
  ///
  /// In ko, this message translates to:
  /// **'아래 필수 및 선택항목에 모두 동의합니다.'**
  String get onboardingAgreeAllHelper;

  /// No description provided for @onboardingRequiredAgreementLabel.
  ///
  /// In ko, this message translates to:
  /// **'(필수) {title}'**
  String onboardingRequiredAgreementLabel(Object title);

  /// No description provided for @onboardingEnterName.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해 주세요'**
  String get onboardingEnterName;

  /// No description provided for @onboardingEnterPhoneNumber.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰 번호를 입력해주세요'**
  String get onboardingEnterPhoneNumber;

  /// No description provided for @onboardingEnterVerificationCode.
  ///
  /// In ko, this message translates to:
  /// **'인증번호를 입력해주세요'**
  String get onboardingEnterVerificationCode;

  /// No description provided for @onboardingPhoneNumberLabel.
  ///
  /// In ko, this message translates to:
  /// **'전화번호'**
  String get onboardingPhoneNumberLabel;

  /// No description provided for @onboardingPhoneNumberHint.
  ///
  /// In ko, this message translates to:
  /// **'예)01012341234'**
  String get onboardingPhoneNumberHint;

  /// No description provided for @onboardingPhoneNumberHelper.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰 번호를 입력하면 인증번호를 받을 수 있어요.'**
  String get onboardingPhoneNumberHelper;

  /// No description provided for @onboardingVerificationCodeLabel.
  ///
  /// In ko, this message translates to:
  /// **'인증번호'**
  String get onboardingVerificationCodeLabel;

  /// No description provided for @onboardingVerificationCodeHint.
  ///
  /// In ko, this message translates to:
  /// **'인증번호 받기를 누르면 입력할 수 있어요.'**
  String get onboardingVerificationCodeHint;

  /// No description provided for @onboardingResendVerificationCode.
  ///
  /// In ko, this message translates to:
  /// **'인증번호 다시받기'**
  String get onboardingResendVerificationCode;

  /// No description provided for @onboardingDebugVerificationCode.
  ///
  /// In ko, this message translates to:
  /// **'테스트용 인증번호: {code}'**
  String onboardingDebugVerificationCode(Object code);

  /// No description provided for @onboardingVerify.
  ///
  /// In ko, this message translates to:
  /// **'인증하기'**
  String get onboardingVerify;

  /// No description provided for @onboardingRequestVerificationCode.
  ///
  /// In ko, this message translates to:
  /// **'인증번호 받기'**
  String get onboardingRequestVerificationCode;

  /// No description provided for @onboardingLocationServiceDisabledMessage.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치로 동네 인증을 진행하려면 기기 위치 서비스를 켜야 합니다. 켜지 않아도 동네를 직접 입력해 가입을 계속할 수 있습니다.'**
  String get onboardingLocationServiceDisabledMessage;

  /// No description provided for @onboardingLocationPermissionDisabledMessage.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치 자동 인증을 사용하려면 앱 설정에서 위치 권한을 허용해야 합니다. 권한을 허용하지 않아도 직접 입력으로 가입을 계속할 수 있습니다.'**
  String get onboardingLocationPermissionDisabledMessage;

  /// No description provided for @onboardingPreviousNeighborhood.
  ///
  /// In ko, this message translates to:
  /// **'이전에 \"{name}\"으로 등록했어요.'**
  String onboardingPreviousNeighborhood(Object name);

  /// No description provided for @onboardingResolvingCurrentLocation.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 확인하고 있어요.'**
  String get onboardingResolvingCurrentLocation;

  /// No description provided for @onboardingCompleteNeighborhood.
  ///
  /// In ko, this message translates to:
  /// **'동네인증 완료하기'**
  String get onboardingCompleteNeighborhood;

  /// No description provided for @onboardingRetryLocationPermission.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치 권한 다시 요청'**
  String get onboardingRetryLocationPermission;

  /// No description provided for @onboardingRetryAfterSettingsChange.
  ///
  /// In ko, this message translates to:
  /// **'설정 변경 후 다시 확인'**
  String get onboardingRetryAfterSettingsChange;

  /// No description provided for @onboardingRetryLocationService.
  ///
  /// In ko, this message translates to:
  /// **'위치 서비스 다시 확인'**
  String get onboardingRetryLocationService;

  /// No description provided for @onboardingRetryCurrentLocation.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치 다시 확인'**
  String get onboardingRetryCurrentLocation;

  /// No description provided for @onboardingNeedHelp.
  ///
  /// In ko, this message translates to:
  /// **'인증이 어려워요.  '**
  String get onboardingNeedHelp;

  /// No description provided for @onboardingManualInputCta.
  ///
  /// In ko, this message translates to:
  /// **'직접 입력하기 >'**
  String get onboardingManualInputCta;

  /// No description provided for @onboardingLocationPermissionNoticeTitle.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한 안내'**
  String get onboardingLocationPermissionNoticeTitle;

  /// No description provided for @onboardingLocationPermissionNoticeMessage.
  ///
  /// In ko, this message translates to:
  /// **'동네 인증 및 내 주변 활동 추천을 위해 위치 정보가 필요합니다.\n위치 권한을 허용하지 않아도 동네를 직접 입력하여\n가입을 계속할 수 있습니다.'**
  String get onboardingLocationPermissionNoticeMessage;

  /// No description provided for @onboardingUseCurrentLocation.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치로 인증하기'**
  String get onboardingUseCurrentLocation;

  /// No description provided for @onboardingManualInput.
  ///
  /// In ko, this message translates to:
  /// **'직접 입력하기'**
  String get onboardingManualInput;

  /// No description provided for @onboardingManualNeighborhoodHelper.
  ///
  /// In ko, this message translates to:
  /// **'00시 00동 또는 00동 형식으로 입력해 주세요.'**
  String get onboardingManualNeighborhoodHelper;

  /// No description provided for @onboardingNeighborhoodHint.
  ///
  /// In ko, this message translates to:
  /// **'우만동'**
  String get onboardingNeighborhoodHint;

  /// No description provided for @onboardingEnterBusinessName.
  ///
  /// In ko, this message translates to:
  /// **'상호명을 입력해 주세요'**
  String get onboardingEnterBusinessName;

  /// No description provided for @onboardingBusinessNameHint.
  ///
  /// In ko, this message translates to:
  /// **'NICE 평가 정보'**
  String get onboardingBusinessNameHint;

  /// No description provided for @onboardingBusinessNumberLabel.
  ///
  /// In ko, this message translates to:
  /// **'사업자 번호'**
  String get onboardingBusinessNumberLabel;

  /// No description provided for @onboardingBusinessOwnerLabel.
  ///
  /// In ko, this message translates to:
  /// **'대표자명'**
  String get onboardingBusinessOwnerLabel;

  /// No description provided for @onboardingBusinessOwnerHint.
  ///
  /// In ko, this message translates to:
  /// **'홍길동'**
  String get onboardingBusinessOwnerHint;

  /// No description provided for @onboardingBusinessOpeningDateLabel.
  ///
  /// In ko, this message translates to:
  /// **'개업일자'**
  String get onboardingBusinessOpeningDateLabel;

  /// No description provided for @onboardingBusinessOpeningDateHint.
  ///
  /// In ko, this message translates to:
  /// **'20240131'**
  String get onboardingBusinessOpeningDateHint;

  /// No description provided for @onboardingCompleteBusinessVerification.
  ///
  /// In ko, this message translates to:
  /// **'사업자인증 완료하기'**
  String get onboardingCompleteBusinessVerification;

  /// No description provided for @onboardingWelcomeBack.
  ///
  /// In ko, this message translates to:
  /// **'돌아오신걸 환영해요'**
  String get onboardingWelcomeBack;

  /// No description provided for @onboardingReturnCompleted.
  ///
  /// In ko, this message translates to:
  /// **'{name}님\n메이트야 복귀를 완료했어요'**
  String onboardingReturnCompleted(Object name);

  /// No description provided for @onboardingLaunchApp.
  ///
  /// In ko, this message translates to:
  /// **'메이트야 시작하기'**
  String get onboardingLaunchApp;

  /// No description provided for @onboardingAgreementSemantics.
  ///
  /// In ko, this message translates to:
  /// **'{label} 동의'**
  String onboardingAgreementSemantics(Object label);

  /// No description provided for @onboardingTermsEffectiveDate.
  ///
  /// In ko, this message translates to:
  /// **'시행일: {date}'**
  String onboardingTermsEffectiveDate(Object date);

  /// No description provided for @onboardingTermsContents.
  ///
  /// In ko, this message translates to:
  /// **'목차'**
  String get onboardingTermsContents;

  /// No description provided for @onboardingTermsSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'제{index}조 {title}'**
  String onboardingTermsSectionTitle(int index, Object title);

  /// No description provided for @onboardingDefaultMemberName.
  ///
  /// In ko, this message translates to:
  /// **'메이트야 회원'**
  String get onboardingDefaultMemberName;

  /// No description provided for @onboardingLoginCompleted.
  ///
  /// In ko, this message translates to:
  /// **'{name}님\n메이트야 로그인을 완료했어요'**
  String onboardingLoginCompleted(Object name);

  /// No description provided for @onboardingSignupCompleted.
  ///
  /// In ko, this message translates to:
  /// **'{name}님\n메이트야 가입을 완료했어요'**
  String onboardingSignupCompleted(Object name);

  /// No description provided for @onboardingNeighborhoodHeadlineReturning.
  ///
  /// In ko, this message translates to:
  /// **'돌아오신걸 환영해요\n{name}님!\n동네 정보를 인증해주세요'**
  String onboardingNeighborhoodHeadlineReturning(Object name);

  /// No description provided for @onboardingNeighborhoodHeadlineSignup.
  ///
  /// In ko, this message translates to:
  /// **'동네 정보를 인증해주세요'**
  String get onboardingNeighborhoodHeadlineSignup;

  /// No description provided for @onboardingResolvedNeighborhoodMessage.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치가 “{name}”에 있어요.'**
  String onboardingResolvedNeighborhoodMessage(Object name);

  /// No description provided for @onboardingNeighborhoodLabel.
  ///
  /// In ko, this message translates to:
  /// **'동네'**
  String get onboardingNeighborhoodLabel;

  /// No description provided for @onboardingVerificationExpired.
  ///
  /// In ko, this message translates to:
  /// **'인증이 만료되어 인증번호를 다시 받아야 해요.'**
  String get onboardingVerificationExpired;

  /// No description provided for @onboardingBusinessVerificationExpired.
  ///
  /// In ko, this message translates to:
  /// **'사업자 인증이 만료되어 다시 인증해야 해요.'**
  String get onboardingBusinessVerificationExpired;

  /// No description provided for @homeSortRecommended.
  ///
  /// In ko, this message translates to:
  /// **'추천순'**
  String get homeSortRecommended;

  /// No description provided for @homeSortPopular.
  ///
  /// In ko, this message translates to:
  /// **'인기순'**
  String get homeSortPopular;

  /// No description provided for @homeSortLatest.
  ///
  /// In ko, this message translates to:
  /// **'최신순'**
  String get homeSortLatest;

  /// No description provided for @homeSortClosingSoon.
  ///
  /// In ko, this message translates to:
  /// **'마감임박순'**
  String get homeSortClosingSoon;

  /// No description provided for @homeSortNearby.
  ///
  /// In ko, this message translates to:
  /// **'가까운 거리순'**
  String get homeSortNearby;

  /// No description provided for @homeAudienceEveryone.
  ///
  /// In ko, this message translates to:
  /// **'누구나'**
  String get homeAudienceEveryone;

  /// No description provided for @homeAudienceForeignerFriendly.
  ///
  /// In ko, this message translates to:
  /// **'외국인 환영'**
  String get homeAudienceForeignerFriendly;

  /// No description provided for @homeAudienceKoreanFriendly.
  ///
  /// In ko, this message translates to:
  /// **'한국인 환영'**
  String get homeAudienceKoreanFriendly;

  /// No description provided for @homeAudienceTouristFriendly.
  ///
  /// In ko, this message translates to:
  /// **'관광객 추천'**
  String get homeAudienceTouristFriendly;

  /// No description provided for @homeAudienceBeginnerFriendly.
  ///
  /// In ko, this message translates to:
  /// **'초보자 환영'**
  String get homeAudienceBeginnerFriendly;

  /// No description provided for @homeStatusRecruiting.
  ///
  /// In ko, this message translates to:
  /// **'모집 중'**
  String get homeStatusRecruiting;

  /// No description provided for @homeStatusClosingSoon.
  ///
  /// In ko, this message translates to:
  /// **'곧 마감 (24시간 내)'**
  String get homeStatusClosingSoon;

  /// No description provided for @homeStatusNewlyListed.
  ///
  /// In ko, this message translates to:
  /// **'신규 등록 (24시간 내)'**
  String get homeStatusNewlyListed;

  /// No description provided for @homeDistanceLocal.
  ///
  /// In ko, this message translates to:
  /// **'내 지역'**
  String get homeDistanceLocal;

  /// No description provided for @homeDistanceWithin1km.
  ///
  /// In ko, this message translates to:
  /// **'1km 이내'**
  String get homeDistanceWithin1km;

  /// No description provided for @homeDistanceWithin5km.
  ///
  /// In ko, this message translates to:
  /// **'5km 이내'**
  String get homeDistanceWithin5km;

  /// No description provided for @homeDistanceWithin10km.
  ///
  /// In ko, this message translates to:
  /// **'10km 이내'**
  String get homeDistanceWithin10km;

  /// No description provided for @homeSearchHeroHint.
  ///
  /// In ko, this message translates to:
  /// **'언제든 어디서든'**
  String get homeSearchHeroHint;

  /// No description provided for @homeSearchHeroHelper.
  ///
  /// In ko, this message translates to:
  /// **'누구와도 메이트가 되는 곳, 메이트야'**
  String get homeSearchHeroHelper;

  /// No description provided for @homeLoadError.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러오지 못했어요.'**
  String get homeLoadError;

  /// No description provided for @homeSelectAtLeastOneCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리를 1개 이상 선택해 주세요.'**
  String get homeSelectAtLeastOneCategory;

  /// No description provided for @homeSelectAtLeastOneLanguage.
  ///
  /// In ko, this message translates to:
  /// **'언어를 1개 이상 선택해 주세요.'**
  String get homeSelectAtLeastOneLanguage;

  /// No description provided for @homeUnsupportedExploreLanguageFilter.
  ///
  /// In ko, this message translates to:
  /// **'둘러보기 언어 필터는 한국어, 영어, 중국어, 일본어만 지원합니다.'**
  String get homeUnsupportedExploreLanguageFilter;

  /// No description provided for @homeEndDateBeforeStartDateError.
  ///
  /// In ko, this message translates to:
  /// **'종료일은 시작일보다 빠를 수 없어요.'**
  String get homeEndDateBeforeStartDateError;

  /// No description provided for @homeMaxPriceLessThanMinPriceError.
  ///
  /// In ko, this message translates to:
  /// **'최대 금액은 최소 금액보다 크거나 같아야 해요.'**
  String get homeMaxPriceLessThanMinPriceError;

  /// No description provided for @homeTrendingTitle.
  ///
  /// In ko, this message translates to:
  /// **'인기 급상승 🔥'**
  String get homeTrendingTitle;

  /// No description provided for @homeSharedExperiencesTitle.
  ///
  /// In ko, this message translates to:
  /// **'함께할 수 있는 경험'**
  String get homeSharedExperiencesTitle;

  /// No description provided for @homeExploreSearchHint.
  ///
  /// In ko, this message translates to:
  /// **'이름, 장소를 검색해 보세요'**
  String get homeExploreSearchHint;

  /// No description provided for @homeExploreError.
  ///
  /// In ko, this message translates to:
  /// **'결과를 불러오지 못했어요.'**
  String get homeExploreError;

  /// No description provided for @homeFavoritesLoadError.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 목록을 불러오지 못했어요.'**
  String get homeFavoritesLoadError;

  /// No description provided for @homeFavoritesTitle.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 목록'**
  String get homeFavoritesTitle;

  /// No description provided for @homeCreateClass.
  ///
  /// In ko, this message translates to:
  /// **'클래스 등록'**
  String get homeCreateClass;

  /// No description provided for @homeCreateGroup.
  ///
  /// In ko, this message translates to:
  /// **'모임 생성'**
  String get homeCreateGroup;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'조건에 맞는 활동이 아직 없어요.'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'검색어 또는 필터를 조정해서 다시 찾아보세요.'**
  String get homeEmptyDescription;

  /// No description provided for @homeLoadMore.
  ///
  /// In ko, this message translates to:
  /// **'더 불러오기'**
  String get homeLoadMore;

  /// No description provided for @homeLoadedAllActivities.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 활동을 모두 불러왔어요.'**
  String homeLoadedAllActivities(int count);

  /// No description provided for @homeFilterTitle.
  ///
  /// In ko, this message translates to:
  /// **'필터'**
  String get homeFilterTitle;

  /// No description provided for @homeFilterSort.
  ///
  /// In ko, this message translates to:
  /// **'정렬'**
  String get homeFilterSort;

  /// No description provided for @homeFilterCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get homeFilterCategory;

  /// No description provided for @homeFilterAudience.
  ///
  /// In ko, this message translates to:
  /// **'참가대상'**
  String get homeFilterAudience;

  /// No description provided for @homeFilterLanguage.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get homeFilterLanguage;

  /// No description provided for @homeFilterRegion.
  ///
  /// In ko, this message translates to:
  /// **'지역'**
  String get homeFilterRegion;

  /// No description provided for @homeFilterSchedule.
  ///
  /// In ko, this message translates to:
  /// **'일정'**
  String get homeFilterSchedule;

  /// No description provided for @homeFilterStartDate.
  ///
  /// In ko, this message translates to:
  /// **'시작일'**
  String get homeFilterStartDate;

  /// No description provided for @homeFilterEndDate.
  ///
  /// In ko, this message translates to:
  /// **'종료일'**
  String get homeFilterEndDate;

  /// No description provided for @homeFilterCost.
  ///
  /// In ko, this message translates to:
  /// **'비용'**
  String get homeFilterCost;

  /// No description provided for @homeFilterMinPrice.
  ///
  /// In ko, this message translates to:
  /// **'최소금액'**
  String get homeFilterMinPrice;

  /// No description provided for @homeFilterMaxPrice.
  ///
  /// In ko, this message translates to:
  /// **'최대금액'**
  String get homeFilterMaxPrice;

  /// No description provided for @homeFilterStatus.
  ///
  /// In ko, this message translates to:
  /// **'모집상태'**
  String get homeFilterStatus;

  /// No description provided for @homeFilterNear.
  ///
  /// In ko, this message translates to:
  /// **'내 지역'**
  String get homeFilterNear;

  /// No description provided for @homeFilterFar.
  ///
  /// In ko, this message translates to:
  /// **'먼 지역'**
  String get homeFilterFar;

  /// No description provided for @homeFilterDistanceFromActivityRegion.
  ///
  /// In ko, this message translates to:
  /// **'활동 지역 기준 {target}'**
  String homeFilterDistanceFromActivityRegion(Object target);

  /// No description provided for @homeFilterDistanceFromRegion.
  ///
  /// In ko, this message translates to:
  /// **'{regionName} 기준 {target}'**
  String homeFilterDistanceFromRegion(Object regionName, Object target);

  /// No description provided for @commonClose.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get commonClose;

  /// No description provided for @commonEdit.
  ///
  /// In ko, this message translates to:
  /// **'편집'**
  String get commonEdit;

  /// No description provided for @commonSeeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get commonSeeAll;

  /// No description provided for @commonSeeDetails.
  ///
  /// In ko, this message translates to:
  /// **'자세히 보기'**
  String get commonSeeDetails;

  /// No description provided for @commonNetworkRetry.
  ///
  /// In ko, this message translates to:
  /// **'네트워크를 확인한 뒤 다시 시도해 주세요.'**
  String get commonNetworkRetry;

  /// No description provided for @countryKorea.
  ///
  /// In ko, this message translates to:
  /// **'대한민국'**
  String get countryKorea;

  /// No description provided for @countryJapan.
  ///
  /// In ko, this message translates to:
  /// **'일본'**
  String get countryJapan;

  /// No description provided for @countryChina.
  ///
  /// In ko, this message translates to:
  /// **'중국'**
  String get countryChina;

  /// No description provided for @countryVietnam.
  ///
  /// In ko, this message translates to:
  /// **'베트남'**
  String get countryVietnam;

  /// No description provided for @countryUnitedStates.
  ///
  /// In ko, this message translates to:
  /// **'미국'**
  String get countryUnitedStates;

  /// No description provided for @countryThailand.
  ///
  /// In ko, this message translates to:
  /// **'태국'**
  String get countryThailand;

  /// No description provided for @activityCategoryTouristAttraction.
  ///
  /// In ko, this message translates to:
  /// **'관광지'**
  String get activityCategoryTouristAttraction;

  /// No description provided for @activityCategoryTravelCourse.
  ///
  /// In ko, this message translates to:
  /// **'여행코스'**
  String get activityCategoryTravelCourse;

  /// No description provided for @activityCategoryCultureTradition.
  ///
  /// In ko, this message translates to:
  /// **'문화/전통'**
  String get activityCategoryCultureTradition;

  /// No description provided for @activityCategoryEventPerformanceFestival.
  ///
  /// In ko, this message translates to:
  /// **'행사/공연/축제'**
  String get activityCategoryEventPerformanceFestival;

  /// No description provided for @activityCategorySports.
  ///
  /// In ko, this message translates to:
  /// **'스포츠'**
  String get activityCategorySports;

  /// No description provided for @activityCategoryActivityLeports.
  ///
  /// In ko, this message translates to:
  /// **'액티비티/레포츠'**
  String get activityCategoryActivityLeports;

  /// No description provided for @activityCategoryShopping.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑'**
  String get activityCategoryShopping;

  /// No description provided for @activityCategoryPublicFacility.
  ///
  /// In ko, this message translates to:
  /// **'공공시설'**
  String get activityCategoryPublicFacility;

  /// No description provided for @activityCategoryOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get activityCategoryOther;

  /// No description provided for @reportSemanticsLabel.
  ///
  /// In ko, this message translates to:
  /// **'신고하기'**
  String get reportSemanticsLabel;

  /// No description provided for @reportTitle.
  ///
  /// In ko, this message translates to:
  /// **'신고하기'**
  String get reportTitle;

  /// No description provided for @reportNoticeMessage.
  ///
  /// In ko, this message translates to:
  /// **'신고 이미지 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 신고 사유 텍스트 작성은 계속할 수 있습니다.'**
  String get reportNoticeMessage;

  /// No description provided for @reportRecoveryMessage.
  ///
  /// In ko, this message translates to:
  /// **'신고 이미지 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.'**
  String get reportRecoveryMessage;

  /// No description provided for @reportFailureMessage.
  ///
  /// In ko, this message translates to:
  /// **'사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.'**
  String get reportFailureMessage;

  /// No description provided for @reportRestoreFallbackErrorMessage.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택하던 신고 이미지를 복구하지 못했어요. 다시 선택해 주세요.'**
  String get reportRestoreFallbackErrorMessage;

  /// No description provided for @reportSubmittedMessage.
  ///
  /// In ko, this message translates to:
  /// **'{subject} 신고가 접수되었어요.'**
  String reportSubmittedMessage(Object subject);

  /// No description provided for @reportBodyHint.
  ///
  /// In ko, this message translates to:
  /// **'신고 사유를 구체적으로 작성해주세요.\n(예: 욕설, 사기 의심, 부적절한 게시물,\n스팸, 괴롭힘 등) 신고 내용은 운영 정책에\n따라 검토됩니다.'**
  String get reportBodyHint;

  /// No description provided for @reportBodyCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}/{max}자'**
  String reportBodyCount(int count, int max);

  /// No description provided for @reportImageSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'이미지 (최대 {max}장)'**
  String reportImageSectionTitle(int max);

  /// No description provided for @reportSubmitting.
  ///
  /// In ko, this message translates to:
  /// **'접수 중...'**
  String get reportSubmitting;

  /// No description provided for @reportReviewNotice.
  ///
  /// In ko, this message translates to:
  /// **'접수된 신고는 영업일 기준 최대 7일 이내에 검토되며,\n허위 신고 또는 신고 사유가 불명확한 경우 처리되지 않을 수 있습니다.'**
  String get reportReviewNotice;

  /// No description provided for @reportRestoredCount.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택하던 신고 이미지 {restoredCount}장을 복구했어요.'**
  String reportRestoredCount(int restoredCount);

  /// No description provided for @mypageTitle.
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get mypageTitle;

  /// No description provided for @mypageLoadError.
  ///
  /// In ko, this message translates to:
  /// **'마이페이지를 불러오지 못했어요.'**
  String get mypageLoadError;

  /// No description provided for @mypageOtherProfileOpenHint.
  ///
  /// In ko, this message translates to:
  /// **'프로필을 불러오고 있어요.'**
  String get mypageOtherProfileOpenHint;

  /// No description provided for @mypageOtherProfileLoadError.
  ///
  /// In ko, this message translates to:
  /// **'상대 프로필을 불러오지 못했어요.'**
  String get mypageOtherProfileLoadError;

  /// No description provided for @mypageEditPrimaryPreferences.
  ///
  /// In ko, this message translates to:
  /// **'기본 정보 수정'**
  String get mypageEditPrimaryPreferences;

  /// No description provided for @mypageEditActivityRegion.
  ///
  /// In ko, this message translates to:
  /// **'활동 지역 수정'**
  String get mypageEditActivityRegion;

  /// No description provided for @mypageConsentHistoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'동의 내역'**
  String get mypageConsentHistoryTitle;

  /// No description provided for @mypageOpenPrivacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get mypageOpenPrivacyPolicy;

  /// No description provided for @mypageOpenCustomerSupport.
  ///
  /// In ko, this message translates to:
  /// **'고객센터'**
  String get mypageOpenCustomerSupport;

  /// No description provided for @mypageOpenBlockedUsers.
  ///
  /// In ko, this message translates to:
  /// **'차단한 사용자'**
  String get mypageOpenBlockedUsers;

  /// No description provided for @mypageLogout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get mypageLogout;

  /// No description provided for @mypageOpenWithdrawal.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get mypageOpenWithdrawal;

  /// No description provided for @mypageConsentHistoryDescription.
  ///
  /// In ko, this message translates to:
  /// **'메이트야 이용을 위해 동의한 약관과 정책 내역을 확인할 수 있어요.'**
  String get mypageConsentHistoryDescription;

  /// No description provided for @mypageConsentHistoryEmpty.
  ///
  /// In ko, this message translates to:
  /// **'아직 저장된 동의 내역이 없어요.'**
  String get mypageConsentHistoryEmpty;

  /// No description provided for @mypageConsentVersion.
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get mypageConsentVersion;

  /// No description provided for @mypageConsentStatus.
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get mypageConsentStatus;

  /// No description provided for @mypageConsentAgreed.
  ///
  /// In ko, this message translates to:
  /// **'동의'**
  String get mypageConsentAgreed;

  /// No description provided for @mypageConsentDeclined.
  ///
  /// In ko, this message translates to:
  /// **'미동의'**
  String get mypageConsentDeclined;

  /// No description provided for @mypageConsentDate.
  ///
  /// In ko, this message translates to:
  /// **'동의 일시'**
  String get mypageConsentDate;

  /// No description provided for @mypageBlockedUsersTitle.
  ///
  /// In ko, this message translates to:
  /// **'차단한 사용자'**
  String get mypageBlockedUsersTitle;

  /// No description provided for @mypageBlockedUsersEmpty.
  ///
  /// In ko, this message translates to:
  /// **'차단한 사용자가 없어요.'**
  String get mypageBlockedUsersEmpty;

  /// No description provided for @mypageRecentActivitiesTitle.
  ///
  /// In ko, this message translates to:
  /// **'최근 활동'**
  String get mypageRecentActivitiesTitle;

  /// No description provided for @mypageRecentActivitiesDescription.
  ///
  /// In ko, this message translates to:
  /// **'최근 참여하거나 개설한 활동을 확인해 보세요.'**
  String get mypageRecentActivitiesDescription;

  /// No description provided for @mypageActivitySummaryTitle.
  ///
  /// In ko, this message translates to:
  /// **'활동 요약'**
  String get mypageActivitySummaryTitle;

  /// No description provided for @mypageHostedCount.
  ///
  /// In ko, this message translates to:
  /// **'개설'**
  String get mypageHostedCount;

  /// No description provided for @mypageJoinedCount.
  ///
  /// In ko, this message translates to:
  /// **'참여'**
  String get mypageJoinedCount;

  /// No description provided for @mypageReviewCount.
  ///
  /// In ko, this message translates to:
  /// **'리뷰'**
  String get mypageReviewCount;

  /// No description provided for @mypageActiveMember.
  ///
  /// In ko, this message translates to:
  /// **'활동 중인 멤버'**
  String get mypageActiveMember;

  /// No description provided for @mypageInactiveMember.
  ///
  /// In ko, this message translates to:
  /// **'최근 활동 없음'**
  String get mypageInactiveMember;

  /// No description provided for @mypageActiveWithin30Days.
  ///
  /// In ko, this message translates to:
  /// **'30일 내 접속'**
  String get mypageActiveWithin30Days;

  /// No description provided for @mypageNoRecentActivity.
  ///
  /// In ko, this message translates to:
  /// **'최근 접속 없음'**
  String get mypageNoRecentActivity;

  /// No description provided for @mypageBadgeLabel.
  ///
  /// In ko, this message translates to:
  /// **'뱃지'**
  String get mypageBadgeLabel;

  /// No description provided for @mypageBadgesTitle.
  ///
  /// In ko, this message translates to:
  /// **'내 뱃지'**
  String get mypageBadgesTitle;

  /// No description provided for @mypageBadgesDescription.
  ///
  /// In ko, this message translates to:
  /// **'참여한 활동 카테고리에 따라 뱃지를 받을 수 있어요.'**
  String get mypageBadgesDescription;

  /// No description provided for @mypageOtherBadgesTitle.
  ///
  /// In ko, this message translates to:
  /// **'획득한 뱃지'**
  String get mypageOtherBadgesTitle;

  /// No description provided for @mypageOtherBadgesDescription.
  ///
  /// In ko, this message translates to:
  /// **'이 사용자가 획득한 뱃지예요.'**
  String get mypageOtherBadgesDescription;

  /// No description provided for @mypageOtherBadgesEmpty.
  ///
  /// In ko, this message translates to:
  /// **'아직 공개된 뱃지가 없어요.'**
  String get mypageOtherBadgesEmpty;

  /// No description provided for @mypageRecentActivitiesSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'활동 이력'**
  String get mypageRecentActivitiesSectionTitle;

  /// No description provided for @mypageActivityHistoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'활동 이력'**
  String get mypageActivityHistoryTitle;

  /// No description provided for @mypagePrimaryPreferencesTitle.
  ///
  /// In ko, this message translates to:
  /// **'기본 정보'**
  String get mypagePrimaryPreferencesTitle;

  /// No description provided for @mypagePrimaryPreferencesDescription.
  ///
  /// In ko, this message translates to:
  /// **'내 언어와 국적 정보를 수정할 수 있어요.'**
  String get mypagePrimaryPreferencesDescription;

  /// No description provided for @mypageMyLanguage.
  ///
  /// In ko, this message translates to:
  /// **'내 언어'**
  String get mypageMyLanguage;

  /// No description provided for @mypageMyCountry.
  ///
  /// In ko, this message translates to:
  /// **'내 국적'**
  String get mypageMyCountry;

  /// No description provided for @mypageEnglishNameOptional.
  ///
  /// In ko, this message translates to:
  /// **'영문 이름 (선택)'**
  String get mypageEnglishNameOptional;

  /// No description provided for @mypageSaving.
  ///
  /// In ko, this message translates to:
  /// **'저장 중...'**
  String get mypageSaving;

  /// No description provided for @mypagePrimaryPreferencesSubmit.
  ///
  /// In ko, this message translates to:
  /// **'저장하기'**
  String get mypagePrimaryPreferencesSubmit;

  /// No description provided for @mypageUpdating.
  ///
  /// In ko, this message translates to:
  /// **'업데이트 중...'**
  String get mypageUpdating;

  /// No description provided for @mypageBusinessIntroTitle.
  ///
  /// In ko, this message translates to:
  /// **'소개글'**
  String get mypageBusinessIntroTitle;

  /// No description provided for @mypageBusinessIntroDescription.
  ///
  /// In ko, this message translates to:
  /// **'호스트 페이지에 노출될 한 줄 소개를 작성해 주세요.'**
  String get mypageBusinessIntroDescription;

  /// No description provided for @mypageBusinessIntroHint.
  ///
  /// In ko, this message translates to:
  /// **'어떤 경험을 제공하는지 자연스럽게 소개해 주세요.'**
  String get mypageBusinessIntroHint;

  /// No description provided for @mypageSaveIntroduction.
  ///
  /// In ko, this message translates to:
  /// **'소개 저장'**
  String get mypageSaveIntroduction;

  /// No description provided for @mypageActiveExperiencesTitle.
  ///
  /// In ko, this message translates to:
  /// **'운영 중인 체험'**
  String get mypageActiveExperiencesTitle;

  /// No description provided for @mypageAddFriend.
  ///
  /// In ko, this message translates to:
  /// **'친구 추가'**
  String get mypageAddFriend;

  /// No description provided for @mypageRemoveFriend.
  ///
  /// In ko, this message translates to:
  /// **'친구삭제하기'**
  String get mypageRemoveFriend;

  /// No description provided for @mypageBlocked.
  ///
  /// In ko, this message translates to:
  /// **'차단됨'**
  String get mypageBlocked;

  /// No description provided for @mypageBlockUser.
  ///
  /// In ko, this message translates to:
  /// **'유저차단하기'**
  String get mypageBlockUser;

  /// No description provided for @mypageSelectLanguageAndCountry.
  ///
  /// In ko, this message translates to:
  /// **'언어와 국가를 모두 선택해 주세요.'**
  String get mypageSelectLanguageAndCountry;

  /// No description provided for @mypageInvalidLanguageOrCountry.
  ///
  /// In ko, this message translates to:
  /// **'지원하지 않는 언어 또는 국가예요.'**
  String get mypageInvalidLanguageOrCountry;

  /// No description provided for @mypagePrimaryPreferencesSaved.
  ///
  /// In ko, this message translates to:
  /// **'기본 정보가 저장되었어요.'**
  String get mypagePrimaryPreferencesSaved;

  /// No description provided for @mypagePrimaryPreferencesSaveError.
  ///
  /// In ko, this message translates to:
  /// **'기본 정보를 저장하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypagePrimaryPreferencesSaveError;

  /// No description provided for @mypageFriendRemoved.
  ///
  /// In ko, this message translates to:
  /// **'친구를 삭제했어요.'**
  String get mypageFriendRemoved;

  /// No description provided for @mypageFriendAdded.
  ///
  /// In ko, this message translates to:
  /// **'친구로 추가했어요.'**
  String get mypageFriendAdded;

  /// No description provided for @mypageFriendUpdateError.
  ///
  /// In ko, this message translates to:
  /// **'친구 상태를 변경하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageFriendUpdateError;

  /// No description provided for @mypageBlockedUserAdded.
  ///
  /// In ko, this message translates to:
  /// **'사용자를 차단했어요.'**
  String get mypageBlockedUserAdded;

  /// No description provided for @mypageBlockUserError.
  ///
  /// In ko, this message translates to:
  /// **'사용자를 차단하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageBlockUserError;

  /// No description provided for @mypageUnblockAction.
  ///
  /// In ko, this message translates to:
  /// **'차단 해제'**
  String get mypageUnblockAction;

  /// No description provided for @mypageUnblockedUser.
  ///
  /// In ko, this message translates to:
  /// **'차단을 해제했어요.'**
  String get mypageUnblockedUser;

  /// No description provided for @mypageUnblockUserError.
  ///
  /// In ko, this message translates to:
  /// **'차단을 해제하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageUnblockUserError;

  /// No description provided for @mypageBusinessIntroRequired.
  ///
  /// In ko, this message translates to:
  /// **'소개글을 입력해 주세요.'**
  String get mypageBusinessIntroRequired;

  /// No description provided for @mypageBusinessIntroTooLong.
  ///
  /// In ko, this message translates to:
  /// **'소개글은 300자 이하로 입력해 주세요.'**
  String get mypageBusinessIntroTooLong;

  /// No description provided for @mypageBusinessIntroSaved.
  ///
  /// In ko, this message translates to:
  /// **'소개글을 저장했어요.'**
  String get mypageBusinessIntroSaved;

  /// No description provided for @mypageBusinessIntroSaveError.
  ///
  /// In ko, this message translates to:
  /// **'소개글을 저장하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageBusinessIntroSaveError;

  /// No description provided for @mypageProfileImageSaved.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지를 저장했어요.'**
  String get mypageProfileImageSaved;

  /// No description provided for @mypageProfileImageSaveError.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지를 저장하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageProfileImageSaveError;

  /// No description provided for @mypageProfileImageInvalidFormat.
  ///
  /// In ko, this message translates to:
  /// **'JPG, PNG, WEBP, GIF 형식의 이미지만 업로드할 수 있어요.'**
  String get mypageProfileImageInvalidFormat;

  /// No description provided for @mypageProfileImageUploadError.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageProfileImageUploadError;

  /// No description provided for @mypageProfileImageConfirmError.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지 업로드 확인에 실패했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageProfileImageConfirmError;

  /// No description provided for @mypageActivityRegionSaved.
  ///
  /// In ko, this message translates to:
  /// **'활동 지역을 저장했어요.'**
  String get mypageActivityRegionSaved;

  /// No description provided for @mypageActivityRegionSaveError.
  ///
  /// In ko, this message translates to:
  /// **'활동 지역을 저장하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageActivityRegionSaveError;

  /// No description provided for @mypageWithdrawalAgreementRequired.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴 동의가 필요해요.'**
  String get mypageWithdrawalAgreementRequired;

  /// No description provided for @mypageWithdrawalSignatureRequired.
  ///
  /// In ko, this message translates to:
  /// **'서명을 입력해 주세요.'**
  String get mypageWithdrawalSignatureRequired;

  /// No description provided for @mypageWithdrawalSignatureMismatch.
  ///
  /// In ko, this message translates to:
  /// **'입력한 서명이 회원 이름과 일치하지 않아요.'**
  String get mypageWithdrawalSignatureMismatch;

  /// No description provided for @mypageWithdrawalAgreementText.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 관리 및 30일 후 최종 삭제 정책에 동의합니다.'**
  String get mypageWithdrawalAgreementText;

  /// No description provided for @mypageWithdrawalSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴 요청이 접수되었어요.'**
  String get mypageWithdrawalSubmitted;

  /// No description provided for @mypageWithdrawalSubmitError.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴 요청을 처리하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageWithdrawalSubmitError;

  /// No description provided for @mypageLogoutError.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageLogoutError;

  /// No description provided for @mypageTermsDetailUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'약관 상세 정보를 불러올 수 없어요.'**
  String get mypageTermsDetailUnavailable;

  /// No description provided for @mypageSupportLinkCopied.
  ///
  /// In ko, this message translates to:
  /// **'고객센터 링크를 복사했어요.'**
  String get mypageSupportLinkCopied;

  /// No description provided for @mypagePrivacyLinkCopied.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침 링크를 복사했어요.'**
  String get mypagePrivacyLinkCopied;

  /// No description provided for @mypageCurrentLocationResolveError.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 확인하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get mypageCurrentLocationResolveError;

  /// No description provided for @mypageNeighborhoodRequired.
  ///
  /// In ko, this message translates to:
  /// **'활동 지역을 입력해 주세요.'**
  String get mypageNeighborhoodRequired;

  /// No description provided for @mypageNeighborhoodLookupError.
  ///
  /// In ko, this message translates to:
  /// **'입력한 지역을 확인하지 못했어요. 다시 확인해 주세요.'**
  String get mypageNeighborhoodLookupError;

  /// No description provided for @mypageNeighborhoodVerificationRequired.
  ///
  /// In ko, this message translates to:
  /// **'확인된 활동 지역을 선택해 주세요.'**
  String get mypageNeighborhoodVerificationRequired;

  /// No description provided for @mypageActivityRegionDialogDescription.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 사용하거나 직접 입력해서 활동 지역을 설정할 수 있어요.'**
  String get mypageActivityRegionDialogDescription;

  /// No description provided for @mypageResolvingCurrentLocation.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 확인하고 있어요.'**
  String get mypageResolvingCurrentLocation;

  /// No description provided for @mypageResolvingNeighborhood.
  ///
  /// In ko, this message translates to:
  /// **'입력한 지역을 확인하고 있어요.'**
  String get mypageResolvingNeighborhood;

  /// No description provided for @mypageConfirmManualNeighborhood.
  ///
  /// In ko, this message translates to:
  /// **'입력한 지역으로 확인'**
  String get mypageConfirmManualNeighborhood;

  /// No description provided for @mypageSelectedActivityRegion.
  ///
  /// In ko, this message translates to:
  /// **'선택한 활동 지역: {name}'**
  String mypageSelectedActivityRegion(Object name);

  /// No description provided for @mypageSaveActivityRegion.
  ///
  /// In ko, this message translates to:
  /// **'활동 지역 저장'**
  String get mypageSaveActivityRegion;

  /// No description provided for @mypageLocationServiceDisabledMessage.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 사용하려면 기기 위치 서비스를 켜야 해요. 직접 입력으로도 계속할 수 있습니다.'**
  String get mypageLocationServiceDisabledMessage;

  /// No description provided for @mypageLocationPermissionDisabledMessage.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 사용하려면 앱 설정에서 위치 권한을 허용해야 해요. 직접 입력으로도 계속할 수 있습니다.'**
  String get mypageLocationPermissionDisabledMessage;

  /// No description provided for @mypageProfileImageNotice.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지를 선택하려면 사진 보관함 접근 권한이 필요합니다.'**
  String get mypageProfileImageNotice;

  /// No description provided for @mypageProfileImageRecovery.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지를 선택하려면 사진 보관함 접근 권한을 허용해 주세요. 다시 시도하거나 앱 설정에서 변경할 수 있어요.'**
  String get mypageProfileImageRecovery;

  /// No description provided for @mypageProfileImageFailure.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지를 불러오지 못했어요. 파일 상태를 확인해 주세요.'**
  String get mypageProfileImageFailure;

  /// No description provided for @mypageProfileImageRestoreFallback.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택하던 프로필 이미지를 복구하지 못했어요. 다시 선택해 주세요.'**
  String get mypageProfileImageRestoreFallback;

  /// No description provided for @mypageProfileImageRestoredCount.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택하던 프로필 이미지 {restoredCount}장을 복구했어요.'**
  String mypageProfileImageRestoredCount(int restoredCount);

  /// No description provided for @mypageWithdrawalTitle.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get mypageWithdrawalTitle;

  /// No description provided for @mypageWithdrawalDescription.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴를 진행하시겠습니까?\n탈퇴 후 계정은 즉시 비활성화되며,\n30일 동안 재가입 또는 로그인 시\n탈퇴가 취소됩니다.\n\n30일이 지나면 회원 정보 및 서비스 이용 기록은 관련 법령에 따라 보관이 필요한 정보를 제외하고 영구 삭제되며 복구할 수 없습니다.'**
  String get mypageWithdrawalDescription;

  /// No description provided for @mypageWithdrawalAgreementCheckbox.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 관리 및 30일 후 최종 삭제 정책에 동의합니다.'**
  String get mypageWithdrawalAgreementCheckbox;

  /// No description provided for @mypageWithdrawalSignatureLabel.
  ///
  /// In ko, this message translates to:
  /// **'서명 입력'**
  String get mypageWithdrawalSignatureLabel;

  /// No description provided for @mypageWithdrawalSignatureHint.
  ///
  /// In ko, this message translates to:
  /// **'{name} 입력'**
  String mypageWithdrawalSignatureHint(Object name);

  /// No description provided for @mypageWithdrawalSubmittedNotice.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴 요청이 접수되었습니다. 앱 재로그인 전까지 계정은 비활성 상태로 간주됩니다.'**
  String get mypageWithdrawalSubmittedNotice;

  /// No description provided for @mypageWithdrawalRequest.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴 요청'**
  String get mypageWithdrawalRequest;

  /// No description provided for @mypageMetricActivities.
  ///
  /// In ko, this message translates to:
  /// **'활동 수'**
  String get mypageMetricActivities;

  /// No description provided for @mypageMetricFriends.
  ///
  /// In ko, this message translates to:
  /// **'친구 수'**
  String get mypageMetricFriends;

  /// No description provided for @mypageMetricReviews.
  ///
  /// In ko, this message translates to:
  /// **'작성 리뷰'**
  String get mypageMetricReviews;

  /// No description provided for @mypageMetricRecruitingExperiences.
  ///
  /// In ko, this message translates to:
  /// **'모집중 체험'**
  String get mypageMetricRecruitingExperiences;

  /// No description provided for @mypageMetricTotalParticipants.
  ///
  /// In ko, this message translates to:
  /// **'누적 참가자'**
  String get mypageMetricTotalParticipants;

  /// No description provided for @mypageMetricAverageRating.
  ///
  /// In ko, this message translates to:
  /// **'평균 평점'**
  String get mypageMetricAverageRating;

  /// No description provided for @mypageMetricReceivedReviews.
  ///
  /// In ko, this message translates to:
  /// **'받은 후기'**
  String get mypageMetricReceivedReviews;

  /// No description provided for @mypageActivityRegionUnset.
  ///
  /// In ko, this message translates to:
  /// **'활동 지역 미설정'**
  String get mypageActivityRegionUnset;

  /// No description provided for @mypageParticipantCount.
  ///
  /// In ko, this message translates to:
  /// **'{current} / {capacity}명'**
  String mypageParticipantCount(int current, int capacity);

  /// No description provided for @mypageConsentTypeServiceTerms.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 약관'**
  String get mypageConsentTypeServiceTerms;

  /// No description provided for @mypageConsentTypePrivacyCollection.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 수집·이용 동의'**
  String get mypageConsentTypePrivacyCollection;

  /// No description provided for @mypageConsentTypeLocationService.
  ///
  /// In ko, this message translates to:
  /// **'위치기반 서비스 이용 동의'**
  String get mypageConsentTypeLocationService;

  /// No description provided for @mypageConsentTypeAgeOver14.
  ///
  /// In ko, this message translates to:
  /// **'만 14세 이상 확인'**
  String get mypageConsentTypeAgeOver14;

  /// No description provided for @mypageHostBadge.
  ///
  /// In ko, this message translates to:
  /// **'HOST'**
  String get mypageHostBadge;

  /// No description provided for @mypageEditActivityCta.
  ///
  /// In ko, this message translates to:
  /// **'수정하기'**
  String get mypageEditActivityCta;

  /// No description provided for @mypageBadgeTraditional.
  ///
  /// In ko, this message translates to:
  /// **'전통 마스터'**
  String get mypageBadgeTraditional;

  /// No description provided for @mypageBadgeActivePerson.
  ///
  /// In ko, this message translates to:
  /// **'액티브 메이트'**
  String get mypageBadgeActivePerson;

  /// No description provided for @mypageBadgeFestive.
  ///
  /// In ko, this message translates to:
  /// **'축제 러버'**
  String get mypageBadgeFestive;

  /// No description provided for @mypageBadgeTourist.
  ///
  /// In ko, this message translates to:
  /// **'로컬 탐험가'**
  String get mypageBadgeTourist;

  /// No description provided for @mypageBadgeUnlockedTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 뱃지를 획득했어요'**
  String get mypageBadgeUnlockedTitle;

  /// No description provided for @mypageBadgeUnlockedDescription.
  ///
  /// In ko, this message translates to:
  /// **'{category} 활동 참여가 반영됐어요.'**
  String mypageBadgeUnlockedDescription(Object category);

  /// No description provided for @galleryPermissionNoticeTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 권한 안내'**
  String get galleryPermissionNoticeTitle;

  /// No description provided for @galleryPermissionSelectPhoto.
  ///
  /// In ko, this message translates to:
  /// **'사진 선택하기'**
  String get galleryPermissionSelectPhoto;

  /// No description provided for @galleryPermissionRecoveryTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 권한이 필요해요'**
  String get galleryPermissionRecoveryTitle;

  /// No description provided for @authLoginRequired.
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다.'**
  String get authLoginRequired;

  /// No description provided for @commonRequestError.
  ///
  /// In ko, this message translates to:
  /// **'요청 처리 중 오류가 발생했습니다.'**
  String get commonRequestError;

  /// No description provided for @chatJustNow.
  ///
  /// In ko, this message translates to:
  /// **'방금'**
  String get chatJustNow;

  /// No description provided for @chatMinutesAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}분 전'**
  String chatMinutesAgo(int count);

  /// No description provided for @chatHoursAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}시간 전'**
  String chatHoursAgo(int count);

  /// No description provided for @chatYesterday.
  ///
  /// In ko, this message translates to:
  /// **'어제'**
  String get chatYesterday;

  /// No description provided for @chatLastYear.
  ///
  /// In ko, this message translates to:
  /// **'작년'**
  String get chatLastYear;

  /// No description provided for @chatPhotoCount.
  ///
  /// In ko, this message translates to:
  /// **'사진 {count}장'**
  String chatPhotoCount(int count);

  /// No description provided for @chatViewOriginal.
  ///
  /// In ko, this message translates to:
  /// **'원문 보기'**
  String get chatViewOriginal;

  /// No description provided for @chatViewTranslation.
  ///
  /// In ko, this message translates to:
  /// **'번역 보기'**
  String get chatViewTranslation;

  /// No description provided for @chatParticipantCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}명 참여'**
  String chatParticipantCount(int count);

  /// No description provided for @chatFilterGroup.
  ///
  /// In ko, this message translates to:
  /// **'단체'**
  String get chatFilterGroup;

  /// No description provided for @chatFilterDirect.
  ///
  /// In ko, this message translates to:
  /// **'개인'**
  String get chatFilterDirect;

  /// No description provided for @chatListGuidance.
  ///
  /// In ko, this message translates to:
  /// **'활동에 참여하면 자동으로 단체채팅방에 가입됩니다.\n개인 채팅은 친구인 유저와 자동으로 생성됩니다.\n친구가 아닌 유저와는 채팅할 수 없습니다.'**
  String get chatListGuidance;

  /// No description provided for @chatComposerHint.
  ///
  /// In ko, this message translates to:
  /// **'메시지를 입력하세요'**
  String get chatComposerHint;

  /// No description provided for @reportReasonRequired.
  ///
  /// In ko, this message translates to:
  /// **'신고 사유를 입력해 주세요.'**
  String get reportReasonRequired;

  /// No description provided for @reportImageInvalidFormat.
  ///
  /// In ko, this message translates to:
  /// **'JPG, PNG, WEBP, GIF 형식의 신고 이미지만 업로드할 수 있어요.'**
  String get reportImageInvalidFormat;

  /// No description provided for @reportImageUploadError.
  ///
  /// In ko, this message translates to:
  /// **'신고 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get reportImageUploadError;

  /// No description provided for @reportImageConfirmError.
  ///
  /// In ko, this message translates to:
  /// **'신고 이미지 업로드 확인에 실패했어요. 잠시 후 다시 시도해 주세요.'**
  String get reportImageConfirmError;

  /// No description provided for @createGroupFlowTitle.
  ///
  /// In ko, this message translates to:
  /// **'모임 만들기'**
  String get createGroupFlowTitle;

  /// No description provided for @createClassFlowTitle.
  ///
  /// In ko, this message translates to:
  /// **'클래스 등록'**
  String get createClassFlowTitle;

  /// No description provided for @createEntityGroup.
  ///
  /// In ko, this message translates to:
  /// **'모임'**
  String get createEntityGroup;

  /// No description provided for @createEntityClass.
  ///
  /// In ko, this message translates to:
  /// **'클래스'**
  String get createEntityClass;

  /// No description provided for @createGroupSubmit.
  ///
  /// In ko, this message translates to:
  /// **'모임 생성하기'**
  String get createGroupSubmit;

  /// No description provided for @createClassSubmit.
  ///
  /// In ko, this message translates to:
  /// **'클래스 등록하기'**
  String get createClassSubmit;

  /// No description provided for @createGroupEditTitle.
  ///
  /// In ko, this message translates to:
  /// **'모임 수정'**
  String get createGroupEditTitle;

  /// No description provided for @createClassEditTitle.
  ///
  /// In ko, this message translates to:
  /// **'클래스 수정'**
  String get createClassEditTitle;

  /// No description provided for @createGroupUpdateSubmit.
  ///
  /// In ko, this message translates to:
  /// **'모임 수정 완료'**
  String get createGroupUpdateSubmit;

  /// No description provided for @createClassUpdateSubmit.
  ///
  /// In ko, this message translates to:
  /// **'클래스 수정 완료'**
  String get createClassUpdateSubmit;

  /// No description provided for @createPaidLabel.
  ///
  /// In ko, this message translates to:
  /// **'유료'**
  String get createPaidLabel;

  /// No description provided for @createEditCompleted.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 수정이 완료되었어요.'**
  String createEditCompleted(Object entity);

  /// No description provided for @createSubmitCompleted.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 등록이 완료되었어요.'**
  String createSubmitCompleted(Object entity);

  /// No description provided for @createChatProvisionFailed.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 등록은 완료됐지만 채팅방을 준비하지 못했어요. 잠시 후 다시 확인해 주세요.'**
  String createChatProvisionFailed(Object entity);

  /// No description provided for @createSubmitFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'{entity}을(를) 등록하지 못했어요. 네트워크를 확인한 뒤 다시 시도해 주세요.'**
  String createSubmitFailedNetwork(Object entity);

  /// No description provided for @createSubmitFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'{entity}을(를) 등록하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String createSubmitFailedServer(Object entity);

  /// No description provided for @createDeleteFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'삭제하지 못했어요. 네트워크를 확인한 뒤 다시 시도해 주세요.'**
  String get createDeleteFailedNetwork;

  /// No description provided for @createDeleteFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'삭제하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get createDeleteFailedServer;

  /// No description provided for @createLoadEditFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'수정할 {entity} 정보를 불러오지 못했어요. 네트워크를 확인한 뒤 다시 시도해 주세요.'**
  String createLoadEditFailedNetwork(Object entity);

  /// No description provided for @createLoadEditFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'수정할 {entity} 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String createLoadEditFailedServer(Object entity);

  /// No description provided for @createValidationSelectCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리를 1개 이상 선택해 주세요.'**
  String get createValidationSelectCategory;

  /// No description provided for @createValidationSelectClassCategoryFirst.
  ///
  /// In ko, this message translates to:
  /// **'클래스에 맞는 카테고리를 먼저 선택해 주세요.'**
  String get createValidationSelectClassCategoryFirst;

  /// No description provided for @createValidationSelectPlaceOrManual.
  ///
  /// In ko, this message translates to:
  /// **'장소를 선택하거나 직접 입력해 주세요.'**
  String get createValidationSelectPlaceOrManual;

  /// No description provided for @createValidationSelectPlace.
  ///
  /// In ko, this message translates to:
  /// **'장소를 선택해 주세요.'**
  String get createValidationSelectPlace;

  /// No description provided for @createValidationEnterEntityName.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 이름을 입력해 주세요.'**
  String createValidationEnterEntityName(Object entity);

  /// No description provided for @createValidationTitleMaxLength.
  ///
  /// In ko, this message translates to:
  /// **'이름은 40자 이내로 입력해 주세요.'**
  String get createValidationTitleMaxLength;

  /// No description provided for @createValidationDescriptionMaxLength.
  ///
  /// In ko, this message translates to:
  /// **'설명은 1000자 이내로 입력해 주세요.'**
  String get createValidationDescriptionMaxLength;

  /// No description provided for @createValidationSelectDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜를 선택해 주세요.'**
  String get createValidationSelectDate;

  /// No description provided for @createValidationNoPastDate.
  ///
  /// In ko, this message translates to:
  /// **'지난 날짜는 선택할 수 없어요.'**
  String get createValidationNoPastDate;

  /// No description provided for @createValidationSelectStartEndTime.
  ///
  /// In ko, this message translates to:
  /// **'시작 시간과 종료 시간을 모두 선택해 주세요.'**
  String get createValidationSelectStartEndTime;

  /// No description provided for @createValidationEndAfterStart.
  ///
  /// In ko, this message translates to:
  /// **'종료 시간은 시작 시간보다 늦어야 해요.'**
  String get createValidationEndAfterStart;

  /// No description provided for @createValidationCapacityRange.
  ///
  /// In ko, this message translates to:
  /// **'참가 인원은 최소 2명, 최대 20명까지 설정할 수 있어요.'**
  String get createValidationCapacityRange;

  /// No description provided for @createValidationSelectDeadline.
  ///
  /// In ko, this message translates to:
  /// **'모집 마감 날짜와 시간을 모두 선택해 주세요.'**
  String get createValidationSelectDeadline;

  /// No description provided for @createValidationSelectDeadlineTogether.
  ///
  /// In ko, this message translates to:
  /// **'모집 마감 날짜와 시간을 함께 선택해 주세요.'**
  String get createValidationSelectDeadlineTogether;

  /// No description provided for @createValidationDeadlineFuture.
  ///
  /// In ko, this message translates to:
  /// **'모집 마감은 현재 시각 이후여야 해요.'**
  String get createValidationDeadlineFuture;

  /// No description provided for @createValidationDeadlineBeforeStart.
  ///
  /// In ko, this message translates to:
  /// **'모집 마감은 시작 시간보다 빨라야 해요.'**
  String get createValidationDeadlineBeforeStart;

  /// No description provided for @createValidationSelectLanguage.
  ///
  /// In ko, this message translates to:
  /// **'사용 언어를 1개 이상 선택해 주세요.'**
  String get createValidationSelectLanguage;

  /// No description provided for @createValidationSelectPriceType.
  ///
  /// In ko, this message translates to:
  /// **'가격 유형을 선택해 주세요.'**
  String get createValidationSelectPriceType;

  /// No description provided for @createValidationEnterPaidPrice.
  ///
  /// In ko, this message translates to:
  /// **'유료일 경우 금액을 입력해 주세요.'**
  String get createValidationEnterPaidPrice;

  /// No description provided for @createValidationPriceRange.
  ///
  /// In ko, this message translates to:
  /// **'금액은 1원 이상 1000000원 이하로 입력해 주세요.'**
  String get createValidationPriceRange;

  /// No description provided for @createValidationRegisterImage.
  ///
  /// In ko, this message translates to:
  /// **'대표 이미지를 1장 이상 등록해 주세요.'**
  String get createValidationRegisterImage;

  /// No description provided for @createGroupInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'모임 정보를 입력해 주세요'**
  String get createGroupInfoTitle;

  /// No description provided for @createClassInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'클래스 정보를 입력해 주세요'**
  String get createClassInfoTitle;

  /// No description provided for @createValidationIntro.
  ///
  /// In ko, this message translates to:
  /// **'아래 필수 정보를 모두 입력하면 바로 등록할 수 있어요.'**
  String get createValidationIntro;

  /// No description provided for @createSelectedCategoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'선택한 카테고리'**
  String get createSelectedCategoryTitle;

  /// No description provided for @createSelectedPlaceTitle.
  ///
  /// In ko, this message translates to:
  /// **'선택한 장소'**
  String get createSelectedPlaceTitle;

  /// No description provided for @createGroupNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'모임 이름'**
  String get createGroupNameLabel;

  /// No description provided for @createClassNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'클래스 이름'**
  String get createClassNameLabel;

  /// No description provided for @createGroupNameHint.
  ///
  /// In ko, this message translates to:
  /// **'예) 북촌 한옥 산책 같이 가요'**
  String get createGroupNameHint;

  /// No description provided for @createClassNameHint.
  ///
  /// In ko, this message translates to:
  /// **'예) 전통 다도 원데이 클래스'**
  String get createClassNameHint;

  /// No description provided for @createDescriptionTitle.
  ///
  /// In ko, this message translates to:
  /// **'상세 설명'**
  String get createDescriptionTitle;

  /// No description provided for @createDescriptionHint.
  ///
  /// In ko, this message translates to:
  /// **'진행 방식, 준비물, 참가자가 알면 좋은 내용을 적어 주세요.'**
  String get createDescriptionHint;

  /// No description provided for @createDateTimeTitle.
  ///
  /// In ko, this message translates to:
  /// **'일정'**
  String get createDateTimeTitle;

  /// No description provided for @createDateLabel.
  ///
  /// In ko, this message translates to:
  /// **'활동 날짜'**
  String get createDateLabel;

  /// No description provided for @createDatePlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'날짜를 선택해 주세요'**
  String get createDatePlaceholder;

  /// No description provided for @createStartTimeLabel.
  ///
  /// In ko, this message translates to:
  /// **'시작 시간'**
  String get createStartTimeLabel;

  /// No description provided for @createStartTimePlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'시작 시간을 선택해 주세요'**
  String get createStartTimePlaceholder;

  /// No description provided for @createEndTimeLabel.
  ///
  /// In ko, this message translates to:
  /// **'종료 시간'**
  String get createEndTimeLabel;

  /// No description provided for @createEndTimePlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'종료 시간을 선택해 주세요'**
  String get createEndTimePlaceholder;

  /// No description provided for @createCapacityTitle.
  ///
  /// In ko, this message translates to:
  /// **'참가 인원'**
  String get createCapacityTitle;

  /// No description provided for @createCapacityValue.
  ///
  /// In ko, this message translates to:
  /// **'{count}명'**
  String createCapacityValue(int count);

  /// No description provided for @createCapacityHelper.
  ///
  /// In ko, this message translates to:
  /// **'최소 2명, 최대 20명'**
  String get createCapacityHelper;

  /// No description provided for @createDeadlineTitle.
  ///
  /// In ko, this message translates to:
  /// **'모집 마감'**
  String get createDeadlineTitle;

  /// No description provided for @createDeadlineDateLabel.
  ///
  /// In ko, this message translates to:
  /// **'마감 날짜'**
  String get createDeadlineDateLabel;

  /// No description provided for @createDeadlineTimeLabel.
  ///
  /// In ko, this message translates to:
  /// **'마감 시간'**
  String get createDeadlineTimeLabel;

  /// No description provided for @createNotSelected.
  ///
  /// In ko, this message translates to:
  /// **'선택 안 함'**
  String get createNotSelected;

  /// No description provided for @createLanguagesTitle.
  ///
  /// In ko, this message translates to:
  /// **'사용 언어'**
  String get createLanguagesTitle;

  /// No description provided for @createPriceTitle.
  ///
  /// In ko, this message translates to:
  /// **'참가 비용'**
  String get createPriceTitle;

  /// No description provided for @createPaidPriceHint.
  ///
  /// In ko, this message translates to:
  /// **'참가 금액을 입력해 주세요'**
  String get createPaidPriceHint;

  /// No description provided for @createAudienceTitle.
  ///
  /// In ko, this message translates to:
  /// **'추천 대상'**
  String get createAudienceTitle;

  /// No description provided for @createPrimaryImageTitle.
  ///
  /// In ko, this message translates to:
  /// **'대표 이미지'**
  String get createPrimaryImageTitle;

  /// No description provided for @createPrimaryImageRequiredHint.
  ///
  /// In ko, this message translates to:
  /// **'대표 이미지를 1장 이상 등록해 주세요.'**
  String get createPrimaryImageRequiredHint;

  /// No description provided for @createPrimaryImageSelectionHint.
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 이미지가 대표로 설정되며, 이미지를 눌러 대표 이미지를 바꿀 수 있어요.'**
  String get createPrimaryImageSelectionHint;

  /// No description provided for @createPrimaryImageBadge.
  ///
  /// In ko, this message translates to:
  /// **'대표'**
  String get createPrimaryImageBadge;

  /// No description provided for @createDeleting.
  ///
  /// In ko, this message translates to:
  /// **'삭제 중...'**
  String get createDeleting;

  /// No description provided for @createDeleteAction.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 삭제하기'**
  String createDeleteAction(Object entity);

  /// No description provided for @createPlaceGroupTitle.
  ///
  /// In ko, this message translates to:
  /// **'모임 장소를 선택해 주세요'**
  String get createPlaceGroupTitle;

  /// No description provided for @createPlaceClassTitle.
  ///
  /// In ko, this message translates to:
  /// **'클래스 장소를 선택해 주세요'**
  String get createPlaceClassTitle;

  /// No description provided for @createPlaceGroupDescription.
  ///
  /// In ko, this message translates to:
  /// **'추천 장소를 고르거나 직접 입력해서 모임 장소를 정할 수 있어요.'**
  String get createPlaceGroupDescription;

  /// No description provided for @createPlaceClassDescription.
  ///
  /// In ko, this message translates to:
  /// **'카테고리에 맞는 장소를 검색하거나 직접 입력해서 클래스 장소를 정할 수 있어요.'**
  String get createPlaceClassDescription;

  /// No description provided for @createClassCategoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'클래스 카테고리'**
  String get createClassCategoryTitle;

  /// No description provided for @createCategoryDetailTitle.
  ///
  /// In ko, this message translates to:
  /// **'세부 카테고리'**
  String get createCategoryDetailTitle;

  /// No description provided for @createManualPlaceTitle.
  ///
  /// In ko, this message translates to:
  /// **'직접 입력'**
  String get createManualPlaceTitle;

  /// No description provided for @createManualPlaceNameHint.
  ///
  /// In ko, this message translates to:
  /// **'장소명을 입력해 주세요'**
  String get createManualPlaceNameHint;

  /// No description provided for @createManualPlaceAddressHint.
  ///
  /// In ko, this message translates to:
  /// **'주소를 입력해 주세요'**
  String get createManualPlaceAddressHint;

  /// No description provided for @createOrSearchTitle.
  ///
  /// In ko, this message translates to:
  /// **'또는 장소 검색'**
  String get createOrSearchTitle;

  /// No description provided for @createPlaceSearchHint.
  ///
  /// In ko, this message translates to:
  /// **'장소명으로 검색해 보세요'**
  String get createPlaceSearchHint;

  /// No description provided for @createManualPlacePreviewDescription.
  ///
  /// In ko, this message translates to:
  /// **'직접 입력한 장소 정보로 등록됩니다.'**
  String get createManualPlacePreviewDescription;

  /// No description provided for @createSearchResultsTitle.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과'**
  String get createSearchResultsTitle;

  /// No description provided for @createSearchEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없어요'**
  String get createSearchEmptyTitle;

  /// No description provided for @createSearchEmptyBody.
  ///
  /// In ko, this message translates to:
  /// **'다른 검색어로 다시 찾아보세요.'**
  String get createSearchEmptyBody;

  /// No description provided for @createSearchInitialTitle.
  ///
  /// In ko, this message translates to:
  /// **'장소를 검색해 보세요'**
  String get createSearchInitialTitle;

  /// No description provided for @createSearchInitialBody.
  ///
  /// In ko, this message translates to:
  /// **'장소명이나 주소를 입력하면 선택할 수 있는 결과를 보여드려요.'**
  String get createSearchInitialBody;

  /// No description provided for @createRecommendedTitle.
  ///
  /// In ko, this message translates to:
  /// **'추천 장소'**
  String get createRecommendedTitle;

  /// No description provided for @createRefresh.
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get createRefresh;

  /// No description provided for @createRecommendedEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'추천 장소가 아직 없어요'**
  String get createRecommendedEmptyTitle;

  /// No description provided for @createRecommendedEmptyBody.
  ///
  /// In ko, this message translates to:
  /// **'카테고리를 바꾸거나 직접 검색해 보세요.'**
  String get createRecommendedEmptyBody;

  /// No description provided for @createMapPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'장소를 선택하면 이 영역에 위치가 표시됩니다.'**
  String get createMapPlaceholder;

  /// No description provided for @createCategoryPromptTitle.
  ///
  /// In ko, this message translates to:
  /// **'어떤 경험을 만들고 있나요?'**
  String get createCategoryPromptTitle;

  /// No description provided for @createCategoryPromptDescription.
  ///
  /// In ko, this message translates to:
  /// **'등록하려는 모임 또는 클래스에 가장 잘 맞는 카테고리를 선택해 주세요.'**
  String get createCategoryPromptDescription;

  /// No description provided for @createCompletedEditDescription.
  ///
  /// In ko, this message translates to:
  /// **'변경한 내용이 저장되었어요. 참가자에게 바로 반영됩니다.'**
  String get createCompletedEditDescription;

  /// No description provided for @createCompletedCreateDescription.
  ///
  /// In ko, this message translates to:
  /// **'이제 메이트야에서 참가자를 모집할 수 있어요.'**
  String get createCompletedCreateDescription;

  /// No description provided for @createBackToPrevious.
  ///
  /// In ko, this message translates to:
  /// **'이전으로'**
  String get createBackToPrevious;

  /// No description provided for @createBackToHome.
  ///
  /// In ko, this message translates to:
  /// **'홈으로 돌아가기'**
  String get createBackToHome;

  /// No description provided for @createStepCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get createStepCategory;

  /// No description provided for @createStepPlaceGroup.
  ///
  /// In ko, this message translates to:
  /// **'장소'**
  String get createStepPlaceGroup;

  /// No description provided for @createStepPlaceClass.
  ///
  /// In ko, this message translates to:
  /// **'장소'**
  String get createStepPlaceClass;

  /// No description provided for @createStepDetailsGroup.
  ///
  /// In ko, this message translates to:
  /// **'정보 입력'**
  String get createStepDetailsGroup;

  /// No description provided for @createStepDetailsClass.
  ///
  /// In ko, this message translates to:
  /// **'정보 입력'**
  String get createStepDetailsClass;

  /// No description provided for @createCompletedProgress.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get createCompletedProgress;

  /// No description provided for @createCategoryTitleCultureTradition.
  ///
  /// In ko, this message translates to:
  /// **'문화/전통'**
  String get createCategoryTitleCultureTradition;

  /// No description provided for @createCategoryTitleEventPerformanceFestival.
  ///
  /// In ko, this message translates to:
  /// **'행사/공연/축제'**
  String get createCategoryTitleEventPerformanceFestival;

  /// No description provided for @createCategoryTitleActivityLeports.
  ///
  /// In ko, this message translates to:
  /// **'액티비티/레포츠'**
  String get createCategoryTitleActivityLeports;

  /// No description provided for @createCategoryDescriptionTourist.
  ///
  /// In ko, this message translates to:
  /// **'대표 관광지에서 함께 둘러보는 모임에 적합해요.'**
  String get createCategoryDescriptionTourist;

  /// No description provided for @createCategoryDescriptionTravelCourse.
  ///
  /// In ko, this message translates to:
  /// **'이동 동선이 있는 여행형 코스에 잘 맞아요.'**
  String get createCategoryDescriptionTravelCourse;

  /// No description provided for @createCategoryDescriptionCultureTradition.
  ///
  /// In ko, this message translates to:
  /// **'전통문화, 공예, 역사 체험 같은 활동에 추천해요.'**
  String get createCategoryDescriptionCultureTradition;

  /// No description provided for @createCategoryDescriptionFestival.
  ///
  /// In ko, this message translates to:
  /// **'공연, 축제, 시즌 이벤트 참여형 활동에 적합해요.'**
  String get createCategoryDescriptionFestival;

  /// No description provided for @createCategoryDescriptionSports.
  ///
  /// In ko, this message translates to:
  /// **'운동, 경기 관람, 스포츠 기반 모임에 어울려요.'**
  String get createCategoryDescriptionSports;

  /// No description provided for @createCategoryDescriptionActivityLeports.
  ///
  /// In ko, this message translates to:
  /// **'야외 체험이나 액티브한 레포츠 활동에 적합해요.'**
  String get createCategoryDescriptionActivityLeports;

  /// No description provided for @createCategoryDescriptionPublicFacility.
  ///
  /// In ko, this message translates to:
  /// **'전시, 공공 공간, 지역 커뮤니티 활동에 추천해요.'**
  String get createCategoryDescriptionPublicFacility;

  /// No description provided for @createCategoryDescriptionShopping.
  ///
  /// In ko, this message translates to:
  /// **'시장, 쇼핑 거리, 로컬 상점 투어에 잘 맞아요.'**
  String get createCategoryDescriptionShopping;

  /// No description provided for @createEventDatePickerHelp.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 날짜 선택'**
  String createEventDatePickerHelp(Object entity);

  /// No description provided for @createStartTimePickerHelp.
  ///
  /// In ko, this message translates to:
  /// **'시작 시간 선택'**
  String get createStartTimePickerHelp;

  /// No description provided for @createEndTimePickerHelp.
  ///
  /// In ko, this message translates to:
  /// **'종료 시간 선택'**
  String get createEndTimePickerHelp;

  /// No description provided for @createDeadlineDatePickerHelp.
  ///
  /// In ko, this message translates to:
  /// **'모집 마감 날짜 선택'**
  String get createDeadlineDatePickerHelp;

  /// No description provided for @createDeadlineTimePickerHelp.
  ///
  /// In ko, this message translates to:
  /// **'모집 마감 시간 선택'**
  String get createDeadlineTimePickerHelp;

  /// No description provided for @createDeleteDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'{entity}을(를) 삭제할까요?'**
  String createDeleteDialogTitle(Object entity);

  /// No description provided for @createDeleteDialogBody.
  ///
  /// In ko, this message translates to:
  /// **'삭제하면 되돌릴 수 없어요.'**
  String createDeleteDialogBody(Object entity);

  /// No description provided for @createDeleteButton.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get createDeleteButton;

  /// No description provided for @createDeleteCompleted.
  ///
  /// In ko, this message translates to:
  /// **'삭제가 완료되었어요.'**
  String get createDeleteCompleted;

  /// No description provided for @createInitializationLoadError.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 정보를 불러오지 못했어요.'**
  String createInitializationLoadError(Object entity);

  /// No description provided for @createInitializationRetryBody.
  ///
  /// In ko, this message translates to:
  /// **'잠시 후 다시 시도해 주세요. 문제가 계속되면 이전 화면으로 돌아가 다시 진입해 주세요.'**
  String get createInitializationRetryBody;

  /// No description provided for @createSavingEntity.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 저장 중...'**
  String createSavingEntity(Object entity);

  /// No description provided for @createSubmittingEntity.
  ///
  /// In ko, this message translates to:
  /// **'{entity} 등록 중...'**
  String createSubmittingEntity(Object entity);

  /// No description provided for @createSelectPlaceAction.
  ///
  /// In ko, this message translates to:
  /// **'장소 선택하기'**
  String get createSelectPlaceAction;

  /// No description provided for @createImagePickerNotice.
  ///
  /// In ko, this message translates to:
  /// **'이미지를 첨부하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 다른 정보 입력은 계속할 수 있어요.'**
  String get createImagePickerNotice;

  /// No description provided for @createImagePickerRecovery.
  ///
  /// In ko, this message translates to:
  /// **'이미지 첨부를 계속하려면 사진 보관함 접근 권한이 필요합니다. 다시 시도하거나 앱 설정에서 권한을 허용해 주세요.'**
  String get createImagePickerRecovery;

  /// No description provided for @createImagePickerFailure.
  ///
  /// In ko, this message translates to:
  /// **'이미지를 불러오지 못했어요. 파일 상태를 확인한 뒤 다시 시도해 주세요.'**
  String get createImagePickerFailure;

  /// No description provided for @createImagePickerRestoreFallback.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택하던 이미지를 복구하지 못했어요. 다시 선택해 주세요.'**
  String get createImagePickerRestoreFallback;

  /// No description provided for @createImagePickerRestoredCount.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택한 이미지 {count}장을 복구했어요.'**
  String createImagePickerRestoredCount(int count);

  /// No description provided for @createRecommendedLoadFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'추천 장소를 불러오지 못했어요. 네트워크 상태를 확인해 주세요.'**
  String get createRecommendedLoadFailedNetwork;

  /// No description provided for @createRecommendedLoadFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'추천 장소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get createRecommendedLoadFailedServer;

  /// No description provided for @createPlaceSearchQueryRequired.
  ///
  /// In ko, this message translates to:
  /// **'장소명을 입력해 주세요.'**
  String get createPlaceSearchQueryRequired;

  /// No description provided for @createPlaceSearchFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'장소 검색에 실패했어요. 연결 상태를 확인한 뒤 다시 시도해 주세요.'**
  String get createPlaceSearchFailedNetwork;

  /// No description provided for @createPlaceSearchFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'장소 검색에 실패했어요. 잠시 후 다시 시도해 주세요.'**
  String get createPlaceSearchFailedServer;

  /// No description provided for @createPlaceCoordinateRequired.
  ///
  /// In ko, this message translates to:
  /// **'위치 정보가 없는 장소라 선택할 수 없어요.'**
  String get createPlaceCoordinateRequired;

  /// No description provided for @createPlaceMapCoordinateRequired.
  ///
  /// In ko, this message translates to:
  /// **'위치 정보가 없는 장소라 지도에 표시할 수 없어요.'**
  String get createPlaceMapCoordinateRequired;

  /// No description provided for @createImageLimitExceeded.
  ///
  /// In ko, this message translates to:
  /// **'이미지는 최대 {max}장까지 등록할 수 있어요.'**
  String createImageLimitExceeded(int max);

  /// No description provided for @createImageInvalidFormat.
  ///
  /// In ko, this message translates to:
  /// **'JPG, PNG, WEBP, GIF 형식의 이미지만 등록할 수 있어요.'**
  String get createImageInvalidFormat;

  /// No description provided for @createImageMaxSize.
  ///
  /// In ko, this message translates to:
  /// **'이미지 한 장당 최대 10MB까지 등록할 수 있어요.'**
  String get createImageMaxSize;

  /// No description provided for @createPlaceDescriptionFallback.
  ///
  /// In ko, this message translates to:
  /// **'위치를 확인한 뒤 선택해 주세요.'**
  String get createPlaceDescriptionFallback;

  /// No description provided for @createExistingPlaceDescription.
  ///
  /// In ko, this message translates to:
  /// **'기존 활동 장소'**
  String get createExistingPlaceDescription;

  /// No description provided for @createResolveServerCategoryFailed.
  ///
  /// In ko, this message translates to:
  /// **'선택한 장소에서 서버 카테고리를 확정할 수 없어요. 다른 장소를 선택해 주세요.'**
  String get createResolveServerCategoryFailed;

  /// No description provided for @createUploadImageRequired.
  ///
  /// In ko, this message translates to:
  /// **'대표 이미지를 1장 이상 등록해 주세요.'**
  String get createUploadImageRequired;

  /// No description provided for @createUploadImageInvalidFormat.
  ///
  /// In ko, this message translates to:
  /// **'JPG, PNG, WEBP, GIF 형식의 이미지만 업로드할 수 있어요.'**
  String get createUploadImageInvalidFormat;

  /// No description provided for @createUploadImageFailed.
  ///
  /// In ko, this message translates to:
  /// **'이미지 업로드에 실패했어요. 잠시 후 다시 시도해 주세요.'**
  String get createUploadImageFailed;

  /// No description provided for @createUploadImageConfirmFailed.
  ///
  /// In ko, this message translates to:
  /// **'이미지 업로드 확인에 실패했어요. 잠시 후 다시 시도해 주세요.'**
  String get createUploadImageConfirmFailed;

  /// No description provided for @onboardingValidationNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해 주세요.'**
  String get onboardingValidationNameRequired;

  /// No description provided for @onboardingValidationNameMaxLength.
  ///
  /// In ko, this message translates to:
  /// **'이름은 30자 이내로 입력해 주세요.'**
  String get onboardingValidationNameMaxLength;

  /// No description provided for @onboardingValidationNameCharacters.
  ///
  /// In ko, this message translates to:
  /// **'숫자와 특수문자 없이 이름만 입력해 주세요.'**
  String get onboardingValidationNameCharacters;

  /// No description provided for @onboardingValidationPhoneRequired.
  ///
  /// In ko, this message translates to:
  /// **'전화번호를 입력해 주세요.'**
  String get onboardingValidationPhoneRequired;

  /// No description provided for @onboardingValidationPhoneDigitsOnly.
  ///
  /// In ko, this message translates to:
  /// **'전화번호는 숫자만 입력해 주세요.'**
  String get onboardingValidationPhoneDigitsOnly;

  /// No description provided for @onboardingValidationPhoneMaxLength.
  ///
  /// In ko, this message translates to:
  /// **'전화번호는 최대 15자리까지 입력할 수 있어요.'**
  String get onboardingValidationPhoneMaxLength;

  /// No description provided for @onboardingValidationPhoneInvalid.
  ///
  /// In ko, this message translates to:
  /// **'전화번호를 정확히 입력해 주세요.'**
  String get onboardingValidationPhoneInvalid;

  /// No description provided for @onboardingValidationVerificationCodeRequired.
  ///
  /// In ko, this message translates to:
  /// **'인증번호 6자리를 입력해 주세요.'**
  String get onboardingValidationVerificationCodeRequired;

  /// No description provided for @onboardingValidationVerificationExpired.
  ///
  /// In ko, this message translates to:
  /// **'인증 시간이 만료됐어요. 인증번호를 다시 받아 주세요.'**
  String get onboardingValidationVerificationExpired;

  /// No description provided for @onboardingValidationVerificationMismatch.
  ///
  /// In ko, this message translates to:
  /// **'인증번호가 일치하지 않아요.'**
  String get onboardingValidationVerificationMismatch;

  /// No description provided for @onboardingValidationBusinessNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'상호명을 입력해 주세요.'**
  String get onboardingValidationBusinessNameRequired;

  /// No description provided for @onboardingValidationOpeningDateRequired.
  ///
  /// In ko, this message translates to:
  /// **'개업일자 8자리를 입력해 주세요.'**
  String get onboardingValidationOpeningDateRequired;

  /// No description provided for @onboardingValidationOpeningDateDigitsOnly.
  ///
  /// In ko, this message translates to:
  /// **'개업일자는 숫자만 입력해 주세요.'**
  String get onboardingValidationOpeningDateDigitsOnly;

  /// No description provided for @onboardingValidationOpeningDateInvalid.
  ///
  /// In ko, this message translates to:
  /// **'개업일자를 정확히 입력해 주세요.'**
  String get onboardingValidationOpeningDateInvalid;

  /// No description provided for @onboardingValidationBusinessNumberRequired.
  ///
  /// In ko, this message translates to:
  /// **'사업자 번호 10자리를 정확히 입력해 주세요.'**
  String get onboardingValidationBusinessNumberRequired;

  /// No description provided for @onboardingValidationBusinessNumberDigitsOnly.
  ///
  /// In ko, this message translates to:
  /// **'사업자 번호는 숫자만 입력해 주세요.'**
  String get onboardingValidationBusinessNumberDigitsOnly;

  /// No description provided for @onboardingLocationErrorServiceDisabled.
  ///
  /// In ko, this message translates to:
  /// **'위치 서비스가 꺼져 있어요. 직접 입력으로 진행해 주세요.'**
  String get onboardingLocationErrorServiceDisabled;

  /// No description provided for @onboardingLocationErrorPermissionDenied.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 없으면 현재 위치 자동 인증을 사용할 수 없어요. 직접 입력은 계속 진행할 수 있고, 권한을 허용하면 다시 시도할 수 있어요.'**
  String get onboardingLocationErrorPermissionDenied;

  /// No description provided for @onboardingLocationErrorPermissionPermanentlyDenied.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 꺼져 있어 현재 위치 자동 인증을 사용할 수 없어요. 앱 설정에서 권한을 허용하거나 직접 입력으로 계속 진행해 주세요.'**
  String get onboardingLocationErrorPermissionPermanentlyDenied;

  /// No description provided for @onboardingLocationErrorAccuracyLow.
  ///
  /// In ko, this message translates to:
  /// **'위치 정확도가 낮아 자동 인증이 어려워요.'**
  String get onboardingLocationErrorAccuracyLow;

  /// No description provided for @onboardingLocationErrorAddressNotFound.
  ///
  /// In ko, this message translates to:
  /// **'주소를 찾지 못했어요. 직접 입력으로 진행해 주세요.'**
  String get onboardingLocationErrorAddressNotFound;

  /// No description provided for @onboardingLocationErrorUnknown.
  ///
  /// In ko, this message translates to:
  /// **'위치를 불러오지 못했어요. 직접 입력으로 진행해 주세요.'**
  String get onboardingLocationErrorUnknown;

  /// No description provided for @onboardingLocationQueryRequired.
  ///
  /// In ko, this message translates to:
  /// **'동네명을 입력해 주세요.'**
  String get onboardingLocationQueryRequired;

  /// No description provided for @onboardingLocationQueryNotFound.
  ///
  /// In ko, this message translates to:
  /// **'입력한 동네를 찾지 못했어요.'**
  String get onboardingLocationQueryNotFound;

  /// No description provided for @onboardingLocationCurrentFallback.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치'**
  String get onboardingLocationCurrentFallback;

  /// No description provided for @homeParticipantCount.
  ///
  /// In ko, this message translates to:
  /// **'{current}/{capacity} 참여'**
  String homeParticipantCount(int current, int capacity);

  /// No description provided for @homeFavoritesSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'당신의 관심을 세상과 공유하세요.'**
  String get homeFavoritesSubtitle;

  /// No description provided for @homeFavoritesEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 즐겨찾기한 활동이 없어요.'**
  String get homeFavoritesEmptyTitle;

  /// No description provided for @homeFavoritesEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'마음에 드는 활동을 저장하면 여기서 다시 볼 수 있어요.'**
  String get homeFavoritesEmptyDescription;

  /// No description provided for @homeNearbyCultureMap.
  ///
  /// In ko, this message translates to:
  /// **'내 주변 전통문화'**
  String get homeNearbyCultureMap;

  /// No description provided for @onboardingTermsPendingEffectiveDate.
  ///
  /// In ko, this message translates to:
  /// **'확인 중'**
  String get onboardingTermsPendingEffectiveDate;

  /// No description provided for @onboardingTermsServiceTitle.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 약관'**
  String get onboardingTermsServiceTitle;

  /// No description provided for @onboardingTermsServiceSummary.
  ///
  /// In ko, this message translates to:
  /// **'메이트야 서비스 이용을 위한 기본 조건, 이용자 책임, 서비스 운영 기준을 안내합니다.'**
  String get onboardingTermsServiceSummary;

  /// No description provided for @onboardingTermsServiceSection1Title.
  ///
  /// In ko, this message translates to:
  /// **'서비스 목적'**
  String get onboardingTermsServiceSection1Title;

  /// No description provided for @onboardingTermsServiceSection1Body.
  ///
  /// In ko, this message translates to:
  /// **'메이트야는 국내 사용자와 외국인이 모임, 클래스, 지역 기반 활동을 안전하게 탐색하고 참여할 수 있도록 연결하는 플랫폼입니다.'**
  String get onboardingTermsServiceSection1Body;

  /// No description provided for @onboardingTermsServiceSection2Title.
  ///
  /// In ko, this message translates to:
  /// **'회원가입 및 계정 관리'**
  String get onboardingTermsServiceSection2Title;

  /// No description provided for @onboardingTermsServiceSection2Body.
  ///
  /// In ko, this message translates to:
  /// **'회원은 본인 명의의 정보로 가입해야 하며, 휴대전화 인증과 약관 동의를 완료해야 서비스를 이용할 수 있습니다. 계정 정보가 변경되면 최신 상태로 유지해야 합니다.'**
  String get onboardingTermsServiceSection2Body;

  /// No description provided for @onboardingTermsServiceSection3Title.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 조건'**
  String get onboardingTermsServiceSection3Title;

  /// No description provided for @onboardingTermsServiceSection3Body.
  ///
  /// In ko, this message translates to:
  /// **'회원은 관련 법령과 본 약관을 준수해야 하며, 타인의 권리를 침해하거나 서비스 운영을 방해하는 행위를 해서는 안 됩니다. 일부 기능은 본인 확인이나 추가 인증이 필요할 수 있습니다.'**
  String get onboardingTermsServiceSection3Body;

  /// No description provided for @onboardingTermsServiceSection4Title.
  ///
  /// In ko, this message translates to:
  /// **'금지 행위'**
  String get onboardingTermsServiceSection4Title;

  /// No description provided for @onboardingTermsServiceSection4Body.
  ///
  /// In ko, this message translates to:
  /// **'허위 정보 등록, 타인 사칭, 불법 홍보, 음란물 또는 혐오 표현 게시, 비정상적인 자동화 접근, 운영 정책 우회를 위한 시도는 금지됩니다. 위반 시 게시물 삭제, 이용 제한, 계정 정지 조치가 이루어질 수 있습니다.'**
  String get onboardingTermsServiceSection4Body;

  /// No description provided for @onboardingTermsServiceSection5Title.
  ///
  /// In ko, this message translates to:
  /// **'서비스 중단 및 변경'**
  String get onboardingTermsServiceSection5Title;

  /// No description provided for @onboardingTermsServiceSection5Body.
  ///
  /// In ko, this message translates to:
  /// **'메이트야는 점검, 장애 대응, 정책 변경 또는 외부 제휴 사정에 따라 서비스 일부를 변경하거나 일시 중단할 수 있습니다. 중요한 변경은 앱 내 공지 또는 적절한 수단으로 안내합니다.'**
  String get onboardingTermsServiceSection5Body;

  /// No description provided for @onboardingTermsServiceSection6Title.
  ///
  /// In ko, this message translates to:
  /// **'책임 제한'**
  String get onboardingTermsServiceSection6Title;

  /// No description provided for @onboardingTermsServiceSection6Body.
  ///
  /// In ko, this message translates to:
  /// **'메이트야는 천재지변, 통신 장애, 이용자 귀책 사유로 발생한 손해에 대해 법령이 허용하는 범위에서 책임을 제한할 수 있습니다. 다만 회사의 고의 또는 중대한 과실이 있는 경우에는 예외로 합니다.'**
  String get onboardingTermsServiceSection6Body;

  /// No description provided for @onboardingTermsServiceSection7Title.
  ///
  /// In ko, this message translates to:
  /// **'문의처'**
  String get onboardingTermsServiceSection7Title;

  /// No description provided for @onboardingTermsServiceSection7Body.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 중 문의가 필요하면 앱 내 고객지원 채널 또는 운영팀 이메일을 통해 접수할 수 있으며, 접수된 내용은 운영 정책에 따라 순차적으로 처리됩니다.'**
  String get onboardingTermsServiceSection7Body;

  /// No description provided for @onboardingTermsPrivacyTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 제3자 제공 동의'**
  String get onboardingTermsPrivacyTitle;

  /// No description provided for @onboardingTermsPrivacySummary.
  ///
  /// In ko, this message translates to:
  /// **'활동 운영, 예약 진행, 고객 응대에 필요한 범위에서 개인정보가 제3자에게 제공되는 기준을 설명합니다.'**
  String get onboardingTermsPrivacySummary;

  /// No description provided for @onboardingTermsPrivacySection1Title.
  ///
  /// In ko, this message translates to:
  /// **'제공받는 자'**
  String get onboardingTermsPrivacySection1Title;

  /// No description provided for @onboardingTermsPrivacySection1Body.
  ///
  /// In ko, this message translates to:
  /// **'메이트야 내 모임/클래스를 운영하는 호스트 또는 서비스 운영에 필요한 제휴 사업자'**
  String get onboardingTermsPrivacySection1Body;

  /// No description provided for @onboardingTermsPrivacySection2Title.
  ///
  /// In ko, this message translates to:
  /// **'제공 목적'**
  String get onboardingTermsPrivacySection2Title;

  /// No description provided for @onboardingTermsPrivacySection2Body.
  ///
  /// In ko, this message translates to:
  /// **'참여 신청 확인, 호스트와의 원활한 일정 조율, 현장 운영 지원, 고객 문의 대응 및 분쟁 처리'**
  String get onboardingTermsPrivacySection2Body;

  /// No description provided for @onboardingTermsPrivacySection3Title.
  ///
  /// In ko, this message translates to:
  /// **'제공 항목'**
  String get onboardingTermsPrivacySection3Title;

  /// No description provided for @onboardingTermsPrivacySection3Body.
  ///
  /// In ko, this message translates to:
  /// **'이름, 휴대전화 번호, 활동 신청 정보, 대표 언어, 참여 이력 중 서비스 제공에 필요한 최소 항목'**
  String get onboardingTermsPrivacySection3Body;

  /// No description provided for @onboardingTermsPrivacySection4Title.
  ///
  /// In ko, this message translates to:
  /// **'보유 및 이용 기간'**
  String get onboardingTermsPrivacySection4Title;

  /// No description provided for @onboardingTermsPrivacySection4Body.
  ///
  /// In ko, this message translates to:
  /// **'제공 목적 달성 시까지 또는 관련 법령상 보존 의무 기간까지 보관되며, 이후에는 지체 없이 삭제하거나 익명화합니다.'**
  String get onboardingTermsPrivacySection4Body;

  /// No description provided for @onboardingTermsPrivacySection5Title.
  ///
  /// In ko, this message translates to:
  /// **'동의 거부 권리 및 불이익'**
  String get onboardingTermsPrivacySection5Title;

  /// No description provided for @onboardingTermsPrivacySection5Body.
  ///
  /// In ko, this message translates to:
  /// **'회원은 개인정보 제3자 제공 동의를 거부할 수 있습니다. 다만 활동 참여, 예약 확인, 호스트와의 연락이 필요한 일부 서비스 이용이 제한될 수 있습니다.'**
  String get onboardingTermsPrivacySection5Body;

  /// No description provided for @onboardingTermsLocationTitle.
  ///
  /// In ko, this message translates to:
  /// **'위치기반서비스 이용약관'**
  String get onboardingTermsLocationTitle;

  /// No description provided for @onboardingTermsLocationSummary.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치와 활동 지역 정보를 활용해 주변 모임과 추천 결과를 제공하는 방식 및 보호 기준을 안내합니다.'**
  String get onboardingTermsLocationSummary;

  /// No description provided for @onboardingTermsLocationSection1Title.
  ///
  /// In ko, this message translates to:
  /// **'목적'**
  String get onboardingTermsLocationSection1Title;

  /// No description provided for @onboardingTermsLocationSection1Body.
  ///
  /// In ko, this message translates to:
  /// **'본 약관은 메이트야가 제공하는 위치기반서비스의 이용조건과 절차, 회사와 이용자의 권리 및 의무, 위치정보 보호 기준을 안내하는 데 목적이 있습니다.'**
  String get onboardingTermsLocationSection1Body;

  /// No description provided for @onboardingTermsLocationSection2Title.
  ///
  /// In ko, this message translates to:
  /// **'위치정보 수집 및 이용'**
  String get onboardingTermsLocationSection2Title;

  /// No description provided for @onboardingTermsLocationSection2Body.
  ///
  /// In ko, this message translates to:
  /// **'회사는 이용자가 요청한 기능 범위 안에서 현재 위치 또는 활동 지역 정보를 활용하며, 다음 목적에 한해 위치정보를 이용합니다.'**
  String get onboardingTermsLocationSection2Body;

  /// No description provided for @onboardingTermsLocationSection2Point1.
  ///
  /// In ko, this message translates to:
  /// **'동네 인증과 활동 지역 확인'**
  String get onboardingTermsLocationSection2Point1;

  /// No description provided for @onboardingTermsLocationSection2Point2.
  ///
  /// In ko, this message translates to:
  /// **'주변 모임 추천 및 거리 기반 정렬'**
  String get onboardingTermsLocationSection2Point2;

  /// No description provided for @onboardingTermsLocationSection2Point3.
  ///
  /// In ko, this message translates to:
  /// **'지역 맞춤형 콘텐츠와 안전한 참여 경험 제공'**
  String get onboardingTermsLocationSection2Point3;

  /// No description provided for @onboardingTermsLocationSection3Title.
  ///
  /// In ko, this message translates to:
  /// **'보유 및 이용기간'**
  String get onboardingTermsLocationSection3Title;

  /// No description provided for @onboardingTermsLocationSection3Body.
  ///
  /// In ko, this message translates to:
  /// **'실시간 위치정보는 즉시성 기능 처리 후 보관하지 않습니다. 다만 활동 지역 인증 결과와 같이 서비스 운영에 필요한 최소 정보는 관련 법령 또는 내부 운영 기준에 따라 필요한 기간 동안 보관한 뒤 지체 없이 삭제하거나 익명화합니다.'**
  String get onboardingTermsLocationSection3Body;

  /// No description provided for @onboardingTermsLocationSection4Title.
  ///
  /// In ko, this message translates to:
  /// **'이용자의 권리'**
  String get onboardingTermsLocationSection4Title;

  /// No description provided for @onboardingTermsLocationSection4Body.
  ///
  /// In ko, this message translates to:
  /// **'이용자는 언제든지 단말기 설정 또는 앱 내 권한 설정을 통해 위치정보 제공 동의를 철회할 수 있으며, 위치기반서비스 이용 여부를 선택할 수 있습니다. 동의 철회 시 일부 추천 기능이나 동네 인증 기능 이용이 제한될 수 있습니다.'**
  String get onboardingTermsLocationSection4Body;

  /// No description provided for @onboardingTermsLocationSection5Title.
  ///
  /// In ko, this message translates to:
  /// **'회사의 의무'**
  String get onboardingTermsLocationSection5Title;

  /// No description provided for @onboardingTermsLocationSection5Body.
  ///
  /// In ko, this message translates to:
  /// **'회사는 위치정보를 관련 법령과 내부 보안 기준에 따라 안전하게 관리하며, 이용 목적 범위를 벗어난 사용이나 별도 동의 없는 제3자 제공을 하지 않습니다. 또한 이용자의 문의와 민원을 신속하게 확인하고 필요한 조치를 안내합니다.'**
  String get onboardingTermsLocationSection5Body;

  /// No description provided for @onboardingTermsLocationSection6Title.
  ///
  /// In ko, this message translates to:
  /// **'문의처'**
  String get onboardingTermsLocationSection6Title;

  /// No description provided for @onboardingTermsLocationSection6Body.
  ///
  /// In ko, this message translates to:
  /// **'위치기반서비스 이용과 관련한 문의는 앱 내 고객지원 채널 또는 운영팀 문의 창구를 통해 접수할 수 있습니다. 접수된 문의는 내부 정책에 따라 순차적으로 처리됩니다.'**
  String get onboardingTermsLocationSection6Body;

  /// No description provided for @onboardingTermsAgeTitle.
  ///
  /// In ko, this message translates to:
  /// **'만 14세 이상 확인'**
  String get onboardingTermsAgeTitle;

  /// No description provided for @onboardingTermsAgeSummary.
  ///
  /// In ko, this message translates to:
  /// **'메이트야 회원가입은 만 14세 이상만 가능하며, 연령 확인과 관련한 이용 제한 기준을 안내합니다.'**
  String get onboardingTermsAgeSummary;

  /// No description provided for @onboardingTermsAgeSection1Title.
  ///
  /// In ko, this message translates to:
  /// **'연령 확인'**
  String get onboardingTermsAgeSection1Title;

  /// No description provided for @onboardingTermsAgeSection1Body.
  ///
  /// In ko, this message translates to:
  /// **'회원은 회원가입 시 본인이 만 14세 이상임을 확인하고 이에 동의해야 합니다.'**
  String get onboardingTermsAgeSection1Body;

  /// No description provided for @onboardingTermsAgeSection2Title.
  ///
  /// In ko, this message translates to:
  /// **'가입 제한'**
  String get onboardingTermsAgeSection2Title;

  /// No description provided for @onboardingTermsAgeSection2Body.
  ///
  /// In ko, this message translates to:
  /// **'만 14세 미만 사용자는 메이트야 회원가입 및 서비스 이용이 제한됩니다.'**
  String get onboardingTermsAgeSection2Body;

  /// No description provided for @onboardingTermsAgeSection3Title.
  ///
  /// In ko, this message translates to:
  /// **'허위 확인에 대한 조치'**
  String get onboardingTermsAgeSection3Title;

  /// No description provided for @onboardingTermsAgeSection3Body.
  ///
  /// In ko, this message translates to:
  /// **'연령을 허위로 확인하여 가입한 사실이 확인되면 서비스 이용 제한, 계정 해지 또는 필요한 추가 확인 절차가 진행될 수 있습니다.'**
  String get onboardingTermsAgeSection3Body;

  /// No description provided for @chatAttachmentRecoveryFailed.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택하던 사진을 복구하지 못했어요. 다시 선택해 주세요.'**
  String get chatAttachmentRecoveryFailed;

  /// No description provided for @chatAttachmentSheetTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 첨부'**
  String get chatAttachmentSheetTitle;

  /// No description provided for @chatAttachmentSheetDescription.
  ///
  /// In ko, this message translates to:
  /// **'앨범에서 여러 장을 고르거나 카메라로 바로 촬영해 보낼 수 있어요.'**
  String get chatAttachmentSheetDescription;

  /// No description provided for @chatAttachmentGalleryTitle.
  ///
  /// In ko, this message translates to:
  /// **'앨범에서 선택'**
  String get chatAttachmentGalleryTitle;

  /// No description provided for @chatAttachmentGallerySubtitle.
  ///
  /// In ko, this message translates to:
  /// **'여러 장을 한 번에 고를 수 있습니다.'**
  String get chatAttachmentGallerySubtitle;

  /// No description provided for @chatAttachmentCameraTitle.
  ///
  /// In ko, this message translates to:
  /// **'카메라로 촬영'**
  String get chatAttachmentCameraTitle;

  /// No description provided for @chatAttachmentCameraSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 1장을 바로 찍어 첨부합니다.'**
  String get chatAttachmentCameraSubtitle;

  /// No description provided for @chatAttachmentGuideFormats.
  ///
  /// In ko, this message translates to:
  /// **'허용 형식: JPG, PNG, WEBP, GIF, HEIC, HEIF'**
  String get chatAttachmentGuideFormats;

  /// No description provided for @chatAttachmentGuideMaxSize.
  ///
  /// In ko, this message translates to:
  /// **'최대 크기: 10MB'**
  String get chatAttachmentGuideMaxSize;

  /// No description provided for @chatAttachmentGuideMaxCount.
  ///
  /// In ko, this message translates to:
  /// **'메시지당 최대 {count}장'**
  String chatAttachmentGuideMaxCount(int count);

  /// No description provided for @chatAttachmentPhotoPermissionTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 권한 안내'**
  String get chatAttachmentPhotoPermissionTitle;

  /// No description provided for @chatAttachmentCameraPermissionTitle.
  ///
  /// In ko, this message translates to:
  /// **'카메라 권한 안내'**
  String get chatAttachmentCameraPermissionTitle;

  /// No description provided for @chatAttachmentPhotoPermissionMessage.
  ///
  /// In ko, this message translates to:
  /// **'채팅에서 사진을 첨부하려면 사진 보관함 접근 권한이 필요합니다. 권한을 거부하셔도 텍스트 채팅은 계속 이용할 수 있습니다.'**
  String get chatAttachmentPhotoPermissionMessage;

  /// No description provided for @chatAttachmentCameraPermissionMessage.
  ///
  /// In ko, this message translates to:
  /// **'채팅에서 사진을 바로 촬영해 보내려면 카메라 권한이 필요합니다. 권한을 거부하셔도 텍스트 채팅은 계속 이용할 수 있습니다.'**
  String get chatAttachmentCameraPermissionMessage;

  /// No description provided for @chatAttachmentPhotoSelect.
  ///
  /// In ko, this message translates to:
  /// **'사진 선택하기'**
  String get chatAttachmentPhotoSelect;

  /// No description provided for @chatAttachmentOpenCamera.
  ///
  /// In ko, this message translates to:
  /// **'카메라 열기'**
  String get chatAttachmentOpenCamera;

  /// No description provided for @chatAttachmentPhotoRecoveryTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 권한이 필요해요'**
  String get chatAttachmentPhotoRecoveryTitle;

  /// No description provided for @chatAttachmentCameraRecoveryTitle.
  ///
  /// In ko, this message translates to:
  /// **'카메라 권한이 필요해요'**
  String get chatAttachmentCameraRecoveryTitle;

  /// No description provided for @chatAttachmentPhotoRecoveryMessage.
  ///
  /// In ko, this message translates to:
  /// **'사진 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 텍스트 채팅은 계속할 수 있고, 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.'**
  String get chatAttachmentPhotoRecoveryMessage;

  /// No description provided for @chatAttachmentCameraRecoveryMessage.
  ///
  /// In ko, this message translates to:
  /// **'사진 촬영 첨부를 사용하려면 카메라 권한이 필요합니다. 권한이 없어도 텍스트 채팅은 계속할 수 있고, 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.'**
  String get chatAttachmentCameraRecoveryMessage;

  /// No description provided for @chatAttachmentLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.'**
  String get chatAttachmentLoadFailed;

  /// No description provided for @chatAttachmentAddedCount.
  ///
  /// In ko, this message translates to:
  /// **'사진 {count}장을 첨부했어요.'**
  String chatAttachmentAddedCount(int count);

  /// No description provided for @chatAttachmentRejectedTypeCount.
  ///
  /// In ko, this message translates to:
  /// **'지원하지 않는 형식의 사진 {count}장은 제외했어요.'**
  String chatAttachmentRejectedTypeCount(int count);

  /// No description provided for @chatAttachmentRejectedSizeCount.
  ///
  /// In ko, this message translates to:
  /// **'10MB를 초과한 사진 {count}장은 제외했어요.'**
  String chatAttachmentRejectedSizeCount(int count);

  /// No description provided for @chatAttachmentOverflowCount.
  ///
  /// In ko, this message translates to:
  /// **'사진은 최대 {count}장까지 첨부할 수 있어요.'**
  String chatAttachmentOverflowCount(int count);

  /// No description provided for @chatAttachmentPhotoOnly.
  ///
  /// In ko, this message translates to:
  /// **'사진'**
  String get chatAttachmentPhotoOnly;

  /// No description provided for @chatAttachmentInvalidFormat.
  ///
  /// In ko, this message translates to:
  /// **'JPG, PNG, WEBP, GIF, HEIC, HEIF 형식의 이미지만 전송할 수 있어요.'**
  String get chatAttachmentInvalidFormat;

  /// No description provided for @chatAttachmentUploadFailed.
  ///
  /// In ko, this message translates to:
  /// **'채팅 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get chatAttachmentUploadFailed;

  /// No description provided for @chatListLoadError.
  ///
  /// In ko, this message translates to:
  /// **'채팅 목록을 불러오지 못했어요.'**
  String get chatListLoadError;

  /// No description provided for @chatListEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'표시할 채팅방이 없어요.'**
  String get chatListEmptyTitle;

  /// No description provided for @chatListEmptyBody.
  ///
  /// In ko, this message translates to:
  /// **'필터를 바꾸거나 새로운 대화를 시작해 보세요.'**
  String get chatListEmptyBody;

  /// No description provided for @chatListLoadMoreHint.
  ///
  /// In ko, this message translates to:
  /// **'스크롤하면 채팅방을 더 불러옵니다.'**
  String get chatListLoadMoreHint;

  /// No description provided for @chatListLoadMoreFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'채팅 목록을 더 불러오지 못했어요. 네트워크를 확인해 주세요.'**
  String get chatListLoadMoreFailedNetwork;

  /// No description provided for @chatListLoadMoreFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'채팅 목록을 더 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get chatListLoadMoreFailedServer;

  /// No description provided for @chatRoomMissing.
  ///
  /// In ko, this message translates to:
  /// **'채팅방 정보를 찾을 수 없어요.'**
  String get chatRoomMissing;

  /// No description provided for @chatBackToList.
  ///
  /// In ko, this message translates to:
  /// **'목록으로'**
  String get chatBackToList;

  /// No description provided for @chatRoomLoadError.
  ///
  /// In ko, this message translates to:
  /// **'채팅방을 불러오지 못했어요.'**
  String get chatRoomLoadError;

  /// No description provided for @chatOlderMessagesHint.
  ///
  /// In ko, this message translates to:
  /// **'위로 스크롤하면 이전 메시지를 더 불러옵니다.'**
  String get chatOlderMessagesHint;

  /// No description provided for @chatOlderMessagesFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'이전 메시지를 불러오지 못했어요. 네트워크를 확인해 주세요.'**
  String get chatOlderMessagesFailedNetwork;

  /// No description provided for @chatOlderMessagesFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'이전 메시지를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get chatOlderMessagesFailedServer;

  /// No description provided for @chatReadSyncFailed.
  ///
  /// In ko, this message translates to:
  /// **'읽음 상태를 서버에 반영하지 못했어요. 다음에 다시 시도합니다.'**
  String get chatReadSyncFailed;

  /// No description provided for @chatSendFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'메시지를 전송하지 못했어요. 네트워크를 확인해 주세요.'**
  String get chatSendFailedNetwork;

  /// No description provided for @chatSendFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'메시지를 전송하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get chatSendFailedServer;

  /// No description provided for @chatMe.
  ///
  /// In ko, this message translates to:
  /// **'나'**
  String get chatMe;

  /// No description provided for @chatDefaultDirectRoomTitle.
  ///
  /// In ko, this message translates to:
  /// **'1:1 채팅'**
  String get chatDefaultDirectRoomTitle;

  /// No description provided for @chatDefaultGroupRoomTitle.
  ///
  /// In ko, this message translates to:
  /// **'채팅방'**
  String get chatDefaultGroupRoomTitle;

  /// No description provided for @chatRealtimeConnectionError.
  ///
  /// In ko, this message translates to:
  /// **'실시간 채팅 연결에 실패했어요.'**
  String get chatRealtimeConnectionError;

  /// No description provided for @chatRealtimeMessageError.
  ///
  /// In ko, this message translates to:
  /// **'실시간 채팅 메시지를 처리하지 못했어요.'**
  String get chatRealtimeMessageError;

  /// No description provided for @homeActivityRegionFallback.
  ///
  /// In ko, this message translates to:
  /// **'활동 지역'**
  String get homeActivityRegionFallback;

  /// No description provided for @homeNearbyMapLoadError.
  ///
  /// In ko, this message translates to:
  /// **'지도 장소를 불러오지 못했어요.'**
  String get homeNearbyMapLoadError;

  /// No description provided for @homeNearbyMapCurrentLocationLabel.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치 기준'**
  String get homeNearbyMapCurrentLocationLabel;

  /// No description provided for @homeNearbyMapSearchHint.
  ///
  /// In ko, this message translates to:
  /// **'무엇을 찾아볼까요?'**
  String get homeNearbyMapSearchHint;

  /// No description provided for @homeNearbyMapEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'주변 장소를 찾지 못했어요'**
  String get homeNearbyMapEmptyTitle;

  /// No description provided for @homeNearbyMapEmptyBody.
  ///
  /// In ko, this message translates to:
  /// **'검색어를 바꾸거나 현재 위치를 다시 불러와 보세요.'**
  String get homeNearbyMapEmptyBody;

  /// No description provided for @homeNearbyMapListTitle.
  ///
  /// In ko, this message translates to:
  /// **'주변 장소 목록'**
  String get homeNearbyMapListTitle;

  /// No description provided for @homeNearbyMapPlaceCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}곳'**
  String homeNearbyMapPlaceCount(int count);

  /// No description provided for @homeNearbyMapListButton.
  ///
  /// In ko, this message translates to:
  /// **'목록보기'**
  String get homeNearbyMapListButton;

  /// No description provided for @homeNearbyMapBadgeFallback.
  ///
  /// In ko, this message translates to:
  /// **'주변 장소'**
  String get homeNearbyMapBadgeFallback;

  /// No description provided for @homeNearbyMapParseError.
  ///
  /// In ko, this message translates to:
  /// **'장소 데이터를 해석하지 못했어요.'**
  String get homeNearbyMapParseError;

  /// No description provided for @homeNearbyMapLocationLoadError.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 가져오지 못했어요.'**
  String get homeNearbyMapLocationLoadError;

  /// No description provided for @homeNearbyMapLocationRefreshError.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 다시 가져오지 못했어요.'**
  String get homeNearbyMapLocationRefreshError;

  /// No description provided for @homeNearbyMapLocationRequired.
  ///
  /// In ko, this message translates to:
  /// **'지도를 보려면 위치 정보를 먼저 확인해 주세요.'**
  String get homeNearbyMapLocationRequired;

  /// No description provided for @homeNearbyMapPlacesLoadError.
  ///
  /// In ko, this message translates to:
  /// **'장소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get homeNearbyMapPlacesLoadError;

  /// No description provided for @detailsActivityRequired.
  ///
  /// In ko, this message translates to:
  /// **'활동 정보를 먼저 불러와야 합니다.'**
  String get detailsActivityRequired;

  /// No description provided for @detailsFavoriteToggleError.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 상태를 변경하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsFavoriteToggleError;

  /// No description provided for @detailsJoinAlreadyRequested.
  ///
  /// In ko, this message translates to:
  /// **'이미 참여 신청한 활동입니다.'**
  String get detailsJoinAlreadyRequested;

  /// No description provided for @detailsJoinAlreadyJoined.
  ///
  /// In ko, this message translates to:
  /// **'이미 참여 중인 활동입니다.'**
  String get detailsJoinAlreadyJoined;

  /// No description provided for @detailsJoinHostedByMe.
  ///
  /// In ko, this message translates to:
  /// **'내가 만든 활동입니다.'**
  String get detailsJoinHostedByMe;

  /// No description provided for @detailsJoinRequestError.
  ///
  /// In ko, this message translates to:
  /// **'참여 신청을 완료하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsJoinRequestError;

  /// No description provided for @detailsParticipantRemoveError.
  ///
  /// In ko, this message translates to:
  /// **'참여자를 삭제하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsParticipantRemoveError;

  /// No description provided for @detailsPendingCancelError.
  ///
  /// In ko, this message translates to:
  /// **'신청을 취소하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsPendingCancelError;

  /// No description provided for @detailsPendingApproveError.
  ///
  /// In ko, this message translates to:
  /// **'참여 신청을 승인하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsPendingApproveError;

  /// No description provided for @detailsReviewRequired.
  ///
  /// In ko, this message translates to:
  /// **'후기 정보를 먼저 불러와야 합니다.'**
  String get detailsReviewRequired;

  /// No description provided for @detailsHelpfulToggleError.
  ///
  /// In ko, this message translates to:
  /// **'도움이 돼요 상태를 변경하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsHelpfulToggleError;

  /// No description provided for @detailsReviewValidationRequired.
  ///
  /// In ko, this message translates to:
  /// **'별점과 후기를 입력해 주세요.'**
  String get detailsReviewValidationRequired;

  /// No description provided for @detailsReviewSubmitError.
  ///
  /// In ko, this message translates to:
  /// **'후기를 등록하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsReviewSubmitError;

  /// No description provided for @detailsLoadError.
  ///
  /// In ko, this message translates to:
  /// **'활동 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsLoadError;

  /// No description provided for @detailsReviewSortLatest.
  ///
  /// In ko, this message translates to:
  /// **'최신순'**
  String get detailsReviewSortLatest;

  /// No description provided for @detailsReviewSortOldest.
  ///
  /// In ko, this message translates to:
  /// **'오래된순'**
  String get detailsReviewSortOldest;

  /// No description provided for @detailsReviewSortHighestRating.
  ///
  /// In ko, this message translates to:
  /// **'평점 높은순'**
  String get detailsReviewSortHighestRating;

  /// No description provided for @detailsReviewSortLowestRating.
  ///
  /// In ko, this message translates to:
  /// **'평점 낮은순'**
  String get detailsReviewSortLowestRating;

  /// No description provided for @detailsJoinAvailable.
  ///
  /// In ko, this message translates to:
  /// **'참가하기'**
  String get detailsJoinAvailable;

  /// No description provided for @detailsJoinRequested.
  ///
  /// In ko, this message translates to:
  /// **'신청 완료'**
  String get detailsJoinRequested;

  /// No description provided for @detailsJoinJoined.
  ///
  /// In ko, this message translates to:
  /// **'참가중'**
  String get detailsJoinJoined;

  /// No description provided for @detailsJoinHost.
  ///
  /// In ko, this message translates to:
  /// **'내 모임'**
  String get detailsJoinHost;

  /// No description provided for @detailsReviewSummary.
  ///
  /// In ko, this message translates to:
  /// **'{average} (후기 {count}개)'**
  String detailsReviewSummary(Object average, int count);

  /// No description provided for @detailsParticipantSummary.
  ///
  /// In ko, this message translates to:
  /// **'{current}/{capacity} 참여'**
  String detailsParticipantSummary(int current, int capacity);

  /// No description provided for @detailsParticipantsJoined.
  ///
  /// In ko, this message translates to:
  /// **'{count}명 참여중'**
  String detailsParticipantsJoined(int count);

  /// No description provided for @detailsParticipantsRemaining.
  ///
  /// In ko, this message translates to:
  /// **'{count}명 남았어요'**
  String detailsParticipantsRemaining(int count);

  /// No description provided for @detailsRecruitmentClosed.
  ///
  /// In ko, this message translates to:
  /// **'모집 마감'**
  String get detailsRecruitmentClosed;

  /// No description provided for @detailsIntroduction.
  ///
  /// In ko, this message translates to:
  /// **'활동 소개'**
  String get detailsIntroduction;

  /// No description provided for @detailsReviewsTitle.
  ///
  /// In ko, this message translates to:
  /// **'후기 {count}개'**
  String detailsReviewsTitle(int count);

  /// No description provided for @detailsReviewsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'아직 등록된 후기가 없어요. 첫 후기를 남겨보세요.'**
  String get detailsReviewsEmpty;

  /// No description provided for @detailsPriceLabel.
  ///
  /// In ko, this message translates to:
  /// **'체험료'**
  String get detailsPriceLabel;

  /// No description provided for @detailsJoinRequesting.
  ///
  /// In ko, this message translates to:
  /// **'신청 중...'**
  String get detailsJoinRequesting;

  /// No description provided for @detailsReviewRatingSummary.
  ///
  /// In ko, this message translates to:
  /// **'전체 {count}개 후기'**
  String detailsReviewRatingSummary(int count);

  /// No description provided for @detailsReviewRating.
  ///
  /// In ko, this message translates to:
  /// **'{rating}점'**
  String detailsReviewRating(int rating);

  /// No description provided for @detailsReviewHelpfulCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}명에게 도움이 됨'**
  String detailsReviewHelpfulCount(int count);

  /// No description provided for @detailsReviewViewOriginal.
  ///
  /// In ko, this message translates to:
  /// **'원문 보기'**
  String get detailsReviewViewOriginal;

  /// No description provided for @detailsReviewViewTranslation.
  ///
  /// In ko, this message translates to:
  /// **'번역 보기'**
  String get detailsReviewViewTranslation;

  /// No description provided for @detailsRepresentativeImage.
  ///
  /// In ko, this message translates to:
  /// **'대표'**
  String get detailsRepresentativeImage;

  /// No description provided for @detailsReviewGalleryNotice.
  ///
  /// In ko, this message translates to:
  /// **'후기에 사진을 첨부하려면 사진 보관함 접근 권한이 필요합니다. 권한을 거부하셔도 후기 텍스트 작성과 평점 등록은 계속할 수 있습니다.'**
  String get detailsReviewGalleryNotice;

  /// No description provided for @detailsReviewGalleryRecovery.
  ///
  /// In ko, this message translates to:
  /// **'후기 사진 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 텍스트 후기와 평점 등록은 계속할 수 있고, 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.'**
  String get detailsReviewGalleryRecovery;

  /// No description provided for @detailsReviewGalleryFailure.
  ///
  /// In ko, this message translates to:
  /// **'사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.'**
  String get detailsReviewGalleryFailure;

  /// No description provided for @detailsReviewGalleryRestoreError.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택하던 후기 이미지를 복구하지 못했어요. 다시 선택해 주세요.'**
  String get detailsReviewGalleryRestoreError;

  /// No description provided for @detailsReviewRestoredCount.
  ///
  /// In ko, this message translates to:
  /// **'이전에 선택하던 후기 이미지 {restoredCount}장을 복구했어요.'**
  String detailsReviewRestoredCount(int restoredCount);

  /// No description provided for @detailsReviewSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'후기를 등록했어요.'**
  String get detailsReviewSubmitted;

  /// No description provided for @detailsReviewComposerTitle.
  ///
  /// In ko, this message translates to:
  /// **'후기 작성하기'**
  String get detailsReviewComposerTitle;

  /// No description provided for @detailsReviewComposerHint.
  ///
  /// In ko, this message translates to:
  /// **'활동에서 좋았던 점이나 다음 참가자에게 도움이 될\n내용을 남겨 주세요.'**
  String get detailsReviewComposerHint;

  /// No description provided for @detailsBodyCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}/{max}자'**
  String detailsBodyCount(int count, int max);

  /// No description provided for @detailsReviewImageSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'이미지 (최대 {max}장)'**
  String detailsReviewImageSectionTitle(int max);

  /// No description provided for @detailsReviewSubmitting.
  ///
  /// In ko, this message translates to:
  /// **'작성 중...'**
  String get detailsReviewSubmitting;

  /// No description provided for @detailsReviewSubmit.
  ///
  /// In ko, this message translates to:
  /// **'작성하기'**
  String get detailsReviewSubmit;

  /// No description provided for @detailsReviewImageGuide.
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 사진이 대표 이미지가 되며,\n길게 눌러 순서를 바꿀 수 있어요.'**
  String get detailsReviewImageGuide;

  /// No description provided for @detailsShareCopied.
  ///
  /// In ko, this message translates to:
  /// **'공유 링크를 복사했어요. 원하는 메신저에 바로 붙여넣을 수 있습니다.'**
  String get detailsShareCopied;

  /// No description provided for @detailsReportActivityReload.
  ///
  /// In ko, this message translates to:
  /// **'활동 정보를 다시 불러온 뒤 신고해 주세요.'**
  String get detailsReportActivityReload;

  /// No description provided for @detailsParticipantsListTitle.
  ///
  /// In ko, this message translates to:
  /// **'참여 유저 목록'**
  String get detailsParticipantsListTitle;

  /// No description provided for @detailsParticipantRemoved.
  ///
  /// In ko, this message translates to:
  /// **'참여자를 삭제했어요.'**
  String get detailsParticipantRemoved;

  /// No description provided for @detailsParticipantActionViewProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필 보기'**
  String get detailsParticipantActionViewProfile;

  /// No description provided for @detailsParticipantActionApprove.
  ///
  /// In ko, this message translates to:
  /// **'참여 승인'**
  String get detailsParticipantActionApprove;

  /// No description provided for @detailsParticipantActionRemove.
  ///
  /// In ko, this message translates to:
  /// **'참여자 삭제'**
  String get detailsParticipantActionRemove;

  /// No description provided for @detailsParticipantActionCancelRequest.
  ///
  /// In ko, this message translates to:
  /// **'신청 취소'**
  String get detailsParticipantActionCancelRequest;

  /// No description provided for @detailsPendingParticipantsListTitle.
  ///
  /// In ko, this message translates to:
  /// **'신청 유저 목록'**
  String get detailsPendingParticipantsListTitle;

  /// No description provided for @detailsPendingCancelled.
  ///
  /// In ko, this message translates to:
  /// **'신청을 취소했어요.'**
  String get detailsPendingCancelled;

  /// No description provided for @detailsParticipantSwipeHint.
  ///
  /// In ko, this message translates to:
  /// **'슬라이드 해서 삭제하거나 취소할 수 있어요'**
  String get detailsParticipantSwipeHint;

  /// No description provided for @detailsReviewListReportSubject.
  ///
  /// In ko, this message translates to:
  /// **'{title} 리뷰 목록'**
  String detailsReviewListReportSubject(Object title);

  /// No description provided for @detailsReviewLoadMoreHint.
  ///
  /// In ko, this message translates to:
  /// **'스크롤하면 후기를 더 불러옵니다.'**
  String get detailsReviewLoadMoreHint;

  /// No description provided for @detailsReviewImageInvalidFormat.
  ///
  /// In ko, this message translates to:
  /// **'JPG, PNG, WEBP, GIF 형식의 리뷰 이미지만 업로드할 수 있어요.'**
  String get detailsReviewImageInvalidFormat;

  /// No description provided for @detailsReviewImageUploadError.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 이미지를 업로드하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get detailsReviewImageUploadError;

  /// No description provided for @detailsMe.
  ///
  /// In ko, this message translates to:
  /// **'나'**
  String get detailsMe;

  /// No description provided for @commonInvalidServerResponse.
  ///
  /// In ko, this message translates to:
  /// **'서버 응답 형식이 올바르지 않습니다.'**
  String get commonInvalidServerResponse;

  /// No description provided for @onboardingVerificationResendLimitNotice.
  ///
  /// In ko, this message translates to:
  /// **'인증번호는 하루 최대 5번까지 다시 받을 수 있어요. 현재 {count}회 요청했어요.'**
  String onboardingVerificationResendLimitNotice(int count);

  /// No description provided for @onboardingVerificationResendLimitReached.
  ///
  /// In ko, this message translates to:
  /// **'인증번호는 하루 최대 5번까지 다시 받을 수 있어요.'**
  String get onboardingVerificationResendLimitReached;

  /// No description provided for @onboardingVerificationSent.
  ///
  /// In ko, this message translates to:
  /// **'인증번호를 발송했어요.'**
  String get onboardingVerificationSent;

  /// No description provided for @onboardingVerificationResent.
  ///
  /// In ko, this message translates to:
  /// **'인증번호를 다시 보냈어요.'**
  String get onboardingVerificationResent;

  /// No description provided for @onboardingBusinessVerificationCompleted.
  ///
  /// In ko, this message translates to:
  /// **'사업자 인증이 완료됐어요. 휴대폰 인증을 이어서 진행해 주세요.'**
  String get onboardingBusinessVerificationCompleted;

  /// No description provided for @onboardingConsentRequired.
  ///
  /// In ko, this message translates to:
  /// **'필수 약관에 모두 동의해 주세요.'**
  String get onboardingConsentRequired;

  /// No description provided for @homeExploreLoadMoreFailedNetwork.
  ///
  /// In ko, this message translates to:
  /// **'추가 결과를 불러오지 못했어요. 네트워크를 확인해 주세요.'**
  String get homeExploreLoadMoreFailedNetwork;

  /// No description provided for @homeExploreLoadMoreFailedServer.
  ///
  /// In ko, this message translates to:
  /// **'추가 결과를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get homeExploreLoadMoreFailedServer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
