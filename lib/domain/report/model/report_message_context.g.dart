// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_message_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportMessageContext _$ReportMessageContextFromJson(
        Map<String, dynamic> json) =>
    ReportMessageContext(
      senderId: (json['senderId'] as num).toInt(),
      content: json['content'] as String,
      sentAt: json['sentAt'] as String,
    );

Map<String, dynamic> _$ReportMessageContextToJson(
        ReportMessageContext instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'content': instance.content,
      'sentAt': instance.sentAt,
    };
