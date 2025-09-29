import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class GetUserNicknamesUseCase {
  final ChatRepository _chatRepository;

  GetUserNicknamesUseCase(
    this._chatRepository,
  );

  Future<Map<String, String>> execute(String roomId) async {
    return await _chatRepository.getUserNicknamesByRoomId(roomId);
  }
}