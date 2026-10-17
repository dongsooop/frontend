import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';

abstract class ReportRepository {
  Future<void> reportChatMessage(ChatReportRequest request);
  Future<void> reportBlindDateMessage(BlindDateReportRequest request);
  Future<ReportSanctionResponse?> getSanctionStatus();
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request);
  Future<void> dismissReport(int reportId);
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  });
}
