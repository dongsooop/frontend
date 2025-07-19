import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class CreateGroupChatRoomUseCase {
  final ChatRepository _chatRepository;

  CreateGroupChatRoomUseCase(
    this._chatRepository,
  );

  Future<void> execute(String title, int userId) async {
    await _chatRepository.createGroupChatRoom(title, userId);
  }
}