import 'package:dongsoop/domain/report/model/report_admin_sanction_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/time_formatter.dart';
part 'report_admin_sanction.freezed.dart';
part 'report_admin_sanction.g.dart';

@freezed
@JsonSerializable()
class ReportAdminSanction with _$ReportAdminSanction {
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
  final String? sanctionStartDate;
  final String? sanctionEndDate;
  final String createdAt;

  const ReportAdminSanction({
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

  factory ReportAdminSanction.fromEntity(ReportAdminSanctionResponse entity) {
    return ReportAdminSanction(
      id: entity.id,
      reporterNickname: entity.reporterNickname,
      reportType: entity.reportType,
      targetId: entity.targetId,
      targetMemberId: entity.targetMemberId,
      reportReason: entity.reportReason,
      description: entity.description,
      adminNickname: entity.adminNickname,
      sanctionReason: entity.sanctionReason,
      sanctionType: entity.sanctionType,
      sanctionStartDate: formatSanctionTime(entity.sanctionStartDate),
      sanctionEndDate: formatSanctionTime(entity.sanctionEndDate),
      createdAt: formatSanctionTime(entity.createdAt) ?? '',
    );
  }
}