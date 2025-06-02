import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(
    this._chatDataSource,
  );

  @override
  Future<List<ChatRoom>?> getChatRooms() async {
    return await _chatDataSource.getChatRooms();
  }
}