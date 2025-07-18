// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_admin_sanction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportAdminSanctionRequest _$ReportAdminSanctionRequestFromJson(
        Map<String, dynamic> json) =>
    ReportAdminSanctionRequest(
      reportId: (json['reportId'] as num).toInt(),
      targetMemberId: (json['targetMemberId'] as num).toInt(),
      sanctionType: $enumDecode(_$SanctionTypeEnumMap, json['sanctionType']),
      sanctionReason: json['sanctionReason'] as String,
      sanctionEndAt: json['sanctionEndAt'] == null
          ? null
          : DateTime.parse(json['sanctionEndAt'] as String),
    );

Map<String, dynamic> _$ReportAdminSanctionRequestToJson(
        ReportAdminSanctionRequest instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'targetMemberId': instance.targetMemberId,
      'sanctionType': _$SanctionTypeEnumMap[instance.sanctionType]!,
      'sanctionReason': instance.sanctionReason,
      'sanctionEndAt': instance.sanctionEndAt?.toIso8601String(),
    };

const _$SanctionTypeEnumMap = {
  SanctionType.WARNING: 'WARNING',
  SanctionType.TEMPORARY_BAN: 'TEMPORARY_BAN',
  SanctionType.PERMANENT_BAN: 'PERMANENT_BAN',
  SanctionType.CONTENT_DELETION: 'CONTENT_DELETION',
};
