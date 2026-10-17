import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/model/report_sanction_status.dart';

class SanctionStatusMapper {
  const SanctionStatusMapper._();

  static ReportSanctionStatus? tryFromResponse(
    ReportSanctionResponse response,
  ) {
    if (!response.isSanctioned) return null;

    final sanctionType =
        SanctionType.tryFromString(response.sanctionType ?? '');
    final reason = response.reason?.trim();
    final description = response.description?.trim();
    final startDate = formatSanctionTime(response.startDate);
    final endDate = formatSanctionTime(response.endDate);
    final isSupportedType = sanctionType == SanctionType.TEMPORARY_BAN ||
        sanctionType == SanctionType.PERMANENT_BAN;

    if (!isSupportedType ||
        reason == null ||
        reason.isEmpty ||
        description == null ||
        description.isEmpty ||
        startDate == null ||
        (sanctionType == SanctionType.TEMPORARY_BAN && endDate == null)) {
      return null;
    }

    return ReportSanctionStatus(
      sanctionType: sanctionType!,
      reason: reason,
      description: description,
      startDate: startDate,
      endDate: sanctionType == SanctionType.PERMANENT_BAN ? null : endDate,
    );
  }
}
