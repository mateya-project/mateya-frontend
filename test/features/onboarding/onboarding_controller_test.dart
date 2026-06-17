import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/onboarding/data/auth_repository.dart';
import 'package:mateya_app/features/onboarding/application/onboarding_controller.dart';
import 'package:mateya_app/features/onboarding/data/location_repository.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_validators.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';

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
    test('existing guest logs in immediately after sms verification', () async {
      AuthSessionStore.instance.clear();
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
        authRepository: _FakeOnboardingAuthRepository.existingUser(),
        authSessionStore: AuthSessionStore.instance,
      );

      controller.startGuestFlow();
      controller.toggleAllAgreements(true);
      controller.confirmConsent();
      controller.updateName('임시이름');
      controller.submitName();
      controller.selectCarrier('LG U+');
      controller.updatePhoneNumber('01012345678');
      await controller.sendVerificationCode();
      controller.updateVerificationCode(controller.debugVerificationCode!);

      await controller.submitVerificationCode();

      expect(controller.step, OnboardingStep.completed);
      expect(controller.completionMode, AuthCompletionMode.login);
      expect(controller.completionHeadline, contains('로그인을 완료했어요'));
      expect(AuthSessionStore.instance.session?.user.displayName, '기존회원');
    });

    test(
      'new guest flow moves to automatic neighborhood verification',
      () async {
        AuthSessionStore.instance.clear();
        final controller = OnboardingController(
          locationRepository: _FakeLocationRepository.success(),
          authRepository: _FakeOnboardingAuthRepository(),
          authSessionStore: AuthSessionStore.instance,
        );

        controller.startGuestFlow();
        controller.toggleAllAgreements(true);
        controller.confirmConsent();
        controller.updateName('홍길동');
        controller.submitName();
        controller.selectCarrier('LG U+');
        controller.updatePhoneNumber('01012345678');
        await controller.sendVerificationCode();
        controller.updateVerificationCode(controller.debugVerificationCode!);

        await controller.submitVerificationCode();

        expect(controller.step, OnboardingStep.neighborhoodAuto);
        expect(controller.completionMode, AuthCompletionMode.signup);
        expect(controller.locationPhase, AsyncPhase.success);
        expect(controller.selectedNeighborhood?.displayName, '우만동');
      },
    );

    test('guest signup stores session after neighborhood completion', () async {
      AuthSessionStore.instance.clear();
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
        authRepository: _FakeOnboardingAuthRepository(),
        authSessionStore: AuthSessionStore.instance,
      );

      controller.startGuestFlow();
      controller.toggleAllAgreements(true);
      controller.confirmConsent();
      controller.updateName('홍길동');
      controller.submitName();
      controller.selectCarrier('LG U+');
      controller.updatePhoneNumber('01012345678');
      await controller.sendVerificationCode();
      controller.updateVerificationCode(controller.debugVerificationCode!);

      await controller.submitVerificationCode();
      await controller.completeNeighborhood();

      expect(controller.step, OnboardingStep.completed);
      expect(AuthSessionStore.instance.session?.user.displayName, '홍길동');
    });

    test('host business validation blocks invalid number', () {
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
        authRepository: _FakeOnboardingAuthRepository(),
        authSessionStore: AuthSessionStore.instance,
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
        authRepository: _FakeOnboardingAuthRepository(),
        authSessionStore: AuthSessionStore.instance,
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
        authRepository: _FakeOnboardingAuthRepository(),
        authSessionStore: AuthSessionStore.instance,
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

class _FakeOnboardingAuthRepository implements OnboardingAuthRepository {
  _FakeOnboardingAuthRepository() : loginSession = null;

  _FakeOnboardingAuthRepository.existingUser()
    : loginSession = AuthSession(
        accessToken: 'logged-in-access',
        refreshToken: 'logged-in-refresh',
        tokenType: 'Bearer',
        expiresIn: 1800,
        refreshExpiresIn: 1209600,
        refreshExpiresAt: DateTime(2026, 7, 1),
        user: AuthUserProfile(
          id: 99,
          phoneNumber: '01012345678',
          displayName: '기존회원',
          role: 'USER',
          primaryLanguage: 'ko',
          primaryCountry: 'KR',
          createdAt: DateTime(2026, 6, 14),
        ),
      );

  final AuthSession? loginSession;

  @override
  Future<SmsRequestResult> requestSmsCode({required String phoneNumber}) async {
    return SmsRequestResult(
      expiresAt: DateTime(2026, 6, 14, 10, 5),
      debugCode: '123456',
    );
  }

  @override
  Future<SmsVerificationResult> verifySmsCode({
    required String phoneNumber,
    required String code,
  }) async {
    return SmsVerificationResult(
      verificationToken: 'verification-token',
      expiresAt: DateTime(2099, 6, 14, 10, 10),
    );
  }

  @override
  Future<AuthSession> loginUser({required String verificationToken}) async {
    if (loginSession != null) {
      return loginSession!;
    }
    throw const MateyaApiException(
      type: ApiFailureType.server,
      message: '회원을 찾을 수 없습니다.',
      code: 'not-found',
      statusCode: 404,
    );
  }

  @override
  Future<AuthSession> signupGuest({
    required String verificationToken,
    required String displayName,
    required String primaryLanguage,
    required String primaryCountry,
    required AgreementState agreementState,
    required NeighborhoodSelection neighborhood,
  }) async {
    return AuthSession(
      accessToken: 'access',
      refreshToken: 'refresh',
      tokenType: 'Bearer',
      expiresIn: 1800,
      refreshExpiresIn: 1209600,
      refreshExpiresAt: DateTime(2026, 7, 1),
      user: AuthUserProfile(
        id: 1,
        phoneNumber: '01012345678',
        displayName: displayName,
        role: 'USER',
        primaryLanguage: primaryLanguage,
        primaryCountry: primaryCountry,
        createdAt: DateTime(2026, 6, 14),
      ),
    );
  }
}
