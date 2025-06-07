import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

@freezed
@JsonSerializable()
class ChatRoom with _$ChatRoom {
  final String roomId;
  final List<int> participants;
  final int? managerId;
  final DateTime createdAt;
  final DateTime lastActivityAt;
  final List<int> kickedUsers;
  final bool groupChat;

  ChatRoom({
    required this.roomId,
    required this.participants,
    required this.managerId,
    required this.createdAt,
    required this.lastActivityAt,
    required this.kickedUsers,
    required this.groupChat,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);
}