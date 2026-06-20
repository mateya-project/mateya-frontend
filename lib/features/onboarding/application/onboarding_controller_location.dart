part of 'onboarding_controller.dart';

Future<void> _startAutomaticNeighborhoodVerification(
  OnboardingController controller,
) async {
  controller._logger.info(
    'Starting automatic neighborhood verification',
    context: <String, Object?>{
      'flowKind': controller._flowKind?.name,
      'completionMode': controller._completionMode.name,
    },
  );
  controller._locationPhase = AsyncPhase.loading;
  controller._locationFailure = null;
  controller._selectedNeighborhood = null;
  controller._notifyChanged();

  final result = await controller._locationRepository
      .resolveCurrentNeighborhood();
  if (result.isSuccess) {
    controller._logger.info(
      'Automatic neighborhood verification succeeded',
      context: <String, Object?>{'district': result.selection?.displayName},
    );
    controller._locationPhase = AsyncPhase.success;
    controller._selectedNeighborhood = result.selection;
    controller._locationFailure = null;
  } else {
    controller._logger.warning(
      'Automatic neighborhood verification failed',
      context: <String, Object?>{
        'failureType': result.failure?.type.name,
        'message': result.failure?.message,
      },
    );
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
  final l10n = MateyaLocalizations.current;
  final trimmed = controller._manualNeighborhoodQuery.trim();
  if (trimmed.isEmpty) {
    controller._fieldErrors['manualNeighborhood'] =
        l10n.onboardingLocationQueryRequired;
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
        result.failure?.message ?? l10n.onboardingLocationQueryNotFound;
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

  if (controller._completionMode == AuthCompletionMode.login) {
    final neighborhood = controller._selectedNeighborhood!;
    final currentSession = controller._authSessionStore.session;
    if (currentSession == null) {
      controller._logger.warning(
        'Skipping neighborhood session sync because auth session is missing after login completion',
      );
    } else {
      controller._authSessionStore.save(
        currentSession.copyWith(
          user: currentSession.user.copyWith(
            activityRegionName: neighborhood.displayName,
            activityLatitude: neighborhood.latitude,
            activityLongitude: neighborhood.longitude,
          ),
        ),
      );
      controller._logger.info(
        'Synced verified neighborhood into auth session after login',
        context: <String, Object?>{'district': neighborhood.displayName},
      );
    }
    controller._authPhase = AsyncPhase.success;
    controller._step = OnboardingStep.completed;
    controller._notifyChanged();
    return;
  }

  await _completeGuestSignup(
    controller,
    neighborhood: controller._selectedNeighborhood!,
  );
}
