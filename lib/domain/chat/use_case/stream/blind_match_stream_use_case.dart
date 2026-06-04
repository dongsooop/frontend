import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindMatchStreamUseCase {
  final ChatRepository _chatRepository;
  BlindMatchStreamUseCase(this._chatRepository);
  Stream<String> call() => _chatRepository.matchStream;
}