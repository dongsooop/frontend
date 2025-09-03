import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room_detail.dart';
import 'package:dongsoop/domain/chat/model/chat_room_request.dart';

abstract class ChatDataSource {
  Future<List<ChatRoom>?> getChatRooms();
  Future<Map<String, String>> getUserNicknamesByRoomId(String roomId);
  Future<ChatRoomDetail> getRoomDetailByRoomId(String roomId);
  Future<void> saveChatMessage(ChatMessage message);
  Future<void> saveChatDetail(ChatRoomDetail room);
  Future<List<ChatMessage>?> getPagedMessages(String roomId, int offset, int limit);
  Future<void> deleteChatBox();
  Future<ChatMessage?> getLatestMessage(String roomId);
  Future<(List<ChatMessage>?, ChatRoomDetail)> getChatInitialize(String roomId);
  Future<List<ChatMessage>?> getChatMessagesAfter(String roomId, String MessageId);
  Future<void> updateReadStatus(String roomId);
  Future<void> leaveChatRoom(String roomId);
  Future<void> kickUser(String roomId, int userId);
  Future<String> createOneToOneChatRoom(String title, int targetUserId);
  Future<String> createQNAChatRoom(ChatRoomRequest request);
  Future<String> sendChatbot(String text);

  // stomp
  Future<void> connect(String roomId);
  void sendMessage(ChatMessageRequest message);
  void disconnect();
  Stream<ChatMessage> subscribeMessages();
  Stream<String> subscribeBlock();
}