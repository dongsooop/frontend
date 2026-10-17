import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_admin_sanction_request.freezed.dart';
part 'report_admin_sanction_request.g.dart';

@freezed
@JsonSerializable(includeIfNull: false)
class ReportAdminSanctionRequest with _$ReportAdminSanctionRequest {
  final int reportId;
  final int targetMemberId;
  final SanctionType sanctionType;
  final String? sanctionReason;
  @JsonKey(toJson: _sanctionEndAtToJson)
  final DateTime? sanctionEndAt;

  const ReportAdminSanctionRequest({
    required this.reportId,
    required this.targetMemberId,
    required this.sanctionType,
    this.sanctionReason,
    this.sanctionEndAt,
  });

  Map<String, dynamic> toJson() => _$ReportAdminSanctionRequestToJson(this);
}

String? _sanctionEndAtToJson(DateTime? value) {
  if (value == null) return null;

  String twoDigits(int number) => number.toString().padLeft(2, '0');
  return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)}'
      'T${twoDigits(value.hour)}:${twoDigits(value.minute)}:'
      '${twoDigits(value.second)}';
}
