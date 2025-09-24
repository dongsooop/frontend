import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindParticipantsStreamUseCase {
  final ChatRepository _chatRepository;
  BlindParticipantsStreamUseCase(this._chatRepository);
  Stream<Map<int, String>> call() => _chatRepository.participantsStream;
}