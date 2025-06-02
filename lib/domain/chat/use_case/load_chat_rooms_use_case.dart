import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class LoadChatRoomsUseCase {
  final ChatRepository _chatRepository;

  LoadChatRoomsUseCase(
    this._chatRepository,
  );

  Future<List<ChatRoom>?> execute() async {
    final chatRooms = await _chatRepository.getChatRooms();
    return chatRooms;
  }
}