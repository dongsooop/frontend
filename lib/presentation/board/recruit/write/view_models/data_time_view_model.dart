import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_write_use_case.dart';
import 'package:dongsoop/presentation/board/recruit/write/state/date_time_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateTimeSelectorViewModel extends StateNotifier<DateTimeSelectorState> {
  final ValidateWriteUseCase validator;

  DateTimeSelectorViewModel(this.validator)
      : super(
          DateTimeSelectorState(
            currentMonth: DateTime(DateTime.now().year, DateTime.now().month),
            startDateTime: _roundUpTo10(DateTime.now()),
            endDateTime:
                _roundUpTo10(DateTime.now()).add(const Duration(hours: 24)),
            startTimePicked: false,
            endTimePicked: false,
          ),
        );

  static DateTime _roundUpTo10(DateTime dt) {
    final roundedMinute = ((dt.minute + 9) ~/ 10) * 10;
    if (roundedMinute == 60) {
      dt = dt.add(const Duration(hours: 1));
      return DateTime(dt.year, dt.month, dt.day, dt.hour, 0);
    }
    return DateTime(dt.year, dt.month, dt.day, dt.hour, roundedMinute);
  }

  DateTime _addMonths(DateTime base, int months) {
    final year = base.year + ((base.month + months - 1) ~/ 12);
    final month = (base.month + months - 1) % 12 + 1;
    final day = base.day;
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }

  // 날짜 선택
  void updateSelectedDate(DateTime date, bool isStart) {
    final current = isStart ? state.startDateTime : state.endDateTime;
    final updated =
        DateTime(date.year, date.month, date.day, current.hour, current.minute);

    if (isStart) {
      final newEnd = updated.add(const Duration(days: 1));
      state = state.copyWith(startDateTime: updated, endDateTime: newEnd);
    } else {
      state = state.copyWith(endDateTime: updated);
    }
  }

  // 시간 선택
  void updateSelectedTime(int hour, int minute, bool isStart) {
    final base = isStart ? state.startDateTime : state.endDateTime;
    final updated = DateTime(base.year, base.month, base.day, hour, minute);

    if (isStart) {
      final newEnd = updated.add(const Duration(hours: 24));
      state = state.copyWith(
        startDateTime: updated,
        endDateTime: newEnd,
      );
    } else {
      state = state.copyWith(endDateTime: updated);
    }
  }

  void confirmStartTime() {
    state = state.copyWith(startTimePicked: true);
  }

  void confirmEndTime() {
    state = state.copyWith(endTimePicked: true);
  }

  bool validateStartTime() {
    return validator.isValidStartTime(state.startDateTime);
  }

  bool validateEndTime() {
    return validator.isValidEndDateTime(
      start: state.startDateTime,
      end: state.endDateTime,
    );
  }

  // View에서 onMonthChanged 시 직접 호출할 메서드
  void tryMoveToMonth(DateTime month, bool isStart) {
    if (isStart && !canMoveToNextMonth(month, true)) return;
    if (!isStart && !canMoveToNextMonth(month, false)) return;

    state = state.copyWith(currentMonth: month);
  }

  bool canMoveToPreviousMonth(DateTime currentMonth) {
    final now = DateTime.now();
    final todayMonth = DateTime(now.year, now.month);
    return currentMonth.isAfter(todayMonth);
  }

  bool canMoveToNextMonth(DateTime targetMonth, bool isStart) {
    final now = DateTime.now();
    final base = isStart ? now : state.startDateTime;
    final max = _addMonths(base, isStart ? 3 : 1);
    final maxMonthOnly = DateTime(max.year, max.month);
    return !targetMonth.isAfter(maxMonthOnly);
  }

  bool isDateEnabled(DateTime date, bool isStart) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isStart) {
      final maxStart = _addMonths(today, 3);
      return !date.isBefore(today) && !date.isAfter(maxStart);
    } else {
      final minEnd = state.startDateTime.add(const Duration(hours: 24));
      final maxEnd = state.startDateTime.add(const Duration(days: 28));

      final minDate = DateTime(minEnd.year, minEnd.month, minEnd.day);
      final maxDate = DateTime(maxEnd.year, maxEnd.month, maxEnd.day);

      return !date.isBefore(minDate) && !date.isAfter(maxDate);
    }
  }
}
