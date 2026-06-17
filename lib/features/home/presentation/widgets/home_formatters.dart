String formatPrice(int price) {
  if (price == 0) {
    return 'FREE';
  }
  final digits = price.toString();
  final buffer = StringBuffer('₩ ');
  for (var index = 0; index < digits.length; index += 1) {
    final reverseIndex = digits.length - index;
    buffer.write(digits[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String formatShortDate(DateTime dateTime) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[dateTime.month - 1]} ${dateTime.day}';
}

String formatMonthDay(DateTime dateTime) => formatShortDate(dateTime);

String formatRelativeDate(DateTime dateTime) {
  final now = DateTime(2026, 6, 13);
  final target = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final difference = target.difference(now).inDays;
  return switch (difference) {
    0 => '오늘',
    1 => '내일',
    _ => formatMonthDay(dateTime),
  };
}

String formatTimeRange(DateTime start, DateTime end) {
  return '${formatKoreanTime(start)} - ${formatKoreanTime(end)}';
}

String formatKoreanTime(DateTime dateTime) {
  final period = dateTime.hour >= 12 ? '오후' : '오전';
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$period $hour:$minute';
}

String formatIsoDate(DateTime dateTime) {
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '${dateTime.year}-$month-$day';
}
