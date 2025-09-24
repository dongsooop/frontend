// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_ws.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomWs _$ChatRoomWsFromJson(Map<String, dynamic> json) => ChatRoomWs(
      roomId: json['roomId'] as String,
      lastMessage: json['lastMessage'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ChatRoomWsToJson(ChatRoomWs instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'timestamp': instance.timestamp.toIso8601String(),
    };
