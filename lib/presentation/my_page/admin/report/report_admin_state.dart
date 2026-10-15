import 'package:dongsoop/domain/report/enum/report_admin_filter.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';

class ReportAdminState {
  final ReportAdminFilter filter;
  final bool isInitialLoading;
  final bool hasLoaded;
  final bool isRefreshing;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? loadMoreErrorMessage;
  final List<ReportAdminSanction> reports;
  final int page;
  final bool hasNext;

  const ReportAdminState({
    this.filter = ReportAdminFilter.unprocessed,
    this.isInitialLoading = false,
    this.hasLoaded = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.loadMoreErrorMessage,
    this.reports = const [],
    this.page = 0,
    this.hasNext = true,
  });

  ReportAdminState copyWith({
    ReportAdminFilter? filter,
    bool? isInitialLoading,
    bool? hasLoaded,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? errorMessage,
    String? loadMoreErrorMessage,
    List<ReportAdminSanction>? reports,
    int? page,
    bool? hasNext,
    bool clearError = false,
    bool clearLoadMoreError = false,
  }) {
    return ReportAdminState(
      filter: filter ?? this.filter,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      loadMoreErrorMessage: clearLoadMoreError
          ? null
          : loadMoreErrorMessage ?? this.loadMoreErrorMessage,
      reports: reports ?? this.reports,
      page: page ?? this.page,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
