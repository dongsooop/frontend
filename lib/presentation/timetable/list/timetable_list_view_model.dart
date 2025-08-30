import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/use_case/delete_timetable_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/get_timetable_info_use_case.dart';
import 'package:dongsoop/presentation/timetable/list/timetable_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimetableListViewModel extends StateNotifier<TimetableListState> {
  final GetTimetableInfoUseCase _getTimetableInfoUseCase;
  final DeleteTimetableUseCase _deleteTimetableUseCase;

  TimetableListViewModel(
    this._getTimetableInfoUseCase,
    this._deleteTimetableUseCase,
  ) : super(
    TimetableListState(isLoading: false, localTimetableInfo: []),
  );

  Future<void> getTimetableList() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final localData = await _getTimetableInfoUseCase.execute();
      state = state.copyWith(isLoading: false, localTimetableInfo: localData);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '시간표를 불러오는 중 오류가 발생했습니다.',
      );
    }
  }

  Future<void> deleteTimetable(int year, Semester semester) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _deleteTimetableUseCase.execute(year, semester);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '시간표를 삭제하는 중 오류가 발생했습니다.',
      );
    }
  }
}