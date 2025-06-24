import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class UpdateReadStatusUseCase {
  final ChatRepository _chatRepository;

  UpdateReadStatusUseCase(
    this._chatRepository,
  );

  Future<void> execute(String roomId) async {
    await _chatRepository.updateReadStatus(roomId);
  }
}