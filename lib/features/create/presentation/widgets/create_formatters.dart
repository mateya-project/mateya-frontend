import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/localization/mateya_localizations.dart';

String formatCreateDate(DateTime? date) {
  if (date == null) {
    return '';
  }
  return DateFormat.yMd(MateyaLocalizations.locale.toLanguageTag()).format(
    date,
  );
}

String formatCreateTime(TimeOfDay? time) {
  if (time == null) {
    return '';
  }
  final dateTime = DateTime(2026, 1, 1, time.hour, time.minute);
  return DateFormat.jm(MateyaLocalizations.locale.toLanguageTag()).format(
    dateTime,
  );
}
