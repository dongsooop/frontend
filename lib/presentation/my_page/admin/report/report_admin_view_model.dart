import 'package:dongsoop/domain/report/enum/report_admin_filter.dart';
import 'package:dongsoop/domain/report/use_case/get_reports_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportAdminViewModel extends StateNotifier<ReportAdminState> {
  static const int _pageSize = 10;

  final GetReportsUseCase _getReportsUseCase;
  int _requestGeneration = 0;

  ReportAdminViewModel(
    this._getReportsUseCase, {
    ReportAdminFilter initialFilter = ReportAdminFilter.unprocessed,
  }) : super(ReportAdminState(filter: initialFilter));

  Future<void> loadReports({ReportAdminFilter? filter}) async {
    final nextFilter = filter ?? state.filter;
    final requestGeneration = ++_requestGeneration;
    state = ReportAdminState(
      filter: nextFilter,
      isInitialLoading: true,
    );

    try {
      final reports = await _getReportsUseCase.execute(
        nextFilter,
        size: _pageSize,
      );
      if (!_isCurrent(requestGeneration, nextFilter)) return;

      state = state.copyWith(
        isInitialLoading: false,
        hasLoaded: true,
        reports: reports,
        page: 0,
        hasNext: reports.length == _pageSize,
        clearError: true,
        clearLoadMoreError: true,
      );
    } catch (_) {
      if (!_isCurrent(requestGeneration, nextFilter)) return;

      state = state.copyWith(
        isInitialLoading: false,
        hasLoaded: true,
        errorMessage: '신고 목록을 불러오는 중 오류가 발생했습니다.',
        hasNext: false,
      );
    }
  }

  Future<void> selectFilter(ReportAdminFilter filter) async {
    if (filter == state.filter && state.reports.isNotEmpty) return;
    await loadReports(filter: filter);
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;

    final requestGeneration = ++_requestGeneration;
    final filter = state.filter;
    state = state.copyWith(
      isRefreshing: true,
      isLoadingMore: false,
      clearError: true,
      clearLoadMoreError: true,
    );

    try {
      final reports = await _getReportsUseCase.execute(
        filter,
        size: _pageSize,
      );
      if (!_isCurrent(requestGeneration, filter)) return;

      state = state.copyWith(
        isRefreshing: false,
        reports: reports,
        page: 0,
        hasNext: reports.length == _pageSize,
        clearError: true,
        clearLoadMoreError: true,
      );
    } catch (_) {
      if (!_isCurrent(requestGeneration, filter)) return;

      state = state.copyWith(
        isRefreshing: false,
        errorMessage: state.reports.isEmpty ? '신고 목록을 새로고침하지 못했습니다.' : null,
        loadMoreErrorMessage:
            state.reports.isEmpty ? null : '신고 목록을 새로고침하지 못했습니다.',
      );
    }
  }

  Future<void> fetchNextPage() async {
    if (!state.hasNext ||
        state.isInitialLoading ||
        state.isRefreshing ||
        state.isLoadingMore) {
      return;
    }

    final requestGeneration = _requestGeneration;
    final filter = state.filter;
    final nextPage = state.page + 1;
    state = state.copyWith(
      isLoadingMore: true,
      clearLoadMoreError: true,
    );

    try {
      final newReports = await _getReportsUseCase.execute(
        filter,
        page: nextPage,
        size: _pageSize,
      );
      if (!_isCurrent(requestGeneration, filter)) return;

      final reportIds = state.reports.map((report) => report.id).toSet();
      final uniqueReports = newReports
          .where((report) => reportIds.add(report.id))
          .toList(growable: false);

      state = state.copyWith(
        isLoadingMore: false,
        reports: [...state.reports, ...uniqueReports],
        page: nextPage,
        hasNext: newReports.length == _pageSize,
        clearLoadMoreError: true,
      );
    } catch (_) {
      if (!_isCurrent(requestGeneration, filter)) return;

      state = state.copyWith(
        isLoadingMore: false,
        loadMoreErrorMessage: '다음 신고 목록을 불러오지 못했습니다.',
      );
    }
  }

  bool _isCurrent(int requestGeneration, ReportAdminFilter filter) {
    return requestGeneration == _requestGeneration && state.filter == filter;
  }
}
