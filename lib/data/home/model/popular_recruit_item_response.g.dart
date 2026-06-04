// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_recruit_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularRecruitItemResponse _$PopularRecruitItemResponseFromJson(
        Map<String, dynamic> json) =>
    PopularRecruitItemResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      tags: json['tags'] as String,
      volunteer: (json['volunteer'] as num).toInt(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$PopularRecruitItemResponseToJson(
        PopularRecruitItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'volunteer': instance.volunteer,
      'type': instance.type,
    };
