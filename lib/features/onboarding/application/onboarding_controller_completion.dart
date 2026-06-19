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
    final session = await _runGuestSignupAttempt(
      controller,
      verificationToken: verificationToken,
      neighborhood: neighborhood,
    );
    _finishSignup(controller, session);
  } on MateyaApiException catch (error) {
    final retriedSession = await _retryGuestSignupWithFreshToken(
      controller,
      error: error,
      neighborhood: neighborhood,
    );
    if (retriedSession != null) {
      _finishSignup(controller, retriedSession);
      return;
    }
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
    final session = await _runHostSignupAttempt(
      controller,
      verificationToken: verificationToken,
      businessVerificationToken: businessVerificationToken,
    );
    _finishSignup(controller, session);
  } on MateyaApiException catch (error) {
    final retriedSession = await _retryHostSignupWithFreshToken(
      controller,
      error: error,
      businessVerificationToken: businessVerificationToken,
    );
    if (retriedSession != null) {
      _finishSignup(controller, retriedSession);
      return;
    }
  }
}

Future<AuthSession> _runGuestSignupAttempt(
  OnboardingController controller, {
  required String verificationToken,
  required NeighborhoodSelection neighborhood,
}) {
  return controller._authRepository.signupGuest(
    verificationToken: verificationToken,
    displayName: controller._signupDisplayName,
    primaryLanguage: controller._resolvedPrimaryLanguage,
    primaryCountry: controller._resolvedPrimaryCountry,
    agreementState: controller._agreementState,
    neighborhood: neighborhood,
  );
}

Future<AuthSession> _runHostSignupAttempt(
  OnboardingController controller, {
  required String verificationToken,
  required String businessVerificationToken,
}) {
  return controller._authRepository.signupHost(
    verificationToken: verificationToken,
    businessVerificationToken: businessVerificationToken,
    displayName: controller._signupDisplayName,
    businessName: controller._businessName.trim(),
    primaryLanguage: controller._resolvedPrimaryLanguage,
    primaryCountry: controller._resolvedPrimaryCountry,
    agreementState: controller._agreementState,
  );
}

Future<AuthSession?> _retryGuestSignupWithFreshToken(
  OnboardingController controller, {
  required MateyaApiException error,
  required NeighborhoodSelection neighborhood,
}) async {
  if (!_shouldRetrySignupWithFreshToken(controller, error)) {
    _applyApiError(controller, error);
    controller._notifyChanged();
    return null;
  }

  final refreshedVerificationToken = await _refreshVerificationTokenForSignup(
    controller,
  );
  if (refreshedVerificationToken == null) {
    return null;
  }

  try {
    return await _runGuestSignupAttempt(
      controller,
      verificationToken: refreshedVerificationToken,
      neighborhood: neighborhood,
    );
  } on MateyaApiException catch (retryError) {
    _applyApiError(controller, retryError);
    controller._notifyChanged();
    return null;
  }
}

Future<AuthSession?> _retryHostSignupWithFreshToken(
  OnboardingController controller, {
  required MateyaApiException error,
  required String businessVerificationToken,
}) async {
  if (!_shouldRetrySignupWithFreshToken(controller, error)) {
    _applyApiError(controller, error);
    controller._notifyChanged();
    return null;
  }

  final refreshedVerificationToken = await _refreshVerificationTokenForSignup(
    controller,
  );
  if (refreshedVerificationToken == null) {
    return null;
  }

  try {
    return await _runHostSignupAttempt(
      controller,
      verificationToken: refreshedVerificationToken,
      businessVerificationToken: businessVerificationToken,
    );
  } on MateyaApiException catch (retryError) {
    _applyApiError(controller, retryError);
    controller._notifyChanged();
    return null;
  }
}

bool _shouldRetrySignupWithFreshToken(
  OnboardingController controller,
  MateyaApiException error,
) {
  if (controller._verificationCode.length != 6) {
    return false;
  }
  final message = error.message.toLowerCase();
  final mentionsInvalidSmsToken =
      message.contains('sms') &&
      message.contains('토큰') &&
      message.contains('유효하지');
  return mentionsInvalidSmsToken || message.contains('verification token');
}

Future<String?> _refreshVerificationTokenForSignup(
  OnboardingController controller,
) async {
  try {
    final result = await controller._authRepository.verifySmsCode(
      phoneNumber: controller._phoneNumber,
      code: controller._verificationCode,
    );
    controller._verificationToken = result.verificationToken;
    controller._verificationTokenExpiresAt = result.expiresAt;
    return result.verificationToken;
  } on MateyaApiException catch (error) {
    _applyApiError(controller, error, preferredField: 'verification');
    controller._notifyChanged();
    return null;
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
