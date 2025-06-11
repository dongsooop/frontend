import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import 'package:dongsoop/domain/chat/use_case/load_chat_rooms_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/chat/chat_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final LoadChatRoomsUseCase _loadChatRoomsUseCase;

  ChatViewModel(
    this._loadChatRoomsUseCase,
  ) : super(ChatState(isLoading: false));

  Future<void> loadChatRooms() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final chatRooms = await _loadChatRoomsUseCase.execute();
      if (chatRooms == null)
        state = state.copyWith(isLoading: false, chatRooms: null);
      final uiChatRooms = chatRooms!.map((room) => UiChatRoom.fromEntity(room)).toList();
      state = state.copyWith(isLoading: false, chatRooms: uiChatRooms);
    } catch (e, st) {
      logger.e('load char rooms error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '채팅방 목록을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }
}