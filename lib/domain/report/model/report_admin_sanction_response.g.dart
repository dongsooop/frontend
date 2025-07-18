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
      targetId: (json['targetId'] as num).toInt(),
      targetMemberId: (json['targetMemberId'] as num?)?.toInt(),
      reportReason: json['reportReason'] as String,
      description: json['description'] as String?,
      adminNickname: json['adminNickname'] as String?,
      sanctionType: json['sanctionType'] as String?,
      sanctionReason: json['sanctionReason'] as String?,
      sanctionStartDate: json['sanctionStartDate'] == null
          ? null
          : DateTime.parse(json['sanctionStartDate'] as String),
      sanctionEndDate: json['sanctionEndDate'] == null
          ? null
          : DateTime.parse(json['sanctionEndDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReportAdminSanctionResponseToJson(
        ReportAdminSanctionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterNickname': instance.reporterNickname,
      'reportType': instance.reportType,
      'targetId': instance.targetId,
      'targetMemberId': instance.targetMemberId,
      'reportReason': instance.reportReason,
      'description': instance.description,
      'adminNickname': instance.adminNickname,
      'sanctionType': instance.sanctionType,
      'sanctionReason': instance.sanctionReason,
      'sanctionStartDate': instance.sanctionStartDate?.toIso8601String(),
      'sanctionEndDate': instance.sanctionEndDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
