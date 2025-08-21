// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      roomId: json['roomId'] as String,
      title: json['title'] as String,
      participantCount: (json['participantCount'] as num).toInt(),
      lastMessage: json['lastMessage'] as String?,
      unreadCount: (json['unreadCount'] as num).toInt(),
      lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
      groupChat: json['groupChat'] as bool,
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'title': instance.title,
      'participantCount': instance.participantCount,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'lastActivityAt': instance.lastActivityAt.toIso8601String(),
      'groupChat': instance.groupChat,
    };
