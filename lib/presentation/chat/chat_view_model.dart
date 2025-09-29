import 'dart:async';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/chat/model/chat_room_ws.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/get_blind_date_open_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/connect_chat_list_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/disconnect_chat_list_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/get_chat_rooms_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/subscribe_chat_list_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final GetChatRoomsUseCase _loadChatRoomsUseCase;
  final GetBlindDateOpenUseCase _getBlindDateOpenUseCase;

  final ConnectChatListUseCase _connectChatListUseCase;
  final DisconnectChatListUseCase _disconnectChatListUseCase;
  final SubscribeChatListUseCase _subscribeChatListUseCase;

  ChatViewModel(
    this._loadChatRoomsUseCase,
    this._getBlindDateOpenUseCase,
    this._connectChatListUseCase,
    this._disconnectChatListUseCase,
    this._subscribeChatListUseCase,
  ) : super(ChatState(isLoading: false));

  StreamSubscription<ChatRoomWs>? _chatRoomListSubscription;

  Future<void> closeChatList() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      _disconnectChatListUseCase.execute();
      _chatRoomListSubscription?.cancel();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '오류가 발생했습니다.\n잠시 후에 다시 시도해 주세요.',
      );
    }
  }

  Future<void> connectChatRoom(int userId) async {
    try {
      await _connectChatListUseCase.execute(userId);
      // 기존 구독이 있다면 해제
      _chatRoomListSubscription?.cancel();

      // block
      _chatRoomListSubscription = _subscribeChatListUseCase.execute().listen((chatRoomData) async {
        updateChatRoomFromWs(chatRoomData);
      });
    } catch (e) {
      state = state.copyWith(
        errorMessage: '채팅방을 불러오는 중\n오류가 발생했습니다.',
        isLoading: false,
      );
    }
  }

  void updateChatRoomFromWs(ChatRoomWs wsRoom) {
    final currentRooms = state.chatRooms;
    if (currentRooms == null) return;

    bool found = false;
    final updatedRooms = currentRooms.map((room) {
      if (room.roomId == wsRoom.roomId) {
        found = true;
        return room.copyWith(
          lastMessage: wsRoom.lastMessage,
          unreadCount: wsRoom.unreadCount,
          lastActivityAt: wsRoom.timestamp,
        );
      }
      return room;
    }).toList();

    if (!found) {
      loadChatRooms();
      return;
    }

    final sortedRooms = updatedRooms
      ..sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));

    state = state.copyWith(chatRooms: sortedRooms);
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
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      state = state.copyWith(isLoading: false);
      return await _getBlindDateOpenUseCase.execute();
    } on BlindDateOpenException catch (e) {
      state = state.copyWith(
        isLoading: false,
        isBlindDateOpened: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '과팅 오픈 확인 중 오류가 발생했습니다.',
      );
      return false;
    }
  }
}