// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_sanction_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportSanctionStatus _$ReportSanctionStatusFromJson(
        Map<String, dynamic> json) =>
    ReportSanctionStatus(
      reason: json['reason'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ReportSanctionStatusToJson(
        ReportSanctionStatus instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'description': instance.description,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
