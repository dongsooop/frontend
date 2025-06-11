import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(
    this._chatDataSource,
  );

  @override
  Future<List<ChatRoom>?> getChatRooms() async {
    final rooms =  await _chatDataSource.getChatRooms();
    if (rooms == null)
      return rooms;
    rooms.sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));
    return rooms;
  }

  @override
  Future<Map<String, String>> getUserNicknamesByRoomId(String roomId) async {
    return await _chatDataSource.getUserNicknamesByRoomId(roomId);
  }

  @override
  Future<void> saveChatMessage(ChatMessage message) async {
    await _chatDataSource.saveChatMessage(message);
  }

  @override
  Future<List<ChatMessage>?> getAllChatMessages(String roomId) async {
    return await _chatDataSource.getAllChatMessages(roomId);
  }

  @override
  Future<void> connect(String roomId) => _chatDataSource.connect(roomId);

  @override
  void disconnect() => _chatDataSource.disconnect();

  @override
  void sendMessage(ChatMessageRequest message) => _chatDataSource.sendMessage(message);

  @override
  Stream<ChatMessage> subscribeMessages() => _chatDataSource.subscribeMessages();
}