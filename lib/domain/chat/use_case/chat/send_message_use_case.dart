import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _chatRepository;

  SendMessageUseCase(
    this._chatRepository,
  );

  void execute(ChatMessageRequest message) {
    _chatRepository.sendMessage(message);
  }
}