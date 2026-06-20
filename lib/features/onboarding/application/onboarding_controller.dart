// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../shared/auth/auth_session.dart';
import '../../../shared/preferences/mateya_language_preferences.dart';
import '../../../shared/logging/app_logger.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../data/auth_repository.dart';
import '../data/location_repository.dart';
import '../domain/onboarding_flow.dart';
import '../domain/onboarding_validators.dart';

part 'onboarding_controller_auth.dart';
part 'onboarding_controller_business.dart';
part 'onboarding_controller_completion.dart';
part 'onboarding_controller_form.dart';
part 'onboarding_controller_flow.dart';
part 'onboarding_controller_location.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required NeighborhoodLocationRepository locationRepository,
    required OnboardingAuthRepository authRepository,
    required AuthSessionStore authSessionStore,
  }) : _locationRepository = locationRepository,
       _authRepository = authRepository,
       _authSessionStore = authSessionStore;

  final NeighborhoodLocationRepository _locationRepository;
  final OnboardingAuthRepository _authRepository;
  final AuthSessionStore _authSessionStore;
  AppLogger get _logger => AppLogger.instance;

  OnboardingStep _step = OnboardingStep.welcome;
  FlowKind? _flowKind;
  AgreementState _agreementState = const AgreementState();
  AsyncPhase _authPhase = AsyncPhase.idle;
  AsyncPhase _locationPhase = AsyncPhase.idle;
  AuthCompletionMode _completionMode = AuthCompletionMode.signup;
  NeighborhoodSelection? _selectedNeighborhood;
  LocationFailure? _locationFailure;
  Map<String, String?> _fieldErrors = <String, String?>{};
  HomePreviewSection _homePreviewSection = HomePreviewSection.home;

  Timer? _verificationTimer;
  Timer? _manualLookupDebounce;
  int _remainingSeconds = 0;
  int _resendCount = 0;
  DateTime? _smsCodeExpiresAt;
  String? _expectedVerificationCode;
  String? _verificationNotice;
  String? _verificationToken;
  DateTime? _verificationTokenExpiresAt;
  String? _businessVerificationToken;
  DateTime? _businessVerificationExpiresAt;

  String _name = '';
  String _phoneNumber = '';
  String _verificationCode = '';
  String _manualNeighborhoodQuery = '';
  String _businessName = '';
  String _businessOwner = '';
  String _businessOpeningDate = '';
  String _businessNumberFirst = '';
  String _businessNumberSecond = '';
  String _businessNumberThird = '';

  String? _toastMessage;
  int _toastVersion = 0;

  OnboardingStep get step => _step;
  FlowKind? get flowKind => _flowKind;
  AgreementState get agreementState => _agreementState;
  AsyncPhase get authPhase => _authPhase;
  AsyncPhase get locationPhase => _locationPhase;
  AuthCompletionMode get completionMode => _completionMode;
  NeighborhoodSelection? get selectedNeighborhood => _selectedNeighborhood;
  LocationFailure? get locationFailure => _locationFailure;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get verificationCode => _verificationCode;
  int get remainingSeconds => _remainingSeconds;
  int get resendCount => _resendCount;
  String? get debugVerificationCode =>
      kDebugMode ? _expectedVerificationCode : null;
  String? get verificationNotice => _verificationNotice;
  String get manualNeighborhoodQuery => _manualNeighborhoodQuery;
  String get businessName => _businessName;
  String get businessOwner => _businessOwner;
  String get businessOpeningDate => _businessOpeningDate;
  String get businessNumberFirst => _businessNumberFirst;
  String get businessNumberSecond => _businessNumberSecond;
  String get businessNumberThird => _businessNumberThird;
  String? get toastMessage => _toastMessage;
  int get toastVersion => _toastVersion;
  HomePreviewSection get homePreviewSection => _homePreviewSection;
  bool get isAuthLoading => _authPhase == AsyncPhase.loading;

  String? errorFor(String fieldName) => _fieldErrors[fieldName];

  bool get isConsentComplete => _agreementState.isAllChecked;
  bool get canContinueName => _name.trim().isNotEmpty;
  bool get canSendVerificationCode =>
      OnboardingValidators.validatePhoneNumber(_phoneNumber) == null;
  bool get hasSentVerificationCode =>
      _smsCodeExpiresAt?.isAfter(DateTime.now()) ?? false;
  bool get canSubmitVerificationCode => _verificationCode.length == 6;
  bool get canCompleteNeighborhood => _selectedNeighborhood != null;
  bool get canCompleteBusiness =>
      _businessName.trim().isNotEmpty &&
      _businessOwner.trim().isNotEmpty &&
      _businessOpeningDate.length == 8 &&
      _businessNumberFirst.length == 3 &&
      _businessNumberSecond.length == 2 &&
      _businessNumberThird.length == 5;

  String get completedName {
    if (_completionMode == AuthCompletionMode.login) {
      final sessionDisplayName = _authSessionStore.session?.user.displayName
          .trim();
      if (sessionDisplayName != null && sessionDisplayName.isNotEmpty) {
        return sessionDisplayName;
      }
    }
    if (_flowKind == FlowKind.host && _businessOwner.trim().isNotEmpty) {
      return _businessOwner.trim();
    }
    return _name.trim().isEmpty ? '메이트야 회원' : _name.trim();
  }

  String get _signupDisplayName {
    if (_flowKind == FlowKind.host && _businessOwner.trim().isNotEmpty) {
      return _businessOwner.trim();
    }
    return _name.trim().isEmpty ? '메이트야 회원' : _name.trim();
  }

  String get completionHeadline => switch (_completionMode) {
    AuthCompletionMode.login => '$completedName님\n메이트야 로그인을 완료했어요',
    AuthCompletionMode.signup => '$completedName님\n메이트야 가입을 완료했어요',
  };

  String get neighborhoodHeadline => switch (_completionMode) {
    AuthCompletionMode.login => '돌아오신걸 환영해요\n$completedName님!\n동네 정보를 인증해주세요',
    AuthCompletionMode.signup => '동네 정보를 인증해주세요',
  };

  String? get previousNeighborhoodLabel =>
      _authSessionStore.session?.user.activityRegionName;

  String get resolvedNeighborhoodMessage {
    final neighborhood = _selectedNeighborhood?.displayName ?? '동네';
    return '현재 위치가 “$neighborhood”에 있어요.';
  }

  void clearToast() {
    _toastMessage = null;
  }

  void startGuestFlow() => _startGuestFlow(this);

  void startHostFlow() => _startHostFlow(this);

  void toggleAllAgreements(bool value) => _toggleAllAgreements(this, value);

  void toggleAgreement({
    bool? service,
    bool? privacy,
    bool? location,
    bool? age,
  }) => _toggleAgreement(
    this,
    service: service,
    privacy: privacy,
    location: location,
    age: age,
  );

  void confirmConsent() => _confirmConsent(this);

  void updateName(String value) => _updateName(this, value);

  bool validateNameField() => _validateNameField(this);

  void submitName() => _submitName(this);

  void updatePhoneNumber(String value) => _updatePhoneNumber(this, value);

  void updateVerificationCode(String value) {
    _updateVerificationCode(this, value);
  }

  Future<void> sendVerificationCode() => _sendVerificationCode(this);

  Future<void> resendVerificationCode() => _resendVerificationCode(this);

  Future<void> submitVerificationCode() => _submitVerificationCode(this);

  Future<void> startAutomaticNeighborhoodVerification() {
    return _startAutomaticNeighborhoodVerification(this);
  }

  void openManualNeighborhood() => _openManualNeighborhood(this);

  void updateManualNeighborhoodQuery(String value) {
    _updateManualNeighborhoodQuery(this, value);
  }

  Future<void> resolveManualNeighborhood() => _resolveManualNeighborhood(this);

  Future<void> completeNeighborhood() => _completeNeighborhood(this);

  void updateBusinessName(String value) => _updateBusinessName(this, value);

  void updateBusinessOwner(String value) => _updateBusinessOwner(this, value);

  void updateBusinessOpeningDate(String value) {
    _updateBusinessOpeningDate(this, value);
  }

  void updateBusinessNumberPart(int partIndex, String value) {
    _updateBusinessNumberPart(this, partIndex: partIndex, value: value);
  }

  bool validateBusinessFields() => _validateBusinessFields(this);

  Future<void> submitBusinessVerification() {
    return _submitBusinessVerification(this);
  }

  void openHomePlaceholder() => _openHomePlaceholder(this);

  void openHomePreviewSection(HomePreviewSection section) {
    _openHomePreviewSection(this, section);
  }

  void openPlusDestination() => _openPlusDestination(this);

  void restart() => _restartOnboarding(this);

  void goBack() => _goBack(this);

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _manualLookupDebounce?.cancel();
    super.dispose();
  }

  void _clearError(String key) {
    if (_fieldErrors[key] != null) {
      _fieldErrors = <String, String?>{..._fieldErrors}..remove(key);
    }
  }

  void _emitToast(String message) {
    _toastMessage = message;
    _toastVersion += 1;
    notifyListeners();
  }

  void _notifyChanged() {
    notifyListeners();
  }

  String get _resolvedPrimaryLanguage =>
      MateyaLanguagePreferences.instance.primaryLanguageCode;

  String get _resolvedPrimaryCountry =>
      MateyaLanguagePreferences.instance.primaryCountryCode;
}
