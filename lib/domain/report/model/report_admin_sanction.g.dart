// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_admin_sanction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportAdminSanction _$ReportAdminSanctionFromJson(Map<String, dynamic> json) =>
    ReportAdminSanction(
      id: (json['id'] as num).toInt(),
      reporterNickname: json['reporterNickname'] as String,
      reportType: json['reportType'] as String,
      targetId: (json['targetId'] as num?)?.toInt(),
      targetUrl: json['targetUrl'] as String?,
      targetMemberId: (json['targetMemberId'] as num?)?.toInt(),
      targetMemberNickname: json['targetMemberNickname'] as String?,
      reportReason: json['reportReason'] as String,
      description: json['description'] as String?,
      isProcessed: json['isProcessed'] as bool,
      adminNickname: json['adminNickname'] as String?,
      sanctionType: json['sanctionType'] as String?,
      sanctionReason: json['sanctionReason'] as String?,
      sanctionStartDate: json['sanctionStartDate'] as String?,
      sanctionEndDate: json['sanctionEndDate'] as String?,
      isSanctionActive: json['isSanctionActive'] as bool?,
      chatRoomId: json['chatRoomId'] as String?,
      messageId: json['messageId'] as String?,
      messageContent: json['messageContent'] as String?,
      messageSentAt: json['messageSentAt'] as String?,
      messageContext: (json['messageContext'] as List<dynamic>?)
              ?.map((e) =>
                  ReportMessageContext.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$ReportAdminSanctionToJson(
        ReportAdminSanction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterNickname': instance.reporterNickname,
      'reportType': instance.reportType,
      'targetId': instance.targetId,
      'targetUrl': instance.targetUrl,
      'targetMemberId': instance.targetMemberId,
      'targetMemberNickname': instance.targetMemberNickname,
      'reportReason': instance.reportReason,
      'description': instance.description,
      'isProcessed': instance.isProcessed,
      'adminNickname': instance.adminNickname,
      'sanctionType': instance.sanctionType,
      'sanctionReason': instance.sanctionReason,
      'sanctionStartDate': instance.sanctionStartDate,
      'sanctionEndDate': instance.sanctionEndDate,
      'isSanctionActive': instance.isSanctionActive,
      'chatRoomId': instance.chatRoomId,
      'messageId': instance.messageId,
      'messageContent': instance.messageContent,
      'messageSentAt': instance.messageSentAt,
      'messageContext': instance.messageContext,
      'createdAt': instance.createdAt,
    };
