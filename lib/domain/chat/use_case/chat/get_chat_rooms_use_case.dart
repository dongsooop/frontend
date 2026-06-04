import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class GetChatRoomsUseCase {
  final ChatRepository _chatRepository;

  GetChatRoomsUseCase(
    this._chatRepository,
  );

  Future<List<ChatRoom>?> execute() async {
    final chatRooms = await _chatRepository.getChatRooms();
    return chatRooms;
  }
}