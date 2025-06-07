
import 'package:dongsoop/domain/chat/model/chat_room.dart';

abstract class ChatDataSource {
  Future<List<ChatRoom>?> getChatRooms();
}