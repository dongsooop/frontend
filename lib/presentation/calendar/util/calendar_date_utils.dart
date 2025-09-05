const weekdays = ['일', '월', '화', '수', '목', '금', '토'];

DateTime dateOnly(DateTime dateTime) =>
    DateTime(dateTime.year, dateTime.month, dateTime.day);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String weekdayName(DateTime date) => weekdays[date.weekday % 7];

String formatDateWithWeekday(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$month.$day(${weekdayName(date)})';
}

DateTime sundayWeekStart(DateTime date) {
  final onlyDate = dateOnly(date);
  final offset = onlyDate.weekday % 7;
  return onlyDate.subtract(Duration(days: offset));
}

List<DateTime> weekStartsInMonth(DateTime month) {
  final firstDay = DateTime(month.year, month.month, 1);
  final lastDay = DateTime(month.year, month.month + 1, 0);
  final start = sundayWeekStart(firstDay);
  final end = sundayWeekStart(lastDay.add(const Duration(days: 7)));

  final result = <DateTime>[];
  for (var current = start;
  current.isBefore(end);
  current = current.add(const Duration(days: 7))) {
    result.add(current);
  }
  return result;
}

bool dateRangesOverlap({
  required DateTime rangeAStart,
  required DateTime rangeAEndInclusive,
  required DateTime rangeBStart,
  required DateTime rangeBEndExclusive,
}) {
  final aStart = dateOnly(rangeAStart);
  final aEnd = dateOnly(rangeAEndInclusive);
  final bStart = dateOnly(rangeBStart);
  final bEndEx = dateOnly(rangeBEndExclusive);

  return aStart.isBefore(bEndEx) && !aEnd.isBefore(bStart);
}
