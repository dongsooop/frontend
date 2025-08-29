import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/use_case/check_local_timetable_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/get_lecture_use_case.dart';
import 'package:dongsoop/presentation/timetable/timetable_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimetableViewModel extends StateNotifier<TimetableState> {
  final GetLectureUseCase _getLectureUseCase;
  final CheckLocalTimetableUseCase _checkLocalTimetableUseCase;

  TimetableViewModel(
    this._getLectureUseCase,
    this._checkLocalTimetableUseCase,
  ) : super(
    TimetableState(isLoading: false,),
  );

  // 현재 학기 계산
  void getCurrentSemester(DateTime now) {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final year = now.year;
    final month = now.month;

    if (month >= 2 && month <= 6) {
      state = state.copyWith(year: year, semester: Semester.FIRST);
    } else if (month >= 8 && month <= 12) {
      state = state.copyWith(year: year, semester: Semester.SECOND);
    } else if (month == 7){
      state = state.copyWith(year: year, semester: Semester.SUMMER);
    } else if (month == 1){
      state = state.copyWith(year: year, semester: Semester.WINTER);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '알 수 없는 오류가 발생했습니다.',
      );
    }
  }

  void setYearSemester(int year, Semester semester) {
    state = state.copyWith(year: year, semester: semester);
  }

  Future<void> getLecture({int? overrideYear, Semester? overrideSemester}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final year = overrideYear ?? state.year;
    final semester = overrideSemester ?? state.semester;

    try {
      final lectureList = await _getLectureUseCase.execute(year!, semester!);
      state = state.copyWith(isLoading: false, lectureList: lectureList);
      if (lectureList == null || lectureList.isEmpty) {
        final exists = await _checkLocalTimetableUseCase.execute(year, semester);
        state = state.copyWith(exists: exists);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '시간표를 불러오는 중 오류가 발생했습니다.',
      );
    }
  }
}