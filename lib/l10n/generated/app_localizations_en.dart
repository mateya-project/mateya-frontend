// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MateYa';

  @override
  String get brandLockupSubtitle =>
      'The start of a special journey\nsharing Korean warmth and culture';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get languageChineseSimplified => 'Chinese (Simplified)';

  @override
  String get bottomNavigationHome => 'Home';

  @override
  String get bottomNavigationExplore => 'Explore';

  @override
  String get bottomNavigationChat => 'Chat';

  @override
  String get bottomNavigationProfile => 'Profile';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonLater => 'Later';

  @override
  String get commonAll => 'All';

  @override
  String get commonNext => 'Next';

  @override
  String get commonReset => 'Reset';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonProcessing => 'Processing...';

  @override
  String get commonFree => 'Free';

  @override
  String get commonToday => 'Today';

  @override
  String get commonTomorrow => 'Tomorrow';

  @override
  String get permissionOpenAppSettings => 'Open app settings';

  @override
  String get permissionOpenLocationSettings => 'Open location settings';

  @override
  String get locationServiceDisabledTitle => 'Location services are turned off';

  @override
  String get locationPermissionDisabledTitle =>
      'Location permission is turned off';

  @override
  String get languageDialogBarrierLabel => 'Language selection';

  @override
  String get languageDialogTitle => 'Change language';

  @override
  String get languageDialogSupportedLanguages => 'Supported languages';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingBusinessPrompt => 'Are you a business owner? ';

  @override
  String get onboardingStartAsHost => 'Start as a host';

  @override
  String get onboardingConsentTitle => 'You need to agree before using MateYa.';

  @override
  String get onboardingAgreeAll => 'Agree to all';

  @override
  String get onboardingAgreeAllHelper =>
      'Agree to all required and optional items below.';

  @override
  String onboardingRequiredAgreementLabel(Object title) {
    return '(Required) $title';
  }

  @override
  String get onboardingEnterName => 'Please enter your name';

  @override
  String get onboardingEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get onboardingEnterVerificationCode =>
      'Please enter the verification code';

  @override
  String get onboardingPhoneNumberLabel => 'Phone number';

  @override
  String get onboardingPhoneNumberHint => 'e.g. 01012341234';

  @override
  String get onboardingPhoneNumberHelper =>
      'Enter your phone number to receive a verification code.';

  @override
  String get onboardingVerificationCodeLabel => 'Verification code';

  @override
  String get onboardingVerificationCodeHint =>
      'You can enter it after tapping Get code.';

  @override
  String get onboardingResendVerificationCode => 'Resend code';

  @override
  String onboardingDebugVerificationCode(Object code) {
    return 'Test verification code: $code';
  }

  @override
  String get onboardingVerify => 'Verify';

  @override
  String get onboardingRequestVerificationCode => 'Get verification code';

  @override
  String get onboardingLocationServiceDisabledMessage =>
      'To verify your neighborhood with your current location, turn on location services on your device. You can still continue by entering your neighborhood manually.';

  @override
  String get onboardingLocationPermissionDisabledMessage =>
      'To use automatic location verification, allow location access in app settings. You can still continue signup with manual entry.';

  @override
  String onboardingPreviousNeighborhood(Object name) {
    return 'You were previously registered as \"$name\".';
  }

  @override
  String get onboardingResolvingCurrentLocation =>
      'Checking your current location.';

  @override
  String get onboardingCompleteNeighborhood =>
      'Complete neighborhood verification';

  @override
  String get onboardingRetryLocationPermission =>
      'Request location permission again';

  @override
  String get onboardingRetryAfterSettingsChange =>
      'Check again after changing settings';

  @override
  String get onboardingRetryLocationService => 'Check location services again';

  @override
  String get onboardingRetryCurrentLocation => 'Check current location again';

  @override
  String get onboardingNeedHelp => 'Having trouble verifying?  ';

  @override
  String get onboardingManualInputCta => 'Enter manually >';

  @override
  String get onboardingLocationPermissionNoticeTitle =>
      'Location permission notice';

  @override
  String get onboardingLocationPermissionNoticeMessage =>
      'Location information is needed for neighborhood verification and nearby activity recommendations.\nYou can still continue signup by entering your neighborhood manually even without granting permission.';

  @override
  String get onboardingUseCurrentLocation => 'Verify with current location';

  @override
  String get onboardingManualInput => 'Enter manually';

  @override
  String get onboardingManualNeighborhoodHelper =>
      'Please enter it in the format of district/town name.';

  @override
  String get onboardingNeighborhoodHint => 'Uman-dong';

  @override
  String get onboardingEnterBusinessName => 'Please enter your business name';

  @override
  String get onboardingBusinessNameHint => 'NICE rating information';

  @override
  String get onboardingBusinessNumberLabel => 'Business registration number';

  @override
  String get onboardingBusinessOwnerLabel => 'Representative name';

  @override
  String get onboardingBusinessOwnerHint => 'Hong Gil-dong';

  @override
  String get onboardingBusinessOpeningDateLabel => 'Opening date';

  @override
  String get onboardingBusinessOpeningDateHint => '20240131';

  @override
  String get onboardingCompleteBusinessVerification =>
      'Complete business verification';

  @override
  String get onboardingWelcomeBack => 'Welcome back';

  @override
  String onboardingReturnCompleted(Object name) {
    return '$name,\nyour return to MateYa is complete';
  }

  @override
  String get onboardingLaunchApp => 'Start MateYa';

  @override
  String onboardingAgreementSemantics(Object label) {
    return '$label agreement';
  }

  @override
  String onboardingTermsEffectiveDate(Object date) {
    return 'Effective date: $date';
  }

  @override
  String get onboardingTermsContents => 'Contents';

  @override
  String onboardingTermsSectionTitle(int index, Object title) {
    return 'Article $index. $title';
  }

  @override
  String get onboardingDefaultMemberName => 'MateYa member';

  @override
  String onboardingLoginCompleted(Object name) {
    return '$name,\nyou have logged in to MateYa';
  }

  @override
  String onboardingSignupCompleted(Object name) {
    return '$name,\nyour MateYa signup is complete';
  }

  @override
  String onboardingNeighborhoodHeadlineReturning(Object name) {
    return 'Welcome back,\n$name!\nPlease verify your neighborhood';
  }

  @override
  String get onboardingNeighborhoodHeadlineSignup =>
      'Please verify your neighborhood';

  @override
  String onboardingResolvedNeighborhoodMessage(Object name) {
    return 'Your current location is in “$name”.';
  }

  @override
  String get onboardingNeighborhoodLabel => 'Neighborhood';

  @override
  String get onboardingVerificationExpired =>
      'Your verification has expired. Please request a new verification code.';

  @override
  String get onboardingBusinessVerificationExpired =>
      'Your business verification has expired. Please verify again.';

  @override
  String get homeSortRecommended => 'Recommended';

  @override
  String get homeSortPopular => 'Popular';

  @override
  String get homeSortLatest => 'Newest';

  @override
  String get homeSortClosingSoon => 'Closing soon';

  @override
  String get homeSortNearby => 'Nearest';

  @override
  String get homeAudienceEveryone => 'Everyone';

  @override
  String get homeAudienceForeignerFriendly => 'Foreigner friendly';

  @override
  String get homeAudienceKoreanFriendly => 'Korean friendly';

  @override
  String get homeAudienceTouristFriendly => 'Recommended for tourists';

  @override
  String get homeAudienceBeginnerFriendly => 'Beginner friendly';

  @override
  String get homeStatusRecruiting => 'Open';

  @override
  String get homeStatusClosingSoon => 'Closing soon (within 24h)';

  @override
  String get homeStatusNewlyListed => 'Newly listed (within 24h)';

  @override
  String get homeDistanceLocal => 'My area';

  @override
  String get homeDistanceWithin1km => 'Within 1 km';

  @override
  String get homeDistanceWithin5km => 'Within 5 km';

  @override
  String get homeDistanceWithin10km => 'Within 10 km';

  @override
  String get homeSearchHeroHint => 'Anytime, anywhere';

  @override
  String get homeSearchHeroHelper =>
      'Where anyone can become your mate, MateYa';

  @override
  String get homeLoadError => 'Failed to load data.';

  @override
  String get homeSelectAtLeastOneCategory =>
      'Please select at least one category.';

  @override
  String get homeSelectAtLeastOneLanguage =>
      'Please select at least one language.';

  @override
  String get homeUnsupportedExploreLanguageFilter =>
      'Explore language filters currently support only Korean, English, Chinese, and Japanese.';

  @override
  String get homeEndDateBeforeStartDateError =>
      'The end date cannot be earlier than the start date.';

  @override
  String get homeMaxPriceLessThanMinPriceError =>
      'The maximum price must be greater than or equal to the minimum price.';

  @override
  String get homeTrendingTitle => 'Trending now 🔥';

  @override
  String get homeSharedExperiencesTitle => 'Experiences to share';

  @override
  String get homeExploreSearchHint => 'Search by name or place';

  @override
  String get homeExploreError => 'Failed to load results.';

  @override
  String get homeFavoritesLoadError => 'Failed to load favorites.';

  @override
  String get homeFavoritesTitle => 'Favorites';

  @override
  String get homeCreateClass => 'Create class';

  @override
  String get homeCreateGroup => 'Create group';

  @override
  String get homeEmptyTitle => 'No activities match your conditions yet.';

  @override
  String get homeEmptyDescription =>
      'Adjust your search or filters and try again.';

  @override
  String get homeLoadMore => 'Load more';

  @override
  String homeLoadedAllActivities(int count) {
    return 'Loaded all $count activities.';
  }

  @override
  String get homeFilterTitle => 'Filters';

  @override
  String get homeFilterSort => 'Sort';

  @override
  String get homeFilterCategory => 'Category';

  @override
  String get homeFilterAudience => 'Audience';

  @override
  String get homeFilterLanguage => 'Language';

  @override
  String get homeFilterRegion => 'Region';

  @override
  String get homeFilterSchedule => 'Schedule';

  @override
  String get homeFilterStartDate => 'Start date';

  @override
  String get homeFilterEndDate => 'End date';

  @override
  String get homeFilterCost => 'Price';

  @override
  String get homeFilterMinPrice => 'Min price';

  @override
  String get homeFilterMaxPrice => 'Max price';

  @override
  String get homeFilterStatus => 'Status';

  @override
  String get homeFilterNear => 'Near';

  @override
  String get homeFilterFar => 'Far';

  @override
  String homeFilterDistanceFromActivityRegion(Object target) {
    return 'Based on activity region: $target';
  }

  @override
  String homeFilterDistanceFromRegion(Object regionName, Object target) {
    return 'Based on $regionName: $target';
  }

  @override
  String get commonClose => 'Close';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonSeeDetails => 'See details';

  @override
  String get commonNetworkRetry =>
      'Check your network connection and try again.';

  @override
  String get countryKorea => 'Korea';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countryChina => 'China';

  @override
  String get countryVietnam => 'Vietnam';

  @override
  String get countryUnitedStates => 'United States';

  @override
  String get countryThailand => 'Thailand';

  @override
  String get activityCategoryTouristAttraction => 'Tourist attraction';

  @override
  String get activityCategoryTravelCourse => 'Travel course';

  @override
  String get activityCategoryCultureTradition => 'Culture / Tradition';

  @override
  String get activityCategoryEventPerformanceFestival =>
      'Events / Performances / Festivals';

  @override
  String get activityCategorySports => 'Sports';

  @override
  String get activityCategoryActivityLeports => 'Activities / Leisure sports';

  @override
  String get activityCategoryShopping => 'Shopping';

  @override
  String get activityCategoryPublicFacility => 'Public facility';

  @override
  String get activityCategoryOther => 'Other';

  @override
  String get reportSemanticsLabel => 'Report';

  @override
  String get reportTitle => 'Report';

  @override
  String get reportNoticeMessage =>
      'Photo library access is required to attach report images. You can still continue writing the report text without permission.';

  @override
  String get reportRecoveryMessage =>
      'Photo library access is required to attach report images. Try again or allow permission in app settings.';

  @override
  String get reportFailureMessage =>
      'Could not load the image. Please check permissions and file status.';

  @override
  String get reportRestoreFallbackErrorMessage =>
      'Could not restore the report images you selected earlier. Please select them again.';

  @override
  String reportSubmittedMessage(Object subject) {
    return 'Your report for $subject has been submitted.';
  }

  @override
  String get reportBodyHint =>
      'Please describe the reason for the report in detail.\nExamples: abusive language, suspected scam, inappropriate post,\nspam, harassment, etc. Reports will be reviewed\naccording to our moderation policy.';

  @override
  String reportBodyCount(int count, int max) {
    return '$count/$max chars';
  }

  @override
  String reportImageSectionTitle(int max) {
    return 'Images (up to $max)';
  }

  @override
  String get reportSubmitting => 'Submitting...';

  @override
  String get reportReviewNotice =>
      'Submitted reports are reviewed within up to 7 business days.\nFalse reports or reports without clear reasons may not be processed.';

  @override
  String reportRestoredCount(int restoredCount) {
    return 'Restored $restoredCount report image(s) you selected earlier.';
  }

  @override
  String get mypageTitle => 'My Page';

  @override
  String get mypageLoadError => 'Failed to load My Page.';

  @override
  String get mypageOtherProfileOpenHint => 'Loading profile.';

  @override
  String get mypageOtherProfileLoadError => 'Failed to load this profile.';

  @override
  String get mypageEditPrimaryPreferences => 'Edit basic info';

  @override
  String get mypageEditActivityRegion => 'Edit activity region';

  @override
  String get mypageConsentHistoryTitle => 'Consent history';

  @override
  String get mypageOpenPrivacyPolicy => 'Privacy Policy';

  @override
  String get mypageOpenCustomerSupport => 'Customer Support';

  @override
  String get mypageOpenBlockedUsers => 'Blocked users';

  @override
  String get mypageLogout => 'Log out';

  @override
  String get mypageOpenWithdrawal => 'Delete account';

  @override
  String get mypageConsentHistoryDescription =>
      'You can review the terms and policies you agreed to for using MateYa.';

  @override
  String get mypageConsentHistoryEmpty =>
      'No consent history has been saved yet.';

  @override
  String get mypageConsentVersion => 'Version';

  @override
  String get mypageConsentStatus => 'Status';

  @override
  String get mypageConsentAgreed => 'Agreed';

  @override
  String get mypageConsentDeclined => 'Declined';

  @override
  String get mypageConsentDate => 'Date';

  @override
  String get mypageBlockedUsersTitle => 'Blocked users';

  @override
  String get mypageBlockedUsersEmpty => 'You have not blocked anyone yet.';

  @override
  String get mypageRecentActivitiesTitle => 'Recent activities';

  @override
  String get mypageRecentActivitiesDescription =>
      'Check the activities you recently joined or hosted.';

  @override
  String get mypageActivitySummaryTitle => 'Activity summary';

  @override
  String get mypageHostedCount => 'Hosted';

  @override
  String get mypageJoinedCount => 'Joined';

  @override
  String get mypageReviewCount => 'Reviews';

  @override
  String get mypageActiveMember => 'Active member';

  @override
  String get mypageInactiveMember => 'No recent activity';

  @override
  String get mypageActiveWithin30Days => 'Active within 30 days';

  @override
  String get mypageNoRecentActivity => 'No recent activity';

  @override
  String get mypageBadgeLabel => 'Badges';

  @override
  String get mypageBadgesTitle => 'My badges';

  @override
  String get mypageBadgesDescription =>
      'You can earn badges based on the categories of activities you joined.';

  @override
  String get mypageRecentActivitiesSectionTitle => 'Activity history';

  @override
  String get mypageActivityHistoryTitle => 'Activity history';

  @override
  String get mypagePrimaryPreferencesTitle => 'Basic info';

  @override
  String get mypagePrimaryPreferencesDescription =>
      'Update your language and nationality information.';

  @override
  String get mypageMyLanguage => 'My language';

  @override
  String get mypageMyCountry => 'My nationality';

  @override
  String get mypageEnglishNameOptional => 'English name (optional)';

  @override
  String get mypageSaving => 'Saving...';

  @override
  String get mypagePrimaryPreferencesSubmit => 'Save';

  @override
  String get mypageUpdating => 'Updating...';

  @override
  String get mypageBusinessIntroTitle => 'Introduction';

  @override
  String get mypageBusinessIntroDescription =>
      'Write a short introduction to show on your host page.';

  @override
  String get mypageBusinessIntroHint =>
      'Briefly introduce the kind of experience you offer.';

  @override
  String get mypageSaveIntroduction => 'Save introduction';

  @override
  String get mypageActiveExperiencesTitle => 'Active experiences';

  @override
  String get mypageRemoveFriend => 'Remove friend';

  @override
  String get mypageBlocked => 'Blocked';

  @override
  String get mypageBlockUser => 'Block user';

  @override
  String get mypageSelectLanguageAndCountry =>
      'Please select both a language and a country.';

  @override
  String get mypageInvalidLanguageOrCountry =>
      'This language or country is not supported.';

  @override
  String get mypagePrimaryPreferencesSaved => 'Your basic info has been saved.';

  @override
  String get mypagePrimaryPreferencesSaveError =>
      'Could not save your basic info. Please try again later.';

  @override
  String get mypageFriendRemoved => 'Friend removed.';

  @override
  String get mypageFriendAdded => 'Added as a friend.';

  @override
  String get mypageFriendUpdateError =>
      'Could not update the friend status. Please try again later.';

  @override
  String get mypageBlockedUserAdded => 'User blocked.';

  @override
  String get mypageBlockUserError =>
      'Could not block the user. Please try again later.';

  @override
  String get mypageUnblockedUser => 'User unblocked.';

  @override
  String get mypageUnblockUserError =>
      'Could not unblock the user. Please try again later.';

  @override
  String get mypageBusinessIntroRequired => 'Please enter an introduction.';

  @override
  String get mypageBusinessIntroTooLong =>
      'Please keep the introduction within 300 characters.';

  @override
  String get mypageBusinessIntroSaved => 'Introduction saved.';

  @override
  String get mypageBusinessIntroSaveError =>
      'Could not save the introduction. Please try again later.';

  @override
  String get mypageProfileImageSaved => 'Profile image saved.';

  @override
  String get mypageProfileImageSaveError =>
      'Could not save the profile image. Please try again later.';

  @override
  String get mypageProfileImageInvalidFormat =>
      'Only JPG, PNG, WEBP, and GIF images can be uploaded.';

  @override
  String get mypageProfileImageUploadError =>
      'Could not upload the profile image. Please try again later.';

  @override
  String get mypageProfileImageConfirmError =>
      'Could not confirm the profile image upload. Please try again later.';

  @override
  String get mypageActivityRegionSaved => 'Activity region saved.';

  @override
  String get mypageActivityRegionSaveError =>
      'Could not save the activity region. Please try again later.';

  @override
  String get mypageWithdrawalAgreementRequired =>
      'You need to agree before requesting account deletion.';

  @override
  String get mypageWithdrawalSignatureRequired =>
      'Please enter your signature.';

  @override
  String get mypageWithdrawalSignatureMismatch =>
      'The signature does not match your member name.';

  @override
  String get mypageWithdrawalAgreementText =>
      'I agree to the privacy management and final deletion policy after 30 days.';

  @override
  String get mypageWithdrawalSubmitted =>
      'Your account deletion request has been submitted.';

  @override
  String get mypageWithdrawalSubmitError =>
      'Could not process your deletion request. Please try again later.';

  @override
  String get mypageLogoutError => 'Could not log out. Please try again later.';

  @override
  String get mypageTermsDetailUnavailable =>
      'Could not load the detailed terms.';

  @override
  String get mypageSupportLinkCopied => 'Customer support link copied.';

  @override
  String get mypagePrivacyLinkCopied => 'Privacy policy link copied.';

  @override
  String get mypageCurrentLocationResolveError =>
      'Could not check your current location. Please try again later.';

  @override
  String get mypageNeighborhoodRequired => 'Please enter your activity region.';

  @override
  String get mypageNeighborhoodLookupError =>
      'Could not verify the area you entered. Please check it again.';

  @override
  String get mypageNeighborhoodVerificationRequired =>
      'Please select a verified activity region.';

  @override
  String get mypageActivityRegionDialogDescription =>
      'You can set your activity region using your current location or manual entry.';

  @override
  String get mypageResolvingCurrentLocation =>
      'Checking your current location.';

  @override
  String get mypageResolvingNeighborhood => 'Checking the area you entered.';

  @override
  String get mypageConfirmManualNeighborhood => 'Use this entered area';

  @override
  String mypageSelectedActivityRegion(Object name) {
    return 'Selected activity region: $name';
  }

  @override
  String get mypageSaveActivityRegion => 'Save activity region';

  @override
  String get mypageLocationServiceDisabledMessage =>
      'Turn on your device\'s location services to use your current location. You can still continue with manual entry.';

  @override
  String get mypageLocationPermissionDisabledMessage =>
      'Allow location access in app settings to use your current location. You can still continue with manual entry.';

  @override
  String get mypageProfileImageNotice =>
      'Photo library access is required to select a profile image.';

  @override
  String get mypageProfileImageRecovery =>
      'Please allow photo library access to select a profile image. You can try again or change it in app settings.';

  @override
  String get mypageProfileImageFailure =>
      'Could not load the profile image. Please check the file status.';

  @override
  String get mypageProfileImageRestoreFallback =>
      'Could not restore the profile image you were selecting earlier. Please choose it again.';

  @override
  String mypageProfileImageRestoredCount(int restoredCount) {
    return 'Restored $restoredCount profile image(s) you selected earlier.';
  }

  @override
  String get mypageWithdrawalTitle => 'Delete account';

  @override
  String get mypageWithdrawalDescription =>
      'Would you like to proceed with account deletion?\nYour account will be deactivated immediately after the request.\nIf you sign up again or log in within 30 days,\nthe deletion will be canceled.\n\nAfter 30 days, your member information and service history will be permanently deleted, except for information that must be retained by law, and cannot be restored.';

  @override
  String get mypageWithdrawalAgreementCheckbox =>
      'I agree to the privacy management and final deletion policy after 30 days.';

  @override
  String get mypageWithdrawalSignatureLabel => 'Signature';

  @override
  String mypageWithdrawalSignatureHint(Object name) {
    return 'Enter $name';
  }

  @override
  String get mypageWithdrawalSubmittedNotice =>
      'Your deletion request has been received. Your account will remain inactive until you log in again.';

  @override
  String get mypageWithdrawalRequest => 'Request deletion';

  @override
  String get mypageMetricActivities => 'Activities';

  @override
  String get mypageMetricFriends => 'Friends';

  @override
  String get mypageMetricReviews => 'Reviews';

  @override
  String get mypageMetricRecruitingExperiences => 'Open experiences';

  @override
  String get mypageMetricTotalParticipants => 'Total participants';

  @override
  String get mypageMetricAverageRating => 'Average rating';

  @override
  String get mypageMetricReceivedReviews => 'Received reviews';

  @override
  String get mypageActivityRegionUnset => 'Activity region not set';

  @override
  String mypageParticipantCount(int current, int capacity) {
    return '$current / $capacity';
  }

  @override
  String get mypageConsentTypeServiceTerms => 'Terms of Service';

  @override
  String get mypageConsentTypePrivacyCollection =>
      'Consent to Personal Data Collection and Use';

  @override
  String get mypageConsentTypeLocationService =>
      'Consent to Location-Based Services';

  @override
  String get mypageConsentTypeAgeOver14 => 'Confirmation of age 14 or older';

  @override
  String get mypageHostBadge => 'HOST';

  @override
  String get mypageEditActivityCta => 'Edit activity';

  @override
  String get mypageBadgeTraditional => 'Tradition Master';

  @override
  String get mypageBadgeActivePerson => 'Active Mate';

  @override
  String get mypageBadgeFestive => 'Festival Lover';

  @override
  String get mypageBadgeTourist => 'Local Explorer';

  @override
  String get mypageBadgeUnlockedTitle => 'You earned a new badge';

  @override
  String mypageBadgeUnlockedDescription(Object category) {
    return 'Your participation in $category activities has been reflected.';
  }

  @override
  String get galleryPermissionNoticeTitle => 'Photo permission notice';

  @override
  String get galleryPermissionSelectPhoto => 'Select photos';

  @override
  String get galleryPermissionRecoveryTitle => 'Photo access is required';

  @override
  String get authLoginRequired => 'Login is required.';

  @override
  String get commonRequestError =>
      'An error occurred while processing the request.';

  @override
  String get chatJustNow => 'Just now';

  @override
  String chatMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String chatHoursAgo(int count) {
    return '$count hr ago';
  }

  @override
  String get chatYesterday => 'Yesterday';

  @override
  String get chatLastYear => 'Last year';

  @override
  String chatPhotoCount(int count) {
    return '$count photo(s)';
  }

  @override
  String get chatViewOriginal => 'View original';

  @override
  String get chatViewTranslation => 'View translation';

  @override
  String chatParticipantCount(int count) {
    return '$count joined';
  }

  @override
  String get chatFilterGroup => 'Groups';

  @override
  String get chatFilterDirect => 'Direct';

  @override
  String get chatListGuidance =>
      'When you join an activity, you are automatically added to the group chat.\nDirect chats are automatically created with users who are your friends.\nYou cannot chat with users who are not your friends.';

  @override
  String get chatComposerHint => 'Type a message';

  @override
  String get reportReasonRequired => 'Please enter a reason for the report.';

  @override
  String get reportImageInvalidFormat =>
      'Only JPG, PNG, WEBP, and GIF images can be attached to a report.';

  @override
  String get reportImageUploadError =>
      'Could not upload the report image. Please try again later.';

  @override
  String get reportImageConfirmError =>
      'Could not confirm the uploaded report image. Please try again later.';

  @override
  String get createGroupFlowTitle => 'Create group';

  @override
  String get createClassFlowTitle => 'Create class';

  @override
  String get createEntityGroup => 'group';

  @override
  String get createEntityClass => 'class';

  @override
  String get createGroupSubmit => 'Create group';

  @override
  String get createClassSubmit => 'Create class';

  @override
  String get createGroupEditTitle => 'Edit group';

  @override
  String get createClassEditTitle => 'Edit class';

  @override
  String get createGroupUpdateSubmit => 'Save group changes';

  @override
  String get createClassUpdateSubmit => 'Save class changes';

  @override
  String get createPaidLabel => 'Paid';

  @override
  String createEditCompleted(Object entity) {
    return 'Your $entity has been updated.';
  }

  @override
  String createSubmitCompleted(Object entity) {
    return 'Your $entity has been created.';
  }

  @override
  String createChatProvisionFailed(Object entity) {
    return 'Your $entity was created, but the chat room could not be prepared. Please try again later.';
  }

  @override
  String createSubmitFailedNetwork(Object entity) {
    return 'Could not create the $entity. Check your connection and try again.';
  }

  @override
  String createSubmitFailedServer(Object entity) {
    return 'Could not create the $entity. Please try again later.';
  }

  @override
  String get createDeleteFailedNetwork =>
      'Could not delete it. Check your connection and try again.';

  @override
  String get createDeleteFailedServer =>
      'Could not delete it. Please try again later.';

  @override
  String createLoadEditFailedNetwork(Object entity) {
    return 'Could not load the $entity for editing. Check your connection and try again.';
  }

  @override
  String createLoadEditFailedServer(Object entity) {
    return 'Could not load the $entity for editing. Please try again later.';
  }

  @override
  String get createValidationSelectCategory =>
      'Please select at least one category.';

  @override
  String get createValidationSelectClassCategoryFirst =>
      'Please choose the class category first.';

  @override
  String get createValidationSelectPlaceOrManual =>
      'Please select a place or enter one manually.';

  @override
  String get createValidationSelectPlace => 'Please select a place.';

  @override
  String createValidationEnterEntityName(Object entity) {
    return 'Please enter the $entity name.';
  }

  @override
  String get createValidationTitleMaxLength =>
      'The name must be 40 characters or fewer.';

  @override
  String get createValidationDescriptionMaxLength =>
      'The description must be 1000 characters or fewer.';

  @override
  String get createValidationSelectDate => 'Please select a date.';

  @override
  String get createValidationNoPastDate => 'You cannot select a past date.';

  @override
  String get createValidationSelectStartEndTime =>
      'Please select both a start time and an end time.';

  @override
  String get createValidationEndAfterStart =>
      'The end time must be later than the start time.';

  @override
  String get createValidationCapacityRange =>
      'Capacity must be between 2 and 20 people.';

  @override
  String get createValidationSelectDeadline =>
      'Please select both the registration deadline date and time.';

  @override
  String get createValidationSelectDeadlineTogether =>
      'Please choose the registration deadline date and time together.';

  @override
  String get createValidationDeadlineFuture =>
      'The registration deadline must be in the future.';

  @override
  String get createValidationDeadlineBeforeStart =>
      'The registration deadline must be earlier than the start time.';

  @override
  String get createValidationSelectLanguage =>
      'Please select at least one language.';

  @override
  String get createValidationSelectPriceType => 'Please select a price type.';

  @override
  String get createValidationEnterPaidPrice =>
      'Please enter a price for a paid activity.';

  @override
  String get createValidationPriceRange =>
      'Enter a price between KRW 1 and KRW 1,000,000.';

  @override
  String get createValidationRegisterImage =>
      'Please add at least one cover image.';

  @override
  String get createGroupInfoTitle => 'Tell us about your group';

  @override
  String get createClassInfoTitle => 'Tell us about your class';

  @override
  String get createValidationIntro =>
      'Fill in the required details below to publish it right away.';

  @override
  String get createSelectedCategoryTitle => 'Selected categories';

  @override
  String get createSelectedPlaceTitle => 'Selected place';

  @override
  String get createGroupNameLabel => 'Group name';

  @override
  String get createClassNameLabel => 'Class name';

  @override
  String get createGroupNameHint => 'e.g. Bukchon hanok walk together';

  @override
  String get createClassNameHint => 'e.g. Traditional tea one-day class';

  @override
  String get createDescriptionTitle => 'Description';

  @override
  String get createDescriptionHint =>
      'Share how it works, what to bring, and anything participants should know.';

  @override
  String get createDateTimeTitle => 'Schedule';

  @override
  String get createDateLabel => 'Date';

  @override
  String get createDatePlaceholder => 'Select a date';

  @override
  String get createStartTimeLabel => 'Start time';

  @override
  String get createStartTimePlaceholder => 'Select a start time';

  @override
  String get createEndTimeLabel => 'End time';

  @override
  String get createEndTimePlaceholder => 'Select an end time';

  @override
  String get createCapacityTitle => 'Capacity';

  @override
  String createCapacityValue(int count) {
    return '$count people';
  }

  @override
  String get createCapacityHelper => 'Minimum 2, maximum 20';

  @override
  String get createDeadlineTitle => 'Registration deadline';

  @override
  String get createDeadlineDateLabel => 'Deadline date';

  @override
  String get createDeadlineTimeLabel => 'Deadline time';

  @override
  String get createNotSelected => 'Not selected';

  @override
  String get createLanguagesTitle => 'Languages';

  @override
  String get createPriceTitle => 'Price';

  @override
  String get createPaidPriceHint => 'Enter the participation fee';

  @override
  String get createAudienceTitle => 'Recommended for';

  @override
  String get createPrimaryImageTitle => 'Cover image';

  @override
  String get createPrimaryImageRequiredHint =>
      'Please add at least one cover image.';

  @override
  String get createPrimaryImageSelectionHint =>
      'The first image becomes the cover image, and you can tap another image to make it the cover.';

  @override
  String get createPrimaryImageBadge => 'Cover';

  @override
  String get createDeleting => 'Deleting...';

  @override
  String createDeleteAction(Object entity) {
    return 'Delete $entity';
  }

  @override
  String get createPlaceGroupTitle => 'Choose a place for the group';

  @override
  String get createPlaceClassTitle => 'Choose a place for the class';

  @override
  String get createPlaceGroupDescription =>
      'Pick a recommended place or enter one manually for your group.';

  @override
  String get createPlaceClassDescription =>
      'Search for a place that fits the category or enter one manually for your class.';

  @override
  String get createClassCategoryTitle => 'Class category';

  @override
  String get createCategoryDetailTitle => 'Detailed category';

  @override
  String get createManualPlaceTitle => 'Enter manually';

  @override
  String get createManualPlaceNameHint => 'Enter the place name';

  @override
  String get createManualPlaceAddressHint => 'Enter the address';

  @override
  String get createOrSearchTitle => 'Or search for a place';

  @override
  String get createPlaceSearchHint => 'Search by place name';

  @override
  String get createManualPlacePreviewDescription =>
      'It will be published using the place information you entered manually.';

  @override
  String get createSearchResultsTitle => 'Search results';

  @override
  String get createSearchEmptyTitle => 'No places found';

  @override
  String get createSearchEmptyBody => 'Try searching with a different keyword.';

  @override
  String get createSearchInitialTitle => 'Search for a place';

  @override
  String get createSearchInitialBody =>
      'Enter a place name or address to see matching results you can choose from.';

  @override
  String get createRecommendedTitle => 'Recommended places';

  @override
  String get createRefresh => 'Refresh';

  @override
  String get createRecommendedEmptyTitle => 'No recommended places yet';

  @override
  String get createRecommendedEmptyBody =>
      'Try changing the category or searching manually.';

  @override
  String get createMapPlaceholder =>
      'Once you select a place, its location will appear here.';

  @override
  String get createCategoryPromptTitle =>
      'What kind of experience are you creating?';

  @override
  String get createCategoryPromptDescription =>
      'Choose the category that best matches the group or class you want to publish.';

  @override
  String get createCompletedEditDescription =>
      'Your changes have been saved and will be reflected for participants right away.';

  @override
  String get createCompletedCreateDescription =>
      'People can now discover it on MateYa.';

  @override
  String get createBackToPrevious => 'Back';

  @override
  String get createBackToHome => 'Back to home';

  @override
  String get createStepCategory => 'Category';

  @override
  String get createStepPlaceGroup => 'Place';

  @override
  String get createStepPlaceClass => 'Place';

  @override
  String get createStepDetailsGroup => 'Details';

  @override
  String get createStepDetailsClass => 'Details';

  @override
  String get createCompletedProgress => 'Complete';

  @override
  String get createCategoryTitleCultureTradition => 'Culture / Tradition';

  @override
  String get createCategoryTitleEventPerformanceFestival =>
      'Events / Performances / Festivals';

  @override
  String get createCategoryTitleActivityLeports =>
      'Activities / Leisure sports';

  @override
  String get createCategoryDescriptionTourist =>
      'Great for meetups built around iconic attractions.';

  @override
  String get createCategoryDescriptionTravelCourse =>
      'Best for travel-style routes with multiple stops.';

  @override
  String get createCategoryDescriptionCultureTradition =>
      'Recommended for traditional culture, crafts, and history experiences.';

  @override
  String get createCategoryDescriptionFestival =>
      'Fits performances, festivals, and seasonal events.';

  @override
  String get createCategoryDescriptionSports =>
      'Ideal for exercise, sports viewing, or active group events.';

  @override
  String get createCategoryDescriptionActivityLeports =>
      'Good for outdoor experiences and active leisure activities.';

  @override
  String get createCategoryDescriptionPublicFacility =>
      'Recommended for exhibitions, public spaces, and local community events.';

  @override
  String get createCategoryDescriptionShopping =>
      'A great fit for markets, shopping streets, and local store tours.';

  @override
  String createEventDatePickerHelp(Object entity) {
    return 'Choose the date for your $entity';
  }

  @override
  String get createStartTimePickerHelp => 'Choose the start time';

  @override
  String get createEndTimePickerHelp => 'Choose the end time';

  @override
  String get createDeadlineDatePickerHelp =>
      'Choose the registration deadline date';

  @override
  String get createDeadlineTimePickerHelp =>
      'Choose the registration deadline time';

  @override
  String createDeleteDialogTitle(Object entity) {
    return 'Delete this $entity?';
  }

  @override
  String createDeleteDialogBody(Object entity) {
    return 'This action cannot be undone.';
  }

  @override
  String get createDeleteButton => 'Delete';

  @override
  String get createDeleteCompleted => 'Deleted successfully.';

  @override
  String createInitializationLoadError(Object entity) {
    return 'Could not load the $entity details.';
  }

  @override
  String get createInitializationRetryBody =>
      'Please try again. If the issue continues, go back and reopen this screen.';

  @override
  String createSavingEntity(Object entity) {
    return 'Saving $entity...';
  }

  @override
  String createSubmittingEntity(Object entity) {
    return 'Creating $entity...';
  }

  @override
  String get createSelectPlaceAction => 'Choose a place';

  @override
  String get createImagePickerNotice =>
      'Photo library access is required to attach images. You can still continue filling out the rest without permission.';

  @override
  String get createImagePickerRecovery =>
      'Photo library access is required to keep attaching images. Try again or allow permission in app settings.';

  @override
  String get createImagePickerFailure =>
      'Could not load the selected image. Please check the file and try again.';

  @override
  String get createImagePickerRestoreFallback =>
      'Could not restore the images you were selecting earlier. Please select them again.';

  @override
  String createImagePickerRestoredCount(int count) {
    return 'Restored $count previously selected image(s).';
  }

  @override
  String get createRecommendedLoadFailedNetwork =>
      'Could not load recommended places. Check your connection and try again.';

  @override
  String get createRecommendedLoadFailedServer =>
      'Could not load recommended places. Please try again later.';

  @override
  String get createPlaceSearchQueryRequired => 'Please enter a place name.';

  @override
  String get createPlaceSearchFailedNetwork =>
      'Place search failed. Check your connection and try again.';

  @override
  String get createPlaceSearchFailedServer =>
      'Place search failed. Please try again later.';

  @override
  String get createPlaceCoordinateRequired =>
      'This place cannot be selected because location coordinates are unavailable.';

  @override
  String get createPlaceMapCoordinateRequired =>
      'This place cannot be shown on the map because location coordinates are unavailable.';

  @override
  String createImageLimitExceeded(int max) {
    return 'You can add up to $max images.';
  }

  @override
  String get createImageInvalidFormat =>
      'Only JPG, PNG, WEBP, and GIF images can be added.';

  @override
  String get createImageMaxSize => 'Each image can be up to 10MB.';

  @override
  String get createPlaceDescriptionFallback =>
      'Check the location before selecting it.';

  @override
  String get createExistingPlaceDescription => 'Current activity location';

  @override
  String get createResolveServerCategoryFailed =>
      'The server category could not be determined from the selected place. Please choose another place.';

  @override
  String get createUploadImageRequired =>
      'Please add at least one cover image.';

  @override
  String get createUploadImageInvalidFormat =>
      'Only JPG, PNG, WEBP, and GIF images can be uploaded.';

  @override
  String get createUploadImageFailed =>
      'Image upload failed. Please try again later.';

  @override
  String get createUploadImageConfirmFailed =>
      'Could not confirm the uploaded image. Please try again later.';

  @override
  String get onboardingValidationNameRequired => 'Please enter your name.';

  @override
  String get onboardingValidationNameMaxLength =>
      'Your name must be 30 characters or fewer.';

  @override
  String get onboardingValidationNameCharacters =>
      'Please enter only your name without numbers or special characters.';

  @override
  String get onboardingValidationPhoneRequired =>
      'Please enter your phone number.';

  @override
  String get onboardingValidationPhoneDigitsOnly =>
      'Please enter digits only for the phone number.';

  @override
  String get onboardingValidationPhoneMaxLength =>
      'Phone numbers can be up to 15 digits.';

  @override
  String get onboardingValidationPhoneInvalid =>
      'Please enter a valid phone number.';

  @override
  String get onboardingValidationVerificationCodeRequired =>
      'Please enter the 6-digit verification code.';

  @override
  String get onboardingValidationVerificationExpired =>
      'The verification time has expired. Please request a new code.';

  @override
  String get onboardingValidationVerificationMismatch =>
      'The verification code does not match.';

  @override
  String get onboardingValidationBusinessNameRequired =>
      'Please enter the business name.';

  @override
  String get onboardingValidationOpeningDateRequired =>
      'Please enter the 8-digit opening date.';

  @override
  String get onboardingValidationOpeningDateDigitsOnly =>
      'The opening date must contain digits only.';

  @override
  String get onboardingValidationOpeningDateInvalid =>
      'Please enter a valid opening date.';

  @override
  String get onboardingValidationBusinessNumberRequired =>
      'Please enter a valid 10-digit business registration number.';

  @override
  String get onboardingValidationBusinessNumberDigitsOnly =>
      'The business registration number must contain digits only.';

  @override
  String get onboardingLocationErrorServiceDisabled =>
      'Location services are turned off. Please continue with manual entry.';

  @override
  String get onboardingLocationErrorPermissionDenied =>
      'Without location permission, automatic verification from your current location is unavailable. You can continue with manual entry and try again after granting permission.';

  @override
  String get onboardingLocationErrorPermissionPermanentlyDenied =>
      'Location permission is turned off, so automatic verification from your current location is unavailable. Allow permission in app settings or continue with manual entry.';

  @override
  String get onboardingLocationErrorAccuracyLow =>
      'Location accuracy is too low for automatic verification.';

  @override
  String get onboardingLocationErrorAddressNotFound =>
      'We could not find the address. Please continue with manual entry.';

  @override
  String get onboardingLocationErrorUnknown =>
      'We could not load your location. Please continue with manual entry.';

  @override
  String get onboardingLocationQueryRequired =>
      'Please enter your neighborhood name.';

  @override
  String get onboardingLocationQueryNotFound =>
      'We could not find the neighborhood you entered.';

  @override
  String get onboardingLocationCurrentFallback => 'Current location';

  @override
  String homeParticipantCount(int current, int capacity) {
    return '$current/$capacity joined';
  }

  @override
  String get homeFavoritesSubtitle => 'Share your interests with the world.';

  @override
  String get homeFavoritesEmptyTitle => 'You have no saved activities yet.';

  @override
  String get homeFavoritesEmptyDescription =>
      'Save activities you like and you can revisit them here.';

  @override
  String get homeNearbyCultureMap => 'Traditional culture nearby';

  @override
  String get onboardingTermsPendingEffectiveDate => 'Pending confirmation';

  @override
  String get onboardingTermsServiceTitle => 'Terms of Service';

  @override
  String get onboardingTermsServiceSummary =>
      'These terms explain the basic conditions for using MateYa, user responsibilities, and how the service is operated.';

  @override
  String get onboardingTermsServiceSection1Title => 'Purpose of the service';

  @override
  String get onboardingTermsServiceSection1Body =>
      'MateYa is a platform that helps domestic users and international users safely discover and join groups, classes, and local activities.';

  @override
  String get onboardingTermsServiceSection2Title =>
      'Signup and account management';

  @override
  String get onboardingTermsServiceSection2Body =>
      'Members must sign up with information under their own name and complete phone verification and consent to the terms before using the service. If account information changes, it must be kept up to date.';

  @override
  String get onboardingTermsServiceSection3Title => 'Conditions of use';

  @override
  String get onboardingTermsServiceSection3Body =>
      'Members must comply with applicable laws and these terms and must not infringe on others rights or interfere with the operation of the service. Some features may require identity verification or additional authentication.';

  @override
  String get onboardingTermsServiceSection4Title => 'Prohibited conduct';

  @override
  String get onboardingTermsServiceSection4Body =>
      'Registering false information, impersonating others, illegal promotion, posting obscene or hateful content, abnormal automated access, or attempts to bypass operational policies are prohibited. Violations may result in content removal, restrictions on use, or account suspension.';

  @override
  String get onboardingTermsServiceSection5Title =>
      'Service interruption and changes';

  @override
  String get onboardingTermsServiceSection5Body =>
      'MateYa may change or temporarily suspend parts of the service due to maintenance, incident response, policy updates, or external partnership circumstances. Important changes will be announced in the app or through another appropriate method.';

  @override
  String get onboardingTermsServiceSection6Title => 'Limitation of liability';

  @override
  String get onboardingTermsServiceSection6Body =>
      'MateYa may limit liability to the extent permitted by law for damage caused by force majeure, communication failures, or reasons attributable to the user. This does not apply in cases of intentional misconduct or gross negligence by the company.';

  @override
  String get onboardingTermsServiceSection7Title => 'Contact';

  @override
  String get onboardingTermsServiceSection7Body =>
      'If you need help while using the service, you can contact us through the in-app support channel or the operations team email. Requests are handled in order according to operational policy.';

  @override
  String get onboardingTermsPrivacyTitle =>
      'Consent to Third-Party Sharing of Personal Information';

  @override
  String get onboardingTermsPrivacySummary =>
      'This explains the standards for sharing personal information with third parties when needed for activity operations, reservations, and customer support.';

  @override
  String get onboardingTermsPrivacySection1Title => 'Recipients';

  @override
  String get onboardingTermsPrivacySection1Body =>
      'Hosts who run groups/classes on MateYa or partner businesses needed for service operations';

  @override
  String get onboardingTermsPrivacySection2Title => 'Purpose of sharing';

  @override
  String get onboardingTermsPrivacySection2Body =>
      'Confirming participation requests, coordinating schedules smoothly with hosts, supporting on-site operations, responding to customer inquiries, and resolving disputes';

  @override
  String get onboardingTermsPrivacySection3Title => 'Items shared';

  @override
  String get onboardingTermsPrivacySection3Body =>
      'Name, phone number, activity application details, preferred language, and the minimum participation history required to provide the service';

  @override
  String get onboardingTermsPrivacySection4Title =>
      'Retention and usage period';

  @override
  String get onboardingTermsPrivacySection4Body =>
      'Information is retained until the purpose of sharing is fulfilled or until a legally required retention period ends, after which it is deleted or anonymized without delay.';

  @override
  String get onboardingTermsPrivacySection5Title =>
      'Right to refuse and disadvantages';

  @override
  String get onboardingTermsPrivacySection5Body =>
      'Members may refuse consent to third-party sharing of personal information. However, some services that require activity participation, reservation confirmation, or communication with hosts may be limited.';

  @override
  String get onboardingTermsLocationTitle =>
      'Terms for Location-Based Services';

  @override
  String get onboardingTermsLocationSummary =>
      'This explains how current location and activity region information are used to provide nearby groups and recommendations, along with the related protection standards.';

  @override
  String get onboardingTermsLocationSection1Title => 'Purpose';

  @override
  String get onboardingTermsLocationSection1Body =>
      'These terms explain the conditions and procedures for using the location-based services provided by MateYa, as well as the rights and obligations of the company and users and the standards for protecting location information.';

  @override
  String get onboardingTermsLocationSection2Title =>
      'Collection and use of location information';

  @override
  String get onboardingTermsLocationSection2Body =>
      'The company uses the current location or activity region information within the scope of features requested by the user and only for the following purposes.';

  @override
  String get onboardingTermsLocationSection2Point1 =>
      'Neighborhood verification and activity region confirmation';

  @override
  String get onboardingTermsLocationSection2Point2 =>
      'Nearby group recommendations and distance-based sorting';

  @override
  String get onboardingTermsLocationSection2Point3 =>
      'Providing region-tailored content and a safer participation experience';

  @override
  String get onboardingTermsLocationSection3Title =>
      'Retention and usage period';

  @override
  String get onboardingTermsLocationSection3Body =>
      'Real-time location information is not retained after immediate processing is completed. However, the minimum data needed for service operations, such as activity region verification results, may be retained for the period required by law or internal policy and then deleted or anonymized without delay.';

  @override
  String get onboardingTermsLocationSection4Title => 'User rights';

  @override
  String get onboardingTermsLocationSection4Body =>
      'Users may withdraw consent to provide location information at any time through device settings or in-app permission settings and may choose whether to use location-based services. Withdrawing consent may limit certain recommendation or neighborhood verification features.';

  @override
  String get onboardingTermsLocationSection5Title => 'Company obligations';

  @override
  String get onboardingTermsLocationSection5Body =>
      'The company manages location information safely in accordance with applicable laws and internal security standards and does not use it beyond the intended purpose or share it with third parties without separate consent. The company also responds promptly to user inquiries and complaints and provides necessary guidance.';

  @override
  String get onboardingTermsLocationSection6Title => 'Contact';

  @override
  String get onboardingTermsLocationSection6Body =>
      'Questions about location-based services can be submitted through the in-app support channel or the operations team contact window. Requests are processed in order according to internal policy.';

  @override
  String get onboardingTermsAgeTitle => 'Confirmation of age 14 or older';

  @override
  String get onboardingTermsAgeSummary =>
      'MateYa signup is available only to users age 14 or older, and this explains the related age verification and usage restrictions.';

  @override
  String get onboardingTermsAgeSection1Title => 'Age confirmation';

  @override
  String get onboardingTermsAgeSection1Body =>
      'When signing up, members must confirm and agree that they are at least 14 years old.';

  @override
  String get onboardingTermsAgeSection2Title => 'Signup restriction';

  @override
  String get onboardingTermsAgeSection2Body =>
      'Users under the age of 14 are not allowed to sign up for MateYa or use the service.';

  @override
  String get onboardingTermsAgeSection3Title => 'Action for false confirmation';

  @override
  String get onboardingTermsAgeSection3Body =>
      'If it is confirmed that a user signed up by falsely confirming their age, the service may be restricted, the account may be terminated, or additional verification procedures may be required.';

  @override
  String get chatAttachmentRecoveryFailed =>
      'Could not restore the photos you were selecting earlier. Please select them again.';

  @override
  String get chatAttachmentSheetTitle => 'Attach photos';

  @override
  String get chatAttachmentSheetDescription =>
      'Choose multiple photos from your album or take one right away with the camera.';

  @override
  String get chatAttachmentGalleryTitle => 'Choose from album';

  @override
  String get chatAttachmentGallerySubtitle =>
      'You can select multiple photos at once.';

  @override
  String get chatAttachmentCameraTitle => 'Take a photo';

  @override
  String get chatAttachmentCameraSubtitle =>
      'Take one photo now and attach it.';

  @override
  String get chatAttachmentGuideFormats =>
      'Supported formats: JPG, PNG, WEBP, GIF, HEIC, HEIF';

  @override
  String get chatAttachmentGuideMaxSize => 'Maximum size: 10MB';

  @override
  String chatAttachmentGuideMaxCount(int count) {
    return 'Up to $count per message';
  }

  @override
  String get chatAttachmentPhotoPermissionTitle => 'Photo permission notice';

  @override
  String get chatAttachmentCameraPermissionTitle => 'Camera permission notice';

  @override
  String get chatAttachmentPhotoPermissionMessage =>
      'Photo library access is required to attach photos in chat. You can continue using text chat even if you deny permission.';

  @override
  String get chatAttachmentCameraPermissionMessage =>
      'Camera access is required to take and send photos in chat. You can continue using text chat even if you deny permission.';

  @override
  String get chatAttachmentPhotoSelect => 'Select photos';

  @override
  String get chatAttachmentOpenCamera => 'Open camera';

  @override
  String get chatAttachmentPhotoRecoveryTitle => 'Photo access is required';

  @override
  String get chatAttachmentCameraRecoveryTitle => 'Camera access is required';

  @override
  String get chatAttachmentPhotoRecoveryMessage =>
      'Photo library access is required to attach photos. You can still continue text chat without it, and you can retry or allow permission in app settings.';

  @override
  String get chatAttachmentCameraRecoveryMessage =>
      'Camera access is required to attach a photo taken in chat. You can still continue text chat without it, and you can retry or allow permission in app settings.';

  @override
  String get chatAttachmentLoadFailed =>
      'Could not load the photo. Please check permissions and file status.';

  @override
  String chatAttachmentAddedCount(int count) {
    return 'Attached $count photo(s).';
  }

  @override
  String chatAttachmentRejectedTypeCount(int count) {
    return 'Excluded $count photo(s) with unsupported formats.';
  }

  @override
  String chatAttachmentRejectedSizeCount(int count) {
    return 'Excluded $count photo(s) larger than 10MB.';
  }

  @override
  String chatAttachmentOverflowCount(int count) {
    return 'You can attach up to $count photos.';
  }

  @override
  String get chatAttachmentPhotoOnly => 'Photo';

  @override
  String get chatAttachmentInvalidFormat =>
      'Only JPG, PNG, WEBP, GIF, HEIC, and HEIF images can be sent.';

  @override
  String get chatAttachmentUploadFailed =>
      'Could not upload the chat image. Please try again later.';

  @override
  String get chatListLoadError => 'Could not load the chat list.';

  @override
  String get chatListEmptyTitle => 'There are no chat rooms to show.';

  @override
  String get chatListEmptyBody =>
      'Try changing the filter or starting a new conversation.';

  @override
  String get chatListLoadMoreHint => 'Scroll to load more chat rooms.';

  @override
  String get chatListLoadMoreFailedNetwork =>
      'Could not load more chat rooms. Please check your connection.';

  @override
  String get chatListLoadMoreFailedServer =>
      'Could not load more chat rooms. Please try again later.';

  @override
  String get chatRoomMissing => 'Could not find the chat room information.';

  @override
  String get chatBackToList => 'Back to list';

  @override
  String get chatRoomLoadError => 'Could not load the chat room.';

  @override
  String get chatOlderMessagesHint => 'Scroll up to load older messages.';

  @override
  String get chatOlderMessagesFailedNetwork =>
      'Could not load older messages. Please check your connection.';

  @override
  String get chatOlderMessagesFailedServer =>
      'Could not load older messages. Please try again later.';

  @override
  String get chatReadSyncFailed =>
      'Could not sync the read status with the server. We will try again later.';

  @override
  String get chatSendFailedNetwork =>
      'Could not send the message. Please check your connection.';

  @override
  String get chatSendFailedServer =>
      'Could not send the message. Please try again later.';

  @override
  String get chatMe => 'Me';

  @override
  String get chatDefaultDirectRoomTitle => 'Direct chat';

  @override
  String get chatDefaultGroupRoomTitle => 'Chat room';

  @override
  String get chatRealtimeConnectionError =>
      'Could not connect to realtime chat.';

  @override
  String get chatRealtimeMessageError =>
      'Could not process the realtime chat message.';

  @override
  String get homeActivityRegionFallback => 'Activity region';

  @override
  String get homeNearbyMapLoadError => 'Could not load places on the map.';

  @override
  String get homeNearbyMapCurrentLocationLabel => 'Based on current location';

  @override
  String get homeNearbyMapSearchHint => 'What would you like to find?';

  @override
  String get homeNearbyMapEmptyTitle => 'No nearby places were found';

  @override
  String get homeNearbyMapEmptyBody =>
      'Try a different keyword or reload your current location.';

  @override
  String get homeNearbyMapListTitle => 'Nearby places';

  @override
  String homeNearbyMapPlaceCount(int count) {
    return '$count places';
  }

  @override
  String get homeNearbyMapListButton => 'View list';

  @override
  String get homeNearbyMapBadgeFallback => 'Nearby place';

  @override
  String get homeNearbyMapParseError => 'Could not parse the place data.';

  @override
  String get homeNearbyMapLocationLoadError =>
      'Could not get your current location.';

  @override
  String get homeNearbyMapLocationRefreshError =>
      'Could not refresh your current location.';

  @override
  String get homeNearbyMapLocationRequired =>
      'Please check your location first to view the map.';

  @override
  String get homeNearbyMapPlacesLoadError =>
      'Could not load places. Please try again later.';

  @override
  String get detailsActivityRequired =>
      'Please load the activity details first.';

  @override
  String get detailsFavoriteToggleError =>
      'Could not update the favorite status. Please try again later.';

  @override
  String get detailsJoinAlreadyRequested =>
      'You have already requested to join this activity.';

  @override
  String get detailsJoinAlreadyJoined =>
      'You are already participating in this activity.';

  @override
  String get detailsJoinHostedByMe => 'This is an activity you created.';

  @override
  String get detailsJoinRequestError =>
      'Could not complete your join request. Please try again later.';

  @override
  String get detailsParticipantRemoveError =>
      'Could not remove the participant. Please try again later.';

  @override
  String get detailsPendingCancelError =>
      'Could not cancel the request. Please try again later.';

  @override
  String get detailsPendingApproveError =>
      'Could not approve the join request. Please try again later.';

  @override
  String get detailsReviewRequired => 'Please load the review details first.';

  @override
  String get detailsHelpfulToggleError =>
      'Could not update the helpful status. Please try again later.';

  @override
  String get detailsReviewValidationRequired =>
      'Please enter both a rating and a review.';

  @override
  String get detailsReviewSubmitError =>
      'Could not submit the review. Please try again later.';

  @override
  String get detailsLoadError =>
      'Could not load the activity details. Please try again later.';

  @override
  String get detailsReviewSortLatest => 'Newest';

  @override
  String get detailsReviewSortOldest => 'Oldest';

  @override
  String get detailsReviewSortHighestRating => 'Highest rating';

  @override
  String get detailsReviewSortLowestRating => 'Lowest rating';

  @override
  String get detailsJoinAvailable => 'Join';

  @override
  String get detailsJoinRequested => 'Requested';

  @override
  String get detailsJoinJoined => 'Joined';

  @override
  String get detailsJoinHost => 'My activity';

  @override
  String detailsReviewSummary(Object average, int count) {
    return '$average ($count reviews)';
  }

  @override
  String detailsParticipantSummary(int current, int capacity) {
    return '$current/$capacity joined';
  }

  @override
  String detailsParticipantsJoined(int count) {
    return '$count joined';
  }

  @override
  String detailsParticipantsRemaining(int count) {
    return '$count spots left';
  }

  @override
  String get detailsRecruitmentClosed => 'Registration closed';

  @override
  String get detailsIntroduction => 'About this activity';

  @override
  String detailsReviewsTitle(int count) {
    return '$count reviews';
  }

  @override
  String get detailsReviewsEmpty =>
      'No reviews yet. Be the first to leave one.';

  @override
  String get detailsPriceLabel => 'Price';

  @override
  String get detailsJoinRequesting => 'Requesting...';

  @override
  String detailsReviewRatingSummary(int count) {
    return '$count reviews total';
  }

  @override
  String detailsReviewRating(int rating) {
    return '$rating stars';
  }

  @override
  String detailsReviewHelpfulCount(int count) {
    return 'Helpful to $count people';
  }

  @override
  String get detailsReviewViewOriginal => 'View original';

  @override
  String get detailsReviewViewTranslation => 'View translation';

  @override
  String get detailsRepresentativeImage => 'Cover';

  @override
  String get detailsReviewGalleryNotice =>
      'Photo library access is required to attach images to your review. Even if you deny access, you can still write a text review and submit a rating.';

  @override
  String get detailsReviewGalleryRecovery =>
      'Photo library access is required to attach review images. Even without permission, you can still submit a text review and rating, and you can try again or allow access in app settings.';

  @override
  String get detailsReviewGalleryFailure =>
      'Could not load the photo. Please check the permission and file status.';

  @override
  String get detailsReviewGalleryRestoreError =>
      'Could not restore the review images you were selecting. Please choose them again.';

  @override
  String detailsReviewRestoredCount(int restoredCount) {
    return 'Restored $restoredCount review images you were selecting.';
  }

  @override
  String get detailsReviewSubmitted => 'Your review has been posted.';

  @override
  String get detailsReviewComposerTitle => 'Write a review';

  @override
  String get detailsReviewComposerHint =>
      'Share what you enjoyed about the activity,\nor leave something helpful for the next participant.';

  @override
  String detailsBodyCount(int count, int max) {
    return '$count/$max chars';
  }

  @override
  String detailsReviewImageSectionTitle(int max) {
    return 'Images (up to $max)';
  }

  @override
  String get detailsReviewSubmitting => 'Posting...';

  @override
  String get detailsReviewSubmit => 'Post review';

  @override
  String get detailsReviewImageGuide =>
      'The first image becomes the cover image,\nand you can long-press to reorder them.';

  @override
  String get detailsShareCopied =>
      'The share link has been copied. You can paste it directly into your preferred messenger.';

  @override
  String get detailsReportActivityReload =>
      'Please reload the activity details before reporting it.';

  @override
  String get detailsParticipantsListTitle => 'Participants';

  @override
  String get detailsParticipantRemoved => 'The participant has been removed.';

  @override
  String get detailsPendingParticipantsListTitle => 'Pending requests';

  @override
  String get detailsPendingCancelled => 'The request has been canceled.';

  @override
  String get detailsParticipantSwipeHint =>
      'Swipe to remove or cancel a request.';

  @override
  String detailsReviewListReportSubject(Object title) {
    return '$title review list';
  }

  @override
  String get detailsReviewLoadMoreHint => 'Scroll to load more reviews.';

  @override
  String get detailsReviewImageInvalidFormat =>
      'Only review images in JPG, PNG, WEBP, or GIF format can be uploaded.';

  @override
  String get detailsReviewImageUploadError =>
      'Could not upload the review images. Please try again later.';

  @override
  String get detailsMe => 'Me';

  @override
  String get commonInvalidServerResponse =>
      'The server response format is invalid.';

  @override
  String onboardingVerificationResendLimitNotice(int count) {
    return 'You can request a new verification code up to 5 times a day. You have requested it $count times so far.';
  }

  @override
  String get onboardingVerificationResendLimitReached =>
      'You can request a new verification code up to 5 times a day.';

  @override
  String get onboardingVerificationSent =>
      'The verification code has been sent.';

  @override
  String get onboardingVerificationResent =>
      'A new verification code has been sent.';

  @override
  String get onboardingBusinessVerificationCompleted =>
      'Business verification is complete. Please continue with phone verification.';

  @override
  String get onboardingConsentRequired => 'Please agree to all required terms.';

  @override
  String get homeExploreLoadMoreFailedNetwork =>
      'Could not load more results. Please check your connection.';

  @override
  String get homeExploreLoadMoreFailedServer =>
      'Could not load more results. Please try again later.';
}
