import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/data/report/data_source/report_data_source.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/model/report_write_request.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import '../../../domain/report/enum/sanction_type.dart';
import '../../../main.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource _reportDataSource;
  final AuthDataSource _authDataSource;

  ReportRepositoryImpl(
    this._reportDataSource,
    this._authDataSource,
  );

  @override
  Future<void> writeReport(ReportWriteRequest request) async {
    await _reportDataSource.writeReport(request);
  }

  @override
  Future<ReportSanctionResponse?> getSanctionStatus() async {
    final response = await _reportDataSource.getSanctionStatus();

    if (!response.isSanctioned) {
      return null;
    }

    final sanctionType = SanctionType.fromString(response.sanctionType!);
    switch (sanctionType) {
      case SanctionType.WARNING:
        // 경고
        break;
      case SanctionType.TEMPORARY_BAN:
        // 일시정지
        logger.i('신고 - 로그아웃');
        await _authDataSource.logout();
        break;
      case SanctionType.PERMANENT_BAN:
        // 영구정지
        logger.i('신고 - 영구정지');
        await _authDataSource.deleteUser();
        break;
      case SanctionType.CONTENT_DELETION:
        // 게시글 삭제
        break;
    }
    return response;
  }

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) async {
    await _reportDataSource.sanctionWriteReport(request);
  }

  @override
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
      int page = 0,
      int size = 10,
    }) async {
    final response = await _reportDataSource.getReports(type, sort, page: page, size: size);
    if (response == null || response.isEmpty) return [];

    final List<ReportAdminSanction> reports = [];

    // 병렬 처리
    await Future.wait(response.map((report) async {
      reports.add(ReportAdminSanction.fromEntity(report));
    }));

    return reports;
  }
}