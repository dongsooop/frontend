import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_detail.freezed.dart';
part 'chat_room_detail.g.dart';

@freezed
@JsonSerializable()
class ChatRoomDetail with _$ChatRoomDetail {
  final String roomId;
  final String title;
  final List<int> participants;
  final int? managerId;
  final bool groupChat;

  ChatRoomDetail({
    required this.roomId,
    required this.title,
    required this.participants,
    this.managerId,
    required this.groupChat,
  });

  factory ChatRoomDetail.fromJson(Map<String, dynamic> json) => _$ChatRoomDetailFromJson(json);
}