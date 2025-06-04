// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitDetailModel _$RecruitDetailModelFromJson(Map<String, dynamic> json) =>
    RecruitDetailModel(
      id: (json['id'] as num).toInt(),
      volunteer: (json['volunteer'] as num).toInt(),
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      title: json['title'] as String,
      content: json['content'] as String,
      tags: json['tags'] as String,
      departmentTypeList: (json['departmentTypeList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      author: json['author'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RecruitDetailModelToJson(RecruitDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'volunteer': instance.volunteer,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'departmentTypeList': instance.departmentTypeList,
      'author': instance.author,
      'createdAt': instance.createdAt.toIso8601String(),
    };
