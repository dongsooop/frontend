import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';

class ReportAdminState {
  final bool isLoading;
  final String? errorMessage;
  final List<ReportAdminSanction>? reports;

  ReportAdminState({
    required this.isLoading,
    this.errorMessage,
    this.reports,
  });

  ReportAdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ReportAdminSanction>? reports,
  }) {
    return ReportAdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      reports: reports ?? this.reports,
    );
  }
}
