import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_ws.freezed.dart';
part 'chat_room_ws.g.dart';

@freezed
@JsonSerializable()
class ChatRoomWs with _$ChatRoomWs {
  final String roomId;
  final String? lastMessage;
  @JsonKey(defaultValue: 0)final int unreadCount;
  final DateTime timestamp;

  ChatRoomWs({
    required this.roomId,
    required this.lastMessage,
    required this.unreadCount,
    required this.timestamp,
  });

  factory ChatRoomWs.fromJson(Map<String, dynamic> json) => _$ChatRoomWsFromJson(json);
}