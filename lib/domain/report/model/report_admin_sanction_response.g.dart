// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_admin_sanction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportAdminSanctionResponse _$ReportAdminSanctionResponseFromJson(
        Map<String, dynamic> json) =>
    ReportAdminSanctionResponse(
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
      sanctionStartDate: json['sanctionStartDate'] == null
          ? null
          : DateTime.parse(json['sanctionStartDate'] as String),
      sanctionEndDate: json['sanctionEndDate'] == null
          ? null
          : DateTime.parse(json['sanctionEndDate'] as String),
      isSanctionActive: json['isSanctionActive'] as bool?,
      chatRoomId: json['chatRoomId'] as String?,
      chatRoomType: $enumDecodeNullable(
          _$ReportChatRoomTypeEnumMap, json['chatRoomType'],
          unknownValue: ReportChatRoomType.UNKNOWN),
      resolvedByReportId: (json['resolvedByReportId'] as num?)?.toInt(),
      messageId: json['messageId'] as String?,
      messageContent: json['messageContent'] as String?,
      messageSentAt: json['messageSentAt'] == null
          ? null
          : DateTime.parse(json['messageSentAt'] as String),
      messageContext: (json['messageContext'] as List<dynamic>?)
          ?.map((e) =>
              ReportMessageContextResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReportAdminSanctionResponseToJson(
        ReportAdminSanctionResponse instance) =>
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
      'sanctionStartDate': instance.sanctionStartDate?.toIso8601String(),
      'sanctionEndDate': instance.sanctionEndDate?.toIso8601String(),
      'isSanctionActive': instance.isSanctionActive,
      'chatRoomId': instance.chatRoomId,
      'chatRoomType': _$ReportChatRoomTypeEnumMap[instance.chatRoomType],
      'resolvedByReportId': instance.resolvedByReportId,
      'messageId': instance.messageId,
      'messageContent': instance.messageContent,
      'messageSentAt': instance.messageSentAt?.toIso8601String(),
      'messageContext':
          instance.messageContext?.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ReportChatRoomTypeEnumMap = {
  ReportChatRoomType.ONE_TO_ONE: 'ONE_TO_ONE',
  ReportChatRoomType.GROUP: 'GROUP',
  ReportChatRoomType.CONTACT: 'CONTACT',
  ReportChatRoomType.BLINDDATE: 'BLINDDATE',
  ReportChatRoomType.UNKNOWN: 'UNKNOWN',
};
