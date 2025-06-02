import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import 'package:dongsoop/domain/chat/use_case/load_chat_rooms_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatViewModel extends StateNotifier<AsyncValue<List<UiChatRoom>?>> {
  final LoadChatRoomsUseCase _loadChatRoomsUseCase;

  ChatViewModel(
    this._loadChatRoomsUseCase,
  ) : super(const AsyncValue.data(null));

  Future<List<UiChatRoom>?> loadChatRooms() async {
    state = const AsyncValue.loading();

    try {
      final chatRooms = await _loadChatRoomsUseCase.execute();
      if (chatRooms == null)
        state = AsyncValue.data(null);
      final uiChatRooms = chatRooms!.map((room) => UiChatRoom.fromEntity(room)).toList();
      state = AsyncValue.data(uiChatRooms);
    } catch (e, st) {
      logger.e('load char rooms error: ${e.runtimeType}', error: e, stackTrace: st);

      state = AsyncValue.error('채팅방 목록을 불러오는 중 오류가 발생했습니다.', st);
    }
    return null;
  }
}