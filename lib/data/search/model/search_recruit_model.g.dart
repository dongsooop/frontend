// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_recruit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRecruitModel _$SearchRecruitModelFromJson(Map<String, dynamic> json) =>
    SearchRecruitModel(
      boardId: (json['boardId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String?,
      boardType: $enumDecode(_$RecruitTypeEnumMap, json['boardType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      contactCount: (json['contactCount'] as num).toInt(),
      recruitmentStartAt: json['recruitmentStartAt'] == null
          ? null
          : DateTime.parse(json['recruitmentStartAt'] as String),
      recruitmentEndAt: json['recruitmentEndAt'] == null
          ? null
          : DateTime.parse(json['recruitmentEndAt'] as String),
      tags: json['tags'] as String,
      departmentName: json['departmentName'] as String,
    );

Map<String, dynamic> _$SearchRecruitModelToJson(SearchRecruitModel instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'title': instance.title,
      'content': instance.content,
      'boardType': _$RecruitTypeEnumMap[instance.boardType]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'contactCount': instance.contactCount,
      'recruitmentStartAt': instance.recruitmentStartAt?.toIso8601String(),
      'recruitmentEndAt': instance.recruitmentEndAt?.toIso8601String(),
      'tags': instance.tags,
      'departmentName': instance.departmentName,
    };

const _$RecruitTypeEnumMap = {
  RecruitType.TUTORING: 'TUTORING',
  RecruitType.STUDY: 'STUDY',
  RecruitType.PROJECT: 'PROJECT',
};
