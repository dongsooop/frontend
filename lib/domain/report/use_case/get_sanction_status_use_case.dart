import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/report_sanction_status.dart';

import '../repository/report_repository.dart';

class GetSanctionStatusUseCase {
  final ReportRepository _reportRepository;

  GetSanctionStatusUseCase(
    this._reportRepository,
  );

  Future<ReportSanctionStatus?> execute() async {
    final sanction = await _reportRepository.getSanctionStatus();

    if (sanction == null) {
      return null;
    }

    final sanctionType =
        SanctionType.tryFromString(sanction.sanctionType ?? '');
    final startDate = formatSanctionTime(sanction.startDate);
    final endDate = formatSanctionTime(sanction.endDate);
    final isSupportedType = sanctionType == SanctionType.TEMPORARY_BAN ||
        sanctionType == SanctionType.PERMANENT_BAN;

    if (sanctionType == null ||
        !isSupportedType ||
        startDate == null ||
        sanction.reason == null ||
        sanction.description == null ||
        (sanctionType == SanctionType.TEMPORARY_BAN && endDate == null)) {
      throw const SanctionStatusException(
        '제재 상태 응답이 올바르지 않습니다. 다시 시도해 주세요.',
      );
    }

    return ReportSanctionStatus(
      sanctionType: sanctionType,
      reason: sanction.reason!,
      startDate: startDate,
      endDate: sanctionType == SanctionType.PERMANENT_BAN ? null : endDate,
      description: sanction.description!,
    );
  }
}
