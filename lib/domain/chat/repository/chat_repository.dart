import 'package:dongsoop/domain/chat/model/chat_room.dart';
import '../model/chat_message.dart';
import '../model/chat_message_request.dart';

abstract class ChatRepository {
  Future<List<ChatRoom>?> getChatRooms();
  Future<Map<String, String>> getUserNicknamesByRoomId(String roomId);
  Future<void> saveChatMessage(ChatMessage message);
  Future<List<ChatMessage>?> getPagedMessages(String roomId, int offset, int limit);
  Future<void> deleteChatBox();

  // stomp
  Future<void> connect(String roomId);
  void sendMessage(ChatMessageRequest message);
  void disconnect();
  Stream<ChatMessage> subscribeMessages();
}

