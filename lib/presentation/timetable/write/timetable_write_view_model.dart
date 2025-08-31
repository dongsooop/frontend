import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/use_case/create_timetable_use_case.dart';
import 'package:dongsoop/presentation/timetable/write/timetable_write_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimetableWriteViewModel extends StateNotifier<TimetableWriteState> {
  final CreateTimetableUseCase _createTimetableUseCase;

  TimetableWriteViewModel(
    this._createTimetableUseCase,
  ) : super(
    TimetableWriteState(isLoading: false),
  );

  Future<bool> createTimetable(int year, Semester semester) async {
    return await _createTimetableUseCase.execute(year, semester);
  }

  // 연도
  void setYear(int? year) {
    state = state.copyWith(
      year: year,
    );
  }

  // 학기
  void setSemester(Semester? semester) {
    state = state.copyWith(
      semester: semester,
    );
  }
}