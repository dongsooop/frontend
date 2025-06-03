import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class ChatRoomDisconnectUseCase {
  final ChatRepository _chatRepository;

  ChatRoomDisconnectUseCase(
    this._chatRepository,
  );

  void execute() {
    _chatRepository.disconnect();
  }
}