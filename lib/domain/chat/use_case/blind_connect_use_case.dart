import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindConnectUseCase {
  final ChatRepository _chatRepository;

  BlindConnectUseCase(this._chatRepository,);

  Future<void> execute(int userId, String? sessionId) async {
    await _chatRepository.blindConnect(userId, sessionId);
  }
}