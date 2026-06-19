abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'MATEYA_API_BASE_URL',
    defaultValue: 'https://api.mateya.cloud',
  );

  static const String naverMapClientId = String.fromEnvironment(
    'NAVER_MAP_CLIENT_ID',
    defaultValue: 'io8sqad7yn',
  );

  static const String customerSupportUrl = String.fromEnvironment(
    'MATEYA_CUSTOMER_SUPPORT_URL',
    defaultValue: 'https://pf.kakao.com/_EPxmXX/friend',
  );

  static const String privacyPolicyUrl = String.fromEnvironment(
    'MATEYA_PRIVACY_POLICY_URL',
    defaultValue:
        'https://app.notion.com/p/Mateya-38458d06892d801185d8eca4faec6e8b?source=copy_link',
  );

  static const List<String> supportedCarriers = <String>[
    'SKT',
    'KT',
    'LG U+',
    'SKT 알뜰폰',
    'KT 알뜰폰',
    'LG U+ 알뜰폰',
  ];

  static const List<String> supportedCountryCodes = <String>[
    '+82',
    '+81',
    '+1',
    '+84',
    '+86',
  ];
}
