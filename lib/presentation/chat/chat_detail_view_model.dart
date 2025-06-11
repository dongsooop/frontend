import 'dart:async';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/use_case/connect_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/disconnect_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_all_chat_messages.dart';
import 'package:dongsoop/domain/chat/use_case/save_chat_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/subscribe_messages_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/domain/chat/use_case/get_user_nicknames_use_case.dart';

import '../../main.dart';

class ChatDetailViewModel extends StateNotifier<ChatDetailState> {
  final ConnectChatRoomUseCase _chatRoomConnectUseCase;
  final DisconnectChatRoomUseCase _chatRoomDisconnectUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final SubscribeMessagesUseCase _subscribeMessagesUseCase;
  final GetUserNicknamesUseCase _getUserNicknamesUseCase;
  final SaveChatMessageUseCase _saveChatMessageUseCase;
  final GetAllChatMessages _getAllChatMessages;
  final Ref _ref;

  StreamSubscription<ChatMessage>? _subscription;

  ChatDetailViewModel(
    this._chatRoomConnectUseCase,
    this._chatRoomDisconnectUseCase,
    this._sendMessageUseCase,
    this._subscribeMessagesUseCase,
    this._getUserNicknamesUseCase,
    this._saveChatMessageUseCase,
    this._getAllChatMessages,
    this._ref,
  ) : super(ChatDetailState(isLoading: false));

  Future<void> enterRoom(String roomId) async {
    try {
      await _chatRoomConnectUseCase.execute(roomId);
      // 기존 구독이 있다면 해제
      _subscription?.cancel();

      _subscription = _subscribeMessagesUseCase.execute().listen((msg) async {
        await _saveChatMessageUseCase.execute(msg);
        _ref.read(chatMessagesProvider.notifier).addMessage(msg);
      });
    } catch (e, st) {
      logger.e('chatroom connect error', error: e, stackTrace: st);
      state = state.copyWith(
        errorMessage: '채팅 중 오류가 발생했습니다.',
        isLoading: false,
      );
    }
  }

  void send(ChatMessageRequest request) {
    _sendMessageUseCase.execute(request);
  }

  void leaveRoom() {
    _chatRoomDisconnectUseCase.execute();
    _subscription?.cancel();  // 구독 해제
    _subscription = null;
    _ref.read(chatMessagesProvider.notifier).clear();
  }

  Future<void> fetchNicknames(String roomId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final nicknameMap = await _getUserNicknamesUseCase.execute(roomId);
      state = state.copyWith(isLoading: false, nicknameMap: nicknameMap);
    } catch (e, st) {
      logger.e('chat get user nickneme error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '채팅 중 오류가 발생했습니다.',
      );
    }
  }
  String getNickname(String userId) {
    return state.nicknameMap[userId] ?? "알 수 없음";
  }

  Future<void> getAllChatMessages(String roomId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final notifier = _ref.read(chatMessagesProvider.notifier);
      final messages = await _getAllChatMessages.execute(roomId);

      if (messages != null || messages!.isNotEmpty) notifier.setMessages(messages);

      state = state.copyWith(isLoading: false);
    } catch (e, st) {
      logger.e('get all chat messages error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '채팅 내역을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }
}

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [message, ...state];
  }

  void setMessages(List<ChatMessage> messages) {
    state = messages.reversed.toList();
  }

  void clear() {
    state = [];
  }
}