import '../../../shared/localization/mateya_localizations.dart';

enum OnboardingTermsType {
  serviceTerms('SERVICE_TERMS'),
  privacyThirdParty('PRIVACY_THIRD_PARTY'),
  locationBasedService('LOCATION_BASED_SERVICE'),
  ageOver14('AGE_OVER_14');

  const OnboardingTermsType(this.apiType);

  final String apiType;
}

class OnboardingTermsSection {
  const OnboardingTermsSection({
    required this.title,
    required this.body,
    this.points = const <String>[],
  });

  final String title;
  final String body;
  final List<String> points;
}

class OnboardingTermsDocument {
  const OnboardingTermsDocument({
    required this.type,
    required this.title,
    required this.effectiveDateLabel,
    required this.summary,
    required this.sections,
  });

  final OnboardingTermsType type;
  final String title;
  final String effectiveDateLabel;
  final String summary;
  final List<OnboardingTermsSection> sections;
}

List<OnboardingTermsDocument> get kRequiredOnboardingTermsDocuments {
  final l10n = MateyaLocalizations.current;
  return <OnboardingTermsDocument>[
    OnboardingTermsDocument(
      type: OnboardingTermsType.serviceTerms,
      title: l10n.onboardingTermsServiceTitle,
      effectiveDateLabel: l10n.onboardingTermsPendingEffectiveDate,
      summary: l10n.onboardingTermsServiceSummary,
      sections: <OnboardingTermsSection>[
        OnboardingTermsSection(
          title: l10n.onboardingTermsServiceSection1Title,
          body: l10n.onboardingTermsServiceSection1Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsServiceSection2Title,
          body: l10n.onboardingTermsServiceSection2Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsServiceSection3Title,
          body: l10n.onboardingTermsServiceSection3Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsServiceSection4Title,
          body: l10n.onboardingTermsServiceSection4Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsServiceSection5Title,
          body: l10n.onboardingTermsServiceSection5Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsServiceSection6Title,
          body: l10n.onboardingTermsServiceSection6Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsServiceSection7Title,
          body: l10n.onboardingTermsServiceSection7Body,
        ),
      ],
    ),
    OnboardingTermsDocument(
      type: OnboardingTermsType.privacyThirdParty,
      title: l10n.onboardingTermsPrivacyTitle,
      effectiveDateLabel: l10n.onboardingTermsPendingEffectiveDate,
      summary: l10n.onboardingTermsPrivacySummary,
      sections: <OnboardingTermsSection>[
        OnboardingTermsSection(
          title: l10n.onboardingTermsPrivacySection1Title,
          body: l10n.onboardingTermsPrivacySection1Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsPrivacySection2Title,
          body: l10n.onboardingTermsPrivacySection2Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsPrivacySection3Title,
          body: l10n.onboardingTermsPrivacySection3Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsPrivacySection4Title,
          body: l10n.onboardingTermsPrivacySection4Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsPrivacySection5Title,
          body: l10n.onboardingTermsPrivacySection5Body,
        ),
      ],
    ),
    OnboardingTermsDocument(
      type: OnboardingTermsType.locationBasedService,
      title: l10n.onboardingTermsLocationTitle,
      effectiveDateLabel: l10n.onboardingTermsPendingEffectiveDate,
      summary: l10n.onboardingTermsLocationSummary,
      sections: <OnboardingTermsSection>[
        OnboardingTermsSection(
          title: l10n.onboardingTermsLocationSection1Title,
          body: l10n.onboardingTermsLocationSection1Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsLocationSection2Title,
          body: l10n.onboardingTermsLocationSection2Body,
          points: <String>[
            l10n.onboardingTermsLocationSection2Point1,
            l10n.onboardingTermsLocationSection2Point2,
            l10n.onboardingTermsLocationSection2Point3,
          ],
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsLocationSection3Title,
          body: l10n.onboardingTermsLocationSection3Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsLocationSection4Title,
          body: l10n.onboardingTermsLocationSection4Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsLocationSection5Title,
          body: l10n.onboardingTermsLocationSection5Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsLocationSection6Title,
          body: l10n.onboardingTermsLocationSection6Body,
        ),
      ],
    ),
    OnboardingTermsDocument(
      type: OnboardingTermsType.ageOver14,
      title: l10n.onboardingTermsAgeTitle,
      effectiveDateLabel: l10n.onboardingTermsPendingEffectiveDate,
      summary: l10n.onboardingTermsAgeSummary,
      sections: <OnboardingTermsSection>[
        OnboardingTermsSection(
          title: l10n.onboardingTermsAgeSection1Title,
          body: l10n.onboardingTermsAgeSection1Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsAgeSection2Title,
          body: l10n.onboardingTermsAgeSection2Body,
        ),
        OnboardingTermsSection(
          title: l10n.onboardingTermsAgeSection3Title,
          body: l10n.onboardingTermsAgeSection3Body,
        ),
      ],
    ),
  ];
}

OnboardingTermsDocument onboardingTermsDocumentForType(
  OnboardingTermsType type,
) {
  return kRequiredOnboardingTermsDocuments.firstWhere(
    (document) => document.type == type,
  );
}

OnboardingTermsDocument? onboardingTermsDocumentForConsent({
  required String consentId,
  required String title,
}) {
  final normalizedConsentId = _normalizeTermsLookupKey(consentId);
  final normalizedTitle = _normalizeTermsLookupKey(title);

  for (final document in kRequiredOnboardingTermsDocuments) {
    final aliases = _termsLookupAliases[document.type] ?? const <String>{};
    final normalizedDocumentTitle = _normalizeTermsLookupKey(document.title);
    if (normalizedConsentId == normalizedDocumentTitle ||
        normalizedTitle == normalizedDocumentTitle) {
      return document;
    }
    for (final alias in aliases) {
      final normalizedAlias = _normalizeTermsLookupKey(alias);
      if (normalizedConsentId == normalizedAlias ||
          normalizedTitle == normalizedAlias) {
        return document;
      }
    }
  }

  return null;
}

String _normalizeTermsLookupKey(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[\s·.,()\[\]{}]'), '')
      .replaceAll('_', '')
      .replaceAll('-', '');
}

const Map<OnboardingTermsType, Set<String>> _termsLookupAliases =
    <OnboardingTermsType, Set<String>>{
      OnboardingTermsType.serviceTerms: <String>{
        'SERVICE_TERMS',
        'service_terms',
        'service-terms',
        '서비스 이용 약관',
      },
      OnboardingTermsType.privacyThirdParty: <String>{
        'PRIVACY_THIRD_PARTY',
        'privacy_third_party',
        'privacy-third-party',
        '개인정보 제3자 제공 동의',
        '개인정보 수집·이용 동의',
      },
      OnboardingTermsType.locationBasedService: <String>{
        'LOCATION_BASED_SERVICE',
        'location_based_service',
        'location-based-service',
        '위치기반서비스 이용약관',
        '위치기반 서비스 이용 동의',
      },
      OnboardingTermsType.ageOver14: <String>{
        'AGE_OVER_14',
        'age_over_14',
        'age-over-14',
        '만 14세 이상 확인',
      },
    };
