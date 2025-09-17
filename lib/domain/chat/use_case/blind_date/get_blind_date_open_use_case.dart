import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class GetBlindDateOpenUseCase {
  final ChatRepository _chatRepository;

  GetBlindDateOpenUseCase(this._chatRepository,);

  Future<bool> execute() async {
    return await _chatRepository.getBlindDateOpen();
  }
}