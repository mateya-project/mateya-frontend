part of 'onboarding_controller.dart';

Future<void> _completeGuestSignup(
  OnboardingController controller, {
  required NeighborhoodSelection neighborhood,
}) async {
  final verificationToken = _requireVerificationToken(
    controller,
    expiredStep: OnboardingStep.guestPhone,
    expiredMessage: '인증이 만료되어 인증번호를 다시 받아야 해요.',
  );
  if (verificationToken == null) {
    return;
  }

  controller._authPhase = AsyncPhase.loading;
  controller._notifyChanged();

  try {
    final session = await controller._authRepository.signupGuest(
      verificationToken: verificationToken,
      displayName: controller._signupDisplayName,
      primaryLanguage: controller._resolvedPrimaryLanguage,
      primaryCountry: controller._resolvedPrimaryCountry,
      agreementState: controller._agreementState,
      neighborhood: neighborhood,
    );
    _finishSignup(controller, session);
  } on MateyaApiException catch (error) {
    _applyApiError(controller, error);
    controller._notifyChanged();
  }
}

Future<void> _completeHostSignup(OnboardingController controller) async {
  final verificationToken = _requireVerificationToken(
    controller,
    expiredStep: OnboardingStep.guestPhone,
    expiredMessage: '인증이 만료되어 인증번호를 다시 받아야 해요.',
  );
  if (verificationToken == null) {
    return;
  }

  final businessVerificationToken = _requireBusinessVerificationToken(
    controller,
  );
  if (businessVerificationToken == null) {
    return;
  }

  controller._authPhase = AsyncPhase.loading;
  controller._notifyChanged();

  try {
    final session = await controller._authRepository.signupHost(
      verificationToken: verificationToken,
      businessVerificationToken: businessVerificationToken,
      displayName: controller._signupDisplayName,
      businessName: controller._businessName.trim(),
      primaryLanguage: controller._resolvedPrimaryLanguage,
      primaryCountry: controller._resolvedPrimaryCountry,
      agreementState: controller._agreementState,
    );
    _finishSignup(controller, session);
  } on MateyaApiException catch (error) {
    _applyApiError(controller, error);
    controller._notifyChanged();
  }
}

String? _requireVerificationToken(
  OnboardingController controller, {
  required OnboardingStep expiredStep,
  required String expiredMessage,
}) {
  final expiresAt = controller._verificationTokenExpiresAt;
  if (controller._verificationToken == null ||
      expiresAt == null ||
      expiresAt.isBefore(DateTime.now())) {
    controller._authPhase = AsyncPhase.validationError;
    controller._emitToast(expiredMessage);
    controller._step = expiredStep;
    controller._notifyChanged();
    return null;
  }
  return controller._verificationToken;
}

String? _requireBusinessVerificationToken(OnboardingController controller) {
  final expiresAt = controller._businessVerificationExpiresAt;
  if (controller._businessVerificationToken == null ||
      expiresAt == null ||
      expiresAt.isBefore(DateTime.now())) {
    controller._authPhase = AsyncPhase.validationError;
    controller._emitToast('사업자 인증이 만료되어 다시 인증해야 해요.');
    controller._step = OnboardingStep.hostBusiness;
    controller._notifyChanged();
    return null;
  }
  return controller._businessVerificationToken;
}

void _finishSignup(OnboardingController controller, AuthSession session) {
  controller._authSessionStore.save(session);
  controller._completionMode = AuthCompletionMode.signup;
  controller._authPhase = AsyncPhase.success;
  controller._step = OnboardingStep.completed;
  controller._notifyChanged();
}
