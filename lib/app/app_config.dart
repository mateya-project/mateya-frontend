abstract final class AppConfig {
  static const String naverMapClientId = String.fromEnvironment(
    'NAVER_MAP_CLIENT_ID',
    defaultValue: 'io8sqad7yn',
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
