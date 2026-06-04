import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class DisconnectChatListUseCase {
  final ChatRepository _chatRepository;

  DisconnectChatListUseCase(this._chatRepository,);

  void execute() {
    _chatRepository.disconnectChatList();
  }
}