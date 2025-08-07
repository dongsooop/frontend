import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(
    this._chatDataSource,
  );

  @override
  Future<UiChatRoom> createOneToOneChatRoom(String title, int targetUserId) async {
    final chatRoom = await _chatDataSource.createOneToOneChatRoom(title, targetUserId);
    return UiChatRoom.fromEntityMinimal(chatRoom);
  }

  @override
  Future<List<UiChatRoom>?> getChatRooms() async {
    final rooms =  await _chatDataSource.getChatRooms();
    if (rooms == null || rooms.isEmpty) return [];

    final List<UiChatRoom> uiRooms = [];

    await Future.wait(rooms.map((room) async {
      try {
        final unreadCount = await _chatDataSource.getUnreadChatMessageCount(room.roomId);
        uiRooms.add(UiChatRoom.fromEntity(room, unreadCount));
      } catch (e) {
        uiRooms.add(UiChatRoom.fromEntity(room, 0));
      }
    }));

    uiRooms.sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));
    return uiRooms;
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
  Future<List<ChatMessage>?> getPagedMessages(String roomId, int offset, int limit) async {
    return await _chatDataSource.getPagedMessages(roomId, offset, limit);
  }

  @override
  Future<List<ChatMessage>?> getOfflineMessages(String roomId) async {
    final localLatestMessage = await _chatDataSource.getLatestMessage(roomId);
    final messageId = localLatestMessage?.messageId;
    List<ChatMessage>? messages;

    if (messageId == null) {
      messages = await _chatDataSource.getChatInitialize(roomId);
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
}