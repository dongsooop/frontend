import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindBroadcastStreamUseCase {
  final ChatRepository _chatRepository;
  BlindBroadcastStreamUseCase(this._chatRepository);
  Stream<Map<String, dynamic>> call() => _chatRepository.broadcastStream;
}