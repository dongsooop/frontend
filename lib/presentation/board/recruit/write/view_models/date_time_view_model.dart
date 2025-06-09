import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_use_case_provider.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_write_use_case.dart';
import 'package:dongsoop/presentation/board/recruit/write/state/date_time_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_time_view_model.g.dart';

@riverpod
class DateTimeViewModel extends _$DateTimeViewModel {
  ValidateWriteUseCase get _validator =>
      ref.watch(validateWriteUseCaseProvider);

  @override
  DateTimeState build() {
    final now = DateTime.now();
    final roundedNow = _roundUpTo10(now);
    return DateTimeState(
      currentMonth: DateTime(now.year, now.month),
      startDateTime: roundedNow,
      endDateTime: roundedNow.add(const Duration(hours: 24)),
      startTimePicked: false,
      endTimePicked: false,
    );
  }

  static DateTime _roundUpTo10(DateTime dt) {
    final roundedMinute = ((dt.minute + 9) ~/ 10) * 10;
    if (roundedMinute == 60) {
      dt = dt.add(const Duration(hours: 1));
      return DateTime(dt.year, dt.month, dt.day, dt.hour, 0);
    }
    return DateTime(dt.year, dt.month, dt.day, dt.hour, roundedMinute);
  }

  void updateSelectedDate(DateTime date, bool isStart) {
    final base = isStart ? state.startDateTime : state.endDateTime;
    final updated =
        DateTime(date.year, date.month, date.day, base.hour, base.minute);

    if (isStart) {
      final currentEnd = state.endDateTime;

      final isAfter = updated.isAfter(currentEnd);
      final updatedDateOnly =
          DateTime(updated.year, updated.month, updated.day);
      final currentEndDateOnly =
          DateTime(currentEnd.year, currentEnd.month, currentEnd.day);

      final shouldAdjustEnd =
          updatedDateOnly.isAfter(currentEndDateOnly) || isAfter;

      final newEnd =
          shouldAdjustEnd ? updated.add(const Duration(days: 1)) : currentEnd;

      state = state.copyWith(
        startDateTime: updated,
        endDateTime: newEnd,
      );
    } else {
      state = state.copyWith(endDateTime: updated);
    }
  }

  void updateSelectedTime(int hour, int minute, bool isStart) {
    final base = isStart ? state.startDateTime : state.endDateTime;
    final updated = DateTime(base.year, base.month, base.day, hour, minute);

    if (isStart) {
      final currentEnd = state.endDateTime;

      final isAfter = updated.isAfter(currentEnd);
      final updatedDateOnly =
          DateTime(updated.year, updated.month, updated.day);
      final currentEndDateOnly =
          DateTime(currentEnd.year, currentEnd.month, currentEnd.day);

      final shouldAdjustEnd =
          updatedDateOnly.isAfter(currentEndDateOnly) || isAfter;

      final newEnd =
          shouldAdjustEnd ? updated.add(const Duration(days: 1)) : currentEnd;

      state = state.copyWith(
        startDateTime: updated,
        endDateTime: newEnd,
      );
    } else {
      state = state.copyWith(endDateTime: updated);
    }
  }

  void confirmStartTime() => state = state.copyWith(startTimePicked: true);
  void confirmEndTime() => state = state.copyWith(endTimePicked: true);

  bool validateStartTime() => _validator.isValidStartTime(state.startDateTime);

  bool validateEndTime() => _validator.isValidEndDateTime(
        start: state.startDateTime,
        end: state.endDateTime,
      );

  bool confirmDateTime(bool isStart) {
    final isValid = isStart ? validateStartTime() : validateEndTime();
    if (!isValid) return false;
    isStart ? confirmStartTime() : confirmEndTime();
    return true;
  }

  void tryMoveToMonth(DateTime month, bool isStart) {
    if (!canMoveToNextMonth(month, isStart)) return;
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
    final max = DateTime(base.year, base.month + (isStart ? 3 : 1));
    final maxMonthOnly = DateTime(max.year, max.month);
    return !targetMonth.isAfter(maxMonthOnly);
  }

  bool isDateEnabled(DateTime date, bool isStart) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isStart) {
      final maxStart = DateTime(today.year, today.month + 3, today.day);
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
