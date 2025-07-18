import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';


class GetReportsUseCase {
  final ReportRepository _reportRepository;

  GetReportsUseCase(
    this._reportRepository,
  );

  Future<List<ReportAdminSanction>?> execute(
    String type, {
    int page = 0,
    int size = 10,
  }) async {
    String sort = '';
    if (type == 'UNPROCESSED' || type == 'PROCESSED')
      sort = "createdAt,asc";
    if (type == 'ACTIVE_SANCTIONS')
      sort = "createdAt,desc";

    final reports = await _reportRepository.getReports(
      type,
      sort,
      page: page,
      size: size,
    );

    if (reports == null || reports.isEmpty) {
      return null;
    }

    return reports;
  }
}