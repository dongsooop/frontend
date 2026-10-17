import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/report/data_source/report_data_source.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource _reportDataSource;
  final AuthDataSource _authDataSource;

  ReportRepositoryImpl(
    this._reportDataSource,
    this._authDataSource,
  );

  @override
  Future<void> reportChatMessage(ChatReportRequest request) async {
    await _reportDataSource.reportChatMessage(request);
  }

  @override
  Future<void> reportBlindDateMessage(
    BlindDateReportRequest request,
  ) async {
    await _reportDataSource.reportBlindDateMessage(request);
  }

  @override
  Future<ReportSanctionResponse?> getSanctionStatus() async {
    final response = await _reportDataSource.getSanctionStatus();

    if (!response.isSanctioned) {
      return null;
    }

    final sanctionType = SanctionType.tryFromString(
      response.sanctionType ?? '',
    );
    final hasRequiredFields = response.reason?.trim().isNotEmpty == true &&
        response.description?.trim().isNotEmpty == true &&
        response.startDate != null;
    final isSupportedType = sanctionType == SanctionType.TEMPORARY_BAN ||
        sanctionType == SanctionType.PERMANENT_BAN;
    final hasValidEndDate =
        sanctionType != SanctionType.TEMPORARY_BAN || response.endDate != null;

    if (!hasRequiredFields || !isSupportedType || !hasValidEndDate) {
      throw const SanctionStatusException(
        '제재 상태 응답이 올바르지 않습니다. 다시 시도해 주세요.',
      );
    }

    // 제재가 확인된 사용자는 서버의 회원 정보에 영향을 주지 않고
    // 이 기기에 저장된 로그인 정보만 제거한다.
    await _authDataSource.clearLocalData();
    return response;
  }

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) async {
    await _reportDataSource.sanctionWriteReport(request);
  }

  @override
  Future<void> dismissReport(int reportId) async {
    await _reportDataSource.dismissReport(reportId);
  }

  @override
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  }) async {
    final response =
        await _reportDataSource.getReports(type, sort, page: page, size: size);
    if (response == null || response.isEmpty) return [];

    return response.map(ReportAdminSanction.fromEntity).toList(growable: false);
  }
}
