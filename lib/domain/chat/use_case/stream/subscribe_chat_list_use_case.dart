import 'package:dongsoop/domain/chat/model/chat_room_ws.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class SubscribeChatListUseCase {
  final ChatRepository _chatRepository;

  SubscribeChatListUseCase(this._chatRepository,);

  Stream<ChatRoomWs> execute() {
    return _chatRepository.subscribeChatList();
  }
}