import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class ChatRoomConnectUseCase {
  final ChatRepository _chatRepository;

  ChatRoomConnectUseCase(
    this._chatRepository,
  );

  Future<void> execute(String roomId) async {
    await _chatRepository.connect(roomId);
  }
}