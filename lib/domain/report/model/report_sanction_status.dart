import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_sanction_status.freezed.dart';
part 'report_sanction_status.g.dart';

@freezed
@JsonSerializable()
class ReportSanctionStatus with _$ReportSanctionStatus {
  final SanctionType sanctionType;
  final String reason;
  final String description;
  final String startDate;
  final String? endDate;

  const ReportSanctionStatus({
    required this.sanctionType,
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  String get endDateLabel => endDate ?? '영구';

  String get periodLabel => '$startDate ~ $endDateLabel';

  String get noticeMessage {
    final normalizedReason = reason.trim();
    final normalizedDescription = description.trim();
    final lines = <String>[
      '제재 유형: ${sanctionType.message}',
      '제재 사유: $normalizedReason',
    ];
    if (normalizedDescription != normalizedReason) {
      lines.add('제재 내용: $normalizedDescription');
    }
    lines.add('제재 기간: $periodLabel');
    return lines.join('\n');
  }

  Map<String, dynamic> toJson() => _$ReportSanctionStatusToJson(this);
}
