import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class GetPagedMessages {
  final ChatRepository _chatRepository;

  GetPagedMessages(
    this._chatRepository,
  );

  Future<List<ChatMessage>?> execute(String roomId, int offset, int limit) async {
    return await _chatRepository.getPagedMessages(roomId, offset, limit);
  }
}