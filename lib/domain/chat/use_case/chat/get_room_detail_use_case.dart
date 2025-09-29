import 'package:dongsoop/domain/chat/model/chat_room_detail.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class GetRoomDetailUseCase {
  final ChatRepository _chatRepository;

  GetRoomDetailUseCase(this._chatRepository,);

  Future<ChatRoomDetail> execute(String roomId) async {
    return await _chatRepository.getRoomDetailByRoomId(roomId);
  }
}