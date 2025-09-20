import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindSendMessageUseCase {
  final ChatRepository _chatRepository;

  BlindSendMessageUseCase(this._chatRepository,);

  void execute(BlindDateRequest message) {
    _chatRepository.blindSendMessage(message);
  }
}