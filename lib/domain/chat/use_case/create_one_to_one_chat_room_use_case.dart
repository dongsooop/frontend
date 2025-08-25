import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class CreateOneToOneChatRoomUseCase {
  final ChatRepository _chatRepository;

  CreateOneToOneChatRoomUseCase(
    this._chatRepository,
  );

  Future<String> execute(String title, int targetUserId) async {
    return await _chatRepository.createOneToOneChatRoom(title, targetUserId);
  }
}