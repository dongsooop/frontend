import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/timetable/use_case/delete_lecture_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/get_analysis_timetable_use_case.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class TimetableDetailViewModel extends StateNotifier<TimetableDetailState> {
  final DeleteLectureUseCase _deleteLectureUseCase;
  final GetAnalysisTimetableUseCase _getAnalysisTimetableUseCase;

  TimetableDetailViewModel(
    this._deleteLectureUseCase,
    this._getAnalysisTimetableUseCase,
  ) : super(
    TimetableDetailState(isLoading: false),
  );

  Future<void> submitAnalysis() async {
    if (!state.canSubmitAnalysis) return;

    state = state.copyWith(isAnalyzing: true, errorMessage: null, analysisErrorMessage: null);
    try {
      final file = state.analysisImage!;

      // AI - 이미지 분석
      state = state.copyWith(analysisLoadingMessage: '시간표를 분석하는 중...');
      final timetable = await _getAnalysisTimetableUseCase.execute(file);
      state = state.copyWith(analysisLoadingMessage: '시간표를 저장하는 중...');
      // BACK - 시간표 저장
      print('완료');

      state = state.copyWith(isAnalyzing: false,);
    } on TimetableException catch (e) {
      state = state.copyWith(isAnalyzing: false, analysisErrorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        analysisErrorMessage: '알 수 없는 오류가 발생했어요',
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