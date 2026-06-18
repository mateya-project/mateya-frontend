import 'package:flutter/foundation.dart';

import '../../../features/onboarding/domain/onboarding_flow.dart';
import '../data/mypage_repository.dart';
import '../domain/mypage_models.dart';

class MyPageController extends ChangeNotifier {
  MyPageController({
    required this.repository,
    required this.flowKind,
    this.initialOtherProfileUserId,
  });

  final MyPageRepository repository;
  final FlowKind? flowKind;
  final String? initialOtherProfileUserId;

  MyPageAsyncPhase _phase = MyPageAsyncPhase.idle;
  MyPageRoute _route = MyPageRoute.personalHome;
  PersonalMyPageData? _personalPage;
  OtherProfileData? _otherProfile;
  RecentActivityData? _recentActivity;
  BusinessMyPageData? _businessPage;
  List<SelectionOption> _languageOptions = const <SelectionOption>[];
  List<SelectionOption> _countryOptions = const <SelectionOption>[];
  List<ConsentHistoryEntry> _consentHistory = const <ConsentHistoryEntry>[];
  List<BlockedUserSummary> _blockedUsers = const <BlockedUserSummary>[];
  String? _errorMessage;
  String? _toastMessage;
  int _toastVersion = 0;
  bool _isSavingPreferences = false;
  bool _isUpdatingFriendship = false;
  bool _isSavingBusinessIntroduction = false;
  bool _isSubmittingWithdrawal = false;
  bool _isLoggingOut = false;
  bool _withdrawalCompleted = false;
  String? _currentOtherProfileUserId;

  MyPageAsyncPhase get phase => _phase;
  MyPageRoute get route => _route;
  PersonalMyPageData? get personalPage => _personalPage;
  OtherProfileData? get otherProfile => _otherProfile;
  RecentActivityData? get recentActivity => _recentActivity;
  BusinessMyPageData? get businessPage => _businessPage;
  List<SelectionOption> get languageOptions => _languageOptions;
  List<SelectionOption> get countryOptions => _countryOptions;
  List<ConsentHistoryEntry> get consentHistory => _consentHistory;
  List<BlockedUserSummary> get blockedUsers => _blockedUsers;
  String? get errorMessage => _errorMessage;
  String? get toastMessage => _toastMessage;
  int get toastVersion => _toastVersion;
  bool get isSavingPreferences => _isSavingPreferences;
  bool get isUpdatingFriendship => _isUpdatingFriendship;
  bool get isSavingBusinessIntroduction => _isSavingBusinessIntroduction;
  bool get isSubmittingWithdrawal => _isSubmittingWithdrawal;
  bool get isLoggingOut => _isLoggingOut;
  bool get withdrawalCompleted => _withdrawalCompleted;

  bool get isBusinessMode => flowKind == FlowKind.host;

  Future<void> initialize() async {
    if (_phase != MyPageAsyncPhase.idle) {
      return;
    }
    await _loadBundle();
    if (initialOtherProfileUserId != null &&
        initialOtherProfileUserId!.isNotEmpty) {
      await openOtherProfile(targetUserId: initialOtherProfileUserId!);
    }
  }

  Future<void> retry() => _loadBundle();

  void clearToast() {
    _toastMessage = null;
  }

  void clearError() {
    _clearErrorWithoutNotify();
    notifyListeners();
  }

  void openRoot() {
    _clearErrorWithoutNotify();
    _route = isBusinessMode
        ? MyPageRoute.businessHome
        : MyPageRoute.personalHome;
    notifyListeners();
  }

  void openPersonalHome() {
    _clearErrorWithoutNotify();
    _route = MyPageRoute.personalHome;
    notifyListeners();
  }

