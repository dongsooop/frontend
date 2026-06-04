import 'package:dongsoop/domain/schedule/entities/schedule_list_entity.dart';
import 'schedule_date_utils.dart';

List<ScheduleListEntity> eventsOnDay(
    List<ScheduleListEntity> events,
    DateTime targetDay,
    ) {
  final startDate = dateOnly(targetDay);
  final endExclusive = startDate.add(const Duration(days: 1));
  return events.where((event) {
    return dateRangesOverlap(
      rangeAStart: event.startAt,
      rangeAEndInclusive: event.endAt,
      rangeBStart: startDate,
      rangeBEndExclusive: endExclusive,
    );
  }).toList();
}

List<ScheduleListEntity> eventsInWeek(
    List<ScheduleListEntity> events,
    DateTime weekStart,
    ) {
  final startDate = dateOnly(weekStart);
  final endExclusive = startDate.add(const Duration(days: 7));
  return events.where((event) {
    return dateRangesOverlap(
      rangeAStart: event.startAt,
      rangeAEndInclusive: event.endAt,
      rangeBStart: startDate,
      rangeBEndExclusive: endExclusive,
    );
  }).toList();
}

List<ScheduleListEntity> eventsInMonth(
    List<ScheduleListEntity> events,
    DateTime month, {
      bool onlyStartsInMonth = false,
    }) {
  final monthStart = DateTime(month.year, month.month, 1);
  final nextMonthStart = DateTime(month.year, month.month + 1, 1);

  return events.where((event) {
    final overlapsMonth = dateRangesOverlap(
      rangeAStart: event.startAt,
      rangeAEndInclusive: event.endAt,
      rangeBStart: monthStart,
      rangeBEndExclusive: nextMonthStart,
    );
    if (!overlapsMonth) return false;
    if (!onlyStartsInMonth) return true;

    final startOnlyDate = dateOnly(event.startAt);
    return !startOnlyDate.isBefore(monthStart) && startOnlyDate.isBefore(nextMonthStart);
  }).toList();
}

List<ScheduleListEntity> deduplicateEvents(
    List<ScheduleListEntity> events,
    ) {
  final seenKeys = <String>{};
  final output = <ScheduleListEntity>[];
  for (final event in events) {
    final key = (event.id != null)
        ? 'id:${event.id}'
        : 'title:${event.title}|start:${event.startAt.toIso8601String()}|end:${event.endAt.toIso8601String()}';
    if (seenKeys.add(key)) output.add(event);
  }
  return output;
}

class WeekEventPlacement {
  WeekEventPlacement({
    required this.event,
    required this.rowIndex,
    required this.startDayIndex,
    required this.endDayIndex,
    required this.isOutOfMonth,
  });

  final ScheduleListEntity event;
  final int rowIndex;
  final int startDayIndex;
  final int endDayIndex;
  final bool isOutOfMonth;
}

class WeekLayoutResult {
  WeekLayoutResult({
    required this.placements,
    required this.hiddenCount,
  });

  final List<WeekEventPlacement> placements;
  final List<int> hiddenCount;
}

WeekLayoutResult layoutWeekEvents({
  required List<DateTime> daysInWeek,
  required List<ScheduleListEntity> weekEvents,
  required DateTime focusedMonth,
  int maxRows = 3,
}) {
  final isOccupied = <List<bool>>[];
  final placements = <WeekEventPlacement>[];
  final hiddenCount = List<int>.filled(7, 0);

  final monthStart = DateTime(focusedMonth.year, focusedMonth.month, 1);
  final monthEnd = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);

  for (final event in weekEvents) {
    final startDateOnly = dateOnly(event.startAt);
    final endDateOnly = dateOnly(event.endAt);

    final startIndex = daysInWeek.indexWhere((d) => !d.isBefore(startDateOnly));
    int endIndex = -1;
    for (int i = 6; i >= 0; i--) {
      if (!daysInWeek[i].isAfter(endDateOnly)) {
        endIndex = i;
        break;
      }
    }
    if (startIndex == -1 || endIndex == -1) continue;

    int rowIndex = -1;
    for (int r = 0; r < isOccupied.length; r++) {
      var canPlace = true;
      for (int j = startIndex; j <= endIndex; j++) {
        if (isOccupied[r][j]) {
          canPlace = false;
          break;
        }
      }
      if (canPlace) {
        rowIndex = r;
        break;
      }
    }

    if (rowIndex == -1) {
      if (isOccupied.length >= maxRows) {
        for (int j = startIndex; j <= endIndex; j++) hiddenCount[j]++;
        continue;
      }
      rowIndex = isOccupied.length;
      isOccupied.add(List<bool>.filled(7, false));
    }

    for (int j = startIndex; j <= endIndex; j++) {
      isOccupied[rowIndex][j] = true;
    }

    final isOutsideMonth = endDateOnly.isBefore(monthStart) || startDateOnly.isAfter(monthEnd);

    placements.add(WeekEventPlacement(
      event: event,
      rowIndex: rowIndex,
      startDayIndex: startIndex,
      endDayIndex: endIndex,
      isOutOfMonth: isOutsideMonth,
    ));
  }

  return WeekLayoutResult(
    placements: placements,
    hiddenCount: hiddenCount,
  );
}