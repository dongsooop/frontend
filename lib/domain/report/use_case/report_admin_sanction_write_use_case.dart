import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import '../repository/report_repository.dart';

class ReportAdminSanctionWriteUseCase {
  final ReportRepository _reportRepository;

  ReportAdminSanctionWriteUseCase(
    this._reportRepository,
    );

  Future<void> execute(ReportAdminSanctionRequest request) async {
    await _reportRepository.sanctionWriteReport(request);
  }
}
