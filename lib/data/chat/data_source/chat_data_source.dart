import 'package:dongsoop/domain/chat/model/chat_room.dart';
import '../../../domain/chat/model/chat_message.dart';
import '../../../domain/chat/model/chat_message_request.dart';

abstract class ChatDataSource {
  Future<List<ChatRoom>?> getChatRooms();
  Future<Map<String, String>> getUserNicknamesByRoomId(String roomId);
  Future<void> saveChatMessage(ChatMessage message);
  Future<List<ChatMessage>?> getAllChatMessages(String roomId);
  Future<void> deleteChatBox();

  // stomp
  Future<void> connect(String roomId);
  void sendMessage(ChatMessageRequest message);
  void disconnect();
  Stream<ChatMessage> subscribeMessages();
}