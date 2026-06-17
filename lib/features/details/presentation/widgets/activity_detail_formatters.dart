String formatLongDate(DateTime value) {
  return '${value.year}년 ${value.month.toString().padLeft(2, '0')}월 ${value.day.toString().padLeft(2, '0')}일';
}

String formatReviewDate(DateTime value) {
  return '${value.year}년 ${value.month}월 ${value.day}일';
}

String formatTimeRange(DateTime start, DateTime end) {
  return '${_formatPeriod(start)} ${_formatHourMinute(start)} ~ ${_formatHourMinute(end)}';
}

String _formatPeriod(DateTime value) => value.hour < 12 ? '오전' : '오후';

String _formatHourMinute(DateTime value) {
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  return '${hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

String formatPrice(int price) {
  if (price == 0) {
    return '무료';
  }
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index += 1) {
    final reverseIndex = digits.length - index;
    buffer.write(digits[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write(',');
    }
  }
  return '${buffer.toString()}원';
}
