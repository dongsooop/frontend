import 'package:dongsoop/domain/chat/model/blind_date/blind_join_info.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class BlindJoinStreamUseCase {
  final ChatRepository _chatRepository;
  BlindJoinStreamUseCase(this._chatRepository);
  Stream<BlindJoinInfo> call() => _chatRepository.joinStream;
}