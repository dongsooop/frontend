import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindJoinedStreamUseCase {
  final ChatRepository _chatRepository;
  BlindJoinedStreamUseCase(this._chatRepository);
  Stream<int> call() => _chatRepository.joinedStream;
}