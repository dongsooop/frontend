import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/model/report_write_request.dart';

abstract class ReportRepository {
  Future<void> writeReport(ReportWriteRequest request);
  Future<ReportSanctionResponse?> getSanctionStatus();
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request);
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  });
}