import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class DisconnectChatRoomUseCase {
  final ChatRepository _chatRepository;

  DisconnectChatRoomUseCase(
    this._chatRepository,
  );

  void execute() {
    _chatRepository.disconnect();
  }
}