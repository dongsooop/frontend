import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/model/report_write_request.dart';
import 'package:dongsoop/domain/report/use_case/report_write_use_case.dart';
import 'package:dongsoop/presentation/report/report_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class ReportViewModel extends StateNotifier<ReportState> {
  final ReportWriteUseCase _reportWriteUseCase;

  ReportViewModel(
    this._reportWriteUseCase,
  ) : super(
    ReportState(isLoading: false, isSuccessed: false,)
  );

  Future<bool> reportWrite(ReportWriteRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _reportWriteUseCase.execute(request);
      state = state.copyWith(isLoading: false, isSuccessed: true);
      return true;
    } on ReportException catch (e) {
      logger.i("신고 오류: ${e.message}");
      state = state.copyWith(
        isLoading: false,
        isSuccessed: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccessed: false,
        errorMessage: '신고 중 오류가 발생했습니다.',
      );
      return false;
    }
  }
}