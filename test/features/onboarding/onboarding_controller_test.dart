import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/onboarding/data/auth_repository.dart';
import 'package:mateya_app/features/onboarding/application/onboarding_controller.dart';
import 'package:mateya_app/features/onboarding/data/location_repository.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_validators.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

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
    test(
      'existing guest moves to neighborhood verification after sms verification',
      () async {
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
        controller.updatePhoneNumber('01012345678');
        await controller.sendVerificationCode();
        controller.updateVerificationCode(controller.debugVerificationCode!);

        await controller.submitVerificationCode();

        expect(controller.step, OnboardingStep.neighborhoodAuto);
        expect(controller.completionMode, AuthCompletionMode.login);
        expect(controller.completionHeadline, contains('로그인을 완료했어요'));
        expect(controller.previousNeighborhoodLabel, '우만동');
        expect(AuthSessionStore.instance.session?.user.displayName, '기존회원');
      },
    );

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
        controller.updatePhoneNumber('01012345678');
        await controller.sendVerificationCode();
        controller.updateVerificationCode(controller.debugVerificationCode!);

        await controller.submitVerificationCode();

        expect(controller.step, OnboardingStep.neighborhoodAuto);
        expect(controller.completionMode, AuthCompletionMode.signup);
        expect(controller.locationPhase, AsyncPhase.idle);
        expect(controller.selectedNeighborhood, isNull);
      },
    );

    test('location verification success updates neighborhood state', () async {
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
        authRepository: _FakeOnboardingAuthRepository(),
        authSessionStore: AuthSessionStore.instance,
      );

      await controller.startAutomaticNeighborhoodVerification();

      expect(controller.locationPhase, AsyncPhase.success);
      expect(controller.selectedNeighborhood?.displayName, '우만동');
    });

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
      controller.updatePhoneNumber('01012345678');
      await controller.sendVerificationCode();
      controller.updateVerificationCode(controller.debugVerificationCode!);

      await controller.submitVerificationCode();
      await controller.startAutomaticNeighborhoodVerification();
      await controller.completeNeighborhood();

      expect(controller.step, OnboardingStep.completed);
      expect(AuthSessionStore.instance.session?.user.displayName, '홍길동');
    });

    test(
      'permission denial keeps auto step and exposes failure state',
      () async {
        final controller = OnboardingController(
          locationRepository: _FakeLocationRepository.permissionDenied(),
          authRepository: _FakeOnboardingAuthRepository(),
          authSessionStore: AuthSessionStore.instance,
        );

        controller.startGuestFlow();
        controller.toggleAllAgreements(true);
        controller.confirmConsent();
        controller.updateName('홍길동');
        controller.submitName();
        controller.updatePhoneNumber('01012345678');
        await controller.sendVerificationCode();
        controller.updateVerificationCode(controller.debugVerificationCode!);
        await controller.submitVerificationCode();

        expect(controller.step, OnboardingStep.neighborhoodAuto);
        expect(controller.locationPhase, AsyncPhase.idle);

        await controller.startAutomaticNeighborhoodVerification();

        expect(controller.locationPhase, AsyncPhase.validationError);
        expect(
          controller.locationFailure?.type,
          LocationFailureType.permissionDenied,
        );
        expect(controller.selectedNeighborhood, isNull);
      },
    );

    test(
      'manual neighborhood completion resolves query before signup',
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
        controller.updatePhoneNumber('01012345678');
        await controller.sendVerificationCode();
        controller.updateVerificationCode(controller.debugVerificationCode!);
        await controller.submitVerificationCode();

        controller.openManualNeighborhood();
        controller.updateManualNeighborhoodQuery('우만동');
        await controller.completeNeighborhood();

        expect(controller.step, OnboardingStep.completed);
        expect(AuthSessionStore.instance.session?.user.displayName, '홍길동');
      },
    );

    test(
      'guest signup retries with a fresh verification token when the first token is rejected',
      () async {
        AuthSessionStore.instance.clear();
        final authRepository = _FakeOnboardingAuthRepository(
          failFirstGuestSignupWithInvalidToken: true,
        );
        final controller = OnboardingController(
          locationRepository: _FakeLocationRepository.success(),
          authRepository: authRepository,
          authSessionStore: AuthSessionStore.instance,
        );

        controller.startGuestFlow();
        controller.toggleAllAgreements(true);
        controller.confirmConsent();
        controller.updateName('홍길동');
        controller.submitName();
        controller.updatePhoneNumber('01012345678');
        await controller.sendVerificationCode();
        controller.updateVerificationCode(controller.debugVerificationCode!);
        await controller.submitVerificationCode();
        await controller.startAutomaticNeighborhoodVerification();
        await controller.completeNeighborhood();

        expect(controller.step, OnboardingStep.completed);
        expect(authRepository.signupGuestAttemptCount, 2);
        expect(
          authRepository.lastGuestSignupVerificationToken,
          'verification-token-2',
        );
      },
    );

    test(
      'guest signup retries with a fresh verification token when signup reports an expired verification code',
      () async {
        AuthSessionStore.instance.clear();
        final authRepository = _FakeOnboardingAuthRepository(
          firstGuestSignupErrorMessage: '인증번호가 만료되었습니다.',
        );
        final controller = OnboardingController(
          locationRepository: _FakeLocationRepository.success(),
          authRepository: authRepository,
          authSessionStore: AuthSessionStore.instance,
        );

        controller.startGuestFlow();
        controller.toggleAllAgreements(true);
        controller.confirmConsent();
        controller.updateName('홍길동');
        controller.submitName();
        controller.updatePhoneNumber('01012345678');
        await controller.sendVerificationCode();
        controller.updateVerificationCode(controller.debugVerificationCode!);
        await controller.submitVerificationCode();
        await controller.startAutomaticNeighborhoodVerification();
        await controller.completeNeighborhood();

        expect(controller.step, OnboardingStep.completed);
        expect(authRepository.signupGuestAttemptCount, 2);
        expect(
          authRepository.lastGuestSignupVerificationToken,
          'verification-token-2',
        );
      },
    );

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
      controller.updateBusinessOpeningDate('20240601');
      controller.updateBusinessNumberPart(0, '123');
      controller.updateBusinessNumberPart(1, '45');
      controller.updateBusinessNumberPart(2, '123');
      controller.submitBusinessVerification();

      expect(controller.step, isNot(OnboardingStep.completed));
      expect(controller.errorFor('businessNumber'), isNotNull);
    });

    test('new host flow verifies business then signs up after sms', () async {
      AuthSessionStore.instance.clear();
      final authRepository = _FakeOnboardingAuthRepository();
      final controller = OnboardingController(
        locationRepository: _FakeLocationRepository.success(),
        authRepository: authRepository,
        authSessionStore: AuthSessionStore.instance,
      );

      controller.startHostFlow();
      controller.toggleAllAgreements(true);
      controller.confirmConsent();
      controller.updateBusinessName('메이트야 공방');
      controller.updateBusinessOwner('홍길동');
      controller.updateBusinessOpeningDate('20240601');
      controller.updateBusinessNumberPart(0, '123');
      controller.updateBusinessNumberPart(1, '45');
      controller.updateBusinessNumberPart(2, '67890');

      await controller.submitBusinessVerification();

      expect(controller.step, OnboardingStep.guestPhone);

      controller.updatePhoneNumber('01012345678');
      await controller.sendVerificationCode();
      controller.updateVerificationCode(controller.debugVerificationCode!);

      await controller.submitVerificationCode();

      expect(controller.step, OnboardingStep.completed);
      expect(AuthSessionStore.instance.session?.user.displayName, '홍길동');
      expect(authRepository.lastBusinessVerificationToken, 'business-token');
      expect(authRepository.lastBusinessName, '메이트야 공방');
    });

    test(
      'sms request without debug code still exposes verification state',
      () async {
        final controller = OnboardingController(
          locationRepository: _FakeLocationRepository.success(),
          authRepository: _FakeOnboardingAuthRepository(smsDebugCode: null),
          authSessionStore: AuthSessionStore.instance,
        );

        controller.startGuestFlow();
        controller.toggleAllAgreements(true);
        controller.confirmConsent();
        controller.updateName('홍길동');
        controller.submitName();
        controller.updatePhoneNumber('01012345678');

        await controller.sendVerificationCode();

        expect(controller.hasSentVerificationCode, isTrue);
        expect(controller.debugVerificationCode, isNull);
        expect(controller.remainingSeconds, greaterThan(0));
      },
    );

    test(
      'sms verification without debug code still calls verify api',
      () async {
        final authRepository = _FakeOnboardingAuthRepository(
          smsDebugCode: null,
        );
        final controller = OnboardingController(
          locationRepository: _FakeLocationRepository.success(),
          authRepository: authRepository,
          authSessionStore: AuthSessionStore.instance,
        );

        controller.startGuestFlow();
        controller.toggleAllAgreements(true);
        controller.confirmConsent();
        controller.updateName('홍길동');
        controller.submitName();
        controller.updatePhoneNumber('01012345678');

        await controller.sendVerificationCode();
        controller.updateVerificationCode('123456');
        await controller.submitVerificationCode();

        expect(authRepository.verifySmsCodeCallCount, 1);
        expect(controller.errorFor('verification'), isNull);
        expect(controller.step, OnboardingStep.neighborhoodAuto);
      },
    );

    test('resend updates inline notice without phone field error', () async {
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
      controller.updatePhoneNumber('01012345678');

      await controller.sendVerificationCode();
      await controller.resendVerificationCode();

      expect(controller.resendCount, 2);
      expect(controller.errorFor('phone'), isNull);
      expect(
        controller.verificationNotice,
        '인증번호는 하루 최대 5번까지 다시 받을 수 있어요. 현재 2회 요청했어요.',
      );
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

  _FakeLocationRepository.permissionDenied()
    : _result = const LocationLookupResult.failure(
        LocationFailure(
          LocationFailureType.permissionDenied,
          '위치 권한이 없으면 현재 위치 자동 인증을 사용할 수 없어요. 직접 입력은 계속 진행할 수 있고, 권한을 허용하면 다시 시도할 수 있어요.',
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
  _FakeOnboardingAuthRepository({
    this.smsDebugCode = '123456',
    this.failFirstGuestSignupWithInvalidToken = false,
    this.firstGuestSignupErrorMessage,
  }) : loginSession = null;

  _FakeOnboardingAuthRepository.existingUser()
    : smsDebugCode = '123456',
      failFirstGuestSignupWithInvalidToken = false,
      firstGuestSignupErrorMessage = null,
      loginSession = AuthSession(
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
          activityRegionName: '우만동',
          createdAt: DateTime(2026, 6, 14),
        ),
      );

  final AuthSession? loginSession;
  final String? smsDebugCode;
  final bool failFirstGuestSignupWithInvalidToken;
  final String? firstGuestSignupErrorMessage;
  String? lastBusinessVerificationToken;
  String? lastBusinessName;
  String? lastGuestSignupVerificationToken;
  int verifySmsCodeCallCount = 0;
  int signupGuestAttemptCount = 0;

  @override
  Future<SmsRequestResult> requestSmsCode({required String phoneNumber}) async {
    return SmsRequestResult(
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      debugCode: smsDebugCode,
    );
  }

  @override
  Future<SmsVerificationResult> verifySmsCode({
    required String phoneNumber,
    required String code,
  }) async {
    verifySmsCodeCallCount += 1;
    return SmsVerificationResult(
      verificationToken: 'verification-token-$verifySmsCodeCallCount',
      expiresAt: DateTime(2099, 6, 14, 10, 10),
    );
  }

  @override
  Future<BusinessVerificationResult> verifyBusiness({
    required String businessNumber,
    required String representativeName,
    required String openingDate,
  }) async {
    return BusinessVerificationResult(
      businessVerificationToken: 'business-token',
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
    signupGuestAttemptCount += 1;
    lastGuestSignupVerificationToken = verificationToken;
    if ((failFirstGuestSignupWithInvalidToken ||
            firstGuestSignupErrorMessage != null) &&
        signupGuestAttemptCount == 1) {
      throw MateyaApiException(
        type: ApiFailureType.validation,
        message: firstGuestSignupErrorMessage ?? 'sms인증 토큰이 유효하지 않아요.',
        code: 'validation-failed',
        statusCode: 400,
      );
    }
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

  @override
  Future<AuthSession> signupHost({
    required String verificationToken,
    required String businessVerificationToken,
    required String displayName,
    required String businessName,
    required String primaryLanguage,
    required String primaryCountry,
    required AgreementState agreementState,
  }) async {
    lastBusinessVerificationToken = businessVerificationToken;
    lastBusinessName = businessName;
    return AuthSession(
      accessToken: 'host-access',
      refreshToken: 'host-refresh',
      tokenType: 'Bearer',
      expiresIn: 1800,
      refreshExpiresIn: 1209600,
      refreshExpiresAt: DateTime(2026, 7, 1),
      user: AuthUserProfile(
        id: 7,
        phoneNumber: '01012345678',
        displayName: displayName,
        role: 'BUSINESS',
        primaryLanguage: primaryLanguage,
        primaryCountry: primaryCountry,
        createdAt: DateTime(2026, 6, 14),
      ),
    );
  }
}
