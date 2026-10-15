import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';

class ReportBlindDateMessageUseCase {
  final ReportRepository _reportRepository;

  const ReportBlindDateMessageUseCase(this._reportRepository);

  Future<void> execute(BlindDateReportRequest request) async {
    await _reportRepository.reportBlindDateMessage(request);
  }
}
