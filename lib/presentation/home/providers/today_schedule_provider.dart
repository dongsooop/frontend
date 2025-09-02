import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/providers/timetable_providers.dart';

// timeTable
int _WeekdayFrom(WeekDay weekday) {
  switch (weekday) {
    case WeekDay.MONDAY:
      return 1;
    case WeekDay.TUESDAY:
      return 2;
    case WeekDay.WEDNESDAY:
      return 3;
    case WeekDay.THURSDAY:
      return 4;
    case WeekDay.FRIDAY:
      return 5;
  }
}

DateTime _startForToday(Lecture lecture, DateTime today) {
  final part = lecture.startAt.split(':');
  final hour = int.parse(part[0]);
  final minutes = int.parse(part[1]);
  return DateTime(today.year, today.month, today.day, hour, minutes);
}

final todayLecturesFromVmProvider = Provider<List<Lecture>>((ref) {
  final state = ref.watch(timetableViewModelProvider);
  final list = state.lectureList ?? const <Lecture>[];

  final now = DateTime.now();
  final todayW = now.weekday;

  final today = list
      .where((lecture) => _WeekdayFrom(lecture.week) == todayW)
      .toList()
    ..sort((a, b) => _startForToday(a, now).compareTo(_startForToday(b, now)));

  return today;
});

// calendar