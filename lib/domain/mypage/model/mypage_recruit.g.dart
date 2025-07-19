// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mypage_recruit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MypageRecruit _$MypageRecruitFromJson(Map<String, dynamic> json) =>
    MypageRecruit(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      tags: _parseToList(json['tags']),
      departmentTypeList: _parseToList(json['departmentTypeList']),
      boardType: _recruitTypeFromJson(json['boardType'] as String),
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      volunteer: (json['volunteer'] as num).toInt(),
      isRecruiting: json['isRecruiting'] as bool,
    );

Map<String, dynamic> _$MypageRecruitToJson(MypageRecruit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'departmentTypeList': instance.departmentTypeList,
      'boardType': _$RecruitTypeEnumMap[instance.boardType]!,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'volunteer': instance.volunteer,
      'isRecruiting': instance.isRecruiting,
    };

const _$RecruitTypeEnumMap = {
  RecruitType.tutoring: 'tutoring',
  RecruitType.study: 'study',
  RecruitType.project: 'project',
};
