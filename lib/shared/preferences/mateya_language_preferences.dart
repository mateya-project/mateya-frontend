import 'package:shared_preferences/shared_preferences.dart';

class MateyaLanguagePreferences {
  MateyaLanguagePreferences._();

  static final MateyaLanguagePreferences instance =
      MateyaLanguagePreferences._();

  static const String _storageKey = 'mateya.language.selected_code';
  static const String _defaultLanguageCode = 'ko';

  String _cachedLanguageCode = _defaultLanguageCode;

  String get currentCodeOrDefault => _cachedLanguageCode;

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

  String get primaryLanguageCode =>
      _normalizeProfileLanguageCode(_cachedLanguageCode);

  String get primaryCountryCode => switch (primaryLanguageCode) {
    'ko' => 'KR',
    'en' => 'US',
    'zh' => 'CN',
    'ja' => 'JP',
    _ => 'KR',
  };

  static bool _isSupportedLanguageCode(String? code) {
    return code == 'ko' || code == 'en' || code == 'zh-Hans' || code == 'ja';
  }

  static String _normalizeDialogLanguageCode(String code) {
    if (_isSupportedLanguageCode(code)) {
      return code;
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
}
