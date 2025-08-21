// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomRequest _$ChatRoomRequestFromJson(Map<String, dynamic> json) =>
    ChatRoomRequest(
      targetUserId: (json['targetUserId'] as num).toInt(),
      recruitType: $enumDecode(_$RecruitTypeEnumMap, json['recruitType']),
      boardId: (json['boardId'] as num).toInt(),
      boardTitle: json['boardTitle'] as String,
    );

Map<String, dynamic> _$ChatRoomRequestToJson(ChatRoomRequest instance) =>
    <String, dynamic>{
      'targetUserId': instance.targetUserId,
      'recruitType': _$RecruitTypeEnumMap[instance.recruitType]!,
      'boardId': instance.boardId,
      'boardTitle': instance.boardTitle,
    };

const _$RecruitTypeEnumMap = {
  RecruitType.tutoring: 'tutoring',
  RecruitType.study: 'study',
  RecruitType.project: 'project',
};
