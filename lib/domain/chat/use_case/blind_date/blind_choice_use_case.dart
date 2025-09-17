import 'package:dongsoop/domain/chat/model/blind_date/blind_choice.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindChoiceUseCase {
  final ChatRepository _chatRepository;

  BlindChoiceUseCase(this._chatRepository,);

  void execute(BlindChoice data) {
    _chatRepository.choice(data);
  }
}