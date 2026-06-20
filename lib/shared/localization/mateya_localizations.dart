import 'package:flutter/widgets.dart';
import 'package:mateya_app/l10n/generated/app_localizations.dart';

import 'app_locale_controller.dart';
import '../preferences/mateya_language_preferences.dart';

extension MateyaBuildContextLocalizations on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? MateyaLocalizations.current;
}

class MateyaLocalizations {
  MateyaLocalizations._();

  static AppLocalizations get current =>
      lookupAppLocalizations(AppLocaleController.instance.locale);

  static Locale get locale => AppLocaleController.instance.locale;

  static Iterable<LocalizationsDelegate<dynamic>> get delegates =>
      AppLocalizations.localizationsDelegates;

  static List<Locale> get supportedLocales =>
      MateyaLanguagePreferences.supportedLocales;
}
