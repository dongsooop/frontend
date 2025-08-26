// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomDetail _$ChatRoomDetailFromJson(Map<String, dynamic> json) =>
    ChatRoomDetail(
      roomId: json['roomId'] as String,
      title: json['title'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      managerId: (json['managerId'] as num?)?.toInt(),
      groupChat: json['groupChat'] as bool,
    );

Map<String, dynamic> _$ChatRoomDetailToJson(ChatRoomDetail instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'title': instance.title,
      'participants': instance.participants,
      'managerId': instance.managerId,
      'groupChat': instance.groupChat,
    };
