import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class SaveBlindSessionUseCase {
  final ChatRepository _chatRepository;

  SaveBlindSessionUseCase(this._chatRepository,);

  Future<void> execute(String sessionId) async {
    await _chatRepository.saveBlindDateSessionId(sessionId);
  }
}