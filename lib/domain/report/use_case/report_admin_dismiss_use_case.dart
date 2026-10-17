import 'package:dongsoop/domain/report/repository/report_repository.dart';

class ReportAdminDismissUseCase {
  final ReportRepository _reportRepository;

  ReportAdminDismissUseCase(this._reportRepository);

  Future<void> execute(int reportId) async {
    await _reportRepository.dismissReport(reportId);
  }
}
