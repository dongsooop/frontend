import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindFreezeStreamUseCase {
  final ChatRepository _chatRepository;
  BlindFreezeStreamUseCase(this._chatRepository);
  Stream<bool> call() => _chatRepository.freezeStream;
}