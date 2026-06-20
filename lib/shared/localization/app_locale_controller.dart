import 'package:flutter/widgets.dart';

import 'app_language_sync_service.dart';
import '../preferences/mateya_language_preferences.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController({
    MateyaLanguagePreferences? preferences,
    AppLanguageSyncService? languageSyncService,
  }) : _preferences = preferences ?? MateyaLanguagePreferences.instance,
       _languageSyncService =
           languageSyncService ?? NetworkAppLanguageSyncService.instance;

  static final AppLocaleController instance = AppLocaleController();

  final MateyaLanguagePreferences _preferences;
  final AppLanguageSyncService _languageSyncService;

  Locale _locale = const Locale('ko');
  bool _initialized = false;

  Locale get locale => _locale;
  bool get isInitialized => _initialized;
  String get languageCode => MateyaLanguagePreferences.codeFromLocale(_locale);

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _locale = await _preferences.currentLocale();
    _initialized = true;
    notifyListeners();
  }

  Future<void> setLanguageCode(String code) async {
    final normalizedCode = await _setAndResolve(code);
    final nextLocale = MateyaLanguagePreferences.localeFromCode(normalizedCode);
    if (_locale == nextLocale) {
      return;
    }
    _locale = nextLocale;
    notifyListeners();
    await _languageSyncService.syncSelectedLanguage(normalizedCode);
  }

  Future<String> _setAndResolve(String code) async {
    await _preferences.setCurrentCode(code);
    return _preferences.currentCodeOrDefault;
  }
}
