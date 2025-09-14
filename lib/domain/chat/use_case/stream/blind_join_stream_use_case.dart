import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindJoinStreamUseCase {
  final ChatRepository _chatRepository;
  BlindJoinStreamUseCase(this._chatRepository);
  Stream<Map<String, dynamic>> call() => _chatRepository.joinStream;
}