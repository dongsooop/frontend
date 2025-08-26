import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/presentation/timetable/write/timetable_write_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/exception/exception.dart';

class TimetableWriteViewModel extends StateNotifier<TimetableWriteState> {

  TimetableWriteViewModel(

  ) : super(
    TimetableWriteState(isLoading: false),
  );

  Future<bool> createTimetable() async {
    return true;
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