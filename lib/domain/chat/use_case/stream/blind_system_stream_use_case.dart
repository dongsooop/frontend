import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindSystemStreamUseCase {
  final ChatRepository _chatRepository;
  BlindSystemStreamUseCase(this._chatRepository);
  Stream<Map<String, dynamic>> call() => _chatRepository.systemStream;
}