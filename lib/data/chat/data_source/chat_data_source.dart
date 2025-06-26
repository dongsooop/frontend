import 'package:dongsoop/domain/chat/model/chat_room.dart';
import '../../../domain/chat/model/chat_message.dart';
import '../../../domain/chat/model/chat_message_request.dart';

abstract class ChatDataSource {
  Future<List<ChatRoom>?> getChatRooms();
  Future<Map<String, String>> getUserNicknamesByRoomId(String roomId);
  Future<void> saveChatMessage(ChatMessage message);
  Future<List<ChatMessage>?> getPagedMessages(String roomId, int offset, int limit);
  Future<void> deleteChatBox();
  Future<ChatMessage?> getLatestMessage(String roomId);
  Future<List<ChatMessage>?> getChatInitialize(String roomId);
  Future<List<ChatMessage>?> getChatMessagesAfter(String roomId, String MessageId);
  Future<void> updateReadStatus(String roomId);
  Future<int> getUnreadChatMessageCount(String roomId);
  Future<void> leaveChatRoom(String roomId);
  Future<void> kickUser(String roomId, int userId);

  // stomp
  Future<void> connect(String roomId);
  void sendMessage(ChatMessageRequest message);
  void disconnect();
  Stream<ChatMessage> subscribeMessages();
}