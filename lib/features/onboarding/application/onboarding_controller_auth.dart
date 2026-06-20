part of 'onboarding_controller.dart';

Future<void> _sendVerificationCode(OnboardingController controller) async {
  await _requestVerificationCode(controller, isResend: false);
}

Future<void> _requestVerificationCode(
  OnboardingController controller, {
  required bool isResend,
}) async {
  final phoneError = OnboardingValidators.validatePhoneNumber(
    controller._phoneNumber,
  );
  controller._fieldErrors['phone'] = phoneError;

  if (phoneError != null) {
    controller._notifyChanged();
    return;
  }

  controller._authPhase = AsyncPhase.loading;
  controller._fieldErrors.remove('verification');
  controller._verificationNotice = null;
  controller._notifyChanged();
  final l10n = MateyaLocalizations.current;

  try {
    final result = await controller._authRepository.requestSmsCode(
      phoneNumber: controller._phoneNumber,
    );
    controller._authPhase = AsyncPhase.success;
    controller._smsCodeExpiresAt = result.expiresAt;
    controller._expectedVerificationCode = result.debugCode;
    controller._verificationCode = '';
    controller._resendCount = isResend ? controller._resendCount + 1 : 1;
    controller._verificationNotice = isResend
        ? l10n.onboardingVerificationResendLimitNotice(controller._resendCount)
        : null;
    _startVerificationCountdown(controller, result.expiresAt);
    controller._emitToast(
      isResend
          ? l10n.onboardingVerificationResent
          : l10n.onboardingVerificationSent,
    );
  } on MateyaApiException catch (error) {
    _applyApiError(
      controller,
      error,
      preferredField: isResend ? null : 'phone',
    );
  }

  controller._notifyChanged();
}

Future<void> _resendVerificationCode(OnboardingController controller) async {
  if (!controller.hasSentVerificationCode) {
    await _sendVerificationCode(controller);
    return;
  }
  if (controller._resendCount >= 5) {
    controller._verificationNotice =
        MateyaLocalizations.current.onboardingVerificationResendLimitReached;
    controller._notifyChanged();
    return;
  }
  await _requestVerificationCode(controller, isResend: true);
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
      controller._locationPhase = AsyncPhase.idle;
      controller._locationFailure = null;
      controller._selectedNeighborhood = null;
      controller._step = OnboardingStep.neighborhoodAuto;
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

void _startVerificationCountdown(
  OnboardingController controller,
  DateTime expiresAt,
) {
  controller._verificationTimer?.cancel();
  controller._remainingSeconds = _secondsUntil(expiresAt);
  controller._verificationTimer = Timer.periodic(const Duration(seconds: 1), (
    timer,
  ) {
    if (controller._remainingSeconds <= 1) {
      controller._remainingSeconds = 0;
      timer.cancel();
      controller._smsCodeExpiresAt = null;
      controller._expectedVerificationCode = null;
      controller._verificationCode = '';
      controller._verificationNotice = null;
      controller._fieldErrors.remove('verification');
    } else {
      controller._remainingSeconds -= 1;
    }
    controller._notifyChanged();
  });
}

int _secondsUntil(DateTime expiresAt) {
  final difference = expiresAt.difference(DateTime.now());
  if (difference.isNegative) {
    return 0;
  }
  return difference.inSeconds;
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
