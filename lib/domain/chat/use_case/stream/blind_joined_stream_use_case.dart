import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindJoinedStreamUseCase {
  final ChatRepository _chatRepository;
  BlindJoinedStreamUseCase(this._chatRepository);
  Stream<Map<String, dynamic>> call() => _chatRepository.joinedStream;
}