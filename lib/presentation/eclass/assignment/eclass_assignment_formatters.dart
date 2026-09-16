import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

String formatEclassDDay(int dDay) {
  if (dDay <= 0) return 'D-DAY';
  return 'D-$dDay';
}

String formatEclassDueAt(DateTime value, int dDay) {
  final time = _formatTime(value);
  if (dDay == 0) return '오늘 $time 마감';
  if (dDay == 1) return '내일 $time 마감';
  return '${value.month}월 ${value.day}일 (${_weekday(value)}) $time 마감';
}

String formatEclassDateTime(DateTime value) {
  return '${value.month}월 ${value.day}일 ${_formatTime(value)}';
}

({Color background, Color foreground}) eclassDDayColors(int dDay) {
  if (dDay <= 0) {
    return (
      background: ColorStyles.warning10,
      foreground: ColorStyles.warning100,
    );
  }
  if (dDay == 1) {
    return (
      background: ColorStyles.labelColorYellow10,
      foreground: ColorStyles.labelColorYellow100,
    );
  }
  return (
    background: ColorStyles.primary5,
    foreground: ColorStyles.primary100,
  );
}

String _formatTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _weekday(DateTime value) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return weekdays[value.weekday - 1];
}
