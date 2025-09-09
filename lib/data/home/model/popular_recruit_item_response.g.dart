// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_recruit_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularRecruitItemResponse _$PopularRecruitItemResponseFromJson(
        Map<String, dynamic> json) =>
    PopularRecruitItemResponse(
      title: json['title'] as String,
      content: json['content'] as String,
      tags: json['tags'] as String,
      volunteer: (json['volunteer'] as num).toInt(),
    );

Map<String, dynamic> _$PopularRecruitItemResponseToJson(
        PopularRecruitItemResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'volunteer': instance.volunteer,
    };
