import 'package:dongsoop/domain/timetable/use_case/delete_lecture_use_case.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimetableDetailViewModel extends StateNotifier<TimetableDetailState> {
  final DeleteLectureUseCase _deleteLectureUseCase;

  TimetableDetailViewModel(
      this._deleteLectureUseCase,
  ) : super(
    TimetableDetailState(isLoading: false),
  );

  Future<bool> deleteLecture(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _deleteLectureUseCase.execute(id);
      state = state.copyWith(isLoading: false,);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '시간표를 삭제하는 중 오류가 발생했습니다.',
      );
      return false;
    }
  }
}