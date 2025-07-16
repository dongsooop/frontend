import 'package:dongsoop/domain/report/model/report_write_request.dart';

abstract class ReportRepository {
  Future<void> writeReport(ReportWriteRequest request);
}