part of 'onboarding_controller.dart';

void _updateBusinessName(OnboardingController controller, String value) {
  controller._businessName = value;
  controller._clearError('businessName');
  controller._notifyChanged();
}

void _updateBusinessOwner(OnboardingController controller, String value) {
  controller._businessOwner = value;
  controller._clearError('businessOwner');
  controller._notifyChanged();
}

void _updateBusinessOpeningDate(OnboardingController controller, String value) {
  controller._businessOpeningDate = value.replaceAll(RegExp(r'\D'), '');
  controller._clearError('businessOpeningDate');
  controller._notifyChanged();
}

void _updateBusinessNumberPart(
  OnboardingController controller, {
  required int partIndex,
  required String value,
}) {
  final sanitized = value.replaceAll(RegExp(r'\D'), '');
  switch (partIndex) {
    case 0:
      controller._businessNumberFirst = sanitized;
      break;
    case 1:
      controller._businessNumberSecond = sanitized;
      break;
    case 2:
      controller._businessNumberThird = sanitized;
      break;
  }
  controller._clearError('businessNumber');
  controller._notifyChanged();
}

bool _validateBusinessFields(OnboardingController controller) {
  controller._fieldErrors['businessName'] =
      OnboardingValidators.validateBusinessName(controller._businessName);
  controller._fieldErrors['businessOwner'] =
      OnboardingValidators.validateBusinessOwner(controller._businessOwner);
  controller._fieldErrors['businessOpeningDate'] =
      OnboardingValidators.validateBusinessOpeningDate(
        controller._businessOpeningDate,
      );
  controller._fieldErrors['businessNumber'] =
      OnboardingValidators.validateBusinessNumber(
        controller._businessNumberFirst,
        controller._businessNumberSecond,
        controller._businessNumberThird,
      );
  controller._notifyChanged();
  return controller._fieldErrors.values.whereType<String>().isEmpty;
}

Future<void> _submitBusinessVerification(
  OnboardingController controller,
) async {
  if (!_validateBusinessFields(controller)) {
    return;
  }

  controller._authPhase = AsyncPhase.loading;
  controller._notifyChanged();

  try {
    final result = await controller._authRepository.verifyBusiness(
      businessNumber:
          '${controller._businessNumberFirst}-${controller._businessNumberSecond}-${controller._businessNumberThird}',
      representativeName: controller._businessOwner.trim(),
      openingDate: controller._businessOpeningDate,
    );
    controller._businessVerificationToken = result.businessVerificationToken;
    controller._businessVerificationExpiresAt = result.expiresAt;
    controller._completionMode = AuthCompletionMode.signup;
    controller._authPhase = AsyncPhase.success;
    controller._step = OnboardingStep.guestPhone;
    controller._emitToast('사업자 인증이 완료됐어요. 휴대폰 인증을 이어서 진행해 주세요.');
  } on MateyaApiException catch (error) {
    _applyApiError(controller, error, preferredField: 'businessNumber');
  }

  controller._notifyChanged();
}
