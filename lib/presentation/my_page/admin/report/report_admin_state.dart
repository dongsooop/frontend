import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';

class ReportAdminState {
  final bool isLoading;
  final String? errorMessage;
  final List<ReportAdminSanction>? reports;
  final int page;
  final bool hasNext;

  ReportAdminState({
    required this.isLoading,
    this.errorMessage,
    this.reports = const [],
    this.page = 0,
    this.hasNext = true,
  });

  ReportAdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ReportAdminSanction>? reports,
    int? page,
    bool? hasNext,
  }) {
    return ReportAdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      reports: reports ?? this.reports,
      page: page ?? this.page,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
