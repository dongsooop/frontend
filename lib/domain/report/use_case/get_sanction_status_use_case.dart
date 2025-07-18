import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/report/model/report_sanction_status.dart';

import '../repository/report_repository.dart';

class GetSanctionStatusUseCase {
  final ReportRepository _reportRepository;

  GetSanctionStatusUseCase(
    this._reportRepository,
  );

  Future<ReportSanctionStatus?> execute() async {
   final sanction = await _reportRepository.getSanctionStatus();

   if (sanction == null) {
     return null;
   }

   final startDate = formatSanctionTime(sanction.startDate!);
   final endDate = formatSanctionTime(sanction.endDate!);

   return ReportSanctionStatus(reason: sanction.reason!, startDate: startDate!, endDate: endDate!, description: sanction.description!);
  }
}