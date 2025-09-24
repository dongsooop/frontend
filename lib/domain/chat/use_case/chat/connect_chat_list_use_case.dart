import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class ConnectChatListUseCase {
  final ChatRepository _chatRepository;

  ConnectChatListUseCase(this._chatRepository,);

  Future<void> execute(int userId) async {
    await _chatRepository.connectChatList(userId);
  }
}