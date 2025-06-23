import 'package:dongsoop/core/utils/time_formatter.dart';
import 'chat_room.dart';

class UiChatRoom {
  final String roomId;
  final String title;
  final String participantCount;
  final DateTime lastActivityAt;
  final String lastActivityText;
  final String unreadCount;
  final bool isGroupChat;

  UiChatRoom({
    required this.roomId,
    required this.title,
    required this.participantCount,
    required this.lastActivityAt,
    required this.lastActivityText,
    required this.unreadCount,
    required this.isGroupChat,
  });

  factory UiChatRoom.fromEntity(ChatRoom entity, int unreadCount) {
    return UiChatRoom(
      roomId: entity.roomId,
      title: entity.title ?? "채팅방 이름 없음",
      lastActivityAt: entity.lastActivityAt,
      lastActivityText: formatLastActivityTime(entity.lastActivityAt),
      participantCount: entity.participants.length.toString(),
      unreadCount: unreadCount < 100 ? unreadCount.toString() : '99+',
      isGroupChat: entity.groupChat,
    );
  }
}