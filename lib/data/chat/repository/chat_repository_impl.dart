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
    final rooms =  await _chatDataSource.getChatRooms();
    if (rooms == null)
      return rooms;
    rooms.sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));
    return rooms;
  }
}