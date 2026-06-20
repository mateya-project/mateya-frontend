import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MateyaLanguagePreferences {
  MateyaLanguagePreferences._();

  static final MateyaLanguagePreferences instance =
      MateyaLanguagePreferences._();

  static const String _storageKey = 'mateya.language.selected_code';
  static const String _defaultLanguageCode = 'ko';

  String _cachedLanguageCode = _defaultLanguageCode;

  String get currentCodeOrDefault => _cachedLanguageCode;

  Locale get currentLocaleOrDefault => localeFromCode(_cachedLanguageCode);

  Future<String> currentCode() async {
    final preferences = await SharedPreferences.getInstance();
    final storedCode = preferences.getString(_storageKey);
    if (_isSupportedLanguageCode(storedCode)) {
      _cachedLanguageCode = storedCode!;
    }
    return _cachedLanguageCode;
  }

  Future<void> setCurrentCode(String code) async {
    final normalized = _normalizeDialogLanguageCode(code);
    _cachedLanguageCode = normalized;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, normalized);
  }

  Future<Locale> currentLocale() async {
    final code = await currentCode();
    return localeFromCode(code);
  }

  String get primaryLanguageCode =>
      primaryLanguageCodeFromCode(_cachedLanguageCode);

  String get primaryCountryCode =>
      primaryCountryCodeFromCode(_cachedLanguageCode);

  static bool _isSupportedLanguageCode(String? code) {
    return code == 'ko' || code == 'en' || code == 'zh-Hans' || code == 'ja';
  }

  static List<Locale> get supportedLocales => const <Locale>[
    Locale('ko'),
    Locale('en'),
    Locale('ja'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  static Locale localeFromCode(String code) {
    return switch (_normalizeDialogLanguageCode(code)) {
      'en' => const Locale('en'),
      'ja' => const Locale('ja'),
      'zh-Hans' => const Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode: 'Hans',
      ),
      _ => const Locale('ko'),
    };
  }

  static String codeFromLocale(Locale locale) {
    final languageCode = locale.languageCode.toLowerCase();
    final scriptCode = locale.scriptCode?.toLowerCase();
    if (languageCode == 'zh' && scriptCode == 'hans') {
      return 'zh-Hans';
    }
    return _normalizeDialogLanguageCode(languageCode);
  }

  static String _normalizeDialogLanguageCode(String code) {
    final trimmed = code.trim();
    if (_isSupportedLanguageCode(trimmed)) {
      return trimmed;
    }
    if (trimmed.toLowerCase() == 'zh') {
      return 'zh-Hans';
    }
    if (trimmed.toLowerCase() == 'zh-hans') {
      return 'zh-Hans';
    }
    final lowerCased = trimmed.toLowerCase();
    if (_isSupportedLanguageCode(lowerCased)) {
      return lowerCased;
    }
    return _defaultLanguageCode;
  }

  static String _normalizeProfileLanguageCode(String code) {
    final normalized = code.trim().toLowerCase();
    if (normalized.startsWith('zh')) {
      return 'zh';
    }
    return switch (normalized) {
      'ko' || 'en' || 'ja' => normalized,
      _ => 'ko',
    };
  }

  static String primaryLanguageCodeFromCode(String code) {
    return _normalizeProfileLanguageCode(code);
  }

  static String primaryCountryCodeFromCode(String code) {
    return switch (primaryLanguageCodeFromCode(code)) {
      'ko' => 'KR',
      'en' => 'US',
      'zh' => 'CN',
      'ja' => 'JP',
      _ => 'KR',
    };
  }
}
