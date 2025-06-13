import 'package:dongsoop/domain/chat/model/chat_room.dart';

abstract class ChatRepository {
  Future<List<ChatRoom>?> getChatRooms();
}