import 'package:dongsoop/domain/chat/model/time_formatter.dart';
import 'chat_room.dart';

class UiChatRoom {
  final String roomId;
  final String participantCount;
  final String lastActivityText;
  final bool isGroupChat;

  UiChatRoom({
    required this.roomId,
    required this.participantCount,
    required this.lastActivityText,
    required this.isGroupChat,
  });

  factory UiChatRoom.fromEntity(ChatRoom entity) {
    return UiChatRoom(
      roomId: entity.roomId,
      lastActivityText: formatLastActivityTime(entity.lastActivityAt),
      participantCount: entity.participants.length.toString(),
      isGroupChat: entity.groupChat,
    );
  }
}