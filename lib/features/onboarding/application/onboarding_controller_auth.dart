part of 'onboarding_controller.dart';

Future<void> _sendVerificationCode(OnboardingController controller) async {
  final phoneError = OnboardingValidators.validatePhoneNumber(
    controller._phoneNumber,
  );
  controller._fieldErrors['phone'] = phoneError;
  controller._fieldErrors['carrier'] = controller._carrier.isEmpty
      ? '통신사를 선택해 주세요.'
      : null;

  if (phoneError != null || controller._carrier.isEmpty) {
    controller._notifyChanged();
    return;
  }

  controller._authPhase = AsyncPhase.loading;
  controller._fieldErrors.remove('verification');
  controller._notifyChanged();

  try {
    final result = await controller._authRepository.requestSmsCode(
      phoneNumber: controller._phoneNumber,
    );
    controller._authPhase = AsyncPhase.success;
    controller._expectedVerificationCode = result.debugCode;
    controller._verificationCode = '';
    controller._resendCount = 1;
    _startVerificationCountdown(controller);
    controller._emitToast('인증번호를 발송했어요.');
  } on MateyaApiException catch (error) {
    _applyApiError(controller, error, preferredField: 'phone');
  }

  controller._notifyChanged();
}

Future<void> _resendVerificationCode(OnboardingController controller) async {
  if (!controller.hasSentVerificationCode) {
    await _sendVerificationCode(controller);
    return;
  }
  if (controller._resendCount >= 5) {
    controller._emitToast('인증번호는 하루 최대 5번까지 다시 받을 수 있어요.');
    return;
  }
  controller._resendCount += 1;
  await _sendVerificationCode(controller);
}

Future<void> _submitVerificationCode(OnboardingController controller) async {
  final error = OnboardingValidators.validateVerificationCode(
    controller._verificationCode,
    controller._expectedVerificationCode,
    controller._remainingSeconds == 0,
  );
  controller._fieldErrors['verification'] = error;

  if (error != null) {
    controller._notifyChanged();
    return;
  }

  controller._authPhase = AsyncPhase.loading;
  controller._notifyChanged();

  try {
    final result = await controller._authRepository.verifySmsCode(
      phoneNumber: controller._phoneNumber,
      code: controller._verificationCode,
    );
    controller._verificationToken = result.verificationToken;
    controller._verificationTokenExpiresAt = result.expiresAt;
    final existingUserSession = await _tryLoginExistingUser(
      controller,
      verificationToken: result.verificationToken,
    );
    controller._verificationTimer?.cancel();
    if (existingUserSession != null) {
      controller._authSessionStore.save(existingUserSession);
      controller._completionMode = AuthCompletionMode.login;
      controller._authPhase = AsyncPhase.success;
      controller._step = OnboardingStep.completed;
      controller._notifyChanged();
      return;
    }

    controller._completionMode = AuthCompletionMode.signup;
    controller._authPhase = AsyncPhase.success;
    if (controller._flowKind == FlowKind.host) {
      await _completeHostSignup(controller);
      return;
    }
    controller._locationPhase = AsyncPhase.idle;
    controller._locationFailure = null;
    controller._selectedNeighborhood = null;
    controller._step = OnboardingStep.neighborhoodAuto;
    controller._notifyChanged();
  } on MateyaApiException catch (apiError) {
    _applyApiError(controller, apiError, preferredField: 'verification');
    controller._notifyChanged();
  }
}

void _startVerificationCountdown(OnboardingController controller) {
  controller._verificationTimer?.cancel();
  controller._remainingSeconds = 300;
  controller._verificationTimer = Timer.periodic(const Duration(seconds: 1), (
    timer,
  ) {
    if (controller._remainingSeconds <= 1) {
      controller._remainingSeconds = 0;
      timer.cancel();
    } else {
      controller._remainingSeconds -= 1;
    }
    controller._notifyChanged();
  });
}

void _applyApiError(
  OnboardingController controller,
  MateyaApiException error, {
  String? preferredField,
}) {
  controller._authPhase = switch (error.type) {
    ApiFailureType.validation => AsyncPhase.validationError,
    ApiFailureType.network => AsyncPhase.networkError,
    ApiFailureType.unauthorized ||
    ApiFailureType.server => AsyncPhase.serverError,
  };

  if (error.fieldErrors.isNotEmpty) {
    controller._fieldErrors = <String, String?>{
      ...controller._fieldErrors,
      ...error.fieldErrors,
    };
  } else if (preferredField != null) {
    controller._fieldErrors[preferredField] = error.message;
  }

  controller._emitToast(error.message);
}

Future<AuthSession?> _tryLoginExistingUser(
  OnboardingController controller, {
  required String verificationToken,
}) async {
  try {
    return await controller._authRepository.loginUser(
      verificationToken: verificationToken,
    );
  } on MateyaApiException catch (error) {
    if (_isSignupCandidate(error)) {
      return null;
    }
    rethrow;
  }
}

bool _isSignupCandidate(MateyaApiException error) {
  return error.code == 'not-found' || error.statusCode == 404;
}

Future<void> _completeHostSignup(OnboardingController controller) async {
  if (controller._verificationToken == null ||
      controller._verificationTokenExpiresAt == null ||
      controller._verificationTokenExpiresAt!.isBefore(DateTime.now())) {
    controller._authPhase = AsyncPhase.validationError;
    controller._emitToast('인증이 만료되어 인증번호를 다시 받아야 해요.');
    controller._step = OnboardingStep.guestPhone;
    controller._notifyChanged();
    return;
  }
  if (controller._businessVerificationToken == null ||
      controller._businessVerificationExpiresAt == null ||
      controller._businessVerificationExpiresAt!.isBefore(DateTime.now())) {
    controller._authPhase = AsyncPhase.validationError;
    controller._emitToast('사업자 인증이 만료되어 다시 인증해야 해요.');
    controller._step = OnboardingStep.hostBusiness;
    controller._notifyChanged();
    return;
  }

  controller._authPhase = AsyncPhase.loading;
  controller._notifyChanged();

  try {
    final session = await controller._authRepository.signupHost(
      verificationToken: controller._verificationToken!,
      businessVerificationToken: controller._businessVerificationToken!,
      displayName: controller._signupDisplayName,
      businessName: controller._businessName.trim(),
      primaryLanguage: controller._resolvedPrimaryLanguage,
      primaryCountry: controller._resolvedPrimaryCountry,
      agreementState: controller._agreementState,
    );
    controller._authSessionStore.save(session);
    controller._completionMode = AuthCompletionMode.signup;
    controller._authPhase = AsyncPhase.success;
    controller._step = OnboardingStep.completed;
    controller._notifyChanged();
  } on MateyaApiException catch (error) {
    _applyApiError(controller, error);
    controller._notifyChanged();
  }
}
