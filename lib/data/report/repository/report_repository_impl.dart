import 'package:dongsoop/data/report/data_source/report_data_source.dart';
import 'package:dongsoop/domain/report/model/report_write_request.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource _reportDataSource;

  ReportRepositoryImpl(this._reportDataSource);

  @override
  Future<void> writeReport(ReportWriteRequest request) async {
    await _reportDataSource.writeReport(request);
  }
}