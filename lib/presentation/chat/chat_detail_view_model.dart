import 'dart:async';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/use_case/chat_room_connect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat_room_disconnect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/subscribe_messages_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/providers/chat_providers.dart';

class ChatDetailViewModel extends StateNotifier<AsyncValue<void>> {
  final ChatRoomConnectUseCase _chatRoomConnectUseCase;
  final ChatRoomDisconnectUseCase _chatRoomDisconnectUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final SubscribeMessagesUseCase _subscribeMessagesUseCase;
  final Ref _ref;

  StreamSubscription<ChatMessage>? _subscription;

  ChatDetailViewModel(
    this._chatRoomConnectUseCase,
    this._chatRoomDisconnectUseCase,
    this._sendMessageUseCase,
    this._subscribeMessagesUseCase,
    this._ref,
  ) : super(const AsyncValue.data(null));

  Future<void> enterRoom(String roomId) async {
    try {
      await _chatRoomConnectUseCase.execute(roomId);
      // 기존 구독이 있다면 해제
      _subscription?.cancel();

      _subscription = _subscribeMessagesUseCase.execute().listen((msg) {
        _ref.read(chatMessagesProvider.notifier).addMessage(msg);
      });
    } catch (e, st) {
      state = AsyncValue.error('채팅 중 오류가 발생했습니다.', st);
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
}

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [message, ...state];
  }

  void clear() {
    state = [];
  }
}