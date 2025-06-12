// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      link: json['link'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
