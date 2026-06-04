import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindDisconnectUseCase {
  final ChatRepository _chatRepository;
  BlindDisconnectUseCase(this._chatRepository);

  Future<void> execute() => _chatRepository.blindDisconnect();
}