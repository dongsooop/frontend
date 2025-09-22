import 'package:dongsoop/domain/chat/model/blind_date/blind_choice.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_join_info.dart';
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
  Future<void> leaveChatRoom(String roomId);
  Future<void> kickUser(String roomId, int userId);
  Future<String> createOneToOneChatRoom(String title, int targetUserId);
  Future<String> createQNAChatRoom(ChatRoomRequest request);
  Future<bool> getBlindDateOpen();

  // stomp
  Future<void> connect(String roomId);
  void sendMessage(ChatMessageRequest message);
  void disconnect();
  Stream<ChatMessage> subscribeMessages();
  Stream<String> subscribeBlock();

  // blind
  Future<void> blindConnect(int userId, String? sessionId);
  Future<void> blindDisconnect();
  Future<String?> getBlindDateSessionId();
  Future<void> saveBlindDateSessionId(String sessionId);

  void blindSendMessage(BlindDateRequest message);
  void choice(BlindChoice data);

  // Streams
  Stream<int> get joinedStream;
  Stream<String> get startStream;
  Stream<BlindDateMessage> get systemStream;
  Stream<bool> get freezeStream;
  Stream<BlindDateMessage> get broadcastStream;
  Stream<BlindJoinInfo> get joinStream;
  Stream<Map<int, String>> get participantsStream;
  Stream<String> get matchStream;
  Stream<String> get disconnectStream;

  bool get isConnected;
}