  Future<void> openOtherProfile({String? targetUserId}) async {
    final nextTargetUserId = targetUserId ?? _currentOtherProfileUserId;
    if (nextTargetUserId == null || nextTargetUserId.isEmpty) {
      _pushToast('다른 사용자 프로필은 활동 상세의 호스트나 참여자에서 열 수 있어요.');
      notifyListeners();
      return;
    }

    _clearErrorWithoutNotify();
    _route = MyPageRoute.otherProfile;
    _isUpdatingFriendship = false;
    _phase = MyPageAsyncPhase.loading;
    notifyListeners();

    try {
      _otherProfile = await repository.fetchOtherProfile(
        targetUserId: nextTargetUserId,
      );
      _currentOtherProfileUserId = nextTargetUserId;
      _phase = MyPageAsyncPhase.success;
      _errorMessage = null;
    } on MyPageRepositoryException catch (error) {
      _phase = error.type == MyPageLoadFailureType.network
          ? MyPageAsyncPhase.networkError
          : MyPageAsyncPhase.serverError;
      _errorMessage =
          error.message ??
          (error.type == MyPageLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '다른 사용자 프로필을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
    }
    notifyListeners();
  }

  void openRecentActivities() {
    _clearErrorWithoutNotify();
    _route = MyPageRoute.recentActivities;
    notifyListeners();
  }

  void openSettings() {
    _clearErrorWithoutNotify();
    _route = MyPageRoute.settings;
    notifyListeners();
  }

  void openConsentHistory() {
    _clearErrorWithoutNotify();
    _route = MyPageRoute.consentHistory;
    notifyListeners();
  }

  void openBlockedUsers() {
    _clearErrorWithoutNotify();
    _route = MyPageRoute.blockedUsers;
    notifyListeners();
  }

  void openPrimaryPreferences() {
    openSettings();
  }

  void openWithdrawal() {
    _clearErrorWithoutNotify();
    _route = MyPageRoute.settings;
    notifyListeners();
  }

  void openBusinessHome() {
    _clearErrorWithoutNotify();
    _route = MyPageRoute.businessHome;
    notifyListeners();
  }

  Future<void> updatePrimaryPreferences({
    required String languageCode,
    required String countryCode,
  }) async {
    if (_personalPage == null) {
      return;
    }
    if (languageCode.isEmpty || countryCode.isEmpty) {
      _phase = MyPageAsyncPhase.validationError;
      _errorMessage = '대표 언어와 대표 나라를 모두 선택해 주세요.';
      notifyListeners();
      return;
    }

    final language = _languageOptions
        .where((item) => item.code == languageCode)
        .firstOrNull;
    final country = _countryOptions
        .where((item) => item.code == countryCode)
        .firstOrNull;

    if (language == null || country == null) {
      _phase = MyPageAsyncPhase.validationError;
      _errorMessage = '선택 가능한 언어/나라를 다시 확인해 주세요.';
      notifyListeners();
      return;
    }

    _isSavingPreferences = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _personalPage = await repository.updatePrimaryPreferences(
        displayName: _personalPage!.profile.name,
        languageCode: language.code,
        countryCode: country.code,
      );
      _phase = MyPageAsyncPhase.success;
      _isSavingPreferences = false;
      _route = MyPageRoute.personalHome;
      _pushToast('대표 언어와 대표 나라를 반영했어요.');
    } on MyPageRepositoryException catch (error) {
      _phase = MyPageAsyncPhase.validationError;
      _isSavingPreferences = false;
      _errorMessage =
          error.message ??
          (error.type == MyPageLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '대표 언어와 대표 나라를 저장하지 못했어요. 잠시 후 다시 시도해 주세요.');
    }
    notifyListeners();
  }

