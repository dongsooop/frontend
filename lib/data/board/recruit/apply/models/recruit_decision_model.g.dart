// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_decision_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitDecisionModel _$RecruitDecisionModelFromJson(
        Map<String, dynamic> json) =>
    RecruitDecisionModel(
      status: json['status'] as String,
      applierId: (json['applierId'] as num).toInt(),
    );

Map<String, dynamic> _$RecruitDecisionModelToJson(
        RecruitDecisionModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'applierId': instance.applierId,
    };
