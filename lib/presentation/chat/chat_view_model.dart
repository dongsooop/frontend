import 'package:dongsoop/domain/chat/use_case/delete_chat_data_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_chat_rooms_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/chat/chat_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final GetChatRoomsUseCase _loadChatRoomsUseCase;
  final DeleteChatDataUseCase _deleteChatDataUseCase;

  ChatViewModel(
    this._loadChatRoomsUseCase,
    this._deleteChatDataUseCase,
  ) : super(ChatState(isLoading: false));

  Future<void> loadChatRooms() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final chatRooms = await _loadChatRoomsUseCase.execute();
      logger.i("chat rooms: ${chatRooms?.length}");
      state = state.copyWith(isLoading: false, chatRooms: chatRooms);
    } catch (e, st) {
      logger.e('load char rooms error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '채팅방 목록을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }
}