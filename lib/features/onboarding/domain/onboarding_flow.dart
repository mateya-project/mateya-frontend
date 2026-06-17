enum FlowKind { guest, host }

enum OnboardingStep {
  welcome,
  guestConsent,
  guestName,
  guestPhone,
  neighborhoodAuto,
  neighborhoodManual,
  hostConsent,
  hostBusiness,
  completed,
  homePlaceholder,
}

enum HomePreviewSection {
  home,
  explore,
  groupCreation,
  classRegistration,
  chat,
  profile,
}

enum AsyncPhase {
  idle,
  loading,
  success,
  validationError,
  networkError,
  serverError,
}

enum AuthCompletionMode { signup, login }

class NeighborhoodSelection {
  const NeighborhoodSelection({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  final String displayName;
  final double latitude;
  final double longitude;
}

enum LocationFailureType {
  permissionDenied,
  permissionPermanentlyDenied,
  serviceDisabled,
  accuracyTooLow,
  geocodingFailed,
  locationUnavailable,
  unknown,
}

class LocationFailure {
  const LocationFailure(this.type, this.message);

  final LocationFailureType type;
  final String message;
}

class LocationLookupResult {
  const LocationLookupResult.success(this.selection)
    : failure = null,
      isSuccess = true;

  const LocationLookupResult.failure(this.failure)
    : selection = null,
      isSuccess = false;

  final NeighborhoodSelection? selection;
  final LocationFailure? failure;
  final bool isSuccess;
}

class AgreementState {
  const AgreementState({
    this.service = false,
    this.privacy = false,
    this.location = false,
    this.age = false,
  });

  final bool service;
  final bool privacy;
  final bool location;
  final bool age;

  bool get isAllChecked => service && privacy && location && age;

  AgreementState toggleAll(bool value) {
    return AgreementState(
      service: value,
      privacy: value,
      location: value,
      age: value,
    );
  }

  AgreementState copyWith({
    bool? service,
    bool? privacy,
    bool? location,
    bool? age,
  }) {
    return AgreementState(
      service: service ?? this.service,
      privacy: privacy ?? this.privacy,
      location: location ?? this.location,
      age: age ?? this.age,
    );
  }
}
