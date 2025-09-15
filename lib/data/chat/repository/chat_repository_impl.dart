import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_join_info.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/model/chat_room_detail.dart';
import 'package:dongsoop/domain/chat/model/chat_room_request.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(
    this._chatDataSource,
  );

  @override
  Future<String> createOneToOneChatRoom(String title, int targetUserId) async {
    return await _chatDataSource.createOneToOneChatRoom(title, targetUserId);
  }

  @override
  Future<String> createQNAChatRoom(ChatRoomRequest request) async {
    return await _chatDataSource.createQNAChatRoom(request);
  }

  @override
  Future<List<ChatRoom>?> getChatRooms() async {
    final rooms =  await _chatDataSource.getChatRooms();
    if (rooms == null || rooms.isEmpty) return [];

    rooms.sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));
    return rooms;
  }

  @override
  Future<Map<String, String>> getUserNicknamesByRoomId(String roomId) async {
    return await _chatDataSource.getUserNicknamesByRoomId(roomId);
  }

  @override
  Future<ChatRoomDetail> getRoomDetailByRoomId(String roomId) async {
    return await _chatDataSource.getRoomDetailByRoomId(roomId);
  }

  @override
  Future<void> saveChatMessage(ChatMessage message) async {
    await _chatDataSource.saveChatMessage(message);
  }

  @override
  Future<List<ChatMessage>?> getPagedMessages(String roomId, int offset, int limit) async {
    return await _chatDataSource.getPagedMessages(roomId, offset, limit);
  }

  @override
  Future<List<ChatMessage>?> getOfflineMessages(String roomId) async {
    final localLatestMessage = await _chatDataSource.getLatestMessage(roomId);
    final messageId = localLatestMessage?.messageId;
    List<ChatMessage>? messages;

    if (messageId == null) {
      final (initMessages, room) = await _chatDataSource.getChatInitialize(roomId);
      messages = initMessages;
      await _chatDataSource.saveChatDetail(room);
    } else {
      messages = await _chatDataSource.getChatMessagesAfter(roomId, messageId);
    }

    messages?.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  @override
  Future<ChatMessage?> getLatestMessage(String roomId) async {
    return await _chatDataSource.getLatestMessage(roomId);
  }

  @override
  Future<void> updateReadStatus(String roomId) async {
    await _chatDataSource.updateReadStatus(roomId);
  }

  @override
  Future<void> deleteChatBox() async {
    await _chatDataSource.deleteChatBox();
  }

  @override
  Future<void> leaveChatRoom(String roomId) async {
    await _chatDataSource.leaveChatRoom(roomId);
  }

  @override
  Future<void> kickUser(String roomId, int userId) async {
    await _chatDataSource.kickUser(roomId, userId);
  }

  @override
  Future<void> connect(String roomId) => _chatDataSource.connect(roomId);

  @override
  void disconnect() => _chatDataSource.disconnect();

  @override
  void sendMessage(ChatMessageRequest message) => _chatDataSource.sendMessage(message);

  @override
  Stream<ChatMessage> subscribeMessages() => _chatDataSource.subscribeMessages();

  @override
  Stream<String> subscribeBlock() => _chatDataSource.subscribeBlock();

  // blind
  @override
  Future<void> blindConnect(int userId) async {
    await _chatDataSource.blindConnect(userId);
  }
  @override
  Future<void> blindDisconnect() => _chatDataSource.blindDisconnect();

  @override
  void blindSendMessage(BlindDateRequest message) => _chatDataSource.blindSendMessage(message);

  // Streams
  @override
  Stream<int> get joinedStream => _chatDataSource.joinedStream;

  @override
  Stream<String> get startStream => _chatDataSource.startStream;

  @override
  Stream<BlindDateMessage> get systemStream => _chatDataSource.systemStream;

  @override
  Stream<bool> get freezeStream => _chatDataSource.freezeStream;

  @override
  Stream<BlindDateMessage> get broadcastStream => _chatDataSource.broadcastStream;

  @override
  Stream<BlindJoinInfo> get joinStream => _chatDataSource.joinStream;

  @override
  Stream<Map<int, String>> get participantsStream => _chatDataSource.participantsStream;

  @override
  Stream<String> get disconnectStream => _chatDataSource.disconnectStream;

  @override
  bool get isConnected => _chatDataSource.isConnected;
}