import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/use_case/report_admin_dismiss_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_dismiss_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportAdminDismissViewModel
    extends StateNotifier<ReportAdminDismissState> {
  final ReportAdminDismissUseCase _dismissUseCase;

  ReportAdminDismissViewModel(this._dismissUseCase)
      : super(const ReportAdminDismissState());

  Future<bool> dismiss(int reportId) async {
    if (state.isSubmitting) return false;

    if (reportId <= 0) {
      state = state.copyWith(
        errorMessage: '신고 정보를 다시 확인해 주세요.',
        failure: ReportAdminDismissFailure.unknown,
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      await _dismissUseCase.execute(reportId);
      state = state.copyWith(isSubmitting: false, clearError: true);
      return true;
    } on NoAdminAuthorityException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminDismissFailure.forbidden,
      );
    } on NotFoundSanctionException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminDismissFailure.notFound,
      );
    } on AlreadyProcessedException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminDismissFailure.alreadyProcessed,
      );
    } on SanctionException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminDismissFailure.unknown,
      );
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: '신고 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
        failure: ReportAdminDismissFailure.unknown,
      );
    }
    return false;
  }
}
