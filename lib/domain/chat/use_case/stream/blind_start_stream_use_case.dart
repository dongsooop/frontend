import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindStartStreamUseCase {
  final ChatRepository _chatRepository;
  BlindStartStreamUseCase(this._chatRepository);
  Stream<String> call() => _chatRepository.startStream;
}