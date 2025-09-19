// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchNoticeModel _$SearchNoticeModelFromJson(Map<String, dynamic> json) =>
    SearchNoticeModel(
      boardId: (json['boardId'] as num).toInt(),
      title: json['title'] as String,
      authorName: json['authorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      noticeUrl: json['noticeUrl'] as String,
    );

Map<String, dynamic> _$SearchNoticeModelToJson(SearchNoticeModel instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'title': instance.title,
      'authorName': instance.authorName,
      'createdAt': instance.createdAt.toIso8601String(),
      'noticeUrl': instance.noticeUrl,
    };