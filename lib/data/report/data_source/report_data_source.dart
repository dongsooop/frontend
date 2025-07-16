import 'package:dongsoop/domain/report/model/report_write_request.dart';

abstract class ReportDataSource {
  Future<void> writeReport(ReportWriteRequest request);
}