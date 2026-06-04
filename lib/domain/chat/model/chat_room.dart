import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

@freezed
@JsonSerializable()
class ChatRoom with _$ChatRoom {
  final String roomId;
  final String title;
  final int participantCount;
  final String? lastMessage;
  final int unreadCount;
  final DateTime lastActivityAt;
  final bool groupChat;

  ChatRoom({
    required this.roomId,
    required this.title,
    required this.participantCount,
    required this.lastMessage,
    required this.unreadCount,
    required this.lastActivityAt,
    required this.groupChat,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);
}