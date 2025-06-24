import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class GetPagedMessagesUseCase {
  final ChatRepository _chatRepository;

  GetPagedMessagesUseCase(
    this._chatRepository,
  );

  Future<List<ChatMessage>?> execute(String roomId, int offset, int limit) async {
    return await _chatRepository.getPagedMessages(roomId, offset, limit);
  }
}