import 'package:dongsoop/domain/chat/model/chat_room_request.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class CreateQnaChatRoomUseCase {
  final ChatRepository _chatRepository;

  CreateQnaChatRoomUseCase(this._chatRepository,);

  Future<String> execute(ChatRoomRequest request) async {
    return await _chatRepository.createQNAChatRoom(request);
  }
}