  Future<void> toggleFriendship() async {
    if (_otherProfile == null ||
        _isUpdatingFriendship ||
        _otherProfile!.isBlocked ||
        _currentOtherProfileUserId == null) {
      return;
    }

    _isUpdatingFriendship = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final wasFriend = _otherProfile!.isFriend;
      _otherProfile = await repository.updateFriendship(
        targetUserId: _currentOtherProfileUserId!,
        isFriend: wasFriend,
      );
      _phase = MyPageAsyncPhase.success;
      _isUpdatingFriendship = false;
      _pushToast(wasFriend ? '친구 상태를 해제했어요.' : '친구를 추가했어요.');
    } on MyPageRepositoryException catch (error) {
      _phase = MyPageAsyncPhase.validationError;
      _isUpdatingFriendship = false;
      _errorMessage =
          error.message ??
          (error.type == MyPageLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '친구 상태를 변경하지 못했어요. 잠시 후 다시 시도해 주세요.');
    }
    notifyListeners();
  }

  void blockCurrentOtherProfile() {
    if (_otherProfile == null || _otherProfile!.isBlocked) {
      return;
    }

    final profile = _otherProfile!.profile;
    _blockedUsers = <BlockedUserSummary>[
      BlockedUserSummary(
        id: profile.id,
        name: profile.name,
        residence: profile.residence,
        profileImageUrl: profile.profileImageUrl,
      ),
      ..._blockedUsers.where((user) => user.id != profile.id),
    ];
    _otherProfile = _otherProfile!.copyWith(isBlocked: true, isFriend: false);
    _pushToast('차단 유저 목록에 추가했어요.');
    notifyListeners();
  }

  void unblockUser(String userId) {
    final target = _blockedUsers.where((user) => user.id == userId).firstOrNull;
    if (target == null) {
      return;
    }

    _blockedUsers = _blockedUsers
        .where((user) => user.id != userId)
        .toList(growable: false);
    if (_otherProfile?.profile.id == userId) {
      _otherProfile = _otherProfile?.copyWith(isBlocked: false);
    }
    _pushToast('차단을 해제하였습니다.');
    notifyListeners();
  }

  Future<void> updateBusinessIntroduction(String nextIntroduction) async {
    if (_businessPage == null) {
      return;
    }
    final trimmed = nextIntroduction.trim();
    if (trimmed.isEmpty) {
      _phase = MyPageAsyncPhase.validationError;
      _errorMessage = '한줄소개를 입력해 주세요.';
      notifyListeners();
      return;
    }
    if (trimmed.length > 500) {
      _phase = MyPageAsyncPhase.validationError;
      _errorMessage = '한줄소개는 500자 이하로 입력해 주세요.';
      notifyListeners();
      return;
    }

    _isSavingBusinessIntroduction = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _businessPage = await repository.updateBusinessIntroduction(
        introduction: trimmed,
        placeName: _businessPage!.profile.placeLabel,
        placeAddress: _businessPage!.profile.residence,
      );
      _phase = MyPageAsyncPhase.success;
      _isSavingBusinessIntroduction = false;
      _pushToast('한줄소개를 저장했어요.');
    } on MyPageRepositoryException catch (error) {
      _phase = MyPageAsyncPhase.validationError;
      _isSavingBusinessIntroduction = false;
      _errorMessage =
          error.message ??
          (error.type == MyPageLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '한줄소개를 저장하지 못했어요. 잠시 후 다시 시도해 주세요.');
    }
    notifyListeners();
  }

  Future<void> submitWithdrawal({
    required bool hasAgreed,
    required String signature,
  }) async {
    final name = _personalPage?.profile.name ?? '';
    final trimmed = signature.trim();

    if (!hasAgreed) {
      _phase = MyPageAsyncPhase.validationError;
      _errorMessage = '개인정보 처리 방침에 동의해 주세요.';
      notifyListeners();
      return;
    }
    if (trimmed.isEmpty) {
      _phase = MyPageAsyncPhase.validationError;
      _errorMessage = '서명 입력이 필요합니다.';
      notifyListeners();
      return;
    }
    if (trimmed != name) {
      _phase = MyPageAsyncPhase.validationError;
      _errorMessage = '서명은 현재 프로필 이름과 동일하게 입력해 주세요.';
      notifyListeners();
      return;
    }

    _isSubmittingWithdrawal = true;
    _errorMessage = null;
    _withdrawalCompleted = false;
    notifyListeners();

    try {
      await repository.submitWithdrawal(
        agreementText: '개인정보 관리 및 30일 후 최종 삭제 정책에 동의합니다.',
      );
      _phase = MyPageAsyncPhase.success;
      _isSubmittingWithdrawal = false;
      _withdrawalCompleted = true;
      _pushToast('탈퇴 요청을 접수했어요. 계정은 비활성화되며 30일 뒤 최종 삭제됩니다.');
    } on MyPageRepositoryException catch (error) {
      _phase = MyPageAsyncPhase.validationError;
      _isSubmittingWithdrawal = false;
      _withdrawalCompleted = false;
      _errorMessage =
          error.message ??
          (error.type == MyPageLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '탈퇴 요청을 처리하지 못했어요. 잠시 후 다시 시도해 주세요.');
    }
    notifyListeners();
  }

  Future<bool> logout() async {
    if (_isLoggingOut) {
      return false;
    }

    _isLoggingOut = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.logout();
      _phase = MyPageAsyncPhase.success;
      return true;
    } on MyPageRepositoryException catch (error) {
      _phase = MyPageAsyncPhase.validationError;
      _errorMessage =
          error.message ??
          (error.type == MyPageLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '로그아웃하지 못했어요. 잠시 후 다시 시도해 주세요.');
      _pushToast(_errorMessage!);
      return false;
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }

  Future<void> _loadBundle() async {
    _phase = MyPageAsyncPhase.loading;
    _errorMessage = null;
    _route = isBusinessMode
        ? MyPageRoute.businessHome
        : MyPageRoute.personalHome;
    notifyListeners();

    try {
      final bundle = await repository.fetchBundle(
        isBusinessMode: isBusinessMode,
      );
      _personalPage = bundle.personalPage;
      _otherProfile = bundle.otherProfile;
      _recentActivity = bundle.recentActivity;
      _businessPage = bundle.businessPage;
      _languageOptions = bundle.languageOptions;
      _countryOptions = bundle.countryOptions;
      _consentHistory = bundle.consentHistory;
      _blockedUsers = bundle.blockedUsers;
      _phase = MyPageAsyncPhase.success;
      _errorMessage = null;
    } on MyPageRepositoryException catch (error) {
      _phase = error.type == MyPageLoadFailureType.network
          ? MyPageAsyncPhase.networkError
          : MyPageAsyncPhase.serverError;
      _errorMessage =
          error.message ??
          (error.type == MyPageLoadFailureType.network
              ? '네트워크 연결을 확인한 뒤 다시 시도해 주세요.'
              : '마이페이지 데이터를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
    } catch (_) {
      _phase = MyPageAsyncPhase.serverError;
      _errorMessage = '마이페이지 데이터를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
    }

    notifyListeners();
  }

  void _pushToast(String message) {
    _toastMessage = message;
    _toastVersion += 1;
  }

  void _clearErrorWithoutNotify() {
    _errorMessage = null;
    if (_phase == MyPageAsyncPhase.validationError) {
      _phase = MyPageAsyncPhase.success;
    }
  }
}
