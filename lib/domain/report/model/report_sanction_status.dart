import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_sanction_status.freezed.dart';
part 'report_sanction_status.g.dart';

@freezed
@JsonSerializable()
class ReportSanctionStatus with _$ReportSanctionStatus {
  final String reason;
  final String description;
  final String startDate;
  final String endDate;

  const ReportSanctionStatus({
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  Map<String, dynamic> toJson() => _$ReportSanctionStatusToJson(this);
}