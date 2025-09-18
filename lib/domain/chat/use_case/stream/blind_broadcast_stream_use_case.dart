import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindBroadcastStreamUseCase {
  final ChatRepository _chatRepository;
  BlindBroadcastStreamUseCase(this._chatRepository);
  Stream<BlindDateMessage> call() => _chatRepository.broadcastStream;
}