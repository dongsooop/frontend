import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindEndedStreamUseCase {
  final ChatRepository _chatRepository;
  BlindEndedStreamUseCase(this._chatRepository);
  Stream<String> call() => _chatRepository.endedStream;
}