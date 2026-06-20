import 'package:mateya_app/l10n/generated/app_localizations.dart';

import 'mateya_localizations.dart';

typedef LocalizedTextBuilder = String Function(AppLocalizations l10n);

class LocalizedText {
  const LocalizedText(this._builder);

  final LocalizedTextBuilder _builder;

  String resolve([AppLocalizations? l10n]) {
    return _builder(l10n ?? MateyaLocalizations.current);
  }
}
