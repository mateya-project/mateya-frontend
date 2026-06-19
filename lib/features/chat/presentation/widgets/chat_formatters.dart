import '../../../../shared/time/korean_time.dart';
import '../../domain/chat_models.dart';

String formatRoomTimestamp(DateTime sentAt) {
  final now = mateyaNowInKst();
  final difference = now.difference(sentAt);

  if (difference.inMinutes < 1) {
    return '방금';
  }
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  }
  if (now.year == sentAt.year &&
      now.month == sentAt.month &&
      now.day == sentAt.day) {
    return '${difference.inHours}시간 전';
  }

  final yesterday = now.subtract(const Duration(days: 1));
  if (yesterday.year == sentAt.year &&
      yesterday.month == sentAt.month &&
      yesterday.day == sentAt.day) {
    return '어제';
  }

  if (now.year == sentAt.year) {
    return '${sentAt.month}월 ${sentAt.day}일';
  }
  if (now.year - sentAt.year == 1) {
    return '작년';
  }
  return '${sentAt.year}.${sentAt.month}.${sentAt.day}';
}

String formatMeridiemTime(DateTime dateTime) {
  final hour = dateTime.hour;
  final period = hour >= 12 ? '오후' : '오전';
  final displayHour = hour == 0
      ? 12
      : hour > 12
      ? hour - 12
      : hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$period $displayHour:$minute';
}

bool isSameDay(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

String formatConversationDate(ChatRoom room) {
  final reference = room.messageGroups.isEmpty
      ? mateyaNowInKst()
      : room.messageGroups.first.sentAt;
  final now = mateyaNowInKst();
  final yesterday = now.subtract(const Duration(days: 1));

  if (isSameDay(now, reference)) {
    return '오늘 ${formatMeridiemTime(reference)}';
  }
  if (isSameDay(yesterday, reference)) {
    return '어제 ${formatMeridiemTime(reference)}';
  }
  if (now.year == reference.year) {
    return '${reference.month}월 ${reference.day}일 ${formatMeridiemTime(reference)}';
  }
  return '${reference.year}.${reference.month}.${reference.day} ${formatMeridiemTime(reference)}';
}
