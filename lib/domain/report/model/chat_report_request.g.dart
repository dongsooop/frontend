// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatReportRequest _$ChatReportRequestFromJson(Map<String, dynamic> json) =>
    ChatReportRequest(
      roomId: json['roomId'] as String,
      messageId: json['messageId'] as String,
      reason: $enumDecode(_$ReportReasonEnumMap, json['reason']),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ChatReportRequestToJson(ChatReportRequest instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'messageId': instance.messageId,
      'reason': _$ReportReasonEnumMap[instance.reason]!,
      if (instance.description case final value?) 'description': value,
    };

const _$ReportReasonEnumMap = {
  ReportReason.SPAM: 'SPAM',
  ReportReason.INAPPROPRIATE_CONTENT: 'INAPPROPRIATE_CONTENT',
  ReportReason.HATE_SPEECH: 'HATE_SPEECH',
  ReportReason.FRAUD: 'FRAUD',
  ReportReason.PRIVACY_VIOLATION: 'PRIVACY_VIOLATION',
  ReportReason.COPYRIGHT_INFRINGEMENT: 'COPYRIGHT_INFRINGEMENT',
  ReportReason.OTHER: 'OTHER',
};
