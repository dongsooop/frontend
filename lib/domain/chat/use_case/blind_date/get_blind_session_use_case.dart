import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class GetBlindSessionUseCase {
  final ChatRepository _chatRepository;

  GetBlindSessionUseCase(this._chatRepository,);

  Future<String?> execute() async {
    await _chatRepository.getBlindDateSessionId();
  }
}