// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_apply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitApplyModel _$RecruitApplyModelFromJson(Map<String, dynamic> json) =>
    RecruitApplyModel(
      boardId: (json['boardId'] as num).toInt(),
      introduction: json['introduction'] as String?,
      motivation: json['motivation'] as String?,
    );

Map<String, dynamic> _$RecruitApplyModelToJson(RecruitApplyModel instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'introduction': instance.introduction,
      'motivation': instance.motivation,
    };
