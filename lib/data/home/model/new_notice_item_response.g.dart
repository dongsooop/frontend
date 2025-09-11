// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_notice_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewNoticeItemResponse _$NewNoticeItemResponseFromJson(
        Map<String, dynamic> json) =>
    NewNoticeItemResponse(
      title: json['title'] as String,
      link: json['link'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$NewNoticeItemResponseToJson(
        NewNoticeItemResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'link': instance.link,
      'type': instance.type,
    };
