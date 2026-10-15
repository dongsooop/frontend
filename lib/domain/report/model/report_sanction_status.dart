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

  Map<String, dynamic> toJson() => _$ReportSanctionStatusToJson(this);
}
