import 'package:dongsoop/domain/report/model/report_write_request.dart';

import '../repository/report_repository.dart';

class ReportWriteUseCase {
  final ReportRepository _reportRepository;

  ReportWriteUseCase(
    this._reportRepository,
  );

  Future<void> execute(ReportWriteRequest request) async {
    await _reportRepository.writeReport(request);
  }
}
