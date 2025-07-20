import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class CreateOneToOneChatRoomUseCase {
  final ChatRepository _chatRepository;

  CreateOneToOneChatRoomUseCase(
    this._chatRepository,
  );

  Future<UiChatRoom> execute(String title, int targetUserId) async {
    return await _chatRepository.createOneToOneChatRoom(title, targetUserId);
  }
}