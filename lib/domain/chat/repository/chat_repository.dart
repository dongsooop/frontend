import 'package:dongsoop/domain/chat/model/chat_room.dart';
import '../model/chat_message.dart';
import '../model/chat_message_request.dart';

abstract class ChatRepository {
  Future<List<ChatRoom>?> getChatRooms();

  // stomp
  Future<void> connect(String roomId);
  void sendMessage(ChatMessageRequest message);
  void disconnect();
  Stream<ChatMessage> subscribeMessages();
}