import 'package:intl/intl.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/time/korean_time.dart';

String formatPrice(int price) {
  final l10n = MateyaLocalizations.current;
  if (price == 0) {
    return l10n.commonFree;
  }
  final locale = MateyaLocalizations.locale.toLanguageTag();
  return NumberFormat.currency(
    locale: locale,
    symbol: '₩ ',
    decimalDigits: 0,
  ).format(price);
}

String formatShortDate(DateTime dateTime) {
  return DateFormat.MMMd(
    MateyaLocalizations.locale.toLanguageTag(),
  ).format(dateTime);
}

String formatMonthDay(DateTime dateTime) => formatShortDate(dateTime);

String formatRelativeDate(DateTime dateTime) {
  final l10n = MateyaLocalizations.current;
  final now = mateyaNowInKst();
  final target = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final normalizedNow = DateTime(now.year, now.month, now.day);
  final difference = target.difference(normalizedNow).inDays;
  return switch (difference) {
    0 => l10n.commonToday,
    1 => l10n.commonTomorrow,
    _ => formatMonthDay(dateTime),
  };
}

String formatTimeRange(DateTime start, DateTime end) {
  return '${formatKoreanTime(start)} - ${formatKoreanTime(end)}';
}

String formatKoreanTime(DateTime dateTime) {
  return DateFormat.jm(
    MateyaLocalizations.locale.toLanguageTag(),
  ).format(dateTime);
}

String formatIsoDate(DateTime dateTime) {
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '${dateTime.year}-$month-$day';
}
