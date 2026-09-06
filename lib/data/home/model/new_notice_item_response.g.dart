// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_notice_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewNoticeItemResponse _$NewNoticeItemResponseFromJson(
        Map<String, dynamic> json) =>
    NewNoticeItemResponse(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      link: json['link'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$NewNoticeItemResponseToJson(
        NewNoticeItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'link': instance.link,
      'type': instance.type,
    };
