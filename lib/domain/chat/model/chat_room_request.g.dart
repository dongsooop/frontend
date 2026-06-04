// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomRequest _$ChatRoomRequestFromJson(Map<String, dynamic> json) =>
    ChatRoomRequest(
      targetUserId: (json['targetUserId'] as num).toInt(),
      boardType: $enumDecode(_$RecruitTypeEnumMap, json['boardType']),
      boardId: (json['boardId'] as num).toInt(),
      boardTitle: json['boardTitle'] as String,
    );

Map<String, dynamic> _$ChatRoomRequestToJson(ChatRoomRequest instance) =>
    <String, dynamic>{
      'targetUserId': instance.targetUserId,
      'boardType': _$RecruitTypeEnumMap[instance.boardType]!,
      'boardId': instance.boardId,
      'boardTitle': instance.boardTitle,
    };

const _$RecruitTypeEnumMap = {
  RecruitType.TUTORING: 'TUTORING',
  RecruitType.STUDY: 'STUDY',
  RecruitType.PROJECT: 'PROJECT',
};
