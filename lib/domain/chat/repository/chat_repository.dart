import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/model/chat_room_detail.dart';
import 'package:dongsoop/domain/chat/model/chat_room_request.dart';

abstract class ChatRepository {
  Future<List<ChatRoom>?> getChatRooms();
  Future<Map<String, String>> getUserNicknamesByRoomId(String roomId);
  Future<ChatRoomDetail> getRoomDetailByRoomId(String roomId);
  Future<void> saveChatMessage(ChatMessage message);
  Future<List<ChatMessage>?> getPagedMessages(String roomId, int offset, int limit);
  Future<void> deleteChatBox();
  Future<List<ChatMessage>?> getOfflineMessages(String roomId);
  Future<ChatMessage?> getLatestMessage(String roomId);
  Future<void> updateReadStatus(String roomId);
  Future<void> leaveChatRoom(String roomId);
  Future<void> kickUser(String roomId, int userId);
  Future<String> createOneToOneChatRoom(String title, int targetUserId);
  Future<String> createQNAChatRoom(ChatRoomRequest request);

  // stomp
  Future<void> connect(String roomId);
  void sendMessage(ChatMessageRequest message);
  void disconnect();
  Stream<ChatMessage> subscribeMessages();
  Stream<String> subscribeBlock();

  // blind
  Future<void> blindConnect(int userId);
  Future<void> blindDisconnect();

  void emit(String event, dynamic data);
  void sendBroadcast(String message);

  // Streams
  Stream<Map<String, dynamic>> get joinedStream;
  Stream<String> get startStream;
  Stream<Map<String, dynamic>> get systemStream;
  Stream<bool> get freezeStream;
  Stream<Map<String, dynamic>> get broadcastStream;
  Stream<Map<String, dynamic>> get joinStream;
  Stream<Map<int, String>> get participantsStream;
  Stream<String> get disconnectStream;

  bool get isConnected;
}

