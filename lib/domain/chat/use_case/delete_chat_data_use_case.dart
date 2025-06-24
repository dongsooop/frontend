import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class DeleteChatDataUseCase {
  final ChatRepository _chatRepository;

  DeleteChatDataUseCase(
    this._chatRepository,
  );

  Future<void> execute() async {
    await _chatRepository.deleteChatBox();
  }
}