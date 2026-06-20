// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MateYa';

  @override
  String get brandLockupSubtitle =>
      'The start of a special journey\nsharing Korean warmth and culture';

  @override
  String get bottomNavigationHome => 'Home';

  @override
  String get bottomNavigationExplore => 'Explore';

  @override
  String get bottomNavigationChat => 'Chat';

  @override
  String get bottomNavigationProfile => 'Profile';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonLater => 'Later';

  @override
  String get permissionOpenAppSettings => 'Open app settings';

  @override
  String get permissionOpenLocationSettings => 'Open location settings';

  @override
  String get languageDialogBarrierLabel => 'Language selection';

  @override
  String get languageDialogTitle => 'Change language';

  @override
  String get languageDialogSupportedLanguages => 'Supported languages';
}
