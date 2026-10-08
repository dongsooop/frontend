import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';

abstract class ReportRepository {
  Future<ReportSanctionResponse?> getSanctionStatus();
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request);
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  });
}
