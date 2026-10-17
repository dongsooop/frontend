// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_message_context_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportMessageContextResponse _$ReportMessageContextResponseFromJson(
        Map<String, dynamic> json) =>
    ReportMessageContextResponse(
      senderId: (json['senderId'] as num).toInt(),
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );

Map<String, dynamic> _$ReportMessageContextResponseToJson(
        ReportMessageContextResponse instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'content': instance.content,
      'sentAt': instance.sentAt.toIso8601String(),
    };
