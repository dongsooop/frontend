import 'package:dongsoop/domain/timetable/use_case/delete_lecture_use_case.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_state.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimetableDetailViewModel extends StateNotifier<TimetableDetailState> {
  final DeleteLectureUseCase _deleteLectureUseCase;

  TimetableDetailViewModel(
      this._deleteLectureUseCase,
  ) : super(
    TimetableDetailState(isLoading: false),
  );

  Future<void> submitAnalysis() async {
    if (!state.canSubmitAnalysis) return;

    state = state.copyWith(isAnalyzing: true, errorMessage: null, analysisErrorMessage: null);
    try {
      final file = state.analysisImage!;

      // AI - 이미지 분석
      // BACK - 시간표 저장

      state = state.copyWith(isAnalyzing: false,);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        analysisErrorMessage: '시간표 분석에 실패했어요\n이미지를 다시 첨부해 주세요',
      );
      rethrow;
    }
  }

  Future<bool> deleteLecture(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null, analysisErrorMessage: null);

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

  void setAnalysisImage(XFile file) {
    state = state.copyWith(analysisImage: file, clearAnalysisImage: false);
  }

  void clearAnalysisImage() {
    state = state.copyWith(clearAnalysisImage: true);
  }
}