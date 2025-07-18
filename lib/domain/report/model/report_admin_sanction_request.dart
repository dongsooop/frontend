import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_admin_sanction_request.freezed.dart';
part 'report_admin_sanction_request.g.dart';

@freezed
@JsonSerializable()
class ReportAdminSanctionRequest with _$ReportAdminSanctionRequest {
  final int reportId;
  final int targetMemberId;
  final SanctionType sanctionType;
  final String sanctionReason;
  final DateTime? sanctionEndAt;

  const ReportAdminSanctionRequest({
    required this.reportId,
    required this.targetMemberId,
    required this.sanctionType,
    required this.sanctionReason,
    this.sanctionEndAt,
  });

  Map<String, dynamic> toJson() => _$ReportAdminSanctionRequestToJson(this);
}