import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_admin_sanction_response.freezed.dart';
part 'report_admin_sanction_response.g.dart';

@freezed
@JsonSerializable()
class ReportAdminSanctionResponse with _$ReportAdminSanctionResponse {
  final int id;
  final String reporterNickname;
  final String reportType;
  final int targetId;
  final int? targetMemberId;
  final String reportReason;
  final String? description;
  final String? adminNickname;
  final String? sanctionType;
  final String? sanctionReason;
  final DateTime? sanctionStartDate;
  final DateTime? sanctionEndDate;
  final DateTime createdAt;

  const ReportAdminSanctionResponse({
    required this.id,
    required this.reporterNickname,
    required this.reportType,
    required this.targetId,
    this.targetMemberId,
    required this.reportReason,
    this.description,
    this.adminNickname,
    this.sanctionType,
    this.sanctionReason,
    this.sanctionStartDate,
    this.sanctionEndDate,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$ReportAdminSanctionResponseToJson(this);
  factory ReportAdminSanctionResponse.fromJson(Map<String, dynamic> json) => _$ReportAdminSanctionResponseFromJson(json);
}