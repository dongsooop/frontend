import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/report/use_case/report_admin_sanction_write_use_case.dart';
import '../../../../main.dart';

class ReportAdminSanctionViewModel extends StateNotifier<ReportAdminSanctionState> {
  final ReportAdminSanctionWriteUseCase _adminSanctionWriteUseCase;

  ReportAdminSanctionViewModel(
    this._adminSanctionWriteUseCase,
  ) : super(
      ReportAdminSanctionState(isLoading: false, isSuccessed: false,)
  );

  Future<bool> sanctionWrite(ReportAdminSanctionRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _adminSanctionWriteUseCase.execute(request);
      state = state.copyWith(isLoading: false, isSuccessed: true);
      return true;
    } on SanctionException catch (e) {
      logger.i("제재 오류: ${e.message}");
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
        errorMessage: '제재 중 오류가 발생했습니다.',
      );
      return false;
    }
  }
}