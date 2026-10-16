import 'package:dongsoop/domain/report/enum/report_chat_room_type.dart';
import 'package:dongsoop/domain/report/model/report_message_context_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_admin_sanction_response.freezed.dart';
part 'report_admin_sanction_response.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class ReportAdminSanctionResponse with _$ReportAdminSanctionResponse {
  final int id;
  final String reporterNickname;
  final String reportType;
  final int? targetId;
  final String? targetUrl;
  final int? targetMemberId;
  final String? targetMemberNickname;
  final String reportReason;
  final String? description;
  final bool isProcessed;
  final String? adminNickname;
  final String? sanctionType;
  final String? sanctionReason;
  final DateTime? sanctionStartDate;
  final DateTime? sanctionEndDate;
  final bool? isSanctionActive;
  final String? chatRoomId;
  @JsonKey(unknownEnumValue: ReportChatRoomType.UNKNOWN)
  final ReportChatRoomType? chatRoomType;
  final int? resolvedByReportId;
  final String? messageId;
  final String? messageContent;
  final DateTime? messageSentAt;
  final List<ReportMessageContextResponse>? messageContext;
  final DateTime createdAt;

  const ReportAdminSanctionResponse({
    required this.id,
    required this.reporterNickname,
    required this.reportType,
    this.targetId,
    this.targetUrl,
    this.targetMemberId,
    this.targetMemberNickname,
    required this.reportReason,
    this.description,
    required this.isProcessed,
    this.adminNickname,
    this.sanctionType,
    this.sanctionReason,
    this.sanctionStartDate,
    this.sanctionEndDate,
    this.isSanctionActive,
    this.chatRoomId,
    this.chatRoomType,
    this.resolvedByReportId,
    this.messageId,
    this.messageContent,
    this.messageSentAt,
    this.messageContext,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$ReportAdminSanctionResponseToJson(this);
  factory ReportAdminSanctionResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportAdminSanctionResponseFromJson(json);
}
