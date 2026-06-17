import 'package:flutter/material.dart';

String formatCreateDate(DateTime? date) {
  if (date == null) {
    return '';
  }
  return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
}

String formatCreateTime(TimeOfDay? time) {
  if (time == null) {
    return '';
  }
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final period = time.period == DayPeriod.am ? '오전' : '오후';
  return '$period ${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
