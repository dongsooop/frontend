import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/mapper/sanction_status_mapper.dart';
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

    final status = SanctionStatusMapper.tryFromResponse(sanction);
    if (status == null) {
      throw const SanctionStatusException(
        '제재 상태 응답이 올바르지 않습니다. 다시 시도해 주세요.',
      );
    }
    return status;
  }
}
