// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_write_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportWriteRequest _$ReportWriteRequestFromJson(Map<String, dynamic> json) =>
    ReportWriteRequest(
      reportType: json['reportType'] as String,
      targetId: (json['targetId'] as num).toInt(),
      reason: json['reason'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ReportWriteRequestToJson(ReportWriteRequest instance) =>
    <String, dynamic>{
      'reportType': instance.reportType,
      'targetId': instance.targetId,
      'reason': instance.reason,
      'description': instance.description,
    };
