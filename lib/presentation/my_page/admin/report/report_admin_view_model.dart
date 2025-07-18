import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/report/use_case/get_reports_use_case.dart';

class ReportAdminViewModel extends StateNotifier<ReportAdminState> {
  final GetReportsUseCase _getReportsUseCase;

  ReportAdminViewModel(
    this._getReportsUseCase,
  ) : super(ReportAdminState(isLoading: false));

  Future<void> loadReports(String type) async {
    state = state.copyWith(isLoading: true, errorMessage: null,);

    try {
      final reports = await _getReportsUseCase.execute(type) ?? [];

      state = state.copyWith(isLoading: false, reports: reports);
    } catch (e, st) {
      logger.e('load reports error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '신고 목록을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }

  // 페이징
  Future<void> fetchNextPage(String type) async {
    if (!state.hasNext || state.isLoading) return; // 이미 끝이거나 로딩 중이면 무시

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.page + 1;
      final newReports = await _getReportsUseCase.execute(type, page: nextPage, size: 10);

      final isLast = newReports == null || newReports.length < 10;
      state = state.copyWith(
        isLoading: false,
        reports: [...(state.reports ?? []), ...?newReports],
        page: nextPage,
        hasNext: !isLast,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '신고 목록을 불러오는 중 오류가 발생했습니다.');
    }
  }
}