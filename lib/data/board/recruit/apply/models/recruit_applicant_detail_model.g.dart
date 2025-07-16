// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_applicant_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitApplicantDetailModel _$RecruitApplicantDetailModelFromJson(
        Map<String, dynamic> json) =>
    RecruitApplicantDetailModel(
      boardId: (json['boardId'] as num).toInt(),
      applierId: (json['applierId'] as num).toInt(),
      applierName: json['applierName'] as String,
      departmentName: json['departmentName'] as String,
      applyTime: DateTime.parse(json['applyTime'] as String),
      introduction: json['introduction'] as String?,
      motivation: json['motivation'] as String?,
    );

Map<String, dynamic> _$RecruitApplicantDetailModelToJson(
        RecruitApplicantDetailModel instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'applierId': instance.applierId,
      'applierName': instance.applierName,
      'departmentName': instance.departmentName,
      'applyTime': instance.applyTime.toIso8601String(),
      'introduction': instance.introduction,
      'motivation': instance.motivation,
    };
