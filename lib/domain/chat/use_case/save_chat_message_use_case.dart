import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class SaveChatMessageUseCase {
  final ChatRepository _chatRepository;

  SaveChatMessageUseCase(
    this._chatRepository,
  );

  Future<void> execute(ChatMessage message) async {
    await _chatRepository.saveChatMessage(message);
  }
}