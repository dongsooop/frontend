// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blind_date_report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlindDateReportRequest _$BlindDateReportRequestFromJson(
        Map<String, dynamic> json) =>
    BlindDateReportRequest(
      sessionId: json['sessionId'] as String,
      messageId: json['messageId'] as String,
      reason: $enumDecode(_$ReportReasonEnumMap, json['reason']),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$BlindDateReportRequestToJson(
        BlindDateReportRequest instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
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
