import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/onboarding/application/onboarding_controller.dart';
import 'package:mateya_app/features/onboarding/data/location_repository.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_validators.dart';

void main() {
  group('OnboardingValidators', () {
    test('rejects names with digits', () {
      expect(OnboardingValidators.validateName('홍길동1'), isNotNull);
    });

    test('accepts korean and latin names', () {
      expect(OnboardingValidators.validateName('홍 길동'), isNull);
      expect(OnboardingValidators.validateName('Mate Ya'), isNull);
    });
  });

  group('OnboardingController', () {
    test('guest flow moves to automatic neighborhood verification', () async {
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
      );

      controller.startGuestFlow();
      controller.toggleAllAgreements(true);
      controller.confirmConsent();
      controller.updateName('홍길동');
      controller.submitName();
      controller.selectCarrier('LG U+');
      controller.updatePhoneNumber('01012345678');
      controller.sendVerificationCode();
      controller.updateVerificationCode(controller.debugVerificationCode!);

      await controller.submitVerificationCode();

      expect(controller.step, OnboardingStep.neighborhoodAuto);
      expect(controller.locationPhase, AsyncPhase.success);
      expect(controller.selectedNeighborhood?.displayName, '우만동');
    });

    test('host business validation blocks invalid number', () {
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
      );

      controller.startHostFlow();
      controller.toggleAllAgreements(true);
      controller.confirmConsent();
      controller.updateBusinessName('메이트야');
      controller.updateBusinessOwner('홍길동');
      controller.updateBusinessNumberPart(0, '123');
      controller.updateBusinessNumberPart(1, '45');
      controller.updateBusinessNumberPart(2, '123');
      controller.submitBusinessVerification();

      expect(controller.step, isNot(OnboardingStep.completed));
      expect(controller.errorFor('businessNumber'), isNotNull);
    });

    test('guest plus destination opens group creation placeholder', () {
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
      );

      controller.startGuestFlow();
      controller.toggleAllAgreements(true);
      controller.confirmConsent();
      controller.openHomePreviewSection(HomePreviewSection.chat);
      controller.openPlusDestination();

      expect(controller.homePreviewSection, HomePreviewSection.groupCreation);
    });

    test('host plus destination opens class registration placeholder', () {
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
      );

      controller.startHostFlow();
      controller.toggleAllAgreements(true);
      controller.confirmConsent();
      controller.openPlusDestination();

      expect(
        controller.homePreviewSection,
        HomePreviewSection.classRegistration,
      );
    });
  });
}

class _FakeLocationRepository implements NeighborhoodLocationRepository {
  _FakeLocationRepository.success()
    : _result = const LocationLookupResult.success(
        NeighborhoodSelection(
          displayName: '우만동',
          latitude: 37.2907,
          longitude: 127.0416,
        ),
      );

  final LocationLookupResult _result;

  @override
  Future<LocationLookupResult> resolveCurrentNeighborhood() async {
    return _result;
  }

  @override
  Future<LocationLookupResult> resolveNeighborhoodQuery(String query) async {
    return _result;
  }
}
