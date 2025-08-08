import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class SubscribeBlockUseCase {
  final ChatRepository _chatRepository;

  SubscribeBlockUseCase(
    this._chatRepository,
  );

  Stream<String> execute() {
    return _chatRepository.subscribeBlock();
  }
}