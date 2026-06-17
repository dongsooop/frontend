// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_keyword_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeKeywordEntity _$NoticeKeywordEntityFromJson(Map<String, dynamic> json) =>
    NoticeKeywordEntity(
      id: (json['id'] as num).toInt(),
      keyword: json['keyword'] as String,
      type: $enumDecode(_$NoticeKeywordTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$NoticeKeywordEntityToJson(
        NoticeKeywordEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyword': instance.keyword,
      'type': _$NoticeKeywordTypeEnumMap[instance.type]!,
    };

const _$NoticeKeywordTypeEnumMap = {
  NoticeKeywordType.include: 'INCLUDE',
  NoticeKeywordType.exclude: 'EXCLUDE',
};
