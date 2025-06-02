// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_write_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitWriteModel _$RecruitWriteModelFromJson(Map<String, dynamic> json) =>
    RecruitWriteModel(
      title: json['title'] as String,
      content: json['content'] as String,
      tags: json['tags'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      departmentTypeList: (json['departmentTypeList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RecruitWriteModelToJson(RecruitWriteModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'departmentTypeList': instance.departmentTypeList,
    };
