import 'package:intl/intl.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/time/korean_time.dart';
import '../../domain/chat_models.dart';

String formatRoomTimestamp(DateTime sentAt) {
  final l10n = MateyaLocalizations.current;
  final locale = MateyaLocalizations.locale.toLanguageTag();
  final now = mateyaNowInKst();
  final difference = now.difference(sentAt);

  if (difference.inMinutes < 1) {
    return l10n.chatJustNow;
  }
  if (difference.inMinutes < 60) {
    return l10n.chatMinutesAgo(difference.inMinutes);
  }
  if (now.year == sentAt.year &&
      now.month == sentAt.month &&
      now.day == sentAt.day) {
    return l10n.chatHoursAgo(difference.inHours);
  }

  final yesterday = now.subtract(const Duration(days: 1));
  if (yesterday.year == sentAt.year &&
      yesterday.month == sentAt.month &&
      yesterday.day == sentAt.day) {
    return l10n.chatYesterday;
  }

  if (now.year == sentAt.year) {
    return DateFormat.Md(locale).format(sentAt);
  }
  if (now.year - sentAt.year == 1) {
    return l10n.chatLastYear;
  }
  return DateFormat.yMd(locale).format(sentAt);
}

String formatMeridiemTime(DateTime dateTime) {
  return DateFormat.jm(MateyaLocalizations.locale.toLanguageTag()).format(
    dateTime,
  );
}

bool isSameDay(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

String formatConversationDate(ChatRoom room) {
  final l10n = MateyaLocalizations.current;
  final locale = MateyaLocalizations.locale.toLanguageTag();
  final reference = room.messageGroups.isEmpty
      ? mateyaNowInKst()
      : room.messageGroups.first.sentAt;
  final now = mateyaNowInKst();
  final yesterday = now.subtract(const Duration(days: 1));

  if (isSameDay(now, reference)) {
    return '${l10n.commonToday} ${formatMeridiemTime(reference)}';
  }
  if (isSameDay(yesterday, reference)) {
    return '${l10n.chatYesterday} ${formatMeridiemTime(reference)}';
  }
  if (now.year == reference.year) {
    return '${DateFormat.Md(locale).format(reference)} ${formatMeridiemTime(reference)}';
  }
  return '${DateFormat.yMd(locale).format(reference)} ${formatMeridiemTime(reference)}';
}
