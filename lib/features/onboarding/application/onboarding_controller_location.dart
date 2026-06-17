part of 'onboarding_controller.dart';

Future<void> _startAutomaticNeighborhoodVerification(
  OnboardingController controller,
) async {
  controller._locationPhase = AsyncPhase.loading;
  controller._locationFailure = null;
  controller._selectedNeighborhood = null;
  controller._notifyChanged();

  final result = await controller._locationRepository
      .resolveCurrentNeighborhood();
  if (result.isSuccess) {
    controller._locationPhase = AsyncPhase.success;
    controller._selectedNeighborhood = result.selection;
    controller._locationFailure = null;
  } else {
    controller._locationPhase = AsyncPhase.validationError;
    controller._locationFailure = result.failure;
  }
  controller._notifyChanged();
}

void _openManualNeighborhood(OnboardingController controller) {
  controller._step = OnboardingStep.neighborhoodManual;
  controller._notifyChanged();
}

void _updateManualNeighborhoodQuery(
  OnboardingController controller,
  String value,
) {
  controller._manualNeighborhoodQuery = value;
  controller._clearError('manualNeighborhood');
  controller._manualLookupDebounce?.cancel();
  if (value.trim().length < 2) {
    controller._notifyChanged();
    return;
  }
  controller._manualLookupDebounce = Timer(
    const Duration(milliseconds: 500),
    () => _resolveManualNeighborhood(controller),
  );
  controller._notifyChanged();
}

Future<void> _resolveManualNeighborhood(OnboardingController controller) async {
  final trimmed = controller._manualNeighborhoodQuery.trim();
  if (trimmed.isEmpty) {
    controller._fieldErrors['manualNeighborhood'] = '동네를 입력해 주세요.';
    controller._notifyChanged();
    return;
  }

  controller._locationPhase = AsyncPhase.loading;
  controller._locationFailure = null;
  controller._notifyChanged();

  final result = await controller._locationRepository.resolveNeighborhoodQuery(
    trimmed,
  );
  if (result.isSuccess) {
    controller._locationPhase = AsyncPhase.success;
    controller._selectedNeighborhood = result.selection;
    controller._locationFailure = null;
    controller._clearError('manualNeighborhood');
  } else {
    controller._locationPhase = AsyncPhase.validationError;
    controller._selectedNeighborhood = null;
    controller._locationFailure = result.failure;
    controller._fieldErrors['manualNeighborhood'] =
        result.failure?.message ?? '동네를 찾지 못했어요.';
  }
  controller._notifyChanged();
}

Future<void> _completeNeighborhood(OnboardingController controller) async {
  if (controller._selectedNeighborhood == null) {
    await _resolveManualNeighborhood(controller);
    if (controller._selectedNeighborhood == null) {
      return;
    }
  }

  if (controller._verificationToken == null ||
      controller._verificationTokenExpiresAt == null ||
      controller._verificationTokenExpiresAt!.isBefore(DateTime.now())) {
    controller._authPhase = AsyncPhase.validationError;
    controller._emitToast('인증이 만료되어 인증번호를 다시 받아야 해요.');
    controller._step = OnboardingStep.guestPhone;
    controller._notifyChanged();
    return;
  }

  controller._authPhase = AsyncPhase.loading;
  controller._notifyChanged();

  try {
    final session = await controller._authRepository.signupGuest(
      verificationToken: controller._verificationToken!,
      displayName: controller._signupDisplayName,
      primaryLanguage: controller._resolvedPrimaryLanguage,
      primaryCountry: controller._resolvedPrimaryCountry,
      agreementState: controller._agreementState,
      neighborhood: controller._selectedNeighborhood!,
    );
    controller._authSessionStore.save(session);
    controller._completionMode = AuthCompletionMode.signup;
    controller._authPhase = AsyncPhase.success;
  } on MateyaApiException catch (error) {
    _applyApiError(controller, error);
    controller._notifyChanged();
    return;
  }

  controller._step = OnboardingStep.completed;
  controller._notifyChanged();
}
