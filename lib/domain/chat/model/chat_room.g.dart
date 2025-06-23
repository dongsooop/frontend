// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      roomId: json['roomId'] as String,
      title: json['title'] as String?,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      managerId: (json['managerId'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
      kickedUsers: (json['kickedUsers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      groupChat: json['groupChat'] as bool,
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'title': instance.title,
      'participants': instance.participants,
      'managerId': instance.managerId,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastActivityAt': instance.lastActivityAt.toIso8601String(),
      'kickedUsers': instance.kickedUsers,
      'groupChat': instance.groupChat,
    };
