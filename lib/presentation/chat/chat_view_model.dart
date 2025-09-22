import 'dart:async';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/chat/model/chat_room_ws.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/get_blind_date_open_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/connect_chat_list_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/disconnect_chat_list_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/get_chat_rooms_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/subscribe_chat_list_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_state.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final Ref _ref;
  final GetChatRoomsUseCase _loadChatRoomsUseCase;
  final GetBlindDateOpenUseCase _getBlindDateOpenUseCase;

  final ConnectChatListUseCase _connectChatListUseCase;
  final DisconnectChatListUseCase _disconnectChatListUseCase;
  final SubscribeChatListUseCase _subscribeChatListUseCase;

  ChatViewModel(
    this._ref,
    this._loadChatRoomsUseCase,
    this._getBlindDateOpenUseCase,
    this._connectChatListUseCase,
    this._disconnectChatListUseCase,
    this._subscribeChatListUseCase,
  ) : super(ChatState(isLoading: false));

  StreamSubscription<ChatRoomWs>? _chatRoomListSubscription;

  Future<void> connectChatRoom(int userId) async {
    try {
      await _connectChatListUseCase.execute(userId);
      // 기존 구독이 있다면 해제
      _chatRoomListSubscription?.cancel();

      // block
      _chatRoomListSubscription = _subscribeChatListUseCase.execute().listen((chatRoomData) async {
        _ref.read(chatRoomListProvider.notifier).chatRoomUpdate(chatRoomData);
      });
    } catch (e) {
      state = state.copyWith(
        errorMessage: '채팅 중 오류가 발생했습니다.',
        isLoading: false,
      );
    }
  }

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

class ChatRoomListNotifier extends StateNotifier<ChatRoomWs?> {
  ChatRoomListNotifier() : super(null);

  void chatRoomUpdate(ChatRoomWs room) {
    print('vm chat room web socket: $room');
  }
}