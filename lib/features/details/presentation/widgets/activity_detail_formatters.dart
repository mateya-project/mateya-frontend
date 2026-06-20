import 'package:intl/intl.dart';

import '../../../../shared/localization/mateya_localizations.dart';

String formatLongDate(DateTime value) {
  return DateFormat.yMMMMd(
    MateyaLocalizations.locale.toLanguageTag(),
  ).format(value);
}

String formatReviewDate(DateTime value) {
  return DateFormat.yMMMd(
    MateyaLocalizations.locale.toLanguageTag(),
  ).format(value);
}

String formatTimeRange(DateTime start, DateTime end) {
  final locale = MateyaLocalizations.locale.toLanguageTag();
  return '${DateFormat.jm(locale).format(start)} - ${DateFormat.jm(locale).format(end)}';
}

String formatPrice(int price) {
  if (price == 0) {
    return MateyaLocalizations.current.commonFree;
  }
  return NumberFormat.currency(
    locale: MateyaLocalizations.locale.toLanguageTag(),
    symbol: '₩ ',
    decimalDigits: 0,
  ).format(price);
}
