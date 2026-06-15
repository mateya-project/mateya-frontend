// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../app/app_config.dart';
import '../data/location_repository.dart';
import '../domain/onboarding_flow.dart';
import '../domain/onboarding_validators.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required NeighborhoodLocationRepository locationRepository,
  }) : _locationRepository = locationRepository;

  final NeighborhoodLocationRepository _locationRepository;
  final Random _random = Random();

  OnboardingStep _step = OnboardingStep.welcome;
  FlowKind? _flowKind;
  AgreementState _agreementState = const AgreementState();
  AsyncPhase _locationPhase = AsyncPhase.idle;
  NeighborhoodSelection? _selectedNeighborhood;
  LocationFailure? _locationFailure;
  Map<String, String?> _fieldErrors = <String, String?>{};
  HomePreviewSection _homePreviewSection = HomePreviewSection.home;

  Timer? _verificationTimer;
  Timer? _manualLookupDebounce;
  int _remainingSeconds = 0;
  int _resendCount = 0;
  String? _expectedVerificationCode;

  String _name = '';
  String _carrier = '';
  String _countryCode = '+82';
  String _phoneNumber = '';
  String _verificationCode = '';
  String _manualNeighborhoodQuery = '';
  String _businessName = '';
  String _businessOwner = '';
  String _businessNumberFirst = '';
  String _businessNumberSecond = '';
  String _businessNumberThird = '';

  String? _toastMessage;
  int _toastVersion = 0;

  OnboardingStep get step => _step;
  FlowKind? get flowKind => _flowKind;
  AgreementState get agreementState => _agreementState;
  AsyncPhase get locationPhase => _locationPhase;
  NeighborhoodSelection? get selectedNeighborhood => _selectedNeighborhood;
  LocationFailure? get locationFailure => _locationFailure;
  String get name => _name;
  String get carrier => _carrier;
  String get countryCode => _countryCode;
  String get phoneNumber => _phoneNumber;
  String get verificationCode => _verificationCode;
  int get remainingSeconds => _remainingSeconds;
  int get resendCount => _resendCount;
  String? get debugVerificationCode => _expectedVerificationCode;
  String get manualNeighborhoodQuery => _manualNeighborhoodQuery;
  String get businessName => _businessName;
  String get businessOwner => _businessOwner;
  String get businessNumberFirst => _businessNumberFirst;
  String get businessNumberSecond => _businessNumberSecond;
  String get businessNumberThird => _businessNumberThird;
  String? get toastMessage => _toastMessage;
  int get toastVersion => _toastVersion;
  HomePreviewSection get homePreviewSection => _homePreviewSection;
  List<String> get carriers => AppConfig.supportedCarriers;
  List<String> get countryCodes => AppConfig.supportedCountryCodes;

  String? errorFor(String fieldName) => _fieldErrors[fieldName];

  bool get isConsentComplete => _agreementState.isAllChecked;
  bool get canContinueName => _name.trim().isNotEmpty;
  bool get canSendVerificationCode =>
      _carrier.isNotEmpty &&
      _countryCode.isNotEmpty &&
      OnboardingValidators.validatePhoneNumber(_phoneNumber) == null;
  bool get hasSentVerificationCode => _expectedVerificationCode != null;
  bool get canSubmitVerificationCode => _verificationCode.length == 6;
  bool get canCompleteNeighborhood => _selectedNeighborhood != null;
  bool get canCompleteBusiness =>
      _businessName.trim().isNotEmpty &&
      _businessOwner.trim().isNotEmpty &&
      _businessNumberFirst.length == 3 &&
      _businessNumberSecond.length == 2 &&
      _businessNumberThird.length == 5;

  String get completedName {
    if (_flowKind == FlowKind.host && _businessOwner.trim().isNotEmpty) {
      return _businessOwner.trim();
    }
    return _name.trim().isEmpty ? '메이트야 회원' : _name.trim();
  }

  String get resolvedNeighborhoodMessage {
    final neighborhood = _selectedNeighborhood?.displayName ?? '동네';
    return '현재 위치가 “$neighborhood”에 있어요.';
  }

  void clearToast() {
    _toastMessage = null;
  }

  void startGuestFlow() {
    _flowKind = FlowKind.guest;
    _agreementState = const AgreementState();
    _fieldErrors = <String, String?>{};
    _step = OnboardingStep.guestConsent;
    notifyListeners();
  }

  void startHostFlow() {
    _flowKind = FlowKind.host;
    _agreementState = const AgreementState();
    _fieldErrors = <String, String?>{};
    _step = OnboardingStep.hostConsent;
    notifyListeners();
  }

  void toggleAllAgreements(bool value) {
    _agreementState = _agreementState.toggleAll(value);
    notifyListeners();
  }

  void toggleAgreement({
    bool? service,
    bool? privacy,
    bool? location,
    bool? age,
  }) {
    _agreementState = _agreementState.copyWith(
      service: service,
      privacy: privacy,
      location: location,
      age: age,
    );
    notifyListeners();
  }

  void confirmConsent() {
    if (!isConsentComplete) {
      _emitToast('필수 약관에 모두 동의해 주세요.');
      return;
    }

    _step = _flowKind == FlowKind.host
        ? OnboardingStep.hostBusiness
        : OnboardingStep.guestName;
    notifyListeners();
  }

  void updateName(String value) {
    _name = value;
    _clearError('name');
    notifyListeners();
  }

  bool validateNameField() {
    final error = OnboardingValidators.validateName(_name);
    _fieldErrors['name'] = error;
    notifyListeners();
    return error == null;
  }

  void submitName() {
    if (!validateNameField()) {
      return;
    }
    _step = OnboardingStep.guestPhone;
    notifyListeners();
  }

  void selectCarrier(String value) {
    _carrier = value;
    _clearError('carrier');
    notifyListeners();
  }

  void selectCountryCode(String value) {
    _countryCode = value;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    _phoneNumber = value.replaceAll(RegExp(r'\D'), '');
    _clearError('phone');
    notifyListeners();
  }

  void updateVerificationCode(String value) {
    _verificationCode = value.replaceAll(RegExp(r'\D'), '');
    _clearError('verification');
    notifyListeners();
  }

  void sendVerificationCode() {
    final phoneError = OnboardingValidators.validatePhoneNumber(_phoneNumber);
    _fieldErrors['phone'] = phoneError;
    _fieldErrors['carrier'] = _carrier.isEmpty ? '통신사를 선택해 주세요.' : null;

    if (phoneError != null || _carrier.isEmpty) {
      notifyListeners();
      return;
    }

    _expectedVerificationCode = _buildVerificationCode();
    _verificationCode = '';
    _resendCount = 1;
    _startVerificationCountdown();
    _emitToast('테스트용 인증번호가 발급됐어요.');
    notifyListeners();
  }

  void resendVerificationCode() {
    if (!hasSentVerificationCode) {
      sendVerificationCode();
      return;
    }
    if (_resendCount >= 5) {
      _emitToast('인증번호는 하루 최대 5번까지 다시 받을 수 있어요.');
      return;
    }
    _resendCount += 1;
    _expectedVerificationCode = _buildVerificationCode();
    _verificationCode = '';
    _startVerificationCountdown();
    _emitToast('인증번호를 다시 발급했어요.');
    notifyListeners();
  }

  Future<void> submitVerificationCode() async {
    final error = OnboardingValidators.validateVerificationCode(
      _verificationCode,
      _expectedVerificationCode,
      _remainingSeconds == 0,
    );
    _fieldErrors['verification'] = error;

    if (error != null) {
      notifyListeners();
      return;
    }

    _verificationTimer?.cancel();
    _step = OnboardingStep.neighborhoodAuto;
    notifyListeners();
    await startAutomaticNeighborhoodVerification();
  }

  Future<void> startAutomaticNeighborhoodVerification() async {
    _locationPhase = AsyncPhase.loading;
    _locationFailure = null;
    _selectedNeighborhood = null;
    notifyListeners();

    final result = await _locationRepository.resolveCurrentNeighborhood();
    if (result.isSuccess) {
      _locationPhase = AsyncPhase.success;
      _selectedNeighborhood = result.selection;
      _locationFailure = null;
    } else {
      _locationPhase = AsyncPhase.validationError;
      _locationFailure = result.failure;
      if (result.failure?.type == LocationFailureType.permissionDenied) {
        _step = OnboardingStep.neighborhoodManual;
        _emitToast(result.failure?.message ?? '직접 입력으로 전환했어요.');
      }
    }
    notifyListeners();
  }

  void openManualNeighborhood() {
    _step = OnboardingStep.neighborhoodManual;
    notifyListeners();
  }

  void updateManualNeighborhoodQuery(String value) {
    _manualNeighborhoodQuery = value;
    _clearError('manualNeighborhood');
    _manualLookupDebounce?.cancel();
    if (value.trim().length < 2) {
      notifyListeners();
      return;
    }
    _manualLookupDebounce = Timer(
      const Duration(milliseconds: 500),
      resolveManualNeighborhood,
    );
    notifyListeners();
  }

  Future<void> resolveManualNeighborhood() async {
    final trimmed = _manualNeighborhoodQuery.trim();
    if (trimmed.isEmpty) {
      _fieldErrors['manualNeighborhood'] = '동네를 입력해 주세요.';
      notifyListeners();
      return;
    }

    _locationPhase = AsyncPhase.loading;
    _locationFailure = null;
    notifyListeners();

    final result = await _locationRepository.resolveNeighborhoodQuery(trimmed);
    if (result.isSuccess) {
      _locationPhase = AsyncPhase.success;
      _selectedNeighborhood = result.selection;
      _locationFailure = null;
      _clearError('manualNeighborhood');
    } else {
      _locationPhase = AsyncPhase.validationError;
      _selectedNeighborhood = null;
      _locationFailure = result.failure;
      _fieldErrors['manualNeighborhood'] =
          result.failure?.message ?? '동네를 찾지 못했어요.';
    }
    notifyListeners();
  }

  Future<void> completeNeighborhood() async {
    if (_selectedNeighborhood == null) {
      await resolveManualNeighborhood();
      if (_selectedNeighborhood == null) {
        return;
      }
    }
    _step = OnboardingStep.completed;
    notifyListeners();
  }

  void updateBusinessName(String value) {
    _businessName = value;
    _clearError('businessName');
    notifyListeners();
  }

  void updateBusinessOwner(String value) {
    _businessOwner = value;
    _clearError('businessOwner');
    notifyListeners();
  }

  void updateBusinessNumberPart(int partIndex, String value) {
    final sanitized = value.replaceAll(RegExp(r'\D'), '');
    switch (partIndex) {
      case 0:
        _businessNumberFirst = sanitized;
        break;
      case 1:
        _businessNumberSecond = sanitized;
        break;
      case 2:
        _businessNumberThird = sanitized;
        break;
    }
    _clearError('businessNumber');
    notifyListeners();
  }

  bool validateBusinessFields() {
    _fieldErrors['businessName'] = OnboardingValidators.validateBusinessName(
      _businessName,
    );
    _fieldErrors['businessOwner'] = OnboardingValidators.validateBusinessOwner(
      _businessOwner,
    );
    _fieldErrors['businessNumber'] =
        OnboardingValidators.validateBusinessNumber(
          _businessNumberFirst,
          _businessNumberSecond,
          _businessNumberThird,
        );
    notifyListeners();
    return _fieldErrors.values.whereType<String>().isEmpty;
  }

  void submitBusinessVerification() {
    if (!validateBusinessFields()) {
      return;
    }
    _step = OnboardingStep.completed;
    notifyListeners();
  }

  void openHomePlaceholder() {
    _homePreviewSection = HomePreviewSection.home;
    _step = OnboardingStep.homePlaceholder;
    notifyListeners();
  }

  void openHomePreviewSection(HomePreviewSection section) {
    if (_homePreviewSection == section) {
      return;
    }
    _homePreviewSection = section;
    notifyListeners();
  }

  void openPlusDestination() {
    _homePreviewSection = _flowKind == FlowKind.host
        ? HomePreviewSection.classRegistration
        : HomePreviewSection.groupCreation;
    notifyListeners();
  }

  void restart() {
    _verificationTimer?.cancel();
    _manualLookupDebounce?.cancel();
    _step = OnboardingStep.welcome;
    _flowKind = null;
    _agreementState = const AgreementState();
    _locationPhase = AsyncPhase.idle;
    _selectedNeighborhood = null;
    _locationFailure = null;
    _fieldErrors = <String, String?>{};
    _homePreviewSection = HomePreviewSection.home;
    _remainingSeconds = 0;
    _resendCount = 0;
    _expectedVerificationCode = null;
    _name = '';
    _carrier = '';
    _countryCode = '+82';
    _phoneNumber = '';
    _verificationCode = '';
    _manualNeighborhoodQuery = '';
    _businessName = '';
    _businessOwner = '';
    _businessNumberFirst = '';
    _businessNumberSecond = '';
    _businessNumberThird = '';
    notifyListeners();
  }

  void goBack() {
    _step = switch (_step) {
      OnboardingStep.welcome => OnboardingStep.welcome,
      OnboardingStep.guestConsent ||
      OnboardingStep.hostConsent => OnboardingStep.welcome,
      OnboardingStep.guestName => OnboardingStep.guestConsent,
      OnboardingStep.guestPhone => OnboardingStep.guestName,
      OnboardingStep.neighborhoodAuto => OnboardingStep.guestPhone,
      OnboardingStep.neighborhoodManual => OnboardingStep.neighborhoodAuto,
      OnboardingStep.hostBusiness => OnboardingStep.hostConsent,
      OnboardingStep.completed =>
        _flowKind == FlowKind.host
            ? OnboardingStep.hostBusiness
            : OnboardingStep.neighborhoodAuto,
      OnboardingStep.homePlaceholder => OnboardingStep.completed,
    };
    notifyListeners();
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _manualLookupDebounce?.cancel();
    super.dispose();
  }

  void _startVerificationCountdown() {
    _verificationTimer?.cancel();
    _remainingSeconds = 300;
    _verificationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        _remainingSeconds = 0;
        timer.cancel();
      } else {
        _remainingSeconds -= 1;
      }
      notifyListeners();
    });
  }

  String _buildVerificationCode() {
    return (_random.nextInt(900000) + 100000).toString();
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
}
