// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_sanction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportSanctionResponse _$ReportSanctionResponseFromJson(
        Map<String, dynamic> json) =>
    ReportSanctionResponse(
      isSanctioned: json['isSanctioned'] as bool,
      sanctionType: json['sanctionType'] as String?,
      reason: json['reason'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ReportSanctionResponseToJson(
        ReportSanctionResponse instance) =>
    <String, dynamic>{
      'isSanctioned': instance.isSanctioned,
      'sanctionType': instance.sanctionType,
      'reason': instance.reason,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'description': instance.description,
    };
