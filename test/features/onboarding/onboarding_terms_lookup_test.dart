import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_terms.dart';

void main() {
  group('onboardingTermsDocumentForConsent', () {
    test('matches API type ids', () {
      final document = onboardingTermsDocumentForConsent(
        consentId: 'service_terms',
        title: '서비스 이용 약관',
      );

      expect(document?.type, OnboardingTermsType.serviceTerms);
    });

    test('matches mock ids and alternate consent titles', () {
      final document = onboardingTermsDocumentForConsent(
        consentId: 'privacy-third-party',
        title: '개인정보 수집·이용 동의',
      );

      expect(document?.type, OnboardingTermsType.privacyThirdParty);
    });

    test('returns null when no matching document exists', () {
      final document = onboardingTermsDocumentForConsent(
        consentId: 'marketing',
        title: '마케팅 정보 수신 동의',
      );

      expect(document, isNull);
    });
  });
}
