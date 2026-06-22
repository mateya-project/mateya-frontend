import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/onboarding/application/onboarding_controller.dart';
import 'package:mateya_app/features/onboarding/data/auth_repository.dart';
import 'package:mateya_app/features/onboarding/data/location_repository.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/features/onboarding/presentation/screens/onboarding_flow_page.dart';
import 'package:mateya_app/shared/auth/auth_session.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';

void main() {
  testWidgets(
    'phone step keeps verification field visible before sms request and switches CTA after request',
    (tester) async {
      final controller = OnboardingController(
        locationRepository: _WidgetFakeLocationRepository(),
        authRepository: _WidgetFakeOnboardingAuthRepository(smsDebugCode: null),
        authSessionStore: AuthSessionStore.instance,
      );

      controller.startGuestFlow();
      controller.toggleAllAgreements(true);
      controller.confirmConsent();
      controller.updateName('홍길동');
      controller.submitName();

      await tester.pumpWidget(
        MaterialApp(home: OnboardingFlowPage(controller: controller)),
      );
      await tester.pumpAndSettle();

      expect(find.text('통신사'), findsNothing);
      expect(find.text('휴대폰 번호를 입력해주세요'), findsOneWidget);
      expect(find.text('인증번호'), findsOneWidget);
      expect(find.text('휴대폰 번호를 입력하면 인증번호를 받을 수 있어요.'), findsOneWidget);
      expect(find.text('예)01012341234'), findsOneWidget);
      expect(find.text('인증번호 받기'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, '01012345678');
      await tester.pump();

      await tester.tap(find.text('인증번호 받기'));
      await tester.pumpAndSettle();

      expect(find.text('인증하기'), findsOneWidget);
      expect(find.text('인증번호'), findsOneWidget);
      expect(find.text('인증번호 다시받기'), findsOneWidget);
    },
  );
}

class _WidgetFakeLocationRepository implements NeighborhoodLocationRepository {
  @override
  Future<LocationLookupResult> resolveCurrentNeighborhood() async {
    return const LocationLookupResult.success(
      NeighborhoodSelection(
        displayName: '우만동',
        latitude: 37.2907,
        longitude: 127.0416,
      ),
    );
  }

  @override
  Future<LocationLookupResult> resolveNeighborhoodQuery(String query) async {
    return const LocationLookupResult.success(
      NeighborhoodSelection(
        displayName: '우만동',
        latitude: 37.2907,
        longitude: 127.0416,
      ),
    );
  }
}

class _WidgetFakeOnboardingAuthRepository implements OnboardingAuthRepository {
  _WidgetFakeOnboardingAuthRepository({required this.smsDebugCode});

  final String? smsDebugCode;

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
    return SmsVerificationResult(
      verificationToken: 'verification-token',
      expiresAt: DateTime(2099, 6, 19),
    );
  }

  @override
  Future<BusinessVerificationResult> verifyBusiness({
    required String businessNumber,
    required String representativeName,
    required String openingDate,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> loginUser({required String verificationToken}) async {
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
  }) {
    throw UnimplementedError();
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
  }) {
    throw UnimplementedError();
  }
}
