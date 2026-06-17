part of 'onboarding_controller.dart';

void _startGuestFlow(OnboardingController controller) {
  controller._flowKind = FlowKind.guest;
  controller._agreementState = const AgreementState();
  controller._completionMode = AuthCompletionMode.signup;
  controller._fieldErrors = <String, String?>{};
  controller._step = OnboardingStep.guestConsent;
  controller._notifyChanged();
}

void _startHostFlow(OnboardingController controller) {
  controller._flowKind = FlowKind.host;
  controller._agreementState = const AgreementState();
  controller._completionMode = AuthCompletionMode.signup;
  controller._fieldErrors = <String, String?>{};
  controller._step = OnboardingStep.hostConsent;
  controller._notifyChanged();
}

void _toggleAllAgreements(OnboardingController controller, bool value) {
  controller._agreementState = controller._agreementState.toggleAll(value);
  controller._notifyChanged();
}

void _toggleAgreement(
  OnboardingController controller, {
  bool? service,
  bool? privacy,
  bool? location,
  bool? age,
}) {
  controller._agreementState = controller._agreementState.copyWith(
    service: service,
    privacy: privacy,
    location: location,
    age: age,
  );
  controller._notifyChanged();
}

void _confirmConsent(OnboardingController controller) {
  if (!controller.isConsentComplete) {
    controller._emitToast('필수 약관에 모두 동의해 주세요.');
    return;
  }

  controller._step = controller._flowKind == FlowKind.host
      ? OnboardingStep.hostBusiness
      : OnboardingStep.guestName;
  controller._notifyChanged();
}

void _updateName(OnboardingController controller, String value) {
  controller._name = value;
  controller._clearError('name');
  controller._notifyChanged();
}

bool _validateNameField(OnboardingController controller) {
  final error = OnboardingValidators.validateName(controller._name);
  controller._fieldErrors['name'] = error;
  controller._notifyChanged();
  return error == null;
}

void _submitName(OnboardingController controller) {
  if (!_validateNameField(controller)) {
    return;
  }
  controller._step = OnboardingStep.guestPhone;
  controller._notifyChanged();
}

void _selectCarrier(OnboardingController controller, String value) {
  controller._carrier = value;
  controller._clearError('carrier');
  controller._notifyChanged();
}

void _selectCountryCode(OnboardingController controller, String value) {
  controller._countryCode = value;
  controller._notifyChanged();
}

void _updatePhoneNumber(OnboardingController controller, String value) {
  controller._phoneNumber = value.replaceAll(RegExp(r'\D'), '');
  controller._clearError('phone');
  controller._notifyChanged();
}

void _updateVerificationCode(OnboardingController controller, String value) {
  controller._verificationCode = value.replaceAll(RegExp(r'\D'), '');
  controller._clearError('verification');
  controller._notifyChanged();
}

void _openHomePlaceholder(OnboardingController controller) {
  controller._homePreviewSection = HomePreviewSection.home;
  controller._step = OnboardingStep.homePlaceholder;
  controller._notifyChanged();
}

void _openHomePreviewSection(
  OnboardingController controller,
  HomePreviewSection section,
) {
  if (controller._homePreviewSection == section) {
    return;
  }
  controller._homePreviewSection = section;
  controller._notifyChanged();
}

void _openPlusDestination(OnboardingController controller) {
  controller._homePreviewSection = controller._flowKind == FlowKind.host
      ? HomePreviewSection.classRegistration
      : HomePreviewSection.groupCreation;
  controller._notifyChanged();
}

void _restartOnboarding(OnboardingController controller) {
  controller._verificationTimer?.cancel();
  controller._manualLookupDebounce?.cancel();
  controller._step = OnboardingStep.welcome;
  controller._flowKind = null;
  controller._agreementState = const AgreementState();
  controller._locationPhase = AsyncPhase.idle;
  controller._completionMode = AuthCompletionMode.signup;
  controller._selectedNeighborhood = null;
  controller._locationFailure = null;
  controller._fieldErrors = <String, String?>{};
  controller._homePreviewSection = HomePreviewSection.home;
  controller._remainingSeconds = 0;
  controller._resendCount = 0;
  controller._expectedVerificationCode = null;
  controller._verificationToken = null;
  controller._verificationTokenExpiresAt = null;
  controller._businessVerificationToken = null;
  controller._businessVerificationExpiresAt = null;
  controller._name = '';
  controller._carrier = '';
  controller._countryCode = '+82';
  controller._phoneNumber = '';
  controller._verificationCode = '';
  controller._manualNeighborhoodQuery = '';
  controller._businessName = '';
  controller._businessOwner = '';
  controller._businessOpeningDate = '';
  controller._businessNumberFirst = '';
  controller._businessNumberSecond = '';
  controller._businessNumberThird = '';
  controller._notifyChanged();
}

void _goBack(OnboardingController controller) {
  controller._step = switch (controller._step) {
    OnboardingStep.welcome => OnboardingStep.welcome,
    OnboardingStep.guestConsent ||
    OnboardingStep.hostConsent => OnboardingStep.welcome,
    OnboardingStep.guestName => OnboardingStep.guestConsent,
    OnboardingStep.guestPhone =>
      controller._flowKind == FlowKind.host
          ? OnboardingStep.hostBusiness
          : OnboardingStep.guestName,
    OnboardingStep.neighborhoodAuto => OnboardingStep.guestPhone,
    OnboardingStep.neighborhoodManual => OnboardingStep.neighborhoodAuto,
    OnboardingStep.hostBusiness => OnboardingStep.hostConsent,
    OnboardingStep.completed =>
      controller._flowKind == FlowKind.host
          ? OnboardingStep.guestPhone
          : controller._completionMode == AuthCompletionMode.login
          ? OnboardingStep.guestPhone
          : OnboardingStep.neighborhoodAuto,
    OnboardingStep.homePlaceholder => OnboardingStep.completed,
  };
  controller._notifyChanged();
}
