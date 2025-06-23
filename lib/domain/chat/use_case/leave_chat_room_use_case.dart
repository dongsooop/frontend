import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class LeaveChatRoomUseCase {
  final ChatRepository _chatRepository;

  LeaveChatRoomUseCase(
    this._chatRepository,
  );

  Future<void> execute(String roomId, String userId) async {
    await _chatRepository.leaveChatRoom(roomId, userId);
  }
}