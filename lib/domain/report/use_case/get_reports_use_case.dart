import 'package:dongsoop/domain/report/enum/report_admin_filter.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';

class GetReportsUseCase {
  final ReportRepository _reportRepository;

  GetReportsUseCase(
    this._reportRepository,
  );

  Future<List<ReportAdminSanction>> execute(
    ReportAdminFilter filter, {
    int page = 0,
    int size = 10,
  }) async {
    final reports = await _reportRepository.getReports(
      filter.apiValue,
      filter.sort,
      page: page,
      size: size,
    );

    return reports ?? const [];
  }
}
