// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'MateYa';

  @override
  String get brandLockupSubtitle => '开启一段分享韩国温情与文化的\n特别旅程';

  @override
  String get languageKorean => '韩语';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageJapanese => '日语';

  @override
  String get languageChineseSimplified => '简体中文';

  @override
  String get bottomNavigationHome => '首页';

  @override
  String get bottomNavigationExplore => '探索';

  @override
  String get bottomNavigationChat => '聊天';

  @override
  String get bottomNavigationProfile => '我的';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonContinue => '继续';

  @override
  String get commonLater => '稍后';

  @override
  String get commonAll => '全部';

  @override
  String get commonNext => '下一步';

  @override
  String get commonReset => '重置';

  @override
  String get commonApply => '应用';

  @override
  String get commonProcessing => '处理中...';

  @override
  String get commonFree => '免费';

  @override
  String get commonToday => '今天';

  @override
  String get commonTomorrow => '明天';

  @override
  String get permissionOpenAppSettings => '打开应用设置';

  @override
  String get permissionOpenLocationSettings => '打开定位设置';

  @override
  String get locationServiceDisabledTitle => '定位服务已关闭';

  @override
  String get locationPermissionDisabledTitle => '定位权限已关闭';

  @override
  String get languageDialogBarrierLabel => '语言选择';

  @override
  String get languageDialogTitle => '切换语言';

  @override
  String get languageDialogSupportedLanguages => '支持语言';

  @override
  String get onboardingStart => '开始使用';

  @override
  String get onboardingBusinessPrompt => '您是商家吗？ ';

  @override
  String get onboardingStartAsHost => '以主办方身份开始';

  @override
  String get onboardingConsentTitle => '使用 MateYa 前需要先同意。';

  @override
  String get onboardingAgreeAll => '全部同意';

  @override
  String get onboardingAgreeAllHelper => '同意以下所有必选和可选项目。';

  @override
  String onboardingRequiredAgreementLabel(Object title) {
    return '（必选）$title';
  }

  @override
  String get onboardingEnterName => '请输入姓名';

  @override
  String get onboardingEnterPhoneNumber => '请输入手机号';

  @override
  String get onboardingEnterVerificationCode => '请输入验证码';

  @override
  String get onboardingPhoneNumberLabel => '手机号';

  @override
  String get onboardingPhoneNumberHint => '例如 01012341234';

  @override
  String get onboardingPhoneNumberHelper => '输入手机号后即可接收验证码。';

  @override
  String get onboardingVerificationCodeLabel => '验证码';

  @override
  String get onboardingVerificationCodeHint => '点击获取验证码后即可输入。';

  @override
  String get onboardingResendVerificationCode => '重新发送验证码';

  @override
  String onboardingDebugVerificationCode(Object code) {
    return '测试验证码：$code';
  }

  @override
  String get onboardingVerify => '验证';

  @override
  String get onboardingRequestVerificationCode => '获取验证码';

  @override
  String get onboardingLocationServiceDisabledMessage =>
      '如需使用当前位置完成社区认证，请先开启设备定位服务。即使不开启，也可以手动输入社区继续注册。';

  @override
  String get onboardingLocationPermissionDisabledMessage =>
      '如需使用当前位置自动认证，请在应用设置中允许定位权限。即使不允许，也可以手动输入继续注册。';

  @override
  String onboardingPreviousNeighborhood(Object name) {
    return '您之前登记的地区是“$name”。';
  }

  @override
  String get onboardingResolvingCurrentLocation => '正在确认当前位置。';

  @override
  String get onboardingCompleteNeighborhood => '完成社区认证';

  @override
  String get onboardingRetryLocationPermission => '重新请求定位权限';

  @override
  String get onboardingRetryAfterSettingsChange => '修改设置后重新确认';

  @override
  String get onboardingRetryLocationService => '重新检查定位服务';

  @override
  String get onboardingRetryCurrentLocation => '重新确认当前位置';

  @override
  String get onboardingNeedHelp => '认证有困难吗？  ';

  @override
  String get onboardingManualInputCta => '手动输入 >';

  @override
  String get onboardingLocationPermissionNoticeTitle => '定位权限说明';

  @override
  String get onboardingLocationPermissionNoticeMessage =>
      '为了进行社区认证并推荐附近活动，需要位置信息。\n即使不授予权限，也可以手动输入社区继续注册。';

  @override
  String get onboardingUseCurrentLocation => '使用当前位置认证';

  @override
  String get onboardingManualInput => '手动输入';

  @override
  String get onboardingManualNeighborhoodHelper => '请输入区/街道等地区名称。';

  @override
  String get onboardingNeighborhoodHint => '牛满洞';

  @override
  String get onboardingEnterBusinessName => '请输入商号名称';

  @override
  String get onboardingBusinessNameHint => 'NICE 评级信息';

  @override
  String get onboardingBusinessNumberLabel => '营业执照号码';

  @override
  String get onboardingBusinessOwnerLabel => '代表人姓名';

  @override
  String get onboardingBusinessOwnerHint => '洪吉童';

  @override
  String get onboardingBusinessOpeningDateLabel => '开业日期';

  @override
  String get onboardingBusinessOpeningDateHint => '20240131';

  @override
  String get onboardingCompleteBusinessVerification => '完成商家认证';

  @override
  String get onboardingWelcomeBack => '欢迎回来';

  @override
  String onboardingReturnCompleted(Object name) {
    return '$name，\n您已完成返回 MateYa';
  }

  @override
  String get onboardingLaunchApp => '开始使用 MateYa';

  @override
  String onboardingAgreementSemantics(Object label) {
    return '同意 $label';
  }

  @override
  String onboardingTermsEffectiveDate(Object date) {
    return '生效日期：$date';
  }

  @override
  String get onboardingTermsContents => '目录';

  @override
  String onboardingTermsSectionTitle(int index, Object title) {
    return '第$index条 $title';
  }

  @override
  String get onboardingDefaultMemberName => 'MateYa 会员';

  @override
  String onboardingLoginCompleted(Object name) {
    return '$name，\n您已登录 MateYa';
  }

  @override
  String onboardingSignupCompleted(Object name) {
    return '$name，\n您的 MateYa 注册已完成';
  }

  @override
  String onboardingNeighborhoodHeadlineReturning(Object name) {
    return '欢迎回来，\n$name！\n请完成社区信息认证';
  }

  @override
  String get onboardingNeighborhoodHeadlineSignup => '请完成社区信息认证';

  @override
  String onboardingResolvedNeighborhoodMessage(Object name) {
    return '您当前位于“$name”。';
  }

  @override
  String get onboardingNeighborhoodLabel => '社区';

  @override
  String get onboardingVerificationExpired => '验证已过期，请重新获取验证码。';

  @override
  String get onboardingBusinessVerificationExpired => '商家认证已过期，请重新认证。';

  @override
  String get homeSortRecommended => '推荐排序';

  @override
  String get homeSortPopular => '热门排序';

  @override
  String get homeSortLatest => '最新排序';

  @override
  String get homeSortClosingSoon => '即将截止排序';

  @override
  String get homeSortNearby => '距离最近排序';

  @override
  String get homeAudienceEveryone => '所有人';

  @override
  String get homeAudienceForeignerFriendly => '欢迎外国人';

  @override
  String get homeAudienceKoreanFriendly => '欢迎韩国人';

  @override
  String get homeAudienceTouristFriendly => '推荐游客参加';

  @override
  String get homeAudienceBeginnerFriendly => '欢迎新手';

  @override
  String get homeStatusRecruiting => '招募中';

  @override
  String get homeStatusClosingSoon => '即将截止（24小时内）';

  @override
  String get homeStatusNewlyListed => '新上线（24小时内）';

  @override
  String get homeDistanceLocal => '我的地区';

  @override
  String get homeDistanceWithin1km => '1公里内';

  @override
  String get homeDistanceWithin5km => '5公里内';

  @override
  String get homeDistanceWithin10km => '10公里内';

  @override
  String get homeSearchHeroHint => '随时随地';

  @override
  String get homeSearchHeroHelper => '在这里，任何人都能成为你的 Mate，MateYa';

  @override
  String get homeLoadError => '无法加载数据。';

  @override
  String get homeSelectAtLeastOneCategory => '请至少选择一个分类。';

  @override
  String get homeSelectAtLeastOneLanguage => '请至少选择一种语言。';

  @override
  String get homeUnsupportedExploreLanguageFilter => '探索语言筛选目前仅支持韩语、英语、中文和日语。';

  @override
  String get homeEndDateBeforeStartDateError => '结束日期不能早于开始日期。';

  @override
  String get homeMaxPriceLessThanMinPriceError => '最高金额必须大于或等于最低金额。';

  @override
  String get homeTrendingTitle => '热门飙升 🔥';

  @override
  String get homeSharedExperiencesTitle => '可以一起参与的体验';

  @override
  String get homeExploreSearchHint => '试着搜索名称或地点';

  @override
  String get homeExploreError => '无法加载结果。';

  @override
  String get homeFavoritesLoadError => '无法加载收藏列表。';

  @override
  String get homeFavoritesTitle => '收藏列表';

  @override
  String get homeCreateClass => '注册课程';

  @override
  String get homeCreateGroup => '创建聚会';

  @override
  String get homeEmptyTitle => '暂时还没有符合条件的活动。';

  @override
  String get homeEmptyDescription => '请调整搜索词或筛选条件后再试一次。';

  @override
  String get homeLoadMore => '加载更多';

  @override
  String homeLoadedAllActivities(int count) {
    return '已加载全部 $count 个活动。';
  }

  @override
  String get homeFilterTitle => '筛选';

  @override
  String get homeFilterSort => '排序';

  @override
  String get homeFilterCategory => '分类';

  @override
  String get homeFilterAudience => '参加对象';

  @override
  String get homeFilterLanguage => '语言';

  @override
  String get homeFilterRegion => '地区';

  @override
  String get homeFilterSchedule => '日程';

  @override
  String get homeFilterStartDate => '开始日期';

  @override
  String get homeFilterEndDate => '结束日期';

  @override
  String get homeFilterCost => '费用';

  @override
  String get homeFilterMinPrice => '最低金额';

  @override
  String get homeFilterMaxPrice => '最高金额';

  @override
  String get homeFilterStatus => '招募状态';

  @override
  String get homeFilterNear => '近';

  @override
  String get homeFilterFar => '远';

  @override
  String homeFilterDistanceFromActivityRegion(Object target) {
    return '以活动地区为基准：$target';
  }

  @override
  String homeFilterDistanceFromRegion(Object regionName, Object target) {
    return '以 $regionName 为基准：$target';
  }

  @override
  String get commonClose => '关闭';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonDelete => '删除';

  @override
  String get commonSeeAll => '查看全部';

  @override
  String get commonSeeDetails => '查看详情';

  @override
  String get commonNetworkRetry => '请检查网络连接后再试。';

  @override
  String get countryKorea => '韩国';

  @override
  String get countryJapan => '日本';

  @override
  String get countryChina => '中国';

  @override
  String get countryVietnam => '越南';

  @override
  String get countryUnitedStates => '美国';

  @override
  String get countryThailand => '泰国';

  @override
  String get activityCategoryTouristAttraction => '旅游景点';

  @override
  String get activityCategoryTravelCourse => '旅行路线';

  @override
  String get activityCategoryCultureTradition => '文化 / 传统';

  @override
  String get activityCategoryEventPerformanceFestival => '活动 / 演出 / 庆典';

  @override
  String get activityCategorySports => '体育';

  @override
  String get activityCategoryActivityLeports => '活动 / 休闲运动';

  @override
  String get activityCategoryShopping => '购物';

  @override
  String get activityCategoryPublicFacility => '公共设施';

  @override
  String get activityCategoryOther => '其他';

  @override
  String get reportSemanticsLabel => '举报';

  @override
  String get reportTitle => '举报';

  @override
  String get reportNoticeMessage => '如需附加举报图片，需要允许访问照片库。即使未授权，也可以继续填写举报内容。';

  @override
  String get reportRecoveryMessage => '如需附加举报图片，需要允许访问照片库。请重试，或在应用设置中允许权限。';

  @override
  String get reportFailureMessage => '无法加载图片。请检查权限和文件状态。';

  @override
  String get reportRestoreFallbackErrorMessage => '无法恢复你之前选择的举报图片，请重新选择。';

  @override
  String reportSubmittedMessage(Object subject) {
    return '已提交关于 $subject 的举报。';
  }

  @override
  String get reportBodyHint =>
      '请尽量详细填写举报原因。\n例如：辱骂、疑似诈骗、不当内容、\n垃圾信息、骚扰等。举报内容将根据运营政策进行审核。';

  @override
  String reportBodyCount(int count, int max) {
    return '$count/$max字';
  }

  @override
  String reportImageSectionTitle(int max) {
    return '图片（最多 $max 张）';
  }

  @override
  String get reportSubmitting => '提交中...';

  @override
  String get reportReviewNotice =>
      '举报提交后会立即发送给运营团队，并在最多 7 个工作日内完成审核。\n如举报内容不实或理由不明确，可能不予处理。';

  @override
  String reportRestoredCount(int restoredCount) {
    return '已恢复之前选择的 $restoredCount 张举报图片。';
  }

  @override
  String get mypageTitle => '我的页面';

  @override
  String get mypageLoadError => '无法加载我的页面。';

  @override
  String get mypageOtherProfileOpenHint => '正在加载个人资料。';

  @override
  String get mypageOtherProfileLoadError => '无法加载对方的个人资料。';

  @override
  String get mypageEditPrimaryPreferences => '编辑基本信息';

  @override
  String get mypageEditActivityRegion => '编辑活动地区';

  @override
  String get mypageConsentHistoryTitle => '同意记录';

  @override
  String get mypageOpenPrivacyPolicy => '隐私政策';

  @override
  String get mypageOpenCustomerSupport => '客服中心';

  @override
  String get mypageOpenBlockedUsers => '已屏蔽用户';

  @override
  String get mypageLogout => '退出登录';

  @override
  String get mypageOpenWithdrawal => '注销账号';

  @override
  String get mypageConsentHistoryDescription => '你可以查看使用 MateYa 时同意过的条款与政策。';

  @override
  String get mypageConsentHistoryEmpty => '还没有保存的同意记录。';

  @override
  String get mypageConsentVersion => '版本';

  @override
  String get mypageConsentStatus => '状态';

  @override
  String get mypageConsentAgreed => '已同意';

  @override
  String get mypageConsentDeclined => '未同意';

  @override
  String get mypageConsentDate => '同意时间';

  @override
  String get mypageBlockedUsersTitle => '已屏蔽用户';

  @override
  String get mypageBlockedUsersDescription =>
      '已屏蔽的用户会立即从你的页面中隐藏，你也可以在此列表中再次管理他们。';

  @override
  String get mypageBlockedUsersEmpty => '还没有屏蔽任何用户。';

  @override
  String get mypageRecentActivitiesTitle => '最近活动';

  @override
  String get mypageRecentActivitiesDescription => '查看你最近参与或创建的活动。';

  @override
  String get mypageActivitySummaryTitle => '活动摘要';

  @override
  String get mypageHostedCount => '发起';

  @override
  String get mypageJoinedCount => '参与';

  @override
  String get mypageReviewCount => '评价';

  @override
  String get mypageActiveMember => '活跃成员';

  @override
  String get mypageInactiveMember => '最近没有活动';

  @override
  String get mypageActiveWithin30Days => '30 天内活跃';

  @override
  String get mypageNoRecentActivity => '最近没有活动';

  @override
  String get mypageBadgeLabel => '徽章';

  @override
  String get mypageBadgesTitle => '我的徽章';

  @override
  String get mypageBadgesDescription => '根据你参与的活动分类，可以获得不同徽章。';

  @override
  String get mypageOtherBadgesTitle => '已获得的徽章';

  @override
  String get mypageOtherBadgesDescription => '这是该用户已获得的徽章。';

  @override
  String get mypageOtherBadgesEmpty => '该用户还没有公开徽章。';

  @override
  String get mypageRecentActivitiesSectionTitle => '活动记录';

  @override
  String get mypageActivityHistoryTitle => '活动记录';

  @override
  String get mypagePrimaryPreferencesTitle => '基本信息';

  @override
  String get mypagePrimaryPreferencesDescription => '可以修改你的语言和国籍信息。';

  @override
  String get mypageMyLanguage => '我的语言';

  @override
  String get mypageMyCountry => '我的国籍';

  @override
  String get mypageEnglishNameOptional => '英文名（可选）';

  @override
  String get mypageSaving => '保存中...';

  @override
  String get mypagePrimaryPreferencesSubmit => '保存';

  @override
  String get mypageUpdating => '更新中...';

  @override
  String get mypageBusinessIntroTitle => '简介';

  @override
  String get mypageBusinessIntroDescription => '请填写会显示在主办方页面上的一句话简介。';

  @override
  String get mypageBusinessIntroHint => '自然地介绍你提供的体验内容。';

  @override
  String get mypageSaveIntroduction => '保存简介';

  @override
  String get mypageActiveExperiencesTitle => '进行中的体验';

  @override
  String get mypageAddFriend => '添加好友';

  @override
  String get mypageRemoveFriend => '删除好友';

  @override
  String get mypageBlocked => '已屏蔽';

  @override
  String get mypageBlockUser => '屏蔽用户';

  @override
  String get mypageBlockUserHint => '该用户的活动和互动会立即从你的页面中隐藏。';

  @override
  String get mypageSelectLanguageAndCountry => '请选择语言和国家。';

  @override
  String get mypageInvalidLanguageOrCountry => '不支持该语言或国家。';

  @override
  String get mypagePrimaryPreferencesSaved => '基本信息已保存。';

  @override
  String get mypagePrimaryPreferencesSaveError => '无法保存基本信息，请稍后再试。';

  @override
  String get mypageFriendRemoved => '已删除好友。';

  @override
  String get mypageFriendAdded => '已添加为好友。';

  @override
  String get mypageFriendUpdateError => '无法更新好友状态，请稍后再试。';

  @override
  String get mypageBlockedUserAdded => '已屏蔽该用户。';

  @override
  String get mypageBlockUserError => '无法屏蔽该用户，请稍后再试。';

  @override
  String get mypageUnblockAction => '解除屏蔽';

  @override
  String get mypageUnblockedUser => '已解除屏蔽。';

  @override
  String get mypageUnblockUserError => '无法解除屏蔽，请稍后再试。';

  @override
  String get mypageBusinessIntroRequired => '请输入简介。';

  @override
  String get mypageBusinessIntroTooLong => '简介请控制在 300 字以内。';

  @override
  String get mypageBusinessIntroSaved => '简介已保存。';

  @override
  String get mypageBusinessIntroSaveError => '无法保存简介，请稍后再试。';

  @override
  String get mypageProfileImageSaved => '头像已保存。';

  @override
  String get mypageProfileImageSaveError => '无法保存头像，请稍后再试。';

  @override
  String get mypageProfileImageInvalidFormat => '仅支持上传 JPG、PNG、WEBP、GIF 格式图片。';

  @override
  String get mypageProfileImageUploadError => '无法上传头像，请稍后再试。';

  @override
  String get mypageProfileImageConfirmError => '头像上传确认失败，请稍后再试。';

  @override
  String get mypageActivityRegionSaved => '活动地区已保存。';

  @override
  String get mypageActivityRegionSaveError => '无法保存活动地区，请稍后再试。';

  @override
  String get mypageWithdrawalAgreementRequired => '申请注销前需要先同意相关内容。';

  @override
  String get mypageWithdrawalSignatureRequired => '请输入签名。';

  @override
  String get mypageWithdrawalSignatureMismatch => '输入的签名与会员姓名不一致。';

  @override
  String get mypageWithdrawalAgreementText => '我同意个人信息管理及 30 天后最终删除政策。';

  @override
  String get mypageWithdrawalSubmitted => '注销申请已提交。';

  @override
  String get mypageWithdrawalSubmitError => '无法处理注销申请，请稍后再试。';

  @override
  String get mypageLogoutError => '无法退出登录，请稍后再试。';

  @override
  String get mypageTermsDetailUnavailable => '无法加载条款详情。';

  @override
  String get mypageSupportLinkCopied => '已复制客服中心链接。';

  @override
  String get mypagePrivacyLinkCopied => '已复制隐私政策链接。';

  @override
  String get mypageCurrentLocationResolveError => '无法确认当前位置，请稍后再试。';

  @override
  String get mypageNeighborhoodRequired => '请输入活动地区。';

  @override
  String get mypageNeighborhoodLookupError => '无法确认你输入的地区，请重新检查。';

  @override
  String get mypageNeighborhoodVerificationRequired => '请选择已确认的活动地区。';

  @override
  String get mypageActivityRegionDialogDescription => '你可以使用当前位置，或手动输入来设置活动地区。';

  @override
  String get mypageResolvingCurrentLocation => '正在确认当前位置。';

  @override
  String get mypageResolvingNeighborhood => '正在确认你输入的地区。';

  @override
  String get mypageConfirmManualNeighborhood => '使用这个输入地区';

  @override
  String mypageSelectedActivityRegion(Object name) {
    return '已选择的活动地区：$name';
  }

  @override
  String get mypageSaveActivityRegion => '保存活动地区';

  @override
  String get mypageLocationServiceDisabledMessage =>
      '如需使用当前位置，请先开启设备定位服务。也可以通过手动输入继续。';

  @override
  String get mypageLocationPermissionDisabledMessage =>
      '如需使用当前位置，请在应用设置中允许定位权限。也可以通过手动输入继续。';

  @override
  String get mypageProfileImageNotice => '选择头像需要访问照片库权限。';

  @override
  String get mypageProfileImageRecovery => '请选择允许访问照片库后再试，也可以在应用设置中修改。';

  @override
  String get mypageProfileImageFailure => '无法加载头像，请检查文件状态。';

  @override
  String get mypageProfileImageRestoreFallback => '无法恢复你之前选择的头像，请重新选择。';

  @override
  String mypageProfileImageRestoredCount(int restoredCount) {
    return '已恢复之前选择的 $restoredCount 张头像图片。';
  }

  @override
  String get mypageWithdrawalTitle => '注销账号';

  @override
  String get mypageWithdrawalDescription =>
      '确定要继续注销账号吗？\n提交后，账号会立即停用。\n如果你在 30 天内重新注册或重新登录，注销将被取消。\n\n30 天后，除法律要求保留的信息外，会员资料和服务使用记录将被永久删除，且无法恢复。';

  @override
  String get mypageWithdrawalAgreementCheckbox => '我同意个人信息管理及 30 天后最终删除政策。';

  @override
  String get mypageWithdrawalSignatureLabel => '签名输入';

  @override
  String mypageWithdrawalSignatureHint(Object name) {
    return '输入 $name';
  }

  @override
  String get mypageWithdrawalSubmittedNotice => '注销申请已受理。在你重新登录之前，账号将被视为停用状态。';

  @override
  String get mypageWithdrawalRequest => '申请注销';

  @override
  String get mypageMetricActivities => '活动数';

  @override
  String get mypageMetricFriends => '好友数';

  @override
  String get mypageMetricReviews => '评价数';

  @override
  String get mypageMetricRecruitingExperiences => '招募中的体验';

  @override
  String get mypageMetricTotalParticipants => '累计参与者';

  @override
  String get mypageMetricAverageRating => '平均评分';

  @override
  String get mypageMetricReceivedReviews => '收到的评价';

  @override
  String get mypageActivityRegionUnset => '未设置活动地区';

  @override
  String mypageParticipantCount(int current, int capacity) {
    return '$current / $capacity人';
  }

  @override
  String get mypageConsentTypeServiceTerms => '服务使用条款';

  @override
  String get mypageConsentTypePrivacyCollection => '个人信息收集与使用同意';

  @override
  String get mypageConsentTypeLocationService => '基于位置服务使用同意';

  @override
  String get mypageConsentTypeAgeOver14 => '已满 14 周岁确认';

  @override
  String get mypageHostBadge => 'HOST';

  @override
  String get mypageEditActivityCta => '编辑活动';

  @override
  String get mypageBadgeTraditional => '传统达人';

  @override
  String get mypageBadgeActivePerson => '活力伙伴';

  @override
  String get mypageBadgeFestive => '庆典爱好者';

  @override
  String get mypageBadgeTourist => '本地探索家';

  @override
  String get mypageBadgeRequirementTraditional => '請至少參加 1 次傳統文化分類體驗。';

  @override
  String get mypageBadgeRequirementActivePerson => '請至少參加 1 次體育或休閒活動分類體驗。';

  @override
  String get mypageBadgeRequirementFestive => '請至少參加 1 次活動/演出/慶典分類體驗。';

  @override
  String get mypageBadgeRequirementTourist => '請至少參加 1 次景點或旅行路線分類體驗。';

  @override
  String get mypageBadgeUnlockedTitle => '获得了新徽章';

  @override
  String mypageBadgeUnlockedDescription(Object category) {
    return '已记录你参与 $category 活动的经历。';
  }

  @override
  String get galleryPermissionNoticeTitle => '照片权限说明';

  @override
  String get galleryPermissionSelectPhoto => '选择照片';

  @override
  String get galleryPermissionRecoveryTitle => '需要照片访问权限';

  @override
  String get authLoginRequired => '需要先登录。';

  @override
  String get commonRequestError => '处理请求时发生错误。';

  @override
  String get chatJustNow => '刚刚';

  @override
  String chatMinutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String chatHoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String get chatYesterday => '昨天';

  @override
  String get chatLastYear => '去年';

  @override
  String chatPhotoCount(int count) {
    return '$count张照片';
  }

  @override
  String get chatViewOriginal => '查看原文';

  @override
  String get chatViewTranslation => '查看翻译';

  @override
  String chatParticipantCount(int count) {
    return '$count人参与';
  }

  @override
  String get chatFilterGroup => '群聊';

  @override
  String get chatFilterDirect => '私聊';

  @override
  String get chatListGuidance => '参加活动后，会自动加入群聊。\n与好友的私聊会自动创建。\n无法与非好友用户聊天。';

  @override
  String get chatComposerHint => '请输入消息';

  @override
  String get reportReasonRequired => '请输入举报原因。';

  @override
  String get reportImageInvalidFormat => '举报图片仅支持 JPG、PNG、WEBP、GIF 格式。';

  @override
  String get reportImageUploadError => '无法上传举报图片，请稍后再试。';

  @override
  String get reportImageConfirmError => '举报图片上传确认失败，请稍后再试。';

  @override
  String get createGroupFlowTitle => '创建小组';

  @override
  String get createClassFlowTitle => '创建课程';

  @override
  String get createEntityGroup => '小组';

  @override
  String get createEntityClass => '课程';

  @override
  String get createGroupSubmit => '创建小组';

  @override
  String get createClassSubmit => '创建课程';

  @override
  String get createGroupEditTitle => '编辑小组';

  @override
  String get createClassEditTitle => '编辑课程';

  @override
  String get createGroupUpdateSubmit => '保存小组修改';

  @override
  String get createClassUpdateSubmit => '保存课程修改';

  @override
  String get createPaidLabel => '收费';

  @override
  String createEditCompleted(Object entity) {
    return '$entity已更新。';
  }

  @override
  String createSubmitCompleted(Object entity) {
    return '$entity已创建。';
  }

  @override
  String createChatProvisionFailed(Object entity) {
    return '$entity已创建，但暂时无法准备聊天室。请稍后再试。';
  }

  @override
  String createSubmitFailedNetwork(Object entity) {
    return '无法创建$entity。请检查网络后重试。';
  }

  @override
  String createSubmitFailedServer(Object entity) {
    return '无法创建$entity。请稍后再试。';
  }

  @override
  String get createDeleteFailedNetwork => '无法删除。请检查网络后重试。';

  @override
  String get createDeleteFailedServer => '无法删除。请稍后再试。';

  @override
  String createLoadEditFailedNetwork(Object entity) {
    return '无法加载要编辑的$entity信息。请检查网络后重试。';
  }

  @override
  String createLoadEditFailedServer(Object entity) {
    return '无法加载要编辑的$entity信息。请稍后再试。';
  }

  @override
  String get createValidationSelectCategory => '请选择至少一个分类。';

  @override
  String get createValidationSelectClassCategoryFirst => '请先选择适合课程的分类。';

  @override
  String get createValidationSelectPlaceOrManual => '请选择地点或手动输入地点。';

  @override
  String get createValidationSelectPlace => '请选择地点。';

  @override
  String createValidationEnterEntityName(Object entity) {
    return '请输入$entity名称。';
  }

  @override
  String get createValidationTitleMaxLength => '名称不能超过 40 个字符。';

  @override
  String get createValidationDescriptionMaxLength => '说明不能超过 1000 个字符。';

  @override
  String get createValidationSelectDate => '请选择日期。';

  @override
  String get createValidationNoPastDate => '不能选择过去的日期。';

  @override
  String get createValidationSelectStartEndTime => '请选择开始时间和结束时间。';

  @override
  String get createValidationEndAfterStart => '结束时间必须晚于开始时间。';

  @override
  String get createValidationCapacityRange => '参与人数必须在 2 到 20 人之间。';

  @override
  String get createValidationSelectDeadline => '请选择报名截止日期和时间。';

  @override
  String get createValidationSelectDeadlineTogether => '请同时选择报名截止日期和时间。';

  @override
  String get createValidationDeadlineFuture => '报名截止时间必须晚于当前时间。';

  @override
  String get createValidationDeadlineBeforeStart => '报名截止时间必须早于开始时间。';

  @override
  String get createValidationSelectLanguage => '请至少选择一种语言。';

  @override
  String get createValidationSelectPriceType => '请选择价格类型。';

  @override
  String get createValidationEnterPaidPrice => '如果是收费活动，请输入金额。';

  @override
  String get createValidationPriceRange => '金额请输入 1 韩元到 1000000 韩元之间。';

  @override
  String get createValidationRegisterImage => '请至少上传一张封面图。';

  @override
  String get createGroupInfoTitle => '请输入小组信息';

  @override
  String get createClassInfoTitle => '请输入课程信息';

  @override
  String get createValidationIntro => '填写下方必填信息后即可立即发布。';

  @override
  String get createSelectedCategoryTitle => '已选分类';

  @override
  String get createSelectedPlaceTitle => '已选地点';

  @override
  String get createGroupNameLabel => '小组名称';

  @override
  String get createClassNameLabel => '课程名称';

  @override
  String get createGroupNameHint => '例如：一起逛北村韩屋';

  @override
  String get createClassNameHint => '例如：传统茶一日体验课';

  @override
  String get createDescriptionTitle => '详细说明';

  @override
  String get createDescriptionHint => '请填写流程、准备物品，以及参与者需要了解的内容。';

  @override
  String get createDateTimeTitle => '日程';

  @override
  String get createDateLabel => '活动日期';

  @override
  String get createDatePlaceholder => '请选择日期';

  @override
  String get createStartTimeLabel => '开始时间';

  @override
  String get createStartTimePlaceholder => '请选择开始时间';

  @override
  String get createEndTimeLabel => '结束时间';

  @override
  String get createEndTimePlaceholder => '请选择结束时间';

  @override
  String get createCapacityTitle => '参与人数';

  @override
  String createCapacityValue(int count) {
    return '$count人';
  }

  @override
  String get createCapacityHelper => '最少 2 人，最多 20 人';

  @override
  String get createDeadlineTitle => '报名截止';

  @override
  String get createDeadlineDateLabel => '截止日期';

  @override
  String get createDeadlineTimeLabel => '截止时间';

  @override
  String get createNotSelected => '未选择';

  @override
  String get createLanguagesTitle => '使用语言';

  @override
  String get createPriceTitle => '参加费用';

  @override
  String get createPaidPriceHint => '请输入参加费用';

  @override
  String get createAudienceTitle => '推荐对象';

  @override
  String get createPrimaryImageTitle => '封面图片';

  @override
  String get createPrimaryImageRequiredHint => '请至少上传一张封面图。';

  @override
  String get createPrimaryImageSelectionHint => '第一张图片会设为封面，点击其他图片可更换封面。';

  @override
  String get createPrimaryImageBadge => '封面';

  @override
  String get createDeleting => '删除中...';

  @override
  String createDeleteAction(Object entity) {
    return '删除$entity';
  }

  @override
  String get createPlaceGroupTitle => '请选择小组地点';

  @override
  String get createPlaceClassTitle => '请选择课程地点';

  @override
  String get createPlaceGroupDescription => '可以选择推荐地点，或手动输入小组地点。';

  @override
  String get createPlaceClassDescription => '可以搜索符合分类的地点，或手动输入课程地点。';

  @override
  String get createClassCategoryTitle => '课程分类';

  @override
  String get createCategoryDetailTitle => '细分类别';

  @override
  String get createManualPlaceTitle => '手动输入';

  @override
  String get createManualPlaceNameHint => '请输入地点名称';

  @override
  String get createManualPlaceAddressHint => '请输入地址';

  @override
  String get createOrSearchTitle => '或搜索地点';

  @override
  String get createPlaceSearchHint => '按地点名称搜索';

  @override
  String get createManualPlacePreviewDescription => '将使用您手动输入的地点信息发布。';

  @override
  String get createSearchResultsTitle => '搜索结果';

  @override
  String get createSearchEmptyTitle => '没有搜索结果';

  @override
  String get createSearchEmptyBody => '请尝试使用其他关键词搜索。';

  @override
  String get createSearchInitialTitle => '请搜索地点';

  @override
  String get createSearchInitialBody => '输入地点名称或地址后，将显示可供选择的结果。';

  @override
  String get createRecommendedTitle => '推荐地点';

  @override
  String get createRefresh => '刷新';

  @override
  String get createRecommendedEmptyTitle => '暂无推荐地点';

  @override
  String get createRecommendedEmptyBody => '请更换分类或手动搜索。';

  @override
  String get createMapPlaceholder => '选择地点后，这里会显示其位置。';

  @override
  String get createCategoryPromptTitle => '你想创建什么样的体验？';

  @override
  String get createCategoryPromptDescription => '请选择最符合你要发布的小组或课程的分类。';

  @override
  String get createCompletedEditDescription => '修改内容已保存，并会立即展示给参与者。';

  @override
  String get createCompletedCreateDescription => '现在大家已经可以在 MateYa 中发现它了。';

  @override
  String get createBackToPrevious => '返回';

  @override
  String get createBackToHome => '返回首页';

  @override
  String get createStepCategory => '分类';

  @override
  String get createStepPlaceGroup => '地点';

  @override
  String get createStepPlaceClass => '地点';

  @override
  String get createStepDetailsGroup => '填写信息';

  @override
  String get createStepDetailsClass => '填写信息';

  @override
  String get createCompletedProgress => '完成';

  @override
  String get createCategoryTitleCultureTradition => '文化 / 传统';

  @override
  String get createCategoryTitleEventPerformanceFestival => '活动 / 演出 / 庆典';

  @override
  String get createCategoryTitleActivityLeports => '活动 / 休闲运动';

  @override
  String get createCategoryDescriptionTourist => '适合围绕代表性景点展开的聚会。';

  @override
  String get createCategoryDescriptionTravelCourse => '适合包含移动路线的旅行型行程。';

  @override
  String get createCategoryDescriptionCultureTradition =>
      '推荐用于传统文化、手工艺、历史体验活动。';

  @override
  String get createCategoryDescriptionFestival => '适合演出、庆典和季节性活动。';

  @override
  String get createCategoryDescriptionSports => '适合运动、观赛以及体育主题聚会。';

  @override
  String get createCategoryDescriptionActivityLeports => '适合户外体验和更活跃的休闲运动活动。';

  @override
  String get createCategoryDescriptionPublicFacility => '推荐用于展览、公共空间和社区活动。';

  @override
  String get createCategoryDescriptionShopping => '很适合市场、购物街和本地店铺巡游。';

  @override
  String createEventDatePickerHelp(Object entity) {
    return '选择$entity日期';
  }

  @override
  String get createStartTimePickerHelp => '选择开始时间';

  @override
  String get createEndTimePickerHelp => '选择结束时间';

  @override
  String get createDeadlineDatePickerHelp => '选择报名截止日期';

  @override
  String get createDeadlineTimePickerHelp => '选择报名截止时间';

  @override
  String createDeleteDialogTitle(Object entity) {
    return '要删除这个$entity吗？';
  }

  @override
  String createDeleteDialogBody(Object entity) {
    return '删除后将无法恢复。';
  }

  @override
  String get createDeleteButton => '删除';

  @override
  String get createDeleteCompleted => '已删除。';

  @override
  String createInitializationLoadError(Object entity) {
    return '无法加载$entity信息。';
  }

  @override
  String get createInitializationRetryBody => '请稍后重试。如果问题持续存在，请返回上一页后重新进入。';

  @override
  String createSavingEntity(Object entity) {
    return '正在保存$entity...';
  }

  @override
  String createSubmittingEntity(Object entity) {
    return '正在创建$entity...';
  }

  @override
  String get createSelectPlaceAction => '选择地点';

  @override
  String get createImagePickerNotice => '要附加图片，需要允许访问照片库。即使不授予权限，也可以继续填写其他信息。';

  @override
  String get createImagePickerRecovery => '要继续附加图片，需要允许访问照片库。请重试，或在应用设置中开启权限。';

  @override
  String get createImagePickerFailure => '无法加载所选图片。请检查文件后重试。';

  @override
  String get createImagePickerRestoreFallback => '无法恢复之前选择的图片，请重新选择。';

  @override
  String createImagePickerRestoredCount(int count) {
    return '已恢复之前选择的 $count 张图片。';
  }

  @override
  String get createRecommendedLoadFailedNetwork => '无法加载推荐地点。请检查网络后重试。';

  @override
  String get createRecommendedLoadFailedServer => '无法加载推荐地点。请稍后再试。';

  @override
  String get createPlaceSearchQueryRequired => '请输入地点名称。';

  @override
  String get createPlaceSearchFailedNetwork => '地点搜索失败。请检查网络后重试。';

  @override
  String get createPlaceSearchFailedServer => '地点搜索失败。请稍后再试。';

  @override
  String get createPlaceCoordinateRequired => '该地点没有位置信息，无法选择。';

  @override
  String get createPlaceMapCoordinateRequired => '该地点没有位置信息，无法显示在地图上。';

  @override
  String createImageLimitExceeded(int max) {
    return '最多可添加 $max 张图片。';
  }

  @override
  String get createImageInvalidFormat => '仅支持添加 JPG、PNG、WEBP、GIF 格式的图片。';

  @override
  String get createImageMaxSize => '每张图片最大可为 10MB。';

  @override
  String get createPlaceDescriptionFallback => '请确认位置后再选择。';

  @override
  String get createExistingPlaceDescription => '现有活动地点';

  @override
  String get createResolveServerCategoryFailed => '无法根据所选地点确定服务器分类。请选择其他地点。';

  @override
  String get createUploadImageRequired => '请至少上传一张封面图。';

  @override
  String get createUploadImageInvalidFormat => '仅支持上传 JPG、PNG、WEBP、GIF 格式的图片。';

  @override
  String get createUploadImageFailed => '图片上传失败。请稍后再试。';

  @override
  String get createUploadImageConfirmFailed => '无法确认已上传的图片。请稍后再试。';

  @override
  String get onboardingValidationNameRequired => '请输入姓名。';

  @override
  String get onboardingValidationNameMaxLength => '姓名不能超过 30 个字符。';

  @override
  String get onboardingValidationNameCharacters => '请输入姓名本身，不要包含数字或特殊字符。';

  @override
  String get onboardingValidationPhoneRequired => '请输入电话号码。';

  @override
  String get onboardingValidationPhoneDigitsOnly => '电话号码只能输入数字。';

  @override
  String get onboardingValidationPhoneMaxLength => '电话号码最多可输入 15 位。';

  @override
  String get onboardingValidationPhoneInvalid => '请输入正确的电话号码。';

  @override
  String get onboardingValidationVerificationCodeRequired => '请输入 6 位验证码。';

  @override
  String get onboardingValidationVerificationExpired => '验证码已过期，请重新获取。';

  @override
  String get onboardingValidationVerificationMismatch => '验证码不匹配。';

  @override
  String get onboardingValidationBusinessNameRequired => '请输入商号名称。';

  @override
  String get onboardingValidationOpeningDateRequired => '请输入 8 位开业日期。';

  @override
  String get onboardingValidationOpeningDateDigitsOnly => '开业日期只能输入数字。';

  @override
  String get onboardingValidationOpeningDateInvalid => '请输入正确的开业日期。';

  @override
  String get onboardingValidationBusinessNumberRequired => '请输入正确的 10 位营业执照号码。';

  @override
  String get onboardingValidationBusinessNumberDigitsOnly => '营业执照号码只能输入数字。';

  @override
  String get onboardingLocationErrorServiceDisabled => '定位服务已关闭。请使用手动输入继续。';

  @override
  String get onboardingLocationErrorPermissionDenied =>
      '没有定位权限时，无法使用当前位置自动认证。你仍然可以通过手动输入继续，并在授权后重新尝试。';

  @override
  String get onboardingLocationErrorPermissionPermanentlyDenied =>
      '定位权限已关闭，无法使用当前位置自动认证。请在应用设置中允许权限，或使用手动输入继续。';

  @override
  String get onboardingLocationErrorAccuracyLow => '定位精度过低，难以进行自动认证。';

  @override
  String get onboardingLocationErrorAddressNotFound => '未找到地址。请使用手动输入继续。';

  @override
  String get onboardingLocationErrorUnknown => '无法获取位置信息。请使用手动输入继续。';

  @override
  String get onboardingLocationQueryRequired => '请输入所在地区名称。';

  @override
  String get onboardingLocationQueryNotFound => '未找到你输入的地区。';

  @override
  String get onboardingLocationCurrentFallback => '当前位置';

  @override
  String homeParticipantCount(int current, int capacity) {
    return '$current/$capacity 参与';
  }

  @override
  String get homeFavoritesSubtitle => '把你的兴趣分享给世界。';

  @override
  String get homeFavoritesEmptyTitle => '你还没有收藏任何活动。';

  @override
  String get homeFavoritesEmptyDescription => '收藏你喜欢的活动后，就可以在这里再次查看。';

  @override
  String get homeNearbyCultureMap => '附近的传统文化';

  @override
  String get onboardingTermsPendingEffectiveDate => '确认中';

  @override
  String get onboardingTermsServiceTitle => '服务使用条款';

  @override
  String get onboardingTermsServiceSummary =>
      '说明使用 MateYa 服务的基本条件、用户责任以及服务运营标准。';

  @override
  String get onboardingTermsServiceSection1Title => '服务目的';

  @override
  String get onboardingTermsServiceSection1Body =>
      'MateYa 是一个帮助本地用户和国际用户安全地发现并参与小组、课程和基于地区活动的平台。';

  @override
  String get onboardingTermsServiceSection2Title => '注册与账号管理';

  @override
  String get onboardingTermsServiceSection2Body =>
      '会员必须使用本人名义的信息注册，并完成手机验证和条款同意后方可使用服务。账号信息发生变化时，应及时保持最新状态。';

  @override
  String get onboardingTermsServiceSection3Title => '服务使用条件';

  @override
  String get onboardingTermsServiceSection3Body =>
      '会员必须遵守相关法律法规和本条款，不得侵犯他人权利或妨碍服务运营。部分功能可能需要身份确认或额外认证。';

  @override
  String get onboardingTermsServiceSection4Title => '禁止行为';

  @override
  String get onboardingTermsServiceSection4Body =>
      '禁止注册虚假信息、冒充他人、违法宣传、发布淫秽或仇恨内容、异常自动化访问或试图绕过运营政策。违反时，可能会采取删除内容、限制使用或暂停账号等措施。';

  @override
  String get onboardingTermsServiceSection5Title => '服务中断与变更';

  @override
  String get onboardingTermsServiceSection5Body =>
      'MateYa 可能因维护、故障应对、政策调整或外部合作因素，对部分服务进行变更或暂时中断。重要变更将通过应用内公告或其他适当方式通知。';

  @override
  String get onboardingTermsServiceSection6Title => '责任限制';

  @override
  String get onboardingTermsServiceSection6Body =>
      '对于因不可抗力、通信故障或用户自身原因造成的损失，MateYa 可在法律允许范围内限制责任。但公司存在故意或重大过失的情况除外。';

  @override
  String get onboardingTermsServiceSection7Title => '联系方式';

  @override
  String get onboardingTermsServiceSection7Body =>
      '如在使用服务过程中需要咨询，可通过应用内客服渠道或运营团队邮箱提交。提交内容将根据运营政策依次处理。';

  @override
  String get onboardingTermsPrivacyTitle => '同意向第三方提供个人信息';

  @override
  String get onboardingTermsPrivacySummary =>
      '说明在活动运营、预约进行和客户应对所需范围内，向第三方提供个人信息的标准。';

  @override
  String get onboardingTermsPrivacySection1Title => '接收方';

  @override
  String get onboardingTermsPrivacySection1Body =>
      '在 MateYa 内运营小组/课程的主持人，或服务运营所需的合作商户';

  @override
  String get onboardingTermsPrivacySection2Title => '提供目的';

  @override
  String get onboardingTermsPrivacySection2Body =>
      '确认报名申请、与主持人顺利协调日程、支持现场运营、处理客户咨询及纠纷';

  @override
  String get onboardingTermsPrivacySection3Title => '提供项目';

  @override
  String get onboardingTermsPrivacySection3Body =>
      '姓名、手机号、活动报名信息、主要语言以及提供服务所需的最少参与记录';

  @override
  String get onboardingTermsPrivacySection4Title => '保存与使用期限';

  @override
  String get onboardingTermsPrivacySection4Body =>
      '信息将保存至提供目的达成时，或法律规定的保存义务期限届满时，之后会及时删除或匿名化。';

  @override
  String get onboardingTermsPrivacySection5Title => '拒绝同意的权利及不利影响';

  @override
  String get onboardingTermsPrivacySection5Body =>
      '会员可以拒绝同意向第三方提供个人信息。但部分需要活动参与、预约确认或与主持人联系的服务可能会受到限制。';

  @override
  String get onboardingTermsLocationTitle => '基于位置服务使用条款';

  @override
  String get onboardingTermsLocationSummary =>
      '说明如何利用当前位置和活动地区信息提供附近小组与推荐结果，以及相关的保护标准。';

  @override
  String get onboardingTermsLocationSection1Title => '目的';

  @override
  String get onboardingTermsLocationSection1Body =>
      '本条款旨在说明 MateYa 提供的基于位置服务的使用条件与流程、公司和用户的权利义务，以及位置信息保护标准。';

  @override
  String get onboardingTermsLocationSection2Title => '位置信息的收集与使用';

  @override
  String get onboardingTermsLocationSection2Body =>
      '公司会在用户请求的功能范围内使用当前位置或活动地区信息，并且仅限于以下目的。';

  @override
  String get onboardingTermsLocationSection2Point1 => '地区认证和活动地区确认';

  @override
  String get onboardingTermsLocationSection2Point2 => '附近小组推荐及按距离排序';

  @override
  String get onboardingTermsLocationSection2Point3 => '提供符合地区的内容和更安全的参与体验';

  @override
  String get onboardingTermsLocationSection3Title => '保存与使用期限';

  @override
  String get onboardingTermsLocationSection3Body =>
      '实时位置信息在即时性功能处理完成后不会保存。但活动地区认证结果等服务运营所需的最少信息，可根据相关法律或内部运营标准保存必要期限，之后会及时删除或匿名化。';

  @override
  String get onboardingTermsLocationSection4Title => '用户权利';

  @override
  String get onboardingTermsLocationSection4Body =>
      '用户可随时通过设备设置或应用内权限设置撤回提供位置信息的同意，并可自行选择是否使用基于位置的服务。撤回同意后，部分推荐功能或地区认证功能可能会受到限制。';

  @override
  String get onboardingTermsLocationSection5Title => '公司的义务';

  @override
  String get onboardingTermsLocationSection5Body =>
      '公司会依据相关法律和内部安全标准安全管理位置信息，不会超出使用目的范围使用，也不会在未获得单独同意的情况下向第三方提供。同时，公司会及时确认用户咨询和投诉，并提供必要的说明。';

  @override
  String get onboardingTermsLocationSection6Title => '联系方式';

  @override
  String get onboardingTermsLocationSection6Body =>
      '有关基于位置服务的咨询，可通过应用内客服渠道或运营团队咨询窗口提交。提交内容将根据内部政策依次处理。';

  @override
  String get onboardingTermsAgeTitle => '确认已满 14 周岁';

  @override
  String get onboardingTermsAgeSummary =>
      'MateYa 仅允许年满 14 周岁的用户注册，本条说明与年龄确认相关的使用限制标准。';

  @override
  String get onboardingTermsAgeSection1Title => '年龄确认';

  @override
  String get onboardingTermsAgeSection1Body => '会员在注册时必须确认并同意自己已满 14 周岁。';

  @override
  String get onboardingTermsAgeSection2Title => '注册限制';

  @override
  String get onboardingTermsAgeSection2Body => '未满 14 周岁的用户不得注册 MateYa 或使用服务。';

  @override
  String get onboardingTermsAgeSection3Title => '虚假确认的处理';

  @override
  String get onboardingTermsAgeSection3Body =>
      '如确认存在虚假年龄确认后注册的情况，可能会限制服务使用、终止账号，或要求进行额外确认程序。';

  @override
  String get chatAttachmentRecoveryFailed => '无法恢复刚才选择的照片，请重新选择。';

  @override
  String get chatAttachmentSheetTitle => '添加照片';

  @override
  String get chatAttachmentSheetDescription => '你可以从相册选择多张照片，或直接用相机拍摄后发送。';

  @override
  String get chatAttachmentGalleryTitle => '从相册选择';

  @override
  String get chatAttachmentGallerySubtitle => '可一次选择多张照片。';

  @override
  String get chatAttachmentCameraTitle => '拍摄照片';

  @override
  String get chatAttachmentCameraSubtitle => '立即拍摄 1 张照片并附加。';

  @override
  String get chatAttachmentGuideFormats =>
      '支持格式: JPG, PNG, WEBP, GIF, HEIC, HEIF';

  @override
  String get chatAttachmentGuideMaxSize => '最大大小: 10MB';

  @override
  String chatAttachmentGuideMaxCount(int count) {
    return '每条消息最多 $count 张';
  }

  @override
  String get chatAttachmentPhotoPermissionTitle => '照片权限提示';

  @override
  String get chatAttachmentCameraPermissionTitle => '相机权限提示';

  @override
  String get chatAttachmentPhotoPermissionMessage =>
      '在聊天中附加照片需要访问照片库。即使拒绝权限，你仍可继续使用文字聊天。';

  @override
  String get chatAttachmentCameraPermissionMessage =>
      '在聊天中拍照并发送需要相机权限。即使拒绝权限，你仍可继续使用文字聊天。';

  @override
  String get chatAttachmentPhotoSelect => '选择照片';

  @override
  String get chatAttachmentOpenCamera => '打开相机';

  @override
  String get chatAttachmentPhotoRecoveryTitle => '需要照片访问权限';

  @override
  String get chatAttachmentCameraRecoveryTitle => '需要相机权限';

  @override
  String get chatAttachmentPhotoRecoveryMessage =>
      '附加照片需要访问照片库。即使没有权限，你仍可继续文字聊天，并可重试或在应用设置中允许权限。';

  @override
  String get chatAttachmentCameraRecoveryMessage =>
      '附加聊天拍摄的照片需要相机权限。即使没有权限，你仍可继续文字聊天，并可重试或在应用设置中允许权限。';

  @override
  String get chatAttachmentLoadFailed => '无法加载照片。请检查权限和文件状态。';

  @override
  String chatAttachmentAddedCount(int count) {
    return '已附加 $count 张照片。';
  }

  @override
  String chatAttachmentRejectedTypeCount(int count) {
    return '已排除 $count 张不支持格式的照片。';
  }

  @override
  String chatAttachmentRejectedSizeCount(int count) {
    return '已排除 $count 张超过 10MB 的照片。';
  }

  @override
  String chatAttachmentOverflowCount(int count) {
    return '最多可附加 $count 张照片。';
  }

  @override
  String get chatAttachmentPhotoOnly => '照片';

  @override
  String get chatAttachmentInvalidFormat =>
      '仅支持发送 JPG、PNG、WEBP、GIF、HEIC、HEIF 格式的图片。';

  @override
  String get chatAttachmentUploadFailed => '无法上传聊天图片，请稍后再试。';

  @override
  String get chatListLoadError => '无法加载聊天列表。';

  @override
  String get chatListEmptyTitle => '没有可显示的聊天室。';

  @override
  String get chatListEmptyBody => '请尝试更改筛选条件或开始新的对话。';

  @override
  String get chatListLoadMoreHint => '滚动以加载更多聊天室。';

  @override
  String get chatListLoadMoreFailedNetwork => '无法加载更多聊天室。请检查网络连接。';

  @override
  String get chatListLoadMoreFailedServer => '无法加载更多聊天室。请稍后再试。';

  @override
  String get chatRoomMissing => '找不到聊天室信息。';

  @override
  String get chatBackToList => '返回列表';

  @override
  String get chatRoomLoadError => '无法加载聊天室。';

  @override
  String get chatOlderMessagesHint => '向上滚动以加载更早的消息。';

  @override
  String get chatOlderMessagesFailedNetwork => '无法加载更早的消息。请检查网络连接。';

  @override
  String get chatOlderMessagesFailedServer => '无法加载更早的消息。请稍后再试。';

  @override
  String get chatReadSyncFailed => '无法将已读状态同步到服务器，稍后会再次尝试。';

  @override
  String get chatSendFailedNetwork => '无法发送消息。请检查网络连接。';

  @override
  String get chatSendFailedServer => '无法发送消息。请稍后再试。';

  @override
  String get chatMe => '我';

  @override
  String get chatDefaultDirectRoomTitle => '一对一聊天';

  @override
  String get chatDefaultGroupRoomTitle => '聊天室';

  @override
  String get chatRealtimeConnectionError => '无法连接实时聊天。';

  @override
  String get chatRealtimeMessageError => '无法处理实时聊天消息。';

  @override
  String get homeActivityRegionFallback => '活动地区';

  @override
  String get homeNearbyMapLoadError => '无法加载地图上的地点。';

  @override
  String get homeNearbyMapCurrentLocationLabel => '基于当前位置';

  @override
  String get homeNearbyMapSearchHint => '你想找什么？';

  @override
  String get homeNearbyMapEmptyTitle => '未找到附近地点';

  @override
  String get homeNearbyMapEmptyBody => '请尝试更换关键词，或重新获取当前位置。';

  @override
  String get homeNearbyMapListTitle => '附近地点列表';

  @override
  String homeNearbyMapPlaceCount(int count) {
    return '$count处';
  }

  @override
  String get homeNearbyMapListButton => '查看列表';

  @override
  String get homeNearbyMapBadgeFallback => '附近地点';

  @override
  String get homeNearbyMapParseError => '无法解析地点数据。';

  @override
  String get homeNearbyMapLocationLoadError => '无法获取当前位置。';

  @override
  String get homeNearbyMapLocationRefreshError => '无法重新获取当前位置。';

  @override
  String get homeNearbyMapLocationRequired => '查看地图前请先确认位置信息。';

  @override
  String get homeNearbyMapPlacesLoadError => '无法加载地点，请稍后再试。';

  @override
  String get detailsActivityRequired => '请先加载活动详情。';

  @override
  String get detailsFavoriteToggleError => '无法更改收藏状态，请稍后再试。';

  @override
  String get detailsJoinAlreadyRequested => '你已经申请参加这个活动了。';

  @override
  String get detailsJoinAlreadyJoined => '你已经在参加这个活动了。';

  @override
  String get detailsJoinHostedByMe => '这是你创建的活动。';

  @override
  String get detailsJoinRequestError => '无法完成参加申请，请稍后再试。';

  @override
  String get detailsParticipantRemoveError => '无法移除参与者，请稍后再试。';

  @override
  String get detailsPendingCancelError => '无法取消申请，请稍后再试。';

  @override
  String get detailsPendingApproveError => '无法批准参加申请，请稍后再试。';

  @override
  String get detailsReviewRequired => '请先加载评价详情。';

  @override
  String get detailsHelpfulToggleError => '无法更改“有帮助”状态，请稍后再试。';

  @override
  String get detailsReviewValidationRequired => '请输入评分和评价内容。';

  @override
  String get detailsReviewSubmitError => '无法发布评价，请稍后再试。';

  @override
  String get detailsReviewUpdateError => '无法更新评价，请稍后再试。';

  @override
  String get detailsReviewDeleteError => '无法删除评价，请稍后再试。';

  @override
  String get detailsLoadError => '无法加载活动详情，请稍后再试。';

  @override
  String get detailsReviewSortLatest => '最新';

  @override
  String get detailsReviewSortOldest => '最早';

  @override
  String get detailsReviewSortHighestRating => '评分从高到低';

  @override
  String get detailsReviewSortLowestRating => '评分从低到高';

  @override
  String get detailsJoinAvailable => '参加活动';

  @override
  String get detailsJoinRequested => '已申请';

  @override
  String get detailsJoinJoined => '已参加';

  @override
  String get detailsJoinHost => '我的活动';

  @override
  String detailsReviewSummary(Object average, int count) {
    return '$average（$count条评价）';
  }

  @override
  String detailsParticipantSummary(int current, int capacity) {
    return '$current/$capacity 人参与';
  }

  @override
  String detailsParticipantsJoined(int count) {
    return '$count 人已参与';
  }

  @override
  String detailsParticipantsRemaining(int count) {
    return '还剩 $count 个名额';
  }

  @override
  String get detailsRecruitmentClosed => '报名结束';

  @override
  String get detailsIntroduction => '活动介绍';

  @override
  String detailsReviewsTitle(int count) {
    return '$count 条评价';
  }

  @override
  String get detailsReviewsEmpty => '还没有评价，来留下第一条吧。';

  @override
  String get detailsPriceLabel => '体验费用';

  @override
  String get detailsJoinRequesting => '申请中...';

  @override
  String detailsReviewRatingSummary(int count) {
    return '共 $count 条评价';
  }

  @override
  String detailsReviewRating(int rating) {
    return '$rating 分';
  }

  @override
  String detailsReviewHelpfulCount(int count) {
    return '对 $count 人有帮助';
  }

  @override
  String get detailsReviewViewOriginal => '查看原文';

  @override
  String get detailsReviewViewTranslation => '查看翻译';

  @override
  String get detailsRepresentativeImage => '封面';

  @override
  String get detailsReviewGalleryNotice =>
      '要在评价中添加图片，需要访问你的照片库。即使不授权，你仍然可以继续填写文字评价和评分。';

  @override
  String get detailsReviewGalleryRecovery =>
      '要添加评价图片，需要访问你的照片库。即使没有权限，你仍然可以继续提交文字评价和评分，也可以稍后重试或前往应用设置开启权限。';

  @override
  String get detailsReviewGalleryFailure => '无法加载图片，请检查权限和文件状态。';

  @override
  String get detailsReviewGalleryRestoreError => '无法恢复你之前选择的评价图片，请重新选择。';

  @override
  String detailsReviewRestoredCount(int restoredCount) {
    return '已恢复你之前选择的 $restoredCount 张评价图片。';
  }

  @override
  String get detailsReviewSubmitted => '评价已发布。';

  @override
  String get detailsReviewUpdated => '评价已更新。';

  @override
  String get detailsReviewDeleted => '评价已删除。';

  @override
  String get detailsReviewComposerTitle => '写评价';

  @override
  String get detailsReviewEditTitle => '编辑评价';

  @override
  String get detailsReviewComposerHint => '请写下这次活动中让你满意的地方，\n或对下一位参加者有帮助的内容。';

  @override
  String detailsBodyCount(int count, int max) {
    return '$count/$max 字';
  }

  @override
  String detailsReviewImageSectionTitle(int max) {
    return '图片（最多 $max 张）';
  }

  @override
  String get detailsReviewSubmitting => '发布中...';

  @override
  String get detailsReviewSubmit => '发布评价';

  @override
  String get detailsReviewUpdating => '保存中...';

  @override
  String get detailsReviewEditSubmit => '保存评价';

  @override
  String get detailsReviewImageGuide => '第一张图片会作为封面图，\n长按可以调整顺序。';

  @override
  String get detailsReviewDeleteDialogTitle => '要删除这条评价吗？';

  @override
  String get detailsReviewDeleteDialogBody => '删除后将无法恢复。';

  @override
  String get detailsShareCopied => '已复制分享链接。可以直接粘贴到你常用的聊天工具中。';

  @override
  String get detailsReportActivityReload => '请重新加载活动信息后再举报。';

  @override
  String get detailsParticipantsListTitle => '参与用户列表';

  @override
  String get detailsParticipantRemoved => '已移除参与者。';

  @override
  String get detailsParticipantActionViewProfile => '查看个人资料';

  @override
  String get detailsParticipantActionApprove => '批准申请';

  @override
  String get detailsParticipantActionRemove => '移除参与者';

  @override
  String get detailsParticipantActionCancelRequest => '取消申请';

  @override
  String get detailsPendingParticipantsListTitle => '申请用户列表';

  @override
  String get detailsPendingCancelled => '已取消申请。';

  @override
  String get detailsParticipantSwipeHint => '可滑动删除或取消申请';

  @override
  String detailsReviewListReportSubject(Object title) {
    return '$title 评价列表';
  }

  @override
  String get detailsReviewLoadMoreHint => '滚动以加载更多评价。';

  @override
  String get detailsReviewImageInvalidFormat =>
      '只能上传 JPG、PNG、WEBP、GIF 格式的评价图片。';

  @override
  String get detailsReviewImageUploadError => '无法上传评价图片，请稍后再试。';

  @override
  String get detailsMe => '我';

  @override
  String get commonInvalidServerResponse => '服务器响应格式不正确。';

  @override
  String onboardingVerificationResendLimitNotice(int count) {
    return '验证码每天最多可重新获取 5 次。你目前已请求 $count 次。';
  }

  @override
  String get onboardingVerificationResendLimitReached => '验证码每天最多可重新获取 5 次。';

  @override
  String get onboardingVerificationSent => '验证码已发送。';

  @override
  String get onboardingVerificationResent => '验证码已重新发送。';

  @override
  String get onboardingBusinessVerificationCompleted => '商家认证已完成。请继续进行手机认证。';

  @override
  String get onboardingConsentRequired => '请同意所有必需条款。';

  @override
  String get homeExploreLoadMoreFailedNetwork => '无法加载更多结果。请检查网络连接。';

  @override
  String get homeExploreLoadMoreFailedServer => '无法加载更多结果。请稍后再试。';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => 'MateYa';

  @override
  String get brandLockupSubtitle => '开启一段分享韩国温情与文化的\n特别旅程';

  @override
  String get languageKorean => '韩语';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageJapanese => '日语';

  @override
  String get languageChineseSimplified => '简体中文';

  @override
  String get bottomNavigationHome => '首页';

  @override
  String get bottomNavigationExplore => '探索';

  @override
  String get bottomNavigationChat => '聊天';

  @override
  String get bottomNavigationProfile => '我的';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonContinue => '继续';

  @override
  String get commonLater => '稍后';

  @override
  String get commonAll => '全部';

  @override
  String get commonNext => '下一步';

  @override
  String get commonReset => '重置';

  @override
  String get commonApply => '应用';

  @override
  String get commonProcessing => '处理中...';

  @override
  String get commonFree => '免费';

  @override
  String get commonToday => '今天';

  @override
  String get commonTomorrow => '明天';

  @override
  String get permissionOpenAppSettings => '打开应用设置';

  @override
  String get permissionOpenLocationSettings => '打开定位设置';

  @override
  String get locationServiceDisabledTitle => '定位服务已关闭';

  @override
  String get locationPermissionDisabledTitle => '定位权限已关闭';

  @override
  String get languageDialogBarrierLabel => '语言选择';

  @override
  String get languageDialogTitle => '切换语言';

  @override
  String get languageDialogSupportedLanguages => '支持语言';

  @override
  String get onboardingStart => '开始使用';

  @override
  String get onboardingBusinessPrompt => '您是商家吗？ ';

  @override
  String get onboardingStartAsHost => '以主办方身份开始';

  @override
  String get onboardingConsentTitle => '使用 MateYa 前需要先同意。';

  @override
  String get onboardingAgreeAll => '全部同意';

  @override
  String get onboardingAgreeAllHelper => '同意以下所有必选和可选项目。';

  @override
  String onboardingRequiredAgreementLabel(Object title) {
    return '（必选）$title';
  }

  @override
  String get onboardingEnterName => '请输入姓名';

  @override
  String get onboardingEnterPhoneNumber => '请输入手机号';

  @override
  String get onboardingEnterVerificationCode => '请输入验证码';

  @override
  String get onboardingPhoneNumberLabel => '手机号';

  @override
  String get onboardingPhoneNumberHint => '例如 01012341234';

  @override
  String get onboardingPhoneNumberHelper => '输入手机号后即可接收验证码。';

  @override
  String get onboardingVerificationCodeLabel => '验证码';

  @override
  String get onboardingVerificationCodeHint => '点击获取验证码后即可输入。';

  @override
  String get onboardingResendVerificationCode => '重新发送验证码';

  @override
  String onboardingDebugVerificationCode(Object code) {
    return '测试验证码：$code';
  }

  @override
  String get onboardingVerify => '验证';

  @override
  String get onboardingRequestVerificationCode => '获取验证码';

  @override
  String get onboardingLocationServiceDisabledMessage =>
      '如需使用当前位置完成社区认证，请先开启设备定位服务。即使不开启，也可以手动输入社区继续注册。';

  @override
  String get onboardingLocationPermissionDisabledMessage =>
      '如需使用当前位置自动认证，请在应用设置中允许定位权限。即使不允许，也可以手动输入继续注册。';

  @override
  String onboardingPreviousNeighborhood(Object name) {
    return '您之前登记的地区是“$name”。';
  }

  @override
  String get onboardingResolvingCurrentLocation => '正在确认当前位置。';

  @override
  String get onboardingCompleteNeighborhood => '完成社区认证';

  @override
  String get onboardingRetryLocationPermission => '重新请求定位权限';

  @override
  String get onboardingRetryAfterSettingsChange => '修改设置后重新确认';

  @override
  String get onboardingRetryLocationService => '重新检查定位服务';

  @override
  String get onboardingRetryCurrentLocation => '重新确认当前位置';

  @override
  String get onboardingNeedHelp => '认证有困难吗？  ';

  @override
  String get onboardingManualInputCta => '手动输入 >';

  @override
  String get onboardingLocationPermissionNoticeTitle => '定位权限说明';

  @override
  String get onboardingLocationPermissionNoticeMessage =>
      '为了进行社区认证并推荐附近活动，需要位置信息。\n即使不授予权限，也可以手动输入社区继续注册。';

  @override
  String get onboardingUseCurrentLocation => '使用当前位置认证';

  @override
  String get onboardingManualInput => '手动输入';

  @override
  String get onboardingManualNeighborhoodHelper => '请输入区/街道等地区名称。';

  @override
  String get onboardingNeighborhoodHint => '牛满洞';

  @override
  String get onboardingEnterBusinessName => '请输入商号名称';

  @override
  String get onboardingBusinessNameHint => 'NICE 评级信息';

  @override
  String get onboardingBusinessNumberLabel => '营业执照号码';

  @override
  String get onboardingBusinessOwnerLabel => '代表人姓名';

  @override
  String get onboardingBusinessOwnerHint => '洪吉童';

  @override
  String get onboardingBusinessOpeningDateLabel => '开业日期';

  @override
  String get onboardingBusinessOpeningDateHint => '20240131';

  @override
  String get onboardingCompleteBusinessVerification => '完成商家认证';

  @override
  String get onboardingWelcomeBack => '欢迎回来';

  @override
  String onboardingReturnCompleted(Object name) {
    return '$name，\n您已完成返回 MateYa';
  }

  @override
  String get onboardingLaunchApp => '开始使用 MateYa';

  @override
  String onboardingAgreementSemantics(Object label) {
    return '同意 $label';
  }

  @override
  String onboardingTermsEffectiveDate(Object date) {
    return '生效日期：$date';
  }

  @override
  String get onboardingTermsContents => '目录';

  @override
  String onboardingTermsSectionTitle(int index, Object title) {
    return '第$index条 $title';
  }

  @override
  String get onboardingDefaultMemberName => 'MateYa 会员';

  @override
  String onboardingLoginCompleted(Object name) {
    return '$name，\n您已登录 MateYa';
  }

  @override
  String onboardingSignupCompleted(Object name) {
    return '$name，\n您的 MateYa 注册已完成';
  }

  @override
  String onboardingNeighborhoodHeadlineReturning(Object name) {
    return '欢迎回来，\n$name！\n请完成社区信息认证';
  }

  @override
  String get onboardingNeighborhoodHeadlineSignup => '请完成社区信息认证';

  @override
  String onboardingResolvedNeighborhoodMessage(Object name) {
    return '您当前位于“$name”。';
  }

  @override
  String get onboardingNeighborhoodLabel => '社区';

  @override
  String get onboardingVerificationExpired => '验证已过期，请重新获取验证码。';

  @override
  String get onboardingBusinessVerificationExpired => '商家认证已过期，请重新认证。';

  @override
  String get homeSortRecommended => '推荐排序';

  @override
  String get homeSortPopular => '热门排序';

  @override
  String get homeSortLatest => '最新排序';

  @override
  String get homeSortClosingSoon => '即将截止排序';

  @override
  String get homeSortNearby => '距离最近排序';

  @override
  String get homeAudienceEveryone => '所有人';

  @override
  String get homeAudienceForeignerFriendly => '欢迎外国人';

  @override
  String get homeAudienceKoreanFriendly => '欢迎韩国人';

  @override
  String get homeAudienceTouristFriendly => '推荐游客参加';

  @override
  String get homeAudienceBeginnerFriendly => '欢迎新手';

  @override
  String get homeStatusRecruiting => '招募中';

  @override
  String get homeStatusClosingSoon => '即将截止（24小时内）';

  @override
  String get homeStatusNewlyListed => '新上线（24小时内）';

  @override
  String get homeDistanceLocal => '我的地区';

  @override
  String get homeDistanceWithin1km => '1公里内';

  @override
  String get homeDistanceWithin5km => '5公里内';

  @override
  String get homeDistanceWithin10km => '10公里内';

  @override
  String get homeSearchHeroHint => '随时随地';

  @override
  String get homeSearchHeroHelper => '在这里，任何人都能成为你的 Mate，MateYa';

  @override
  String get homeLoadError => '无法加载数据。';

  @override
  String get homeSelectAtLeastOneCategory => '请至少选择一个分类。';

  @override
  String get homeSelectAtLeastOneLanguage => '请至少选择一种语言。';

  @override
  String get homeUnsupportedExploreLanguageFilter => '探索语言筛选目前仅支持韩语、英语、中文和日语。';

  @override
  String get homeEndDateBeforeStartDateError => '结束日期不能早于开始日期。';

  @override
  String get homeMaxPriceLessThanMinPriceError => '最高金额必须大于或等于最低金额。';

  @override
  String get homeTrendingTitle => '热门飙升 🔥';

  @override
  String get homeSharedExperiencesTitle => '可以一起参与的体验';

  @override
  String get homeExploreSearchHint => '试着搜索名称或地点';

  @override
  String get homeExploreError => '无法加载结果。';

  @override
  String get homeFavoritesLoadError => '无法加载收藏列表。';

  @override
  String get homeFavoritesTitle => '收藏列表';

  @override
  String get homeCreateClass => '注册课程';

  @override
  String get homeCreateGroup => '创建聚会';

  @override
  String get homeEmptyTitle => '暂时还没有符合条件的活动。';

  @override
  String get homeEmptyDescription => '请调整搜索词或筛选条件后再试一次。';

  @override
  String get homeLoadMore => '加载更多';

  @override
  String homeLoadedAllActivities(int count) {
    return '已加载全部 $count 个活动。';
  }

  @override
  String get homeFilterTitle => '筛选';

  @override
  String get homeFilterSort => '排序';

  @override
  String get homeFilterCategory => '分类';

  @override
  String get homeFilterAudience => '参加对象';

  @override
  String get homeFilterLanguage => '语言';

  @override
  String get homeFilterRegion => '地区';

  @override
  String get homeFilterSchedule => '日程';

  @override
  String get homeFilterStartDate => '开始日期';

  @override
  String get homeFilterEndDate => '结束日期';

  @override
  String get homeFilterCost => '费用';

  @override
  String get homeFilterMinPrice => '最低金额';

  @override
  String get homeFilterMaxPrice => '最高金额';

  @override
  String get homeFilterStatus => '招募状态';

  @override
  String get homeFilterNear => '近';

  @override
  String get homeFilterFar => '远';

  @override
  String homeFilterDistanceFromActivityRegion(Object target) {
    return '以活动地区为基准：$target';
  }

  @override
  String homeFilterDistanceFromRegion(Object regionName, Object target) {
    return '以 $regionName 为基准：$target';
  }

  @override
  String get commonClose => '关闭';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonDelete => '删除';

  @override
  String get commonSeeAll => '查看全部';

  @override
  String get commonSeeDetails => '查看详情';

  @override
  String get commonNetworkRetry => '请检查网络连接后再试。';

  @override
  String get countryKorea => '韩国';

  @override
  String get countryJapan => '日本';

  @override
  String get countryChina => '中国';

  @override
  String get countryVietnam => '越南';

  @override
  String get countryUnitedStates => '美国';

  @override
  String get countryThailand => '泰国';

  @override
  String get activityCategoryTouristAttraction => '旅游景点';

  @override
  String get activityCategoryTravelCourse => '旅行路线';

  @override
  String get activityCategoryCultureTradition => '文化 / 传统';

  @override
  String get activityCategoryEventPerformanceFestival => '活动 / 演出 / 庆典';

  @override
  String get activityCategorySports => '体育';

  @override
  String get activityCategoryActivityLeports => '活动 / 休闲运动';

  @override
  String get activityCategoryShopping => '购物';

  @override
  String get activityCategoryPublicFacility => '公共设施';

  @override
  String get activityCategoryOther => '其他';

  @override
  String get reportSemanticsLabel => '举报';

  @override
  String get reportTitle => '举报';

  @override
  String get reportNoticeMessage => '如需附加举报图片，需要允许访问照片库。即使未授权，也可以继续填写举报内容。';

  @override
  String get reportRecoveryMessage => '如需附加举报图片，需要允许访问照片库。请重试，或在应用设置中允许权限。';

  @override
  String get reportFailureMessage => '无法加载图片。请检查权限和文件状态。';

  @override
  String get reportRestoreFallbackErrorMessage => '无法恢复你之前选择的举报图片，请重新选择。';

  @override
  String reportSubmittedMessage(Object subject) {
    return '已提交关于 $subject 的举报。';
  }

  @override
  String get reportBodyHint =>
      '请尽量详细填写举报原因。\n例如：辱骂、疑似诈骗、不当内容、\n垃圾信息、骚扰等。举报内容将根据运营政策进行审核。';

  @override
  String reportBodyCount(int count, int max) {
    return '$count/$max字';
  }

  @override
  String reportImageSectionTitle(int max) {
    return '图片（最多 $max 张）';
  }

  @override
  String get reportSubmitting => '提交中...';

  @override
  String get reportReviewNotice =>
      '举报提交后会立即发送给运营团队，并在最多 7 个工作日内完成审核。\n如举报内容不实或理由不明确，可能不予处理。';

  @override
  String reportRestoredCount(int restoredCount) {
    return '已恢复之前选择的 $restoredCount 张举报图片。';
  }

  @override
  String get mypageTitle => '我的页面';

  @override
  String get mypageLoadError => '无法加载我的页面。';

  @override
  String get mypageOtherProfileOpenHint => '正在加载个人资料。';

  @override
  String get mypageOtherProfileLoadError => '无法加载对方的个人资料。';

  @override
  String get mypageEditPrimaryPreferences => '编辑基本信息';

  @override
  String get mypageEditActivityRegion => '编辑活动地区';

  @override
  String get mypageConsentHistoryTitle => '同意记录';

  @override
  String get mypageOpenPrivacyPolicy => '隐私政策';

  @override
  String get mypageOpenCustomerSupport => '客服中心';

  @override
  String get mypageOpenBlockedUsers => '已屏蔽用户';

  @override
  String get mypageLogout => '退出登录';

  @override
  String get mypageOpenWithdrawal => '注销账号';

  @override
  String get mypageConsentHistoryDescription => '你可以查看使用 MateYa 时同意过的条款与政策。';

  @override
  String get mypageConsentHistoryEmpty => '还没有保存的同意记录。';

  @override
  String get mypageConsentVersion => '版本';

  @override
  String get mypageConsentStatus => '状态';

  @override
  String get mypageConsentAgreed => '已同意';

  @override
  String get mypageConsentDeclined => '未同意';

  @override
  String get mypageConsentDate => '同意时间';

  @override
  String get mypageBlockedUsersTitle => '已屏蔽用户';

  @override
  String get mypageBlockedUsersDescription =>
      '已屏蔽的用户会立即从你的页面中隐藏，你也可以在此列表中再次管理他们。';

  @override
  String get mypageBlockedUsersEmpty => '还没有屏蔽任何用户。';

  @override
  String get mypageRecentActivitiesTitle => '最近活动';

  @override
  String get mypageRecentActivitiesDescription => '查看你最近参与或创建的活动。';

  @override
  String get mypageActivitySummaryTitle => '活动摘要';

  @override
  String get mypageHostedCount => '发起';

  @override
  String get mypageJoinedCount => '参与';

  @override
  String get mypageReviewCount => '评价';

  @override
  String get mypageActiveMember => '活跃成员';

  @override
  String get mypageInactiveMember => '最近没有活动';

  @override
  String get mypageActiveWithin30Days => '30 天内活跃';

  @override
  String get mypageNoRecentActivity => '最近没有活动';

  @override
  String get mypageBadgeLabel => '徽章';

  @override
  String get mypageBadgesTitle => '我的徽章';

  @override
  String get mypageBadgesDescription => '根据你参与的活动分类，可以获得不同徽章。';

  @override
  String get mypageOtherBadgesTitle => '已获得的徽章';

  @override
  String get mypageOtherBadgesDescription => '这是该用户已获得的徽章。';

  @override
  String get mypageOtherBadgesEmpty => '该用户还没有公开徽章。';

  @override
  String get mypageRecentActivitiesSectionTitle => '活动记录';

  @override
  String get mypageActivityHistoryTitle => '活动记录';

  @override
  String get mypagePrimaryPreferencesTitle => '基本信息';

  @override
  String get mypagePrimaryPreferencesDescription => '可以修改你的语言和国籍信息。';

  @override
  String get mypageMyLanguage => '我的语言';

  @override
  String get mypageMyCountry => '我的国籍';

  @override
  String get mypageEnglishNameOptional => '英文名（可选）';

  @override
  String get mypageSaving => '保存中...';

  @override
  String get mypagePrimaryPreferencesSubmit => '保存';

  @override
  String get mypageUpdating => '更新中...';

  @override
  String get mypageBusinessIntroTitle => '简介';

  @override
  String get mypageBusinessIntroDescription => '请填写会显示在主办方页面上的一句话简介。';

  @override
  String get mypageBusinessIntroHint => '自然地介绍你提供的体验内容。';

  @override
  String get mypageSaveIntroduction => '保存简介';

  @override
  String get mypageActiveExperiencesTitle => '进行中的体验';

  @override
  String get mypageAddFriend => '添加好友';

  @override
  String get mypageRemoveFriend => '删除好友';

  @override
  String get mypageBlocked => '已屏蔽';

  @override
  String get mypageBlockUser => '屏蔽用户';

  @override
  String get mypageBlockUserHint => '该用户的活动和互动会立即从你的页面中隐藏。';

  @override
  String get mypageSelectLanguageAndCountry => '请选择语言和国家。';

  @override
  String get mypageInvalidLanguageOrCountry => '不支持该语言或国家。';

  @override
  String get mypagePrimaryPreferencesSaved => '基本信息已保存。';

  @override
  String get mypagePrimaryPreferencesSaveError => '无法保存基本信息，请稍后再试。';

  @override
  String get mypageFriendRemoved => '已删除好友。';

  @override
  String get mypageFriendAdded => '已添加为好友。';

  @override
  String get mypageFriendUpdateError => '无法更新好友状态，请稍后再试。';

  @override
  String get mypageBlockedUserAdded => '已屏蔽该用户。';

  @override
  String get mypageBlockUserError => '无法屏蔽该用户，请稍后再试。';

  @override
  String get mypageUnblockAction => '解除屏蔽';

  @override
  String get mypageUnblockedUser => '已解除屏蔽。';

  @override
  String get mypageUnblockUserError => '无法解除屏蔽，请稍后再试。';

  @override
  String get mypageBusinessIntroRequired => '请输入简介。';

  @override
  String get mypageBusinessIntroTooLong => '简介请控制在 300 字以内。';

  @override
  String get mypageBusinessIntroSaved => '简介已保存。';

  @override
  String get mypageBusinessIntroSaveError => '无法保存简介，请稍后再试。';

  @override
  String get mypageProfileImageSaved => '头像已保存。';

  @override
  String get mypageProfileImageSaveError => '无法保存头像，请稍后再试。';

  @override
  String get mypageProfileImageInvalidFormat => '仅支持上传 JPG、PNG、WEBP、GIF 格式图片。';

  @override
  String get mypageProfileImageUploadError => '无法上传头像，请稍后再试。';

  @override
  String get mypageProfileImageConfirmError => '头像上传确认失败，请稍后再试。';

  @override
  String get mypageActivityRegionSaved => '活动地区已保存。';

  @override
  String get mypageActivityRegionSaveError => '无法保存活动地区，请稍后再试。';

  @override
  String get mypageWithdrawalAgreementRequired => '申请注销前需要先同意相关内容。';

  @override
  String get mypageWithdrawalSignatureRequired => '请输入签名。';

  @override
  String get mypageWithdrawalSignatureMismatch => '输入的签名与会员姓名不一致。';

  @override
  String get mypageWithdrawalAgreementText => '我同意个人信息管理及 30 天后最终删除政策。';

  @override
  String get mypageWithdrawalSubmitted => '注销申请已提交。';

  @override
  String get mypageWithdrawalSubmitError => '无法处理注销申请，请稍后再试。';

  @override
  String get mypageLogoutError => '无法退出登录，请稍后再试。';

  @override
  String get mypageTermsDetailUnavailable => '无法加载条款详情。';

  @override
  String get mypageSupportLinkCopied => '已复制客服中心链接。';

  @override
  String get mypagePrivacyLinkCopied => '已复制隐私政策链接。';

  @override
  String get mypageCurrentLocationResolveError => '无法确认当前位置，请稍后再试。';

  @override
  String get mypageNeighborhoodRequired => '请输入活动地区。';

  @override
  String get mypageNeighborhoodLookupError => '无法确认你输入的地区，请重新检查。';

  @override
  String get mypageNeighborhoodVerificationRequired => '请选择已确认的活动地区。';

  @override
  String get mypageActivityRegionDialogDescription => '你可以使用当前位置，或手动输入来设置活动地区。';

  @override
  String get mypageResolvingCurrentLocation => '正在确认当前位置。';

  @override
  String get mypageResolvingNeighborhood => '正在确认你输入的地区。';

  @override
  String get mypageConfirmManualNeighborhood => '使用这个输入地区';

  @override
  String mypageSelectedActivityRegion(Object name) {
    return '已选择的活动地区：$name';
  }

  @override
  String get mypageSaveActivityRegion => '保存活动地区';

  @override
  String get mypageLocationServiceDisabledMessage =>
      '如需使用当前位置，请先开启设备定位服务。也可以通过手动输入继续。';

  @override
  String get mypageLocationPermissionDisabledMessage =>
      '如需使用当前位置，请在应用设置中允许定位权限。也可以通过手动输入继续。';

  @override
  String get mypageProfileImageNotice => '选择头像需要访问照片库权限。';

  @override
  String get mypageProfileImageRecovery => '请选择允许访问照片库后再试，也可以在应用设置中修改。';

  @override
  String get mypageProfileImageFailure => '无法加载头像，请检查文件状态。';

  @override
  String get mypageProfileImageRestoreFallback => '无法恢复你之前选择的头像，请重新选择。';

  @override
  String mypageProfileImageRestoredCount(int restoredCount) {
    return '已恢复之前选择的 $restoredCount 张头像图片。';
  }

  @override
  String get mypageWithdrawalTitle => '注销账号';

  @override
  String get mypageWithdrawalDescription =>
      '确定要继续注销账号吗？\n提交后，账号会立即停用。\n如果你在 30 天内重新注册或重新登录，注销将被取消。\n\n30 天后，除法律要求保留的信息外，会员资料和服务使用记录将被永久删除，且无法恢复。';

  @override
  String get mypageWithdrawalAgreementCheckbox => '我同意个人信息管理及 30 天后最终删除政策。';

  @override
  String get mypageWithdrawalSignatureLabel => '签名输入';

  @override
  String mypageWithdrawalSignatureHint(Object name) {
    return '输入 $name';
  }

  @override
  String get mypageWithdrawalSubmittedNotice => '注销申请已受理。在你重新登录之前，账号将被视为停用状态。';

  @override
  String get mypageWithdrawalRequest => '申请注销';

  @override
  String get mypageMetricActivities => '活动数';

  @override
  String get mypageMetricFriends => '好友数';

  @override
  String get mypageMetricReviews => '评价数';

  @override
  String get mypageMetricRecruitingExperiences => '招募中的体验';

  @override
  String get mypageMetricTotalParticipants => '累计参与者';

  @override
  String get mypageMetricAverageRating => '平均评分';

  @override
  String get mypageMetricReceivedReviews => '收到的评价';

  @override
  String get mypageActivityRegionUnset => '未设置活动地区';

  @override
  String mypageParticipantCount(int current, int capacity) {
    return '$current / $capacity人';
  }

  @override
  String get mypageConsentTypeServiceTerms => '服务使用条款';

  @override
  String get mypageConsentTypePrivacyCollection => '个人信息收集与使用同意';

  @override
  String get mypageConsentTypeLocationService => '基于位置服务使用同意';

  @override
  String get mypageConsentTypeAgeOver14 => '已满 14 周岁确认';

  @override
  String get mypageHostBadge => 'HOST';

  @override
  String get mypageEditActivityCta => '编辑活动';

  @override
  String get mypageBadgeTraditional => '传统达人';

  @override
  String get mypageBadgeActivePerson => '活力伙伴';

  @override
  String get mypageBadgeFestive => '庆典爱好者';

  @override
  String get mypageBadgeTourist => '本地探索家';

  @override
  String get mypageBadgeRequirementTraditional => '请至少参加 1 次传统文化分类体验。';

  @override
  String get mypageBadgeRequirementActivePerson => '请至少参加 1 次体育或休闲活动分类体验。';

  @override
  String get mypageBadgeRequirementFestive => '请至少参加 1 次活动/演出/庆典分类体验。';

  @override
  String get mypageBadgeRequirementTourist => '请至少参加 1 次景点或旅行路线分类体验。';

  @override
  String get mypageBadgeUnlockedTitle => '获得了新徽章';

  @override
  String mypageBadgeUnlockedDescription(Object category) {
    return '已记录你参与 $category 活动的经历。';
  }

  @override
  String get galleryPermissionNoticeTitle => '照片权限说明';

  @override
  String get galleryPermissionSelectPhoto => '选择照片';

  @override
  String get galleryPermissionRecoveryTitle => '需要照片访问权限';

  @override
  String get authLoginRequired => '需要先登录。';

  @override
  String get commonRequestError => '处理请求时发生错误。';

  @override
  String get chatJustNow => '刚刚';

  @override
  String chatMinutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String chatHoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String get chatYesterday => '昨天';

  @override
  String get chatLastYear => '去年';

  @override
  String chatPhotoCount(int count) {
    return '$count张照片';
  }

  @override
  String get chatViewOriginal => '查看原文';

  @override
  String get chatViewTranslation => '查看翻译';

  @override
  String chatParticipantCount(int count) {
    return '$count人参与';
  }

  @override
  String get chatFilterGroup => '群聊';

  @override
  String get chatFilterDirect => '私聊';

  @override
  String get chatListGuidance => '参加活动后，会自动加入群聊。\n与好友的私聊会自动创建。\n无法与非好友用户聊天。';

  @override
  String get chatComposerHint => '请输入消息';

  @override
  String get reportReasonRequired => '请输入举报原因。';

  @override
  String get reportImageInvalidFormat => '举报图片仅支持 JPG、PNG、WEBP、GIF 格式。';

  @override
  String get reportImageUploadError => '无法上传举报图片，请稍后再试。';

  @override
  String get reportImageConfirmError => '举报图片上传确认失败，请稍后再试。';

  @override
  String get createGroupFlowTitle => '创建小组';

  @override
  String get createClassFlowTitle => '创建课程';

  @override
  String get createEntityGroup => '小组';

  @override
  String get createEntityClass => '课程';

  @override
  String get createGroupSubmit => '创建小组';

  @override
  String get createClassSubmit => '创建课程';

  @override
  String get createGroupEditTitle => '编辑小组';

  @override
  String get createClassEditTitle => '编辑课程';

  @override
  String get createGroupUpdateSubmit => '保存小组修改';

  @override
  String get createClassUpdateSubmit => '保存课程修改';

  @override
  String get createPaidLabel => '收费';

  @override
  String createEditCompleted(Object entity) {
    return '$entity已更新。';
  }

  @override
  String createSubmitCompleted(Object entity) {
    return '$entity已创建。';
  }

  @override
  String createChatProvisionFailed(Object entity) {
    return '$entity已创建，但暂时无法准备聊天室。请稍后再试。';
  }

  @override
  String createSubmitFailedNetwork(Object entity) {
    return '无法创建$entity。请检查网络后重试。';
  }

  @override
  String createSubmitFailedServer(Object entity) {
    return '无法创建$entity。请稍后再试。';
  }

  @override
  String get createDeleteFailedNetwork => '无法删除。请检查网络后重试。';

  @override
  String get createDeleteFailedServer => '无法删除。请稍后再试。';

  @override
  String createLoadEditFailedNetwork(Object entity) {
    return '无法加载要编辑的$entity信息。请检查网络后重试。';
  }

  @override
  String createLoadEditFailedServer(Object entity) {
    return '无法加载要编辑的$entity信息。请稍后再试。';
  }

  @override
  String get createValidationSelectCategory => '请选择至少一个分类。';

  @override
  String get createValidationSelectClassCategoryFirst => '请先选择适合课程的分类。';

  @override
  String get createValidationSelectPlaceOrManual => '请选择地点或手动输入地点。';

  @override
  String get createValidationSelectPlace => '请选择地点。';

  @override
  String createValidationEnterEntityName(Object entity) {
    return '请输入$entity名称。';
  }

  @override
  String get createValidationTitleMaxLength => '名称不能超过 40 个字符。';

  @override
  String get createValidationDescriptionMaxLength => '说明不能超过 1000 个字符。';

  @override
  String get createValidationSelectDate => '请选择日期。';

  @override
  String get createValidationNoPastDate => '不能选择过去的日期。';

  @override
  String get createValidationSelectStartEndTime => '请选择开始时间和结束时间。';

  @override
  String get createValidationEndAfterStart => '结束时间必须晚于开始时间。';

  @override
  String get createValidationCapacityRange => '参与人数必须在 2 到 20 人之间。';

  @override
  String get createValidationSelectDeadline => '请选择报名截止日期和时间。';

  @override
  String get createValidationSelectDeadlineTogether => '请同时选择报名截止日期和时间。';

  @override
  String get createValidationDeadlineFuture => '报名截止时间必须晚于当前时间。';

  @override
  String get createValidationDeadlineBeforeStart => '报名截止时间必须早于开始时间。';

  @override
  String get createValidationSelectLanguage => '请至少选择一种语言。';

  @override
  String get createValidationSelectPriceType => '请选择价格类型。';

  @override
  String get createValidationEnterPaidPrice => '如果是收费活动，请输入金额。';

  @override
  String get createValidationPriceRange => '金额请输入 1 韩元到 1000000 韩元之间。';

  @override
  String get createValidationRegisterImage => '请至少上传一张封面图。';

  @override
  String get createGroupInfoTitle => '请输入小组信息';

  @override
  String get createClassInfoTitle => '请输入课程信息';

  @override
  String get createValidationIntro => '填写下方必填信息后即可立即发布。';

  @override
  String get createSelectedCategoryTitle => '已选分类';

  @override
  String get createSelectedPlaceTitle => '已选地点';

  @override
  String get createGroupNameLabel => '小组名称';

  @override
  String get createClassNameLabel => '课程名称';

  @override
  String get createGroupNameHint => '例如：一起逛北村韩屋';

  @override
  String get createClassNameHint => '例如：传统茶一日体验课';

  @override
  String get createDescriptionTitle => '详细说明';

  @override
  String get createDescriptionHint => '请填写流程、准备物品，以及参与者需要了解的内容。';

  @override
  String get createDateTimeTitle => '日程';

  @override
  String get createDateLabel => '活动日期';

  @override
  String get createDatePlaceholder => '请选择日期';

  @override
  String get createStartTimeLabel => '开始时间';

  @override
  String get createStartTimePlaceholder => '请选择开始时间';

  @override
  String get createEndTimeLabel => '结束时间';

  @override
  String get createEndTimePlaceholder => '请选择结束时间';

  @override
  String get createCapacityTitle => '参与人数';

  @override
  String createCapacityValue(int count) {
    return '$count人';
  }

  @override
  String get createCapacityHelper => '最少 2 人，最多 20 人';

  @override
  String get createDeadlineTitle => '报名截止';

  @override
  String get createDeadlineDateLabel => '截止日期';

  @override
  String get createDeadlineTimeLabel => '截止时间';

  @override
  String get createNotSelected => '未选择';

  @override
  String get createLanguagesTitle => '使用语言';

  @override
  String get createPriceTitle => '参加费用';

  @override
  String get createPaidPriceHint => '请输入参加费用';

  @override
  String get createAudienceTitle => '推荐对象';

  @override
  String get createPrimaryImageTitle => '封面图片';

  @override
  String get createPrimaryImageRequiredHint => '请至少上传一张封面图。';

  @override
  String get createPrimaryImageSelectionHint => '第一张图片会设为封面，点击其他图片可更换封面。';

  @override
  String get createPrimaryImageBadge => '封面';

  @override
  String get createDeleting => '删除中...';

  @override
  String createDeleteAction(Object entity) {
    return '删除$entity';
  }

  @override
  String get createPlaceGroupTitle => '请选择小组地点';

  @override
  String get createPlaceClassTitle => '请选择课程地点';

  @override
  String get createPlaceGroupDescription => '可以选择推荐地点，或手动输入小组地点。';

  @override
  String get createPlaceClassDescription => '可以搜索符合分类的地点，或手动输入课程地点。';

  @override
  String get createClassCategoryTitle => '课程分类';

  @override
  String get createCategoryDetailTitle => '细分类别';

  @override
  String get createManualPlaceTitle => '手动输入';

  @override
  String get createManualPlaceNameHint => '请输入地点名称';

  @override
  String get createManualPlaceAddressHint => '请输入地址';

  @override
  String get createOrSearchTitle => '或搜索地点';

  @override
  String get createPlaceSearchHint => '按地点名称搜索';

  @override
  String get createManualPlacePreviewDescription => '将使用您手动输入的地点信息发布。';

  @override
  String get createSearchResultsTitle => '搜索结果';

  @override
  String get createSearchEmptyTitle => '没有搜索结果';

  @override
  String get createSearchEmptyBody => '请尝试使用其他关键词搜索。';

  @override
  String get createSearchInitialTitle => '请搜索地点';

  @override
  String get createSearchInitialBody => '输入地点名称或地址后，将显示可供选择的结果。';

  @override
  String get createRecommendedTitle => '推荐地点';

  @override
  String get createRefresh => '刷新';

  @override
  String get createRecommendedEmptyTitle => '暂无推荐地点';

  @override
  String get createRecommendedEmptyBody => '请更换分类或手动搜索。';

  @override
  String get createMapPlaceholder => '选择地点后，这里会显示其位置。';

  @override
  String get createCategoryPromptTitle => '你想创建什么样的体验？';

  @override
  String get createCategoryPromptDescription => '请选择最符合你要发布的小组或课程的分类。';

  @override
  String get createCompletedEditDescription => '修改内容已保存，并会立即展示给参与者。';

  @override
  String get createCompletedCreateDescription => '现在大家已经可以在 MateYa 中发现它了。';

  @override
  String get createBackToPrevious => '返回';

  @override
  String get createBackToHome => '返回首页';

  @override
  String get createStepCategory => '分类';

  @override
  String get createStepPlaceGroup => '地点';

  @override
  String get createStepPlaceClass => '地点';

  @override
  String get createStepDetailsGroup => '填写信息';

  @override
  String get createStepDetailsClass => '填写信息';

  @override
  String get createCompletedProgress => '完成';

  @override
  String get createCategoryTitleCultureTradition => '文化 / 传统';

  @override
  String get createCategoryTitleEventPerformanceFestival => '活动 / 演出 / 庆典';

  @override
  String get createCategoryTitleActivityLeports => '活动 / 休闲运动';

  @override
  String get createCategoryDescriptionTourist => '适合围绕代表性景点展开的聚会。';

  @override
  String get createCategoryDescriptionTravelCourse => '适合包含移动路线的旅行型行程。';

  @override
  String get createCategoryDescriptionCultureTradition =>
      '推荐用于传统文化、手工艺、历史体验活动。';

  @override
  String get createCategoryDescriptionFestival => '适合演出、庆典和季节性活动。';

  @override
  String get createCategoryDescriptionSports => '适合运动、观赛以及体育主题聚会。';

  @override
  String get createCategoryDescriptionActivityLeports => '适合户外体验和更活跃的休闲运动活动。';

  @override
  String get createCategoryDescriptionPublicFacility => '推荐用于展览、公共空间和社区活动。';

  @override
  String get createCategoryDescriptionShopping => '很适合市场、购物街和本地店铺巡游。';

  @override
  String createEventDatePickerHelp(Object entity) {
    return '选择$entity日期';
  }

  @override
  String get createStartTimePickerHelp => '选择开始时间';

  @override
  String get createEndTimePickerHelp => '选择结束时间';

  @override
  String get createDeadlineDatePickerHelp => '选择报名截止日期';

  @override
  String get createDeadlineTimePickerHelp => '选择报名截止时间';

  @override
  String createDeleteDialogTitle(Object entity) {
    return '要删除这个$entity吗？';
  }

  @override
  String createDeleteDialogBody(Object entity) {
    return '删除后将无法恢复。';
  }

  @override
  String get createDeleteButton => '删除';

  @override
  String get createDeleteCompleted => '已删除。';

  @override
  String createInitializationLoadError(Object entity) {
    return '无法加载$entity信息。';
  }

  @override
  String get createInitializationRetryBody => '请稍后重试。如果问题持续存在，请返回上一页后重新进入。';

  @override
  String createSavingEntity(Object entity) {
    return '正在保存$entity...';
  }

  @override
  String createSubmittingEntity(Object entity) {
    return '正在创建$entity...';
  }

  @override
  String get createSelectPlaceAction => '选择地点';

  @override
  String get createImagePickerNotice => '要附加图片，需要允许访问照片库。即使不授予权限，也可以继续填写其他信息。';

  @override
  String get createImagePickerRecovery => '要继续附加图片，需要允许访问照片库。请重试，或在应用设置中开启权限。';

  @override
  String get createImagePickerFailure => '无法加载所选图片。请检查文件后重试。';

  @override
  String get createImagePickerRestoreFallback => '无法恢复之前选择的图片，请重新选择。';

  @override
  String createImagePickerRestoredCount(int count) {
    return '已恢复之前选择的 $count 张图片。';
  }

  @override
  String get createRecommendedLoadFailedNetwork => '无法加载推荐地点。请检查网络后重试。';

  @override
  String get createRecommendedLoadFailedServer => '无法加载推荐地点。请稍后再试。';

  @override
  String get createPlaceSearchQueryRequired => '请输入地点名称。';

  @override
  String get createPlaceSearchFailedNetwork => '地点搜索失败。请检查网络后重试。';

  @override
  String get createPlaceSearchFailedServer => '地点搜索失败。请稍后再试。';

  @override
  String get createPlaceCoordinateRequired => '该地点没有位置信息，无法选择。';

  @override
  String get createPlaceMapCoordinateRequired => '该地点没有位置信息，无法显示在地图上。';

  @override
  String createImageLimitExceeded(int max) {
    return '最多可添加 $max 张图片。';
  }

  @override
  String get createImageInvalidFormat => '仅支持添加 JPG、PNG、WEBP、GIF 格式的图片。';

  @override
  String get createImageMaxSize => '每张图片最大可为 10MB。';

  @override
  String get createPlaceDescriptionFallback => '请确认位置后再选择。';

  @override
  String get createExistingPlaceDescription => '现有活动地点';

  @override
  String get createResolveServerCategoryFailed => '无法根据所选地点确定服务器分类。请选择其他地点。';

  @override
  String get createUploadImageRequired => '请至少上传一张封面图。';

  @override
  String get createUploadImageInvalidFormat => '仅支持上传 JPG、PNG、WEBP、GIF 格式的图片。';

  @override
  String get createUploadImageFailed => '图片上传失败。请稍后再试。';

  @override
  String get createUploadImageConfirmFailed => '无法确认已上传的图片。请稍后再试。';

  @override
  String get onboardingValidationNameRequired => '请输入姓名。';

  @override
  String get onboardingValidationNameMaxLength => '姓名不能超过 30 个字符。';

  @override
  String get onboardingValidationNameCharacters => '请输入姓名本身，不要包含数字或特殊字符。';

  @override
  String get onboardingValidationPhoneRequired => '请输入电话号码。';

  @override
  String get onboardingValidationPhoneDigitsOnly => '电话号码只能输入数字。';

  @override
  String get onboardingValidationPhoneMaxLength => '电话号码最多可输入 15 位。';

  @override
  String get onboardingValidationPhoneInvalid => '请输入正确的电话号码。';

  @override
  String get onboardingValidationVerificationCodeRequired => '请输入 6 位验证码。';

  @override
  String get onboardingValidationVerificationExpired => '验证码已过期，请重新获取。';

  @override
  String get onboardingValidationVerificationMismatch => '验证码不匹配。';

  @override
  String get onboardingValidationBusinessNameRequired => '请输入商号名称。';

  @override
  String get onboardingValidationOpeningDateRequired => '请输入 8 位开业日期。';

  @override
  String get onboardingValidationOpeningDateDigitsOnly => '开业日期只能输入数字。';

  @override
  String get onboardingValidationOpeningDateInvalid => '请输入正确的开业日期。';

  @override
  String get onboardingValidationBusinessNumberRequired => '请输入正确的 10 位营业执照号码。';

  @override
  String get onboardingValidationBusinessNumberDigitsOnly => '营业执照号码只能输入数字。';

  @override
  String get onboardingLocationErrorServiceDisabled => '定位服务已关闭。请使用手动输入继续。';

  @override
  String get onboardingLocationErrorPermissionDenied =>
      '没有定位权限时，无法使用当前位置自动认证。你仍然可以通过手动输入继续，并在授权后重新尝试。';

  @override
  String get onboardingLocationErrorPermissionPermanentlyDenied =>
      '定位权限已关闭，无法使用当前位置自动认证。请在应用设置中允许权限，或使用手动输入继续。';

  @override
  String get onboardingLocationErrorAccuracyLow => '定位精度过低，难以进行自动认证。';

  @override
  String get onboardingLocationErrorAddressNotFound => '未找到地址。请使用手动输入继续。';

  @override
  String get onboardingLocationErrorUnknown => '无法获取位置信息。请使用手动输入继续。';

  @override
  String get onboardingLocationQueryRequired => '请输入所在地区名称。';

  @override
  String get onboardingLocationQueryNotFound => '未找到你输入的地区。';

  @override
  String get onboardingLocationCurrentFallback => '当前位置';

  @override
  String homeParticipantCount(int current, int capacity) {
    return '$current/$capacity 参与';
  }

  @override
  String get homeFavoritesSubtitle => '把你的兴趣分享给世界。';

  @override
  String get homeFavoritesEmptyTitle => '你还没有收藏任何活动。';

  @override
  String get homeFavoritesEmptyDescription => '收藏你喜欢的活动后，就可以在这里再次查看。';

  @override
  String get homeNearbyCultureMap => '附近的传统文化';

  @override
  String get onboardingTermsPendingEffectiveDate => '确认中';

  @override
  String get onboardingTermsServiceTitle => '服务使用条款';

  @override
  String get onboardingTermsServiceSummary =>
      '说明使用 MateYa 服务的基本条件、用户责任以及服务运营标准。';

  @override
  String get onboardingTermsServiceSection1Title => '服务目的';

  @override
  String get onboardingTermsServiceSection1Body =>
      'MateYa 是一个帮助本地用户和国际用户安全地发现并参与小组、课程和基于地区活动的平台。';

  @override
  String get onboardingTermsServiceSection2Title => '注册与账号管理';

  @override
  String get onboardingTermsServiceSection2Body =>
      '会员必须使用本人名义的信息注册，并完成手机验证和条款同意后方可使用服务。账号信息发生变化时，应及时保持最新状态。';

  @override
  String get onboardingTermsServiceSection3Title => '服务使用条件';

  @override
  String get onboardingTermsServiceSection3Body =>
      '会员必须遵守相关法律法规和本条款，不得侵犯他人权利或妨碍服务运营。部分功能可能需要身份确认或额外认证。';

  @override
  String get onboardingTermsServiceSection4Title => '禁止行为';

  @override
  String get onboardingTermsServiceSection4Body =>
      '禁止注册虚假信息、冒充他人、违法宣传、发布淫秽或仇恨内容、异常自动化访问或试图绕过运营政策。违反时，可能会采取删除内容、限制使用或暂停账号等措施。';

  @override
  String get onboardingTermsServiceSection5Title => '服务中断与变更';

  @override
  String get onboardingTermsServiceSection5Body =>
      'MateYa 可能因维护、故障应对、政策调整或外部合作因素，对部分服务进行变更或暂时中断。重要变更将通过应用内公告或其他适当方式通知。';

  @override
  String get onboardingTermsServiceSection6Title => '责任限制';

  @override
  String get onboardingTermsServiceSection6Body =>
      '对于因不可抗力、通信故障或用户自身原因造成的损失，MateYa 可在法律允许范围内限制责任。但公司存在故意或重大过失的情况除外。';

  @override
  String get onboardingTermsServiceSection7Title => '联系方式';

  @override
  String get onboardingTermsServiceSection7Body =>
      '如在使用服务过程中需要咨询，可通过应用内客服渠道或运营团队邮箱提交。提交内容将根据运营政策依次处理。';

  @override
  String get onboardingTermsPrivacyTitle => '同意向第三方提供个人信息';

  @override
  String get onboardingTermsPrivacySummary =>
      '说明在活动运营、预约进行和客户应对所需范围内，向第三方提供个人信息的标准。';

  @override
  String get onboardingTermsPrivacySection1Title => '接收方';

  @override
  String get onboardingTermsPrivacySection1Body =>
      '在 MateYa 内运营小组/课程的主持人，或服务运营所需的合作商户';

  @override
  String get onboardingTermsPrivacySection2Title => '提供目的';

  @override
  String get onboardingTermsPrivacySection2Body =>
      '确认报名申请、与主持人顺利协调日程、支持现场运营、处理客户咨询及纠纷';

  @override
  String get onboardingTermsPrivacySection3Title => '提供项目';

  @override
  String get onboardingTermsPrivacySection3Body =>
      '姓名、手机号、活动报名信息、主要语言以及提供服务所需的最少参与记录';

  @override
  String get onboardingTermsPrivacySection4Title => '保存与使用期限';

  @override
  String get onboardingTermsPrivacySection4Body =>
      '信息将保存至提供目的达成时，或法律规定的保存义务期限届满时，之后会及时删除或匿名化。';

  @override
  String get onboardingTermsPrivacySection5Title => '拒绝同意的权利及不利影响';

  @override
  String get onboardingTermsPrivacySection5Body =>
      '会员可以拒绝同意向第三方提供个人信息。但部分需要活动参与、预约确认或与主持人联系的服务可能会受到限制。';

  @override
  String get onboardingTermsLocationTitle => '基于位置服务使用条款';

  @override
  String get onboardingTermsLocationSummary =>
      '说明如何利用当前位置和活动地区信息提供附近小组与推荐结果，以及相关的保护标准。';

  @override
  String get onboardingTermsLocationSection1Title => '目的';

  @override
  String get onboardingTermsLocationSection1Body =>
      '本条款旨在说明 MateYa 提供的基于位置服务的使用条件与流程、公司和用户的权利义务，以及位置信息保护标准。';

  @override
  String get onboardingTermsLocationSection2Title => '位置信息的收集与使用';

  @override
  String get onboardingTermsLocationSection2Body =>
      '公司会在用户请求的功能范围内使用当前位置或活动地区信息，并且仅限于以下目的。';

  @override
  String get onboardingTermsLocationSection2Point1 => '地区认证和活动地区确认';

  @override
  String get onboardingTermsLocationSection2Point2 => '附近小组推荐及按距离排序';

  @override
  String get onboardingTermsLocationSection2Point3 => '提供符合地区的内容和更安全的参与体验';

  @override
  String get onboardingTermsLocationSection3Title => '保存与使用期限';

  @override
  String get onboardingTermsLocationSection3Body =>
      '实时位置信息在即时性功能处理完成后不会保存。但活动地区认证结果等服务运营所需的最少信息，可根据相关法律或内部运营标准保存必要期限，之后会及时删除或匿名化。';

  @override
  String get onboardingTermsLocationSection4Title => '用户权利';

  @override
  String get onboardingTermsLocationSection4Body =>
      '用户可随时通过设备设置或应用内权限设置撤回提供位置信息的同意，并可自行选择是否使用基于位置的服务。撤回同意后，部分推荐功能或地区认证功能可能会受到限制。';

  @override
  String get onboardingTermsLocationSection5Title => '公司的义务';

  @override
  String get onboardingTermsLocationSection5Body =>
      '公司会依据相关法律和内部安全标准安全管理位置信息，不会超出使用目的范围使用，也不会在未获得单独同意的情况下向第三方提供。同时，公司会及时确认用户咨询和投诉，并提供必要的说明。';

  @override
  String get onboardingTermsLocationSection6Title => '联系方式';

  @override
  String get onboardingTermsLocationSection6Body =>
      '有关基于位置服务的咨询，可通过应用内客服渠道或运营团队咨询窗口提交。提交内容将根据内部政策依次处理。';

  @override
  String get onboardingTermsAgeTitle => '确认已满 14 周岁';

  @override
  String get onboardingTermsAgeSummary =>
      'MateYa 仅允许年满 14 周岁的用户注册，本条说明与年龄确认相关的使用限制标准。';

  @override
  String get onboardingTermsAgeSection1Title => '年龄确认';

  @override
  String get onboardingTermsAgeSection1Body => '会员在注册时必须确认并同意自己已满 14 周岁。';

  @override
  String get onboardingTermsAgeSection2Title => '注册限制';

  @override
  String get onboardingTermsAgeSection2Body => '未满 14 周岁的用户不得注册 MateYa 或使用服务。';

  @override
  String get onboardingTermsAgeSection3Title => '虚假确认的处理';

  @override
  String get onboardingTermsAgeSection3Body =>
      '如确认存在虚假年龄确认后注册的情况，可能会限制服务使用、终止账号，或要求进行额外确认程序。';

  @override
  String get chatAttachmentRecoveryFailed => '无法恢复刚才选择的照片，请重新选择。';

  @override
  String get chatAttachmentSheetTitle => '添加照片';

  @override
  String get chatAttachmentSheetDescription => '你可以从相册选择多张照片，或直接用相机拍摄后发送。';

  @override
  String get chatAttachmentGalleryTitle => '从相册选择';

  @override
  String get chatAttachmentGallerySubtitle => '可一次选择多张照片。';

  @override
  String get chatAttachmentCameraTitle => '拍摄照片';

  @override
  String get chatAttachmentCameraSubtitle => '立即拍摄 1 张照片并附加。';

  @override
  String get chatAttachmentGuideFormats =>
      '支持格式: JPG, PNG, WEBP, GIF, HEIC, HEIF';

  @override
  String get chatAttachmentGuideMaxSize => '最大大小: 10MB';

  @override
  String chatAttachmentGuideMaxCount(int count) {
    return '每条消息最多 $count 张';
  }

  @override
  String get chatAttachmentPhotoPermissionTitle => '照片权限提示';

  @override
  String get chatAttachmentCameraPermissionTitle => '相机权限提示';

  @override
  String get chatAttachmentPhotoPermissionMessage =>
      '在聊天中附加照片需要访问照片库。即使拒绝权限，你仍可继续使用文字聊天。';

  @override
  String get chatAttachmentCameraPermissionMessage =>
      '在聊天中拍照并发送需要相机权限。即使拒绝权限，你仍可继续使用文字聊天。';

  @override
  String get chatAttachmentPhotoSelect => '选择照片';

  @override
  String get chatAttachmentOpenCamera => '打开相机';

  @override
  String get chatAttachmentPhotoRecoveryTitle => '需要照片访问权限';

  @override
  String get chatAttachmentCameraRecoveryTitle => '需要相机权限';

  @override
  String get chatAttachmentPhotoRecoveryMessage =>
      '附加照片需要访问照片库。即使没有权限，你仍可继续文字聊天，并可重试或在应用设置中允许权限。';

  @override
  String get chatAttachmentCameraRecoveryMessage =>
      '附加聊天拍摄的照片需要相机权限。即使没有权限，你仍可继续文字聊天，并可重试或在应用设置中允许权限。';

  @override
  String get chatAttachmentLoadFailed => '无法加载照片。请检查权限和文件状态。';

  @override
  String chatAttachmentAddedCount(int count) {
    return '已附加 $count 张照片。';
  }

  @override
  String chatAttachmentRejectedTypeCount(int count) {
    return '已排除 $count 张不支持格式的照片。';
  }

  @override
  String chatAttachmentRejectedSizeCount(int count) {
    return '已排除 $count 张超过 10MB 的照片。';
  }

  @override
  String chatAttachmentOverflowCount(int count) {
    return '最多可附加 $count 张照片。';
  }

  @override
  String get chatAttachmentPhotoOnly => '照片';

  @override
  String get chatAttachmentInvalidFormat =>
      '仅支持发送 JPG、PNG、WEBP、GIF、HEIC、HEIF 格式的图片。';

  @override
  String get chatAttachmentUploadFailed => '无法上传聊天图片，请稍后再试。';

  @override
  String get chatListLoadError => '无法加载聊天列表。';

  @override
  String get chatListEmptyTitle => '没有可显示的聊天室。';

  @override
  String get chatListEmptyBody => '请尝试更改筛选条件或开始新的对话。';

  @override
  String get chatListLoadMoreHint => '滚动以加载更多聊天室。';

  @override
  String get chatListLoadMoreFailedNetwork => '无法加载更多聊天室。请检查网络连接。';

  @override
  String get chatListLoadMoreFailedServer => '无法加载更多聊天室。请稍后再试。';

  @override
  String get chatRoomMissing => '找不到聊天室信息。';

  @override
  String get chatBackToList => '返回列表';

  @override
  String get chatRoomLoadError => '无法加载聊天室。';

  @override
  String get chatOlderMessagesHint => '向上滚动以加载更早的消息。';

  @override
  String get chatOlderMessagesFailedNetwork => '无法加载更早的消息。请检查网络连接。';

  @override
  String get chatOlderMessagesFailedServer => '无法加载更早的消息。请稍后再试。';

  @override
  String get chatReadSyncFailed => '无法将已读状态同步到服务器，稍后会再次尝试。';

  @override
  String get chatSendFailedNetwork => '无法发送消息。请检查网络连接。';

  @override
  String get chatSendFailedServer => '无法发送消息。请稍后再试。';

  @override
  String get chatMe => '我';

  @override
  String get chatDefaultDirectRoomTitle => '一对一聊天';

  @override
  String get chatDefaultGroupRoomTitle => '聊天室';

  @override
  String get chatRealtimeConnectionError => '无法连接实时聊天。';

  @override
  String get chatRealtimeMessageError => '无法处理实时聊天消息。';

  @override
  String get homeActivityRegionFallback => '活动地区';

  @override
  String get homeNearbyMapLoadError => '无法加载地图上的地点。';

  @override
  String get homeNearbyMapCurrentLocationLabel => '基于当前位置';

  @override
  String get homeNearbyMapSearchHint => '你想找什么？';

  @override
  String get homeNearbyMapEmptyTitle => '未找到附近地点';

  @override
  String get homeNearbyMapEmptyBody => '请尝试更换关键词，或重新获取当前位置。';

  @override
  String get homeNearbyMapListTitle => '附近地点列表';

  @override
  String homeNearbyMapPlaceCount(int count) {
    return '$count处';
  }

  @override
  String get homeNearbyMapListButton => '查看列表';

  @override
  String get homeNearbyMapBadgeFallback => '附近地点';

  @override
  String get homeNearbyMapParseError => '无法解析地点数据。';

  @override
  String get homeNearbyMapLocationLoadError => '无法获取当前位置。';

  @override
  String get homeNearbyMapLocationRefreshError => '无法重新获取当前位置。';

  @override
  String get homeNearbyMapLocationRequired => '查看地图前请先确认位置信息。';

  @override
  String get homeNearbyMapPlacesLoadError => '无法加载地点，请稍后再试。';

  @override
  String get detailsActivityRequired => '请先加载活动详情。';

  @override
  String get detailsFavoriteToggleError => '无法更改收藏状态，请稍后再试。';

  @override
  String get detailsJoinAlreadyRequested => '你已经申请参加这个活动了。';

  @override
  String get detailsJoinAlreadyJoined => '你已经在参加这个活动了。';

  @override
  String get detailsJoinHostedByMe => '这是你创建的活动。';

  @override
  String get detailsJoinRequestError => '无法完成参加申请，请稍后再试。';

  @override
  String get detailsParticipantRemoveError => '无法移除参与者，请稍后再试。';

  @override
  String get detailsPendingCancelError => '无法取消申请，请稍后再试。';

  @override
  String get detailsPendingApproveError => '无法批准参加申请，请稍后再试。';

  @override
  String get detailsReviewRequired => '请先加载评价详情。';

  @override
  String get detailsHelpfulToggleError => '无法更改“有帮助”状态，请稍后再试。';

  @override
  String get detailsReviewValidationRequired => '请输入评分和评价内容。';

  @override
  String get detailsReviewSubmitError => '无法发布评价，请稍后再试。';

  @override
  String get detailsReviewUpdateError => '无法更新评价，请稍后再试。';

  @override
  String get detailsReviewDeleteError => '无法删除评价，请稍后再试。';

  @override
  String get detailsLoadError => '无法加载活动详情，请稍后再试。';

  @override
  String get detailsReviewSortLatest => '最新';

  @override
  String get detailsReviewSortOldest => '最早';

  @override
  String get detailsReviewSortHighestRating => '评分从高到低';

  @override
  String get detailsReviewSortLowestRating => '评分从低到高';

  @override
  String get detailsJoinAvailable => '参加活动';

  @override
  String get detailsJoinRequested => '已申请';

  @override
  String get detailsJoinJoined => '已参加';

  @override
  String get detailsJoinHost => '我的活动';

  @override
  String detailsReviewSummary(Object average, int count) {
    return '$average（$count条评价）';
  }

  @override
  String detailsParticipantSummary(int current, int capacity) {
    return '$current/$capacity 人参与';
  }

  @override
  String detailsParticipantsJoined(int count) {
    return '$count 人已参与';
  }

  @override
  String detailsParticipantsRemaining(int count) {
    return '还剩 $count 个名额';
  }

  @override
  String get detailsRecruitmentClosed => '报名结束';

  @override
  String get detailsIntroduction => '活动介绍';

  @override
  String detailsReviewsTitle(int count) {
    return '$count 条评价';
  }

  @override
  String get detailsReviewsEmpty => '还没有评价，来留下第一条吧。';

  @override
  String get detailsPriceLabel => '体验费用';

  @override
  String get detailsJoinRequesting => '申请中...';

  @override
  String detailsReviewRatingSummary(int count) {
    return '共 $count 条评价';
  }

  @override
  String detailsReviewRating(int rating) {
    return '$rating 分';
  }

  @override
  String detailsReviewHelpfulCount(int count) {
    return '对 $count 人有帮助';
  }

  @override
  String get detailsReviewViewOriginal => '查看原文';

  @override
  String get detailsReviewViewTranslation => '查看翻译';

  @override
  String get detailsRepresentativeImage => '封面';

  @override
  String get detailsReviewGalleryNotice =>
      '要在评价中添加图片，需要访问你的照片库。即使不授权，你仍然可以继续填写文字评价和评分。';

  @override
  String get detailsReviewGalleryRecovery =>
      '要添加评价图片，需要访问你的照片库。即使没有权限，你仍然可以继续提交文字评价和评分，也可以稍后重试或前往应用设置开启权限。';

  @override
  String get detailsReviewGalleryFailure => '无法加载图片，请检查权限和文件状态。';

  @override
  String get detailsReviewGalleryRestoreError => '无法恢复你之前选择的评价图片，请重新选择。';

  @override
  String detailsReviewRestoredCount(int restoredCount) {
    return '已恢复你之前选择的 $restoredCount 张评价图片。';
  }

  @override
  String get detailsReviewSubmitted => '评价已发布。';

  @override
  String get detailsReviewUpdated => '评价已更新。';

  @override
  String get detailsReviewDeleted => '评价已删除。';

  @override
  String get detailsReviewComposerTitle => '写评价';

  @override
  String get detailsReviewEditTitle => '编辑评价';

  @override
  String get detailsReviewComposerHint => '请写下这次活动中让你满意的地方，\n或对下一位参加者有帮助的内容。';

  @override
  String detailsBodyCount(int count, int max) {
    return '$count/$max 字';
  }

  @override
  String detailsReviewImageSectionTitle(int max) {
    return '图片（最多 $max 张）';
  }

  @override
  String get detailsReviewSubmitting => '发布中...';

  @override
  String get detailsReviewSubmit => '发布评价';

  @override
  String get detailsReviewUpdating => '保存中...';

  @override
  String get detailsReviewEditSubmit => '保存评价';

  @override
  String get detailsReviewImageGuide => '第一张图片会作为封面图，\n长按可以调整顺序。';

  @override
  String get detailsReviewDeleteDialogTitle => '要删除这条评价吗？';

  @override
  String get detailsReviewDeleteDialogBody => '删除后将无法恢复。';

  @override
  String get detailsShareCopied => '已复制分享链接。可以直接粘贴到你常用的聊天工具中。';

  @override
  String get detailsReportActivityReload => '请重新加载活动信息后再举报。';

  @override
  String get detailsParticipantsListTitle => '参与用户列表';

  @override
  String get detailsParticipantRemoved => '已移除参与者。';

  @override
  String get detailsParticipantActionViewProfile => '查看个人资料';

  @override
  String get detailsParticipantActionApprove => '批准申请';

  @override
  String get detailsParticipantActionRemove => '移除参与者';

  @override
  String get detailsParticipantActionCancelRequest => '取消申请';

  @override
  String get detailsPendingParticipantsListTitle => '申请用户列表';

  @override
  String get detailsPendingCancelled => '已取消申请。';

  @override
  String get detailsParticipantSwipeHint => '可滑动删除或取消申请';

  @override
  String detailsReviewListReportSubject(Object title) {
    return '$title 评价列表';
  }

  @override
  String get detailsReviewLoadMoreHint => '滚动以加载更多评价。';

  @override
  String get detailsReviewImageInvalidFormat =>
      '只能上传 JPG、PNG、WEBP、GIF 格式的评价图片。';

  @override
  String get detailsReviewImageUploadError => '无法上传评价图片，请稍后再试。';

  @override
  String get detailsMe => '我';

  @override
  String get commonInvalidServerResponse => '服务器响应格式不正确。';

  @override
  String onboardingVerificationResendLimitNotice(int count) {
    return '验证码每天最多可重新获取 5 次。你目前已请求 $count 次。';
  }

  @override
  String get onboardingVerificationResendLimitReached => '验证码每天最多可重新获取 5 次。';

  @override
  String get onboardingVerificationSent => '验证码已发送。';

  @override
  String get onboardingVerificationResent => '验证码已重新发送。';

  @override
  String get onboardingBusinessVerificationCompleted => '商家认证已完成。请继续进行手机认证。';

  @override
  String get onboardingConsentRequired => '请同意所有必需条款。';

  @override
  String get homeExploreLoadMoreFailedNetwork => '无法加载更多结果。请检查网络连接。';

  @override
  String get homeExploreLoadMoreFailedServer => '无法加载更多结果。请稍后再试。';
}
