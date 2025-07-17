// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_applicant_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitApplicantListModel _$RecruitApplicantListModelFromJson(
        Map<String, dynamic> json) =>
    RecruitApplicantListModel(
      memberName: json['memberName'] as String,
      memberId: (json['memberId'] as num).toInt(),
      departmentName: json['departmentName'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$RecruitApplicantListModelToJson(
        RecruitApplicantListModel instance) =>
    <String, dynamic>{
      'memberName': instance.memberName,
      'memberId': instance.memberId,
      'departmentName': instance.departmentName,
      'status': instance.status,
    };
