import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class KickUserUseCase {
  final ChatRepository _chatRepository;

  KickUserUseCase(
    this._chatRepository,
  );

  Future<void> execute(String roomId, int userId) async {
    await _chatRepository.kickUser(roomId, userId);
  }
}