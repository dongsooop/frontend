import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class SendChatbotMessageUseCase {
  final ChatRepository _chatRepository;

  SendChatbotMessageUseCase(this._chatRepository,);

  Future<String> execute(String text) async {
    return await _chatRepository.sendChatbot(text);
  }
}