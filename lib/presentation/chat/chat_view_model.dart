import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/get_blind_date_open_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_chat_rooms_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final GetChatRoomsUseCase _loadChatRoomsUseCase;
  final GetBlindDateOpenUseCase _getBlindDateOpenUseCase;

  ChatViewModel(
    this._loadChatRoomsUseCase,
    this._getBlindDateOpenUseCase,
  ) : super(ChatState(isLoading: false));

  Future<void> loadChatRooms() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final chatRooms = await _loadChatRoomsUseCase.execute();
      state = state.copyWith(isLoading: false, chatRooms: chatRooms);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '채팅방 목록을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }

  Future<bool> isOpened() async {
    state = state.copyWith(errorMessage: null);

    try {
      return await _getBlindDateOpenUseCase.execute();
    } on BlindDateOpenException catch (e) {
      state = state.copyWith(
        isBlindDateOpened: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: '과팅 오픈 확인 중 오류가 발생했습니다.',
      );
      return false;
    }
  }
}