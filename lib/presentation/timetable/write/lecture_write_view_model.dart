import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:dongsoop/domain/timetable/use_case/create_lecture_use_case.dart';
import 'package:dongsoop/presentation/timetable/write/lecture_write_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LectureWriteViewModel extends StateNotifier<LectureWriteState> {
  final CreateLectureUseCase _createLectureUseCase;

  LectureWriteViewModel(
    this._createLectureUseCase,
  ) : super(
    LectureWriteState(isLoading: false, day: WeekDay.MONDAY, startHour: 9, startMinute: 0, endHour: 10, endMinute: 0),
  );

  void setDay(WeekDay day) {
    state = state.copyWith(day: day);
  }

  void setTimeRange({
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) {
    state = state.copyWith(
      startHour: startHour,
      startMinute: startMinute,
      endHour: endHour,
      endMinute: endMinute,
    );
  }

  bool validateTimeRange() {
    final startTotal = state.startHour * 60 + state.startMinute;
    final endTotal = state.endHour * 60 + state.endMinute;

    return endTotal > startTotal;
  }

  bool canCreateLecture(List<Lecture> existingLectures) {
    final newStart = (state.startHour - 9) * 60 + state.startMinute;
    final newEnd = (state.endHour - 9) * 60 + state.endMinute;

    for (final lec in existingLectures) {
      if (lec.week != state.day) continue;

      final existStart = lec.startAt.toMinutesFrom9AM();
      final existEnd   = lec.endAt.toMinutesFrom9AM();

      final overlap = newStart < existEnd && newEnd > existStart;
      if (overlap) return false;
    }
    return true;
  }

  Future<bool> createLecture({
    required int year,
    required Semester semester,
    required String name,
    String? professor,
    String? location,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final startAt = _formatTime(state.startHour, state.startMinute);
    final endAt = _formatTime(state.endHour, state.endMinute);

    try {
      final result = await _createLectureUseCase.execute(
        LectureRequest(
          name: name,
          professor: professor,
          location: location,
          week: state.day,
          startAt: startAt,
          endAt: endAt,
          year: year,
          semester: semester.name,
        )
      );
      state = state.copyWith(isLoading: false,);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '시간표를 작성하는 중 오류가 발생했습니다.\n$e',
      );
      return false;
    }
  }

  String _formatTime(int hour, int minute) {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm:00';
  }
}