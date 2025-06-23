import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class LeaveChatRoomUseCase {
  final ChatRepository _chatRepository;

  LeaveChatRoomUseCase(
    this._chatRepository,
  );

  Future<void> execute(String roomId) async {
    await _chatRepository.leaveChatRoom(roomId);
  }
}