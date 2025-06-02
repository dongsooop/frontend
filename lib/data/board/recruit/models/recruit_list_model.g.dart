// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitListModel _$RecruitListModelFromJson(Map<String, dynamic> json) =>
    RecruitListModel(
      id: (json['id'] as num).toInt(),
      volunteer: (json['volunteer'] as num).toInt(),
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      title: json['title'] as String,
      content: json['content'] as String,
      tags: json['tags'] as String,
    );

Map<String, dynamic> _$RecruitListModelToJson(RecruitListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'volunteer': instance.volunteer,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
    };
