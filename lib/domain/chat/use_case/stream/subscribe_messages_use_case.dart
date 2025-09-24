import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';

class SubscribeMessagesUseCase {
  final ChatRepository _chatRepository;

  SubscribeMessagesUseCase(
    this._chatRepository,
  );

  Stream<ChatMessage> execute() {
    return _chatRepository.subscribeMessages();
  }
}