// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'MateYa';

  @override
  String get brandLockupSubtitle => '韓国の情と文化を分かち合う\n特別な旅の始まり';

  @override
  String get languageKorean => '韓国語';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageChineseSimplified => '中国語';

  @override
  String get bottomNavigationHome => 'ホーム';

  @override
  String get bottomNavigationExplore => '探す';

  @override
  String get bottomNavigationChat => 'チャット';

  @override
  String get bottomNavigationProfile => 'プロフィール';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonContinue => '続ける';

  @override
  String get commonLater => '後で';

  @override
  String get commonAll => 'すべて';

  @override
  String get commonNext => '次へ';

  @override
  String get commonReset => 'リセット';

  @override
  String get commonApply => '適用する';

  @override
  String get commonProcessing => '処理中...';

  @override
  String get commonFree => '無料';

  @override
  String get commonToday => '今日';

  @override
  String get commonTomorrow => '明日';

  @override
  String get permissionOpenAppSettings => 'アプリ設定を開く';

  @override
  String get permissionOpenLocationSettings => '位置情報設定を開く';

  @override
  String get locationServiceDisabledTitle => '位置情報サービスがオフです';

  @override
  String get locationPermissionDisabledTitle => '位置情報の権限がオフです';

  @override
  String get languageDialogBarrierLabel => '言語選択';

  @override
  String get languageDialogTitle => '言語を変更';

  @override
  String get languageDialogSupportedLanguages => '対応言語';

  @override
  String get onboardingStart => '始める';

  @override
  String get onboardingBusinessPrompt => '事業者の方ですか？ ';

  @override
  String get onboardingStartAsHost => 'ホストとして始める';

  @override
  String get onboardingConsentTitle => 'MateYa を利用するには同意が必要です。';

  @override
  String get onboardingAgreeAll => 'すべて同意';

  @override
  String get onboardingAgreeAllHelper => '以下の必須項目と任意項目のすべてに同意します。';

  @override
  String onboardingRequiredAgreementLabel(Object title) {
    return '（必須）$title';
  }

  @override
  String get onboardingEnterName => 'お名前を入力してください';

  @override
  String get onboardingEnterPhoneNumber => '携帯電話番号を入力してください';

  @override
  String get onboardingEnterVerificationCode => '認証コードを入力してください';

  @override
  String get onboardingPhoneNumberLabel => '電話番号';

  @override
  String get onboardingPhoneNumberHint => '例)01012341234';

  @override
  String get onboardingPhoneNumberHelper => '携帯電話番号を入力すると認証コードを受け取れます。';

  @override
  String get onboardingVerificationCodeLabel => '認証コード';

  @override
  String get onboardingVerificationCodeHint => '認証コードを受け取るを押すと入力できます。';

  @override
  String get onboardingResendVerificationCode => '認証コードを再送';

  @override
  String onboardingDebugVerificationCode(Object code) {
    return 'テスト用認証コード: $code';
  }

  @override
  String get onboardingVerify => '認証する';

  @override
  String get onboardingRequestVerificationCode => '認証コードを受け取る';

  @override
  String get onboardingLocationServiceDisabledMessage =>
      '現在地で地域認証を進めるには、端末の位置情報サービスをオンにする必要があります。オンにしなくても地域を直接入力して登録を続けられます。';

  @override
  String get onboardingLocationPermissionDisabledMessage =>
      '現在地の自動認証を使うには、アプリ設定で位置情報の権限を許可してください。許可しなくても手入力で登録を続けられます。';

  @override
  String onboardingPreviousNeighborhood(Object name) {
    return '以前は「$name」で登録されていました。';
  }

  @override
  String get onboardingResolvingCurrentLocation => '現在地を確認しています。';

  @override
  String get onboardingCompleteNeighborhood => '地域認証を完了する';

  @override
  String get onboardingRetryLocationPermission => '位置情報の権限を再リクエスト';

  @override
  String get onboardingRetryAfterSettingsChange => '設定変更後に再確認';

  @override
  String get onboardingRetryLocationService => '位置情報サービスを再確認';

  @override
  String get onboardingRetryCurrentLocation => '現在地を再確認';

  @override
  String get onboardingNeedHelp => '認証が難しいですか？  ';

  @override
  String get onboardingManualInputCta => '手動で入力 >';

  @override
  String get onboardingLocationPermissionNoticeTitle => '位置情報権限の案内';

  @override
  String get onboardingLocationPermissionNoticeMessage =>
      '地域認証と周辺アクティビティのおすすめのために位置情報が必要です。\n権限を許可しなくても地域を手動で入力して登録を続けられます。';

  @override
  String get onboardingUseCurrentLocation => '現在地で認証する';

  @override
  String get onboardingManualInput => '手動で入力';

  @override
  String get onboardingManualNeighborhoodHelper => '市区町村名や町名の形式で入力してください。';

  @override
  String get onboardingNeighborhoodHint => 'ウマン洞';

  @override
  String get onboardingEnterBusinessName => '屋号を入力してください';

  @override
  String get onboardingBusinessNameHint => 'NICE 評価情報';

  @override
  String get onboardingBusinessNumberLabel => '事業者登録番号';

  @override
  String get onboardingBusinessOwnerLabel => '代表者名';

  @override
  String get onboardingBusinessOwnerHint => 'ホン・ギルドン';

  @override
  String get onboardingBusinessOpeningDateLabel => '開業日';

  @override
  String get onboardingBusinessOpeningDateHint => '20240131';

  @override
  String get onboardingCompleteBusinessVerification => '事業者認証を完了する';

  @override
  String get onboardingWelcomeBack => 'お帰りなさい';

  @override
  String onboardingReturnCompleted(Object name) {
    return '$nameさん、\nMateYa への復帰が完了しました';
  }

  @override
  String get onboardingLaunchApp => 'MateYa を始める';

  @override
  String onboardingAgreementSemantics(Object label) {
    return '$label に同意';
  }

  @override
  String onboardingTermsEffectiveDate(Object date) {
    return '施行日: $date';
  }

  @override
  String get onboardingTermsContents => '目次';

  @override
  String onboardingTermsSectionTitle(int index, Object title) {
    return '第$index条 $title';
  }

  @override
  String get onboardingDefaultMemberName => 'MateYa 会員';

  @override
  String onboardingLoginCompleted(Object name) {
    return '$nameさん、\nMateYa へのログインが完了しました';
  }

  @override
  String onboardingSignupCompleted(Object name) {
    return '$nameさん、\nMateYa への登録が完了しました';
  }

  @override
  String onboardingNeighborhoodHeadlineReturning(Object name) {
    return 'お帰りなさい、\n$nameさん！\n地域情報を認証してください';
  }

  @override
  String get onboardingNeighborhoodHeadlineSignup => '地域情報を認証してください';

  @override
  String onboardingResolvedNeighborhoodMessage(Object name) {
    return '現在地は「$name」にあります。';
  }

  @override
  String get onboardingNeighborhoodLabel => '地域';

  @override
  String get onboardingVerificationExpired =>
      '認証の有効期限が切れました。認証コードを再度受け取ってください。';

  @override
  String get onboardingBusinessVerificationExpired =>
      '事業者認証の有効期限が切れました。再度認証してください。';

  @override
  String get homeSortRecommended => 'おすすめ順';

  @override
  String get homeSortPopular => '人気順';

  @override
  String get homeSortLatest => '新着順';

  @override
  String get homeSortClosingSoon => '締切間近順';

  @override
  String get homeSortNearby => '近い順';

  @override
  String get homeAudienceEveryone => '誰でも';

  @override
  String get homeAudienceForeignerFriendly => '外国人歓迎';

  @override
  String get homeAudienceKoreanFriendly => '韓国人歓迎';

  @override
  String get homeAudienceTouristFriendly => '観光客におすすめ';

  @override
  String get homeAudienceBeginnerFriendly => '初心者歓迎';

  @override
  String get homeStatusRecruiting => '募集中';

  @override
  String get homeStatusClosingSoon => 'まもなく締切（24時間以内）';

  @override
  String get homeStatusNewlyListed => '新規掲載（24時間以内）';

  @override
  String get homeDistanceLocal => '自分の地域';

  @override
  String get homeDistanceWithin1km => '1km以内';

  @override
  String get homeDistanceWithin5km => '5km以内';

  @override
  String get homeDistanceWithin10km => '10km以内';

  @override
  String get homeSearchHeroHint => 'いつでも、どこでも';

  @override
  String get homeSearchHeroHelper => '誰とでもメイトになれる場所、MateYa';

  @override
  String get homeLoadError => 'データを読み込めませんでした。';

  @override
  String get homeSelectAtLeastOneCategory => 'カテゴリーを1つ以上選択してください。';

  @override
  String get homeSelectAtLeastOneLanguage => '言語を1つ以上選択してください。';

  @override
  String get homeUnsupportedExploreLanguageFilter =>
      '探す言語フィルターは現在、韓国語・英語・中国語・日本語のみ対応しています。';

  @override
  String get homeEndDateBeforeStartDateError => '終了日は開始日より前にできません。';

  @override
  String get homeMaxPriceLessThanMinPriceError => '最大金額は最小金額以上である必要があります。';

  @override
  String get homeTrendingTitle => '急上昇中 🔥';

  @override
  String get homeSharedExperiencesTitle => '一緒に楽しめる体験';

  @override
  String get homeExploreSearchHint => '名前や場所で検索してみてください';

  @override
  String get homeExploreError => '結果を読み込めませんでした。';

  @override
  String get homeFavoritesLoadError => 'お気に入りを読み込めませんでした。';

  @override
  String get homeFavoritesTitle => 'お気に入り';

  @override
  String get homeCreateClass => 'クラスを登録';

  @override
  String get homeCreateGroup => 'グループを作成';

  @override
  String get homeEmptyTitle => '条件に合うアクティビティがまだありません。';

  @override
  String get homeEmptyDescription => '検索語やフィルターを調整してもう一度お試しください。';

  @override
  String get homeLoadMore => 'もっと見る';

  @override
  String homeLoadedAllActivities(int count) {
    return '$count件のアクティビティをすべて読み込みました。';
  }

  @override
  String get homeFilterTitle => 'フィルター';

  @override
  String get homeFilterSort => '並び替え';

  @override
  String get homeFilterCategory => 'カテゴリ';

  @override
  String get homeFilterAudience => '参加対象';

  @override
  String get homeFilterLanguage => '言語';

  @override
  String get homeFilterRegion => '地域';

  @override
  String get homeFilterSchedule => '日程';

  @override
  String get homeFilterStartDate => '開始日';

  @override
  String get homeFilterEndDate => '終了日';

  @override
  String get homeFilterCost => '費用';

  @override
  String get homeFilterMinPrice => '最低金額';

  @override
  String get homeFilterMaxPrice => '最高金額';

  @override
  String get homeFilterStatus => '募集状態';

  @override
  String get homeFilterNear => '近い地域';

  @override
  String get homeFilterFar => '遠い地域';

  @override
  String homeFilterDistanceFromActivityRegion(Object target) {
    return '活動地域を基準に $target';
  }

  @override
  String homeFilterDistanceFromRegion(Object regionName, Object target) {
    return '$regionName を基準に $target';
  }

  @override
  String get commonClose => '閉じる';

  @override
  String get commonEdit => '編集';

  @override
  String get commonSeeAll => 'すべて見る';

  @override
  String get commonSeeDetails => '詳細を見る';

  @override
  String get commonNetworkRetry => 'ネットワーク接続を確認してから再試行してください。';

  @override
  String get countryKorea => '韓国';

  @override
  String get countryJapan => '日本';

  @override
  String get countryChina => '中国';

  @override
  String get countryVietnam => 'ベトナム';

  @override
  String get countryUnitedStates => 'アメリカ';

  @override
  String get countryThailand => 'タイ';

  @override
  String get activityCategoryTouristAttraction => '観光地';

  @override
  String get activityCategoryTravelCourse => '旅行コース';

  @override
  String get activityCategoryCultureTradition => '文化 / 伝統';

  @override
  String get activityCategoryEventPerformanceFestival => 'イベント / 公演 / 祭り';

  @override
  String get activityCategorySports => 'スポーツ';

  @override
  String get activityCategoryActivityLeports => 'アクティビティ / レジャー';

  @override
  String get activityCategoryShopping => 'ショッピング';

  @override
  String get activityCategoryPublicFacility => '公共施設';

  @override
  String get activityCategoryOther => 'その他';

  @override
  String get reportSemanticsLabel => '通報する';

  @override
  String get reportTitle => '通報する';

  @override
  String get reportNoticeMessage =>
      '通報画像を添付するには写真ライブラリへのアクセス権限が必要です。権限がなくても通報内容の入力は続けられます。';

  @override
  String get reportRecoveryMessage =>
      '通報画像を添付するには写真ライブラリへのアクセス権限が必要です。再試行するか、アプリ設定で権限を許可してください。';

  @override
  String get reportFailureMessage => '画像を読み込めませんでした。権限とファイルの状態を確認してください。';

  @override
  String get reportRestoreFallbackErrorMessage =>
      '以前に選択していた通報画像を復元できませんでした。もう一度選択してください。';

  @override
  String reportSubmittedMessage(Object subject) {
    return '$subject の通報を受け付けました。';
  }

  @override
  String get reportBodyHint =>
      '通報理由を具体的に記入してください。\n例: 暴言、詐欺の疑い、不適切な投稿、\nスパム、嫌がらせなど。通報内容は運営ポリシーに\n基づいて確認されます。';

  @override
  String reportBodyCount(int count, int max) {
    return '$count/$max文字';
  }

  @override
  String reportImageSectionTitle(int max) {
    return '画像（最大 $max 枚）';
  }

  @override
  String get reportSubmitting => '送信中...';

  @override
  String get reportReviewNotice =>
      '受け付けた通報は、最大7営業日以内に確認されます。\n虚偽の通報や理由が不明確な通報は処理されない場合があります。';

  @override
  String reportRestoredCount(int restoredCount) {
    return '以前に選択した通報画像を $restoredCount 枚復元しました。';
  }

  @override
  String get mypageTitle => 'マイページ';

  @override
  String get mypageLoadError => 'マイページを読み込めませんでした。';

  @override
  String get mypageOtherProfileOpenHint => 'プロフィールを読み込んでいます。';

  @override
  String get mypageOtherProfileLoadError => '相手のプロフィールを読み込めませんでした。';

  @override
  String get mypageEditPrimaryPreferences => '基本情報を編集';

  @override
  String get mypageEditActivityRegion => '活動地域を編集';

  @override
  String get mypageConsentHistoryTitle => '同意履歴';

  @override
  String get mypageOpenPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get mypageOpenCustomerSupport => 'カスタマーサポート';

  @override
  String get mypageOpenBlockedUsers => 'ブロックしたユーザー';

  @override
  String get mypageLogout => 'ログアウト';

  @override
  String get mypageOpenWithdrawal => '退会する';

  @override
  String get mypageConsentHistoryDescription =>
      'MateYa の利用に同意した規約とポリシーを確認できます。';

  @override
  String get mypageConsentHistoryEmpty => '保存された同意履歴はまだありません。';

  @override
  String get mypageConsentVersion => 'バージョン';

  @override
  String get mypageConsentStatus => '状態';

  @override
  String get mypageConsentAgreed => '同意';

  @override
  String get mypageConsentDeclined => '未同意';

  @override
  String get mypageConsentDate => '同意日時';

  @override
  String get mypageBlockedUsersTitle => 'ブロックしたユーザー';

  @override
  String get mypageBlockedUsersEmpty => 'ブロックしたユーザーはいません。';

  @override
  String get mypageRecentActivitiesTitle => '最近のアクティビティ';

  @override
  String get mypageRecentActivitiesDescription => '最近参加または主催したアクティビティを確認しましょう。';

  @override
  String get mypageActivitySummaryTitle => '活動サマリー';

  @override
  String get mypageHostedCount => '主催';

  @override
  String get mypageJoinedCount => '参加';

  @override
  String get mypageReviewCount => 'レビュー';

  @override
  String get mypageActiveMember => '活動中のメンバー';

  @override
  String get mypageInactiveMember => '最近の活動なし';

  @override
  String get mypageActiveWithin30Days => '30日以内に利用';

  @override
  String get mypageNoRecentActivity => '最近の利用なし';

  @override
  String get mypageBadgeLabel => 'バッジ';

  @override
  String get mypageBadgesTitle => 'マイバッジ';

  @override
  String get mypageBadgesDescription => '参加したアクティビティのカテゴリに応じてバッジを獲得できます。';

  @override
  String get mypageRecentActivitiesSectionTitle => '活動履歴';

  @override
  String get mypageActivityHistoryTitle => '活動履歴';

  @override
  String get mypagePrimaryPreferencesTitle => '基本情報';

  @override
  String get mypagePrimaryPreferencesDescription => '言語と国籍情報を修正できます。';

  @override
  String get mypageMyLanguage => 'マイ言語';

  @override
  String get mypageMyCountry => '国籍';

  @override
  String get mypageEnglishNameOptional => '英語名（任意）';

  @override
  String get mypageSaving => '保存中...';

  @override
  String get mypagePrimaryPreferencesSubmit => '保存する';

  @override
  String get mypageUpdating => '更新中...';

  @override
  String get mypageBusinessIntroTitle => '紹介文';

  @override
  String get mypageBusinessIntroDescription => 'ホストページに表示される一言紹介を書いてください。';

  @override
  String get mypageBusinessIntroHint => '提供する体験の魅力を自然に紹介してください。';

  @override
  String get mypageSaveIntroduction => '紹介文を保存';

  @override
  String get mypageActiveExperiencesTitle => '運営中の体験';

  @override
  String get mypageRemoveFriend => '友だち削除';

  @override
  String get mypageBlocked => 'ブロック済み';

  @override
  String get mypageBlockUser => 'ブロックする';

  @override
  String get mypageSelectLanguageAndCountry => '言語と国を両方選択してください。';

  @override
  String get mypageInvalidLanguageOrCountry => 'サポートされていない言語または国です。';

  @override
  String get mypagePrimaryPreferencesSaved => '基本情報を保存しました。';

  @override
  String get mypagePrimaryPreferencesSaveError =>
      '基本情報を保存できませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageFriendRemoved => '友だちを削除しました。';

  @override
  String get mypageFriendAdded => '友だちに追加しました。';

  @override
  String get mypageFriendUpdateError => '友だち状態を変更できませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageBlockedUserAdded => 'ユーザーをブロックしました。';

  @override
  String get mypageBlockUserError => 'ユーザーをブロックできませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageUnblockedUser => 'ブロックを解除しました。';

  @override
  String get mypageUnblockUserError => 'ブロックを解除できませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageBusinessIntroRequired => '紹介文を入力してください。';

  @override
  String get mypageBusinessIntroTooLong => '紹介文は300文字以内で入力してください。';

  @override
  String get mypageBusinessIntroSaved => '紹介文を保存しました。';

  @override
  String get mypageBusinessIntroSaveError =>
      '紹介文を保存できませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageProfileImageSaved => 'プロフィール画像を保存しました。';

  @override
  String get mypageProfileImageSaveError =>
      'プロフィール画像を保存できませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageProfileImageInvalidFormat =>
      'JPG、PNG、WEBP、GIF 形式の画像のみアップロードできます。';

  @override
  String get mypageProfileImageUploadError =>
      'プロフィール画像をアップロードできませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageProfileImageConfirmError =>
      'プロフィール画像のアップロード確認に失敗しました。しばらくしてから再試行してください。';

  @override
  String get mypageActivityRegionSaved => '活動地域を保存しました。';

  @override
  String get mypageActivityRegionSaveError =>
      '活動地域を保存できませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageWithdrawalAgreementRequired => '退会リクエストの前に同意が必要です。';

  @override
  String get mypageWithdrawalSignatureRequired => '署名を入力してください。';

  @override
  String get mypageWithdrawalSignatureMismatch => '入力した署名が会員名と一致しません。';

  @override
  String get mypageWithdrawalAgreementText => '個人情報管理および30日後の最終削除ポリシーに同意します。';

  @override
  String get mypageWithdrawalSubmitted => '退会リクエストを受け付けました。';

  @override
  String get mypageWithdrawalSubmitError =>
      '退会リクエストを処理できませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageLogoutError => 'ログアウトできませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageTermsDetailUnavailable => '規約の詳細を読み込めませんでした。';

  @override
  String get mypageSupportLinkCopied => 'カスタマーサポートのリンクをコピーしました。';

  @override
  String get mypagePrivacyLinkCopied => 'プライバシーポリシーのリンクをコピーしました。';

  @override
  String get mypageCurrentLocationResolveError =>
      '現在地を確認できませんでした。しばらくしてから再試行してください。';

  @override
  String get mypageNeighborhoodRequired => '活動地域を入力してください。';

  @override
  String get mypageNeighborhoodLookupError => '入力した地域を確認できませんでした。もう一度確認してください。';

  @override
  String get mypageNeighborhoodVerificationRequired => '確認済みの活動地域を選択してください。';

  @override
  String get mypageActivityRegionDialogDescription =>
      '現在地を使うか、直接入力して活動地域を設定できます。';

  @override
  String get mypageResolvingCurrentLocation => '現在地を確認しています。';

  @override
  String get mypageResolvingNeighborhood => '入力した地域を確認しています。';

  @override
  String get mypageConfirmManualNeighborhood => 'この地域を使用する';

  @override
  String mypageSelectedActivityRegion(Object name) {
    return '選択した活動地域: $name';
  }

  @override
  String get mypageSaveActivityRegion => '活動地域を保存';

  @override
  String get mypageLocationServiceDisabledMessage =>
      '現在地を使うには、端末の位置情報サービスをオンにしてください。手動入力でも続けられます。';

  @override
  String get mypageLocationPermissionDisabledMessage =>
      '現在地を使うには、アプリ設定で位置情報の権限を許可してください。手動入力でも続けられます。';

  @override
  String get mypageProfileImageNotice => 'プロフィール画像を選択するには写真ライブラリへのアクセス権限が必要です。';

  @override
  String get mypageProfileImageRecovery =>
      'プロフィール画像を選択するには写真ライブラリへのアクセスを許可してください。再試行するか、アプリ設定で変更できます。';

  @override
  String get mypageProfileImageFailure =>
      'プロフィール画像を読み込めませんでした。ファイルの状態を確認してください。';

  @override
  String get mypageProfileImageRestoreFallback =>
      '以前に選択していたプロフィール画像を復元できませんでした。もう一度選択してください。';

  @override
  String mypageProfileImageRestoredCount(int restoredCount) {
    return '以前に選択していたプロフィール画像を $restoredCount 枚復元しました。';
  }

  @override
  String get mypageWithdrawalTitle => '退会する';

  @override
  String get mypageWithdrawalDescription =>
      '退会を進めますか？\n退会後、アカウントはすぐに無効化されます。\n30日以内に再登録または再ログインすると、\n退会は取り消されます。\n\n30日を過ぎると、法令上保管が必要な情報を除き、会員情報と利用履歴は完全に削除され、復元できません。';

  @override
  String get mypageWithdrawalAgreementCheckbox =>
      '個人情報管理および30日後の最終削除ポリシーに同意します。';

  @override
  String get mypageWithdrawalSignatureLabel => '署名入力';

  @override
  String mypageWithdrawalSignatureHint(Object name) {
    return '$name を入力';
  }

  @override
  String get mypageWithdrawalSubmittedNotice =>
      '退会リクエストを受け付けました。再ログインするまでアカウントは無効状態として扱われます。';

  @override
  String get mypageWithdrawalRequest => '退会を申請';

  @override
  String get mypageMetricActivities => '活動数';

  @override
  String get mypageMetricFriends => '友だち数';

  @override
  String get mypageMetricReviews => '作成レビュー';

  @override
  String get mypageMetricRecruitingExperiences => '募集中の体験';

  @override
  String get mypageMetricTotalParticipants => '累計参加者';

  @override
  String get mypageMetricAverageRating => '平均評価';

  @override
  String get mypageMetricReceivedReviews => '受け取ったレビュー';

  @override
  String get mypageActivityRegionUnset => '活動地域未設定';

  @override
  String mypageParticipantCount(int current, int capacity) {
    return '$current / $capacity人';
  }

  @override
  String get mypageConsentTypeServiceTerms => 'サービス利用規約';

  @override
  String get mypageConsentTypePrivacyCollection => '個人情報の収集・利用への同意';

  @override
  String get mypageConsentTypeLocationService => '位置情報サービス利用への同意';

  @override
  String get mypageConsentTypeAgeOver14 => '14歳以上の確認';

  @override
  String get mypageHostBadge => 'HOST';

  @override
  String get mypageEditActivityCta => '編集する';

  @override
  String get mypageBadgeTraditional => '伝統マスター';

  @override
  String get mypageBadgeActivePerson => 'アクティブメイト';

  @override
  String get mypageBadgeFestive => 'フェス好き';

  @override
  String get mypageBadgeTourist => 'ローカル探検家';

  @override
  String get mypageBadgeUnlockedTitle => '新しいバッジを獲得しました';

  @override
  String mypageBadgeUnlockedDescription(Object category) {
    return '$category 活動への参加が反映されました。';
  }

  @override
  String get galleryPermissionNoticeTitle => '写真権限の案内';

  @override
  String get galleryPermissionSelectPhoto => '写真を選択';

  @override
  String get galleryPermissionRecoveryTitle => '写真へのアクセス権限が必要です';

  @override
  String get authLoginRequired => 'ログインが必要です。';

  @override
  String get commonRequestError => 'リクエスト処理中にエラーが発生しました。';

  @override
  String get chatJustNow => 'たった今';

  @override
  String chatMinutesAgo(int count) {
    return '$count分前';
  }

  @override
  String chatHoursAgo(int count) {
    return '$count時間前';
  }

  @override
  String get chatYesterday => '昨日';

  @override
  String get chatLastYear => '昨年';

  @override
  String chatPhotoCount(int count) {
    return '写真 $count枚';
  }

  @override
  String get chatViewOriginal => '原文を見る';

  @override
  String get chatViewTranslation => '翻訳を見る';

  @override
  String chatParticipantCount(int count) {
    return '$count人参加';
  }

  @override
  String get chatFilterGroup => 'グループ';

  @override
  String get chatFilterDirect => '個人';

  @override
  String get chatListGuidance =>
      'アクティビティに参加すると、自動的にグループチャットに追加されます。\n個人チャットは友だちのユーザーと自動的に作成されます。\n友だちではないユーザーとはチャットできません。';

  @override
  String get chatComposerHint => 'メッセージを入力してください';

  @override
  String get reportReasonRequired => '通報理由を入力してください。';

  @override
  String get reportImageInvalidFormat =>
      '通報画像は JPG、PNG、WEBP、GIF 形式のみアップロードできます。';

  @override
  String get reportImageUploadError => '通報画像をアップロードできませんでした。しばらくしてから再試行してください。';

  @override
  String get reportImageConfirmError =>
      '通報画像のアップロード確認に失敗しました。しばらくしてから再試行してください.';

  @override
  String get createGroupFlowTitle => 'グループを作成';

  @override
  String get createClassFlowTitle => 'クラスを作成';

  @override
  String get createEntityGroup => 'グループ';

  @override
  String get createEntityClass => 'クラス';

  @override
  String get createGroupSubmit => 'グループを作成';

  @override
  String get createClassSubmit => 'クラスを作成';

  @override
  String get createGroupEditTitle => 'グループを編集';

  @override
  String get createClassEditTitle => 'クラスを編集';

  @override
  String get createGroupUpdateSubmit => 'グループの変更を保存';

  @override
  String get createClassUpdateSubmit => 'クラスの変更を保存';

  @override
  String get createPaidLabel => '有料';

  @override
  String createEditCompleted(Object entity) {
    return '$entityの更新が完了しました。';
  }

  @override
  String createSubmitCompleted(Object entity) {
    return '$entityの作成が完了しました。';
  }

  @override
  String createChatProvisionFailed(Object entity) {
    return '$entityの作成は完了しましたが、チャットルームを準備できませんでした。しばらくしてからもう一度お試しください。';
  }

  @override
  String createSubmitFailedNetwork(Object entity) {
    return '$entityを作成できませんでした。ネットワークを確認してからもう一度お試しください。';
  }

  @override
  String createSubmitFailedServer(Object entity) {
    return '$entityを作成できませんでした。しばらくしてからもう一度お試しください。';
  }

  @override
  String get createDeleteFailedNetwork =>
      '削除できませんでした。ネットワークを確認してからもう一度お試しください。';

  @override
  String get createDeleteFailedServer => '削除できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String createLoadEditFailedNetwork(Object entity) {
    return '編集する$entity情報を読み込めませんでした。ネットワークを確認してからもう一度お試しください。';
  }

  @override
  String createLoadEditFailedServer(Object entity) {
    return '編集する$entity情報を読み込めませんでした。しばらくしてからもう一度お試しください。';
  }

  @override
  String get createValidationSelectCategory => 'カテゴリを1つ以上選択してください。';

  @override
  String get createValidationSelectClassCategoryFirst =>
      'まずクラスに合うカテゴリを選択してください。';

  @override
  String get createValidationSelectPlaceOrManual => '場所を選択するか、手動で入力してください。';

  @override
  String get createValidationSelectPlace => '場所を選択してください。';

  @override
  String createValidationEnterEntityName(Object entity) {
    return '$entity名を入力してください。';
  }

  @override
  String get createValidationTitleMaxLength => '名前は40文字以内で入力してください。';

  @override
  String get createValidationDescriptionMaxLength => '説明は1000文字以内で入力してください。';

  @override
  String get createValidationSelectDate => '日付を選択してください。';

  @override
  String get createValidationNoPastDate => '過去の日付は選択できません。';

  @override
  String get createValidationSelectStartEndTime => '開始時刻と終了時刻を両方選択してください。';

  @override
  String get createValidationEndAfterStart => '終了時刻は開始時刻より後である必要があります。';

  @override
  String get createValidationCapacityRange => '参加人数は2人以上20人以下で設定してください。';

  @override
  String get createValidationSelectDeadline => '募集締切の日付と時刻を両方選択してください。';

  @override
  String get createValidationSelectDeadlineTogether =>
      '募集締切の日付と時刻を一緒に選択してください。';

  @override
  String get createValidationDeadlineFuture => '募集締切は現在時刻より後である必要があります。';

  @override
  String get createValidationDeadlineBeforeStart => '募集締切は開始時刻より前である必要があります。';

  @override
  String get createValidationSelectLanguage => '言語を1つ以上選択してください。';

  @override
  String get createValidationSelectPriceType => '料金タイプを選択してください。';

  @override
  String get createValidationEnterPaidPrice => '有料の場合は金額を入力してください。';

  @override
  String get createValidationPriceRange => '金額は1ウォン以上1,000,000ウォン以下で入力してください。';

  @override
  String get createValidationRegisterImage => '代表画像を1枚以上登録してください。';

  @override
  String get createGroupInfoTitle => 'グループ情報を入力してください';

  @override
  String get createClassInfoTitle => 'クラス情報を入力してください';

  @override
  String get createValidationIntro => '必須情報を入力するとすぐに公開できます。';

  @override
  String get createSelectedCategoryTitle => '選択したカテゴリ';

  @override
  String get createSelectedPlaceTitle => '選択した場所';

  @override
  String get createGroupNameLabel => 'グループ名';

  @override
  String get createClassNameLabel => 'クラス名';

  @override
  String get createGroupNameHint => '例) 北村韓屋散歩に一緒に行きましょう';

  @override
  String get createClassNameHint => '例) 伝統茶ワンデークラス';

  @override
  String get createDescriptionTitle => '詳細説明';

  @override
  String get createDescriptionHint => '進行方法、持ち物、参加者に伝えたい内容を入力してください。';

  @override
  String get createDateTimeTitle => '日程';

  @override
  String get createDateLabel => '開催日';

  @override
  String get createDatePlaceholder => '日付を選択してください';

  @override
  String get createStartTimeLabel => '開始時刻';

  @override
  String get createStartTimePlaceholder => '開始時刻を選択してください';

  @override
  String get createEndTimeLabel => '終了時刻';

  @override
  String get createEndTimePlaceholder => '終了時刻を選択してください';

  @override
  String get createCapacityTitle => '参加人数';

  @override
  String createCapacityValue(int count) {
    return '$count人';
  }

  @override
  String get createCapacityHelper => '最小2人、最大20人';

  @override
  String get createDeadlineTitle => '募集締切';

  @override
  String get createDeadlineDateLabel => '締切日';

  @override
  String get createDeadlineTimeLabel => '締切時刻';

  @override
  String get createNotSelected => '未選択';

  @override
  String get createLanguagesTitle => '使用言語';

  @override
  String get createPriceTitle => '参加費';

  @override
  String get createPaidPriceHint => '参加費を入力してください';

  @override
  String get createAudienceTitle => 'おすすめ対象';

  @override
  String get createPrimaryImageTitle => '代表画像';

  @override
  String get createPrimaryImageRequiredHint => '代表画像を1枚以上登録してください。';

  @override
  String get createPrimaryImageSelectionHint =>
      '最初の画像が代表画像になります。別の画像をタップすると代表画像を変更できます。';

  @override
  String get createPrimaryImageBadge => '代表';

  @override
  String get createDeleting => '削除中...';

  @override
  String createDeleteAction(Object entity) {
    return '$entityを削除';
  }

  @override
  String get createPlaceGroupTitle => 'グループの場所を選択してください';

  @override
  String get createPlaceClassTitle => 'クラスの場所を選択してください';

  @override
  String get createPlaceGroupDescription =>
      'おすすめの場所を選ぶか、手動で入力してグループの場所を決められます。';

  @override
  String get createPlaceClassDescription =>
      'カテゴリに合う場所を検索するか、手動で入力してクラスの場所を決められます。';

  @override
  String get createClassCategoryTitle => 'クラスカテゴリ';

  @override
  String get createCategoryDetailTitle => '詳細カテゴリ';

  @override
  String get createManualPlaceTitle => '手動で入力';

  @override
  String get createManualPlaceNameHint => '場所名を入力してください';

  @override
  String get createManualPlaceAddressHint => '住所を入力してください';

  @override
  String get createOrSearchTitle => 'または場所を検索';

  @override
  String get createPlaceSearchHint => '場所名で検索';

  @override
  String get createManualPlacePreviewDescription => '手動で入力した場所情報で公開されます。';

  @override
  String get createSearchResultsTitle => '検索結果';

  @override
  String get createSearchEmptyTitle => '検索結果がありません';

  @override
  String get createSearchEmptyBody => '別のキーワードで検索してください。';

  @override
  String get createSearchInitialTitle => '場所を検索してください';

  @override
  String get createSearchInitialBody => '場所名や住所を入力すると、選択できる候補が表示されます。';

  @override
  String get createRecommendedTitle => 'おすすめの場所';

  @override
  String get createRefresh => '再読み込み';

  @override
  String get createRecommendedEmptyTitle => 'おすすめの場所がまだありません';

  @override
  String get createRecommendedEmptyBody => 'カテゴリを変更するか、手動で検索してください。';

  @override
  String get createMapPlaceholder => '場所を選択すると、このエリアに位置が表示されます。';

  @override
  String get createCategoryPromptTitle => 'どんな体験を作りますか？';

  @override
  String get createCategoryPromptDescription =>
      '公開したいグループまたはクラスに最も合うカテゴリを選択してください。';

  @override
  String get createCompletedEditDescription => '変更内容を保存しました。参加者にもすぐ反映されます。';

  @override
  String get createCompletedCreateDescription => 'これでMateYaで参加者を募集できます。';

  @override
  String get createBackToPrevious => '戻る';

  @override
  String get createBackToHome => 'ホームに戻る';

  @override
  String get createStepCategory => 'カテゴリ';

  @override
  String get createStepPlaceGroup => '場所';

  @override
  String get createStepPlaceClass => '場所';

  @override
  String get createStepDetailsGroup => '情報入力';

  @override
  String get createStepDetailsClass => '情報入力';

  @override
  String get createCompletedProgress => '完了';

  @override
  String get createCategoryTitleCultureTradition => '文化 / 伝統';

  @override
  String get createCategoryTitleEventPerformanceFestival => 'イベント / 公演 / 祭り';

  @override
  String get createCategoryTitleActivityLeports => 'アクティビティ / レジャースポーツ';

  @override
  String get createCategoryDescriptionTourist => '有名な観光地を一緒に巡る集まりに向いています。';

  @override
  String get createCategoryDescriptionTravelCourse => '移動を含む旅行コース型の体験に向いています。';

  @override
  String get createCategoryDescriptionCultureTradition =>
      '伝統文化、工芸、歴史体験におすすめです。';

  @override
  String get createCategoryDescriptionFestival => '公演、祭り、季節イベントへの参加型体験に適しています。';

  @override
  String get createCategoryDescriptionSports => '運動、観戦、スポーツ中心の集まりに合います。';

  @override
  String get createCategoryDescriptionActivityLeports =>
      '屋外体験やアクティブなレジャー活動に適しています。';

  @override
  String get createCategoryDescriptionPublicFacility =>
      '展示、公的空間、地域コミュニティ活動におすすめです。';

  @override
  String get createCategoryDescriptionShopping =>
      '市場やショッピングストリート、ローカル店舗ツアーにぴったりです。';

  @override
  String createEventDatePickerHelp(Object entity) {
    return '$entityの日付を選択';
  }

  @override
  String get createStartTimePickerHelp => '開始時刻を選択';

  @override
  String get createEndTimePickerHelp => '終了時刻を選択';

  @override
  String get createDeadlineDatePickerHelp => '募集締切日を選択';

  @override
  String get createDeadlineTimePickerHelp => '募集締切時刻を選択';

  @override
  String createDeleteDialogTitle(Object entity) {
    return 'この$entityを削除しますか？';
  }

  @override
  String createDeleteDialogBody(Object entity) {
    return '削除すると元に戻せません。';
  }

  @override
  String get createDeleteButton => '削除';

  @override
  String get createDeleteCompleted => '削除しました。';

  @override
  String createInitializationLoadError(Object entity) {
    return '$entity情報を読み込めませんでした。';
  }

  @override
  String get createInitializationRetryBody =>
      'しばらくしてからもう一度お試しください。問題が続く場合は前の画面に戻って開き直してください。';

  @override
  String createSavingEntity(Object entity) {
    return '$entityを保存中...';
  }

  @override
  String createSubmittingEntity(Object entity) {
    return '$entityを作成中...';
  }

  @override
  String get createSelectPlaceAction => '場所を選択';

  @override
  String get createImagePickerNotice =>
      '画像を添付するには写真ライブラリへのアクセス権限が必要です。権限がなくても他の情報入力は続けられます。';

  @override
  String get createImagePickerRecovery =>
      '画像添付を続けるには写真ライブラリへのアクセス権限が必要です。再試行するか、アプリ設定で権限を許可してください。';

  @override
  String get createImagePickerFailure =>
      '画像を読み込めませんでした。ファイルの状態を確認してからもう一度お試しください。';

  @override
  String get createImagePickerRestoreFallback =>
      '先ほど選択していた画像を復元できませんでした。もう一度選択してください。';

  @override
  String createImagePickerRestoredCount(int count) {
    return '以前に選択した画像を$count枚復元しました。';
  }

  @override
  String get createRecommendedLoadFailedNetwork =>
      'おすすめの場所を読み込めませんでした。ネットワークを確認してからもう一度お試しください。';

  @override
  String get createRecommendedLoadFailedServer =>
      'おすすめの場所を読み込めませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get createPlaceSearchQueryRequired => '場所名を入力してください。';

  @override
  String get createPlaceSearchFailedNetwork =>
      '場所検索に失敗しました。接続状態を確認してからもう一度お試しください。';

  @override
  String get createPlaceSearchFailedServer =>
      '場所検索に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get createPlaceCoordinateRequired => '位置情報がないため、この場所は選択できません。';

  @override
  String get createPlaceMapCoordinateRequired => '位置情報がないため、この場所を地図に表示できません。';

  @override
  String createImageLimitExceeded(int max) {
    return '画像は最大$max枚まで追加できます。';
  }

  @override
  String get createImageInvalidFormat => '追加できる画像形式は JPG、PNG、WEBP、GIF のみです。';

  @override
  String get createImageMaxSize => '画像1枚あたり最大10MBまで追加できます。';

  @override
  String get createPlaceDescriptionFallback => '位置を確認してから選択してください。';

  @override
  String get createExistingPlaceDescription => '既存の活動場所';

  @override
  String get createResolveServerCategoryFailed =>
      '選択した場所からサーバーカテゴリを確定できませんでした。別の場所を選択してください。';

  @override
  String get createUploadImageRequired => '代表画像を1枚以上登録してください。';

  @override
  String get createUploadImageInvalidFormat =>
      'アップロードできる画像形式は JPG、PNG、WEBP、GIF のみです。';

  @override
  String get createUploadImageFailed => '画像のアップロードに失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get createUploadImageConfirmFailed =>
      'アップロードした画像を確認できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get onboardingValidationNameRequired => '名前を入力してください。';

  @override
  String get onboardingValidationNameMaxLength => '名前は30文字以内で入力してください。';

  @override
  String get onboardingValidationNameCharacters => '数字や記号を除き、名前のみ入力してください。';

  @override
  String get onboardingValidationPhoneRequired => '電話番号を入力してください。';

  @override
  String get onboardingValidationPhoneDigitsOnly => '電話番号は数字のみ入力してください。';

  @override
  String get onboardingValidationPhoneMaxLength => '電話番号は最大15桁まで入力できます。';

  @override
  String get onboardingValidationPhoneInvalid => '電話番号を正しく入力してください。';

  @override
  String get onboardingValidationVerificationCodeRequired =>
      '6桁の認証コードを入力してください。';

  @override
  String get onboardingValidationVerificationExpired =>
      '認証時間が切れました。認証コードを再度受け取ってください。';

  @override
  String get onboardingValidationVerificationMismatch => '認証コードが一致しません。';

  @override
  String get onboardingValidationBusinessNameRequired => '商号を入力してください。';

  @override
  String get onboardingValidationOpeningDateRequired => '開業日8桁を入力してください。';

  @override
  String get onboardingValidationOpeningDateDigitsOnly => '開業日は数字のみ入力してください。';

  @override
  String get onboardingValidationOpeningDateInvalid => '正しい開業日を入力してください。';

  @override
  String get onboardingValidationBusinessNumberRequired =>
      '10桁の事業者番号を正しく入力してください。';

  @override
  String get onboardingValidationBusinessNumberDigitsOnly =>
      '事業者番号は数字のみ入力してください。';

  @override
  String get onboardingLocationErrorServiceDisabled =>
      '位置情報サービスがオフです。手動入力で進めてください。';

  @override
  String get onboardingLocationErrorPermissionDenied =>
      '位置情報の権限がないため、現在地による自動認証は利用できません。手動入力で進めることはでき、権限を許可した後に再試行できます。';

  @override
  String get onboardingLocationErrorPermissionPermanentlyDenied =>
      '位置情報の権限がオフのため、現在地による自動認証は利用できません。アプリ設定で権限を許可するか、手動入力で進めてください。';

  @override
  String get onboardingLocationErrorAccuracyLow => '位置精度が低いため、自動認証が難しいです。';

  @override
  String get onboardingLocationErrorAddressNotFound =>
      '住所が見つかりませんでした。手動入力で進めてください。';

  @override
  String get onboardingLocationErrorUnknown => '位置情報を読み込めませんでした。手動入力で進めてください。';

  @override
  String get onboardingLocationQueryRequired => '地域名を入力してください。';

  @override
  String get onboardingLocationQueryNotFound => '入力した地域が見つかりませんでした。';

  @override
  String get onboardingLocationCurrentFallback => '現在地';

  @override
  String homeParticipantCount(int current, int capacity) {
    return '$current/$capacity 参加';
  }

  @override
  String get homeFavoritesSubtitle => 'あなたの関心を世界と共有しましょう。';

  @override
  String get homeFavoritesEmptyTitle => 'まだ保存したアクティビティがありません。';

  @override
  String get homeFavoritesEmptyDescription => '気に入ったアクティビティを保存すると、ここで再び確認できます。';

  @override
  String get homeNearbyCultureMap => '近くの伝統文化';

  @override
  String get onboardingTermsPendingEffectiveDate => '確認中';

  @override
  String get onboardingTermsServiceTitle => 'サービス利用規約';

  @override
  String get onboardingTermsServiceSummary =>
      'MateYaサービスを利用するための基本条件、利用者の責任、サービス運営基準を案内します。';

  @override
  String get onboardingTermsServiceSection1Title => 'サービスの目的';

  @override
  String get onboardingTermsServiceSection1Body =>
      'MateYaは、国内ユーザーと海外ユーザーがグループ、クラス、地域ベースの活動を安全に探し、参加できるようにつなぐプラットフォームです。';

  @override
  String get onboardingTermsServiceSection2Title => '会員登録とアカウント管理';

  @override
  String get onboardingTermsServiceSection2Body =>
      '会員は本人名義の情報で登録し、電話認証と規約同意を完了してからサービスを利用できます。アカウント情報が変更された場合は、最新の状態に保つ必要があります。';

  @override
  String get onboardingTermsServiceSection3Title => 'サービス利用条件';

  @override
  String get onboardingTermsServiceSection3Body =>
      '会員は関係法令および本規約を遵守し、他人の権利を侵害したり、サービス運営を妨害したりしてはいけません。一部機能では本人確認や追加認証が必要になる場合があります。';

  @override
  String get onboardingTermsServiceSection4Title => '禁止行為';

  @override
  String get onboardingTermsServiceSection4Body =>
      '虚偽情報の登録、他人へのなりすまし、違法な宣伝、わいせつまたはヘイト表現の投稿、異常な自動化アクセス、運営ポリシー回避の試みは禁止されます。違反時には投稿削除、利用制限、アカウント停止などの措置が行われることがあります。';

  @override
  String get onboardingTermsServiceSection5Title => 'サービスの中断および変更';

  @override
  String get onboardingTermsServiceSection5Body =>
      'MateYaは、点検、障害対応、ポリシー変更、または外部提携事情により、サービスの一部を変更または一時中断することがあります。重要な変更はアプリ内のお知らせ、または適切な手段で案内します。';

  @override
  String get onboardingTermsServiceSection6Title => '責任の制限';

  @override
  String get onboardingTermsServiceSection6Body =>
      'MateYaは、天災、通信障害、利用者の責に帰す事由により発生した損害について、法令が許容する範囲で責任を制限できるものとします。ただし、会社に故意または重大な過失がある場合はこの限りではありません。';

  @override
  String get onboardingTermsServiceSection7Title => 'お問い合わせ先';

  @override
  String get onboardingTermsServiceSection7Body =>
      'サービス利用中にお問い合わせが必要な場合は、アプリ内サポートチャネルまたは運営チームのメールで受け付けます。受付内容は運営ポリシーに従って順次処理されます。';

  @override
  String get onboardingTermsPrivacyTitle => '個人情報の第三者提供への同意';

  @override
  String get onboardingTermsPrivacySummary =>
      '活動運営、予約進行、顧客対応に必要な範囲で個人情報が第三者へ提供される基準を説明します。';

  @override
  String get onboardingTermsPrivacySection1Title => '提供先';

  @override
  String get onboardingTermsPrivacySection1Body =>
      'MateYa内でグループやクラスを運営するホスト、またはサービス運営に必要な提携事業者';

  @override
  String get onboardingTermsPrivacySection2Title => '提供目的';

  @override
  String get onboardingTermsPrivacySection2Body =>
      '参加申請の確認、ホストとの円滑な日程調整、現場運営支援、顧客問い合わせ対応、紛争処理';

  @override
  String get onboardingTermsPrivacySection3Title => '提供項目';

  @override
  String get onboardingTermsPrivacySection3Body =>
      '氏名、電話番号、活動申請情報、代表言語、参加履歴のうち、サービス提供に必要な最小項目';

  @override
  String get onboardingTermsPrivacySection4Title => '保有および利用期間';

  @override
  String get onboardingTermsPrivacySection4Body =>
      '提供目的の達成時まで、または法令上保存義務のある期間まで保管し、その後は遅滞なく削除または匿名化します。';

  @override
  String get onboardingTermsPrivacySection5Title => '同意拒否権および不利益';

  @override
  String get onboardingTermsPrivacySection5Body =>
      '会員は個人情報の第三者提供への同意を拒否できます。ただし、活動参加、予約確認、ホストとの連絡が必要な一部サービスの利用が制限されることがあります。';

  @override
  String get onboardingTermsLocationTitle => '位置情報サービス利用規約';

  @override
  String get onboardingTermsLocationSummary =>
      '現在地や活動地域情報を活用して周辺のグループやおすすめ結果を提供する方法と、その保護基準を案内します。';

  @override
  String get onboardingTermsLocationSection1Title => '目的';

  @override
  String get onboardingTermsLocationSection1Body =>
      '本規約は、MateYaが提供する位置情報サービスの利用条件と手続き、会社と利用者の権利義務、位置情報保護基準を案内することを目的とします。';

  @override
  String get onboardingTermsLocationSection2Title => '位置情報の収集および利用';

  @override
  String get onboardingTermsLocationSection2Body =>
      '会社は、利用者が要求した機能の範囲内で現在地または活動地域情報を活用し、次の目的に限って位置情報を利用します。';

  @override
  String get onboardingTermsLocationSection2Point1 => '地域認証と活動地域の確認';

  @override
  String get onboardingTermsLocationSection2Point2 => '周辺グループのおすすめと距離順ソート';

  @override
  String get onboardingTermsLocationSection2Point3 =>
      '地域に合わせたコンテンツと、より安全な参加体験の提供';

  @override
  String get onboardingTermsLocationSection3Title => '保有および利用期間';

  @override
  String get onboardingTermsLocationSection3Body =>
      'リアルタイム位置情報は即時性のある機能処理後には保管しません。ただし、活動地域認証結果などサービス運営に必要な最小情報は、法令または内部運営基準に従って必要期間保管した後、遅滞なく削除または匿名化します。';

  @override
  String get onboardingTermsLocationSection4Title => '利用者の権利';

  @override
  String get onboardingTermsLocationSection4Body =>
      '利用者は、端末設定またはアプリ内権限設定を通じて、いつでも位置情報提供への同意を撤回でき、位置情報サービスの利用可否を選択できます。同意を撤回した場合、一部のおすすめ機能や地域認証機能の利用が制限されることがあります。';

  @override
  String get onboardingTermsLocationSection5Title => '会社の義務';

  @override
  String get onboardingTermsLocationSection5Body =>
      '会社は、位置情報を関係法令および内部セキュリティ基準に従って安全に管理し、利用目的を超えた使用や別途同意のない第三者提供を行いません。また、利用者からの問い合わせや苦情を迅速に確認し、必要な案内を行います。';

  @override
  String get onboardingTermsLocationSection6Title => 'お問い合わせ先';

  @override
  String get onboardingTermsLocationSection6Body =>
      '位置情報サービス利用に関するお問い合わせは、アプリ内サポートチャネルまたは運営チームのお問い合わせ窓口から受け付けます。受付内容は内部ポリシーに従って順次処理されます。';

  @override
  String get onboardingTermsAgeTitle => '14歳以上の確認';

  @override
  String get onboardingTermsAgeSummary =>
      'MateYaの会員登録は14歳以上のみ可能であり、年齢確認に関する利用制限基準を案内します。';

  @override
  String get onboardingTermsAgeSection1Title => '年齢確認';

  @override
  String get onboardingTermsAgeSection1Body =>
      '会員は会員登録時に、自身が14歳以上であることを確認し、これに同意する必要があります。';

  @override
  String get onboardingTermsAgeSection2Title => '登録制限';

  @override
  String get onboardingTermsAgeSection2Body =>
      '14歳未満のユーザーはMateYaへの会員登録およびサービス利用が制限されます。';

  @override
  String get onboardingTermsAgeSection3Title => '虚偽確認への措置';

  @override
  String get onboardingTermsAgeSection3Body =>
      '年齢を偽って登録したことが確認された場合、サービス利用制限、アカウント解約、または追加確認手続きが行われることがあります。';

  @override
  String get chatAttachmentRecoveryFailed =>
      '先ほど選択していた写真を復元できませんでした。もう一度選択してください。';

  @override
  String get chatAttachmentSheetTitle => '写真を添付';

  @override
  String get chatAttachmentSheetDescription =>
      'アルバムから複数の写真を選ぶか、カメラですぐ撮影して送信できます。';

  @override
  String get chatAttachmentGalleryTitle => 'アルバムから選択';

  @override
  String get chatAttachmentGallerySubtitle => '複数枚をまとめて選択できます。';

  @override
  String get chatAttachmentCameraTitle => 'カメラで撮影';

  @override
  String get chatAttachmentCameraSubtitle => '写真を1枚すぐに撮って添付します。';

  @override
  String get chatAttachmentGuideFormats =>
      '対応形式: JPG, PNG, WEBP, GIF, HEIC, HEIF';

  @override
  String get chatAttachmentGuideMaxSize => '最大サイズ: 10MB';

  @override
  String chatAttachmentGuideMaxCount(int count) {
    return '1メッセージあたり最大 $count 枚';
  }

  @override
  String get chatAttachmentPhotoPermissionTitle => '写真権限のご案内';

  @override
  String get chatAttachmentCameraPermissionTitle => 'カメラ権限のご案内';

  @override
  String get chatAttachmentPhotoPermissionMessage =>
      'チャットで写真を添付するには写真ライブラリへのアクセス権限が必要です。権限を拒否してもテキストチャットは引き続き利用できます。';

  @override
  String get chatAttachmentCameraPermissionMessage =>
      'チャットで写真を撮影して送るにはカメラ権限が必要です。権限を拒否してもテキストチャットは引き続き利用できます。';

  @override
  String get chatAttachmentPhotoSelect => '写真を選択';

  @override
  String get chatAttachmentOpenCamera => 'カメラを開く';

  @override
  String get chatAttachmentPhotoRecoveryTitle => '写真へのアクセス権限が必要です';

  @override
  String get chatAttachmentCameraRecoveryTitle => 'カメラ権限が必要です';

  @override
  String get chatAttachmentPhotoRecoveryMessage =>
      '写真を添付するには写真ライブラリへのアクセス権限が必要です。権限がなくてもテキストチャットは続けられ、再試行するかアプリ設定で権限を許可できます。';

  @override
  String get chatAttachmentCameraRecoveryMessage =>
      'チャットで撮影した写真を添付するにはカメラ権限が必要です。権限がなくてもテキストチャットは続けられ、再試行するかアプリ設定で権限を許可できます。';

  @override
  String get chatAttachmentLoadFailed => '写真を読み込めませんでした。権限とファイル状態を確認してください。';

  @override
  String chatAttachmentAddedCount(int count) {
    return '写真を $count 枚添付しました。';
  }

  @override
  String chatAttachmentRejectedTypeCount(int count) {
    return '対応していない形式の写真 $count 枚を除外しました。';
  }

  @override
  String chatAttachmentRejectedSizeCount(int count) {
    return '10MB を超える写真 $count 枚を除外しました。';
  }

  @override
  String chatAttachmentOverflowCount(int count) {
    return '写真は最大 $count 枚まで添付できます。';
  }

  @override
  String get chatAttachmentPhotoOnly => '写真';

  @override
  String get chatAttachmentInvalidFormat =>
      '送信できる画像形式は JPG、PNG、WEBP、GIF、HEIC、HEIF のみです。';

  @override
  String get chatAttachmentUploadFailed =>
      'チャット画像をアップロードできませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get chatListLoadError => 'チャット一覧を読み込めませんでした。';

  @override
  String get chatListEmptyTitle => '表示できるチャットルームがありません。';

  @override
  String get chatListEmptyBody => 'フィルターを変更するか、新しい会話を始めてみてください。';

  @override
  String get chatListLoadMoreHint => 'スクロールするとチャットルームをさらに読み込みます。';

  @override
  String get chatListLoadMoreFailedNetwork =>
      'チャットルームをさらに読み込めませんでした。ネットワークを確認してください。';

  @override
  String get chatListLoadMoreFailedServer =>
      'チャットルームをさらに読み込めませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get chatRoomMissing => 'チャットルーム情報が見つかりません。';

  @override
  String get chatBackToList => '一覧へ';

  @override
  String get chatRoomLoadError => 'チャットルームを読み込めませんでした。';

  @override
  String get chatOlderMessagesHint => '上にスクロールすると以前のメッセージをさらに読み込みます。';

  @override
  String get chatOlderMessagesFailedNetwork =>
      '以前のメッセージを読み込めませんでした。ネットワークを確認してください。';

  @override
  String get chatOlderMessagesFailedServer =>
      '以前のメッセージを読み込めませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get chatReadSyncFailed => '既読状態をサーバーに反映できませんでした。後でもう一度試します。';

  @override
  String get chatSendFailedNetwork => 'メッセージを送信できませんでした。ネットワークを確認してください。';

  @override
  String get chatSendFailedServer => 'メッセージを送信できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get chatMe => '自分';

  @override
  String get chatDefaultDirectRoomTitle => '1対1チャット';

  @override
  String get chatDefaultGroupRoomTitle => 'チャットルーム';

  @override
  String get chatRealtimeConnectionError => 'リアルタイムチャットに接続できませんでした。';

  @override
  String get chatRealtimeMessageError => 'リアルタイムチャットメッセージを処理できませんでした。';

  @override
  String get homeActivityRegionFallback => '活動地域';

  @override
  String get homeNearbyMapLoadError => '地図上の場所を読み込めませんでした。';

  @override
  String get homeNearbyMapCurrentLocationLabel => '現在地基準';

  @override
  String get homeNearbyMapSearchHint => '何を探しますか？';

  @override
  String get homeNearbyMapEmptyTitle => '周辺の場所が見つかりませんでした';

  @override
  String get homeNearbyMapEmptyBody => '検索語を変えるか、現在地を再読み込みしてください。';

  @override
  String get homeNearbyMapListTitle => '周辺の場所一覧';

  @override
  String homeNearbyMapPlaceCount(int count) {
    return '$countか所';
  }

  @override
  String get homeNearbyMapListButton => '一覧を見る';

  @override
  String get homeNearbyMapBadgeFallback => '周辺の場所';

  @override
  String get homeNearbyMapParseError => '場所データを解析できませんでした。';

  @override
  String get homeNearbyMapLocationLoadError => '現在地を取得できませんでした。';

  @override
  String get homeNearbyMapLocationRefreshError => '現在地を再取得できませんでした。';

  @override
  String get homeNearbyMapLocationRequired => '地図を見るには先に位置情報を確認してください。';

  @override
  String get homeNearbyMapPlacesLoadError =>
      '場所を読み込めませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsActivityRequired => '先にアクティビティ情報を読み込んでください。';

  @override
  String get detailsFavoriteToggleError =>
      'お気に入り状態を変更できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsJoinAlreadyRequested => 'このアクティビティにはすでに参加申請しています。';

  @override
  String get detailsJoinAlreadyJoined => 'このアクティビティにはすでに参加中です。';

  @override
  String get detailsJoinHostedByMe => '自分が作成したアクティビティです。';

  @override
  String get detailsJoinRequestError => '参加申請を完了できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsParticipantRemoveError =>
      '参加者を削除できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsPendingCancelError => '申請を取り消せませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsPendingApproveError =>
      '参加申請を承認できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsReviewRequired => '先にレビュー情報を読み込んでください。';

  @override
  String get detailsHelpfulToggleError =>
      '「参考になった」の状態を変更できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsReviewValidationRequired => '評価とレビューの両方を入力してください。';

  @override
  String get detailsReviewSubmitError => 'レビューを投稿できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsLoadError => 'アクティビティ情報を読み込めませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsReviewSortLatest => '新しい順';

  @override
  String get detailsReviewSortOldest => '古い順';

  @override
  String get detailsReviewSortHighestRating => '評価が高い順';

  @override
  String get detailsReviewSortLowestRating => '評価が低い順';

  @override
  String get detailsJoinAvailable => '参加する';

  @override
  String get detailsJoinRequested => '申請済み';

  @override
  String get detailsJoinJoined => '参加中';

  @override
  String get detailsJoinHost => '自分の会';

  @override
  String detailsReviewSummary(Object average, int count) {
    return '$average (レビュー$count件)';
  }

  @override
  String detailsParticipantSummary(int current, int capacity) {
    return '$current/$capacity人参加';
  }

  @override
  String detailsParticipantsJoined(int count) {
    return '$count人参加中';
  }

  @override
  String detailsParticipantsRemaining(int count) {
    return '残り$count人';
  }

  @override
  String get detailsRecruitmentClosed => '募集終了';

  @override
  String get detailsIntroduction => 'アクティビティ紹介';

  @override
  String detailsReviewsTitle(int count) {
    return 'レビュー$count件';
  }

  @override
  String get detailsReviewsEmpty => 'まだレビューがありません。最初のレビューを残してみましょう。';

  @override
  String get detailsPriceLabel => '体験料';

  @override
  String get detailsJoinRequesting => '申請中...';

  @override
  String detailsReviewRatingSummary(int count) {
    return 'レビュー全$count件';
  }

  @override
  String detailsReviewRating(int rating) {
    return '$rating点';
  }

  @override
  String detailsReviewHelpfulCount(int count) {
    return '$count人の参考になりました';
  }

  @override
  String get detailsReviewViewOriginal => '原文を見る';

  @override
  String get detailsReviewViewTranslation => '翻訳を見る';

  @override
  String get detailsRepresentativeImage => '代表';

  @override
  String get detailsReviewGalleryNotice =>
      'レビューに写真を添付するには写真ライブラリへのアクセス権が必要です。権限を許可しなくても、テキストレビューの作成と評価の登録は続けられます。';

  @override
  String get detailsReviewGalleryRecovery =>
      'レビュー写真を添付するには写真ライブラリへのアクセス権が必要です。権限がなくてもテキストレビューと評価の登録は続けられ、再試行するかアプリ設定で権限を許可できます。';

  @override
  String get detailsReviewGalleryFailure =>
      '写真を読み込めませんでした。権限とファイルの状態を確認してください。';

  @override
  String get detailsReviewGalleryRestoreError =>
      '選択中だったレビュー画像を復元できませんでした。もう一度選択してください。';

  @override
  String detailsReviewRestoredCount(int restoredCount) {
    return '選択中だったレビュー画像を$restoredCount枚復元しました。';
  }

  @override
  String get detailsReviewSubmitted => 'レビューを投稿しました。';

  @override
  String get detailsReviewComposerTitle => 'レビューを書く';

  @override
  String get detailsReviewComposerHint =>
      'アクティビティで良かった点や、\n次の参加者の参考になる内容を書いてください。';

  @override
  String detailsBodyCount(int count, int max) {
    return '$count/$max文字';
  }

  @override
  String detailsReviewImageSectionTitle(int max) {
    return '画像 (最大$max枚)';
  }

  @override
  String get detailsReviewSubmitting => '投稿中...';

  @override
  String get detailsReviewSubmit => '投稿する';

  @override
  String get detailsReviewImageGuide => '1枚目の写真が代表画像になります。\n長押しで順番を変更できます。';

  @override
  String get detailsShareCopied => '共有リンクをコピーしました。お好きなメッセンジャーにそのまま貼り付けられます。';

  @override
  String get detailsReportActivityReload => 'アクティビティ情報を再読み込みしてから通報してください。';

  @override
  String get detailsParticipantsListTitle => '参加ユーザー一覧';

  @override
  String get detailsParticipantRemoved => '参加者を削除しました。';

  @override
  String get detailsPendingParticipantsListTitle => '申請ユーザー一覧';

  @override
  String get detailsPendingCancelled => '申請を取り消しました。';

  @override
  String get detailsParticipantSwipeHint => 'スワイプして削除または取り消しできます';

  @override
  String detailsReviewListReportSubject(Object title) {
    return '$title レビュー一覧';
  }

  @override
  String get detailsReviewLoadMoreHint => 'スクロールするとレビューをさらに読み込みます。';

  @override
  String get detailsReviewImageInvalidFormat =>
      'JPG、PNG、WEBP、GIF形式のレビュー画像のみアップロードできます。';

  @override
  String get detailsReviewImageUploadError =>
      'レビュー画像をアップロードできませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get detailsMe => '自分';

  @override
  String get commonInvalidServerResponse => 'サーバー応答の形式が正しくありません。';

  @override
  String onboardingVerificationResendLimitNotice(int count) {
    return '認証コードは1日最大5回まで再送できます。現在 $count 回リクエストしています。';
  }

  @override
  String get onboardingVerificationResendLimitReached =>
      '認証コードは1日最大5回まで再送できます。';

  @override
  String get onboardingVerificationSent => '認証コードを送信しました。';

  @override
  String get onboardingVerificationResent => '認証コードを再送しました。';

  @override
  String get onboardingBusinessVerificationCompleted =>
      '事業者認証が完了しました。続けて電話認証を進めてください。';

  @override
  String get onboardingConsentRequired => '必須の利用規約にすべて同意してください。';

  @override
  String get homeExploreLoadMoreFailedNetwork =>
      '追加の結果を読み込めませんでした。ネットワークを確認してください。';

  @override
  String get homeExploreLoadMoreFailedServer =>
      '追加の結果を読み込めませんでした。しばらくしてからもう一度お試しください。';
}
