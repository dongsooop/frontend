import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindDisconnectStreamUseCase {
  final ChatRepository _chatRepository;
  BlindDisconnectStreamUseCase(this._chatRepository);
  Stream<String> call() => _chatRepository.disconnectStream;
}