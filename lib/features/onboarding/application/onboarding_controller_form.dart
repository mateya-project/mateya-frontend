part of 'onboarding_controller.dart';

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
