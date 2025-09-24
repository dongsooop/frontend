import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class ConnectChatRoomUseCase {
  final ChatRepository _chatRepository;

  ConnectChatRoomUseCase(
    this._chatRepository,
  );

  Future<void> execute(String roomId) async {
    await _chatRepository.connect(roomId);
  }
}