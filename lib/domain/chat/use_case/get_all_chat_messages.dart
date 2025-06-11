import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class GetAllChatMessages {
  final ChatRepository _chatRepository;

  GetAllChatMessages(
    this._chatRepository,
  );

  Future<List<ChatMessage>?> execute(String roomId) async {
    return await _chatRepository.getAllChatMessages(roomId);
  }
}