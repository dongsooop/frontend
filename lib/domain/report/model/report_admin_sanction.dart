import 'package:dongsoop/domain/report/enum/report_chat_room_type.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_response.dart';
import 'package:dongsoop/domain/report/model/report_message_context.dart';
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
  final String? sanctionStartDate;
  final String? sanctionEndDate;
  final bool? isSanctionActive;
  final String? chatRoomId;
  final ReportChatRoomType? chatRoomType;
  final int? resolvedByReportId;
  final String? messageId;
  final String? messageContent;
  final String? messageSentAt;
  final List<ReportMessageContext> messageContext;
  final String createdAt;

  const ReportAdminSanction({
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
    this.messageContext = const [],
    required this.createdAt,
  });

  factory ReportAdminSanction.fromEntity(ReportAdminSanctionResponse entity) {
    return ReportAdminSanction(
      id: entity.id,
      reporterNickname: entity.reporterNickname,
      reportType: entity.reportType,
      targetId: entity.targetId,
      targetUrl: entity.targetUrl,
      targetMemberId: entity.targetMemberId,
      targetMemberNickname: entity.targetMemberNickname,
      reportReason: entity.reportReason,
      description: entity.description,
      isProcessed: entity.isProcessed,
      adminNickname: entity.adminNickname,
      sanctionReason: entity.sanctionReason,
      sanctionType: entity.sanctionType,
      sanctionStartDate: formatSanctionTime(entity.sanctionStartDate),
      sanctionEndDate: formatSanctionTime(entity.sanctionEndDate),
      isSanctionActive: entity.isSanctionActive,
      chatRoomId: entity.chatRoomId,
      chatRoomType: entity.chatRoomType,
      resolvedByReportId: entity.resolvedByReportId,
      messageId: entity.messageId,
      messageContent: entity.messageContent,
      messageSentAt: formatSanctionTime(entity.messageSentAt),
      messageContext: entity.messageContext
              ?.map(ReportMessageContext.fromEntity)
              .toList() ??
          const [],
      createdAt: formatSanctionTime(entity.createdAt) ?? '',
    );
  }
}

extension ReportAdminSanctionDisplay on ReportAdminSanction {
  String get targetMemberLabel {
    final nickname = targetMemberNickname?.trim();
    if (nickname != null && nickname.isNotEmpty) return nickname;

    final memberId = targetMemberId;
    if (memberId != null) return '사용자 ID $memberId';

    return '알 수 없는 사용자';
  }

  String? get relatedResolutionLabel {
    final reportId = resolvedByReportId;
    if (reportId == null) return null;

    return '신고 #$reportId 처리로 함께 해결됨';
  }
}
