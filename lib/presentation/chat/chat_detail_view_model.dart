import 'dart:async';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/use_case/connect_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/disconnect_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_offline_messages_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_paged_messages.dart';
import 'package:dongsoop/domain/chat/use_case/save_chat_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/subscribe_messages_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/update_read_status_use_case.dart';
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
  final GetPagedMessagesUseCase _getPagedMessages;
  final GetOfflineMessagesUseCase _getOfflineMessagesUseCase;
  final UpdateReadStatusUseCase _updateReadStatusUseCase;
  final Ref _ref;

  StreamSubscription<ChatMessage>? _subscription;
  ChatMessage? _latestMessage; // 소켓 연결 중 최신 메시지

  ChatDetailViewModel(
    this._chatRoomConnectUseCase,
    this._chatRoomDisconnectUseCase,
    this._sendMessageUseCase,
    this._subscribeMessagesUseCase,
    this._getUserNicknamesUseCase,
    this._saveChatMessageUseCase,
    this._getPagedMessages,
    this._getOfflineMessagesUseCase,
    this._updateReadStatusUseCase,
    this._ref,
  ) : super(ChatDetailState(isLoading: false));

  Future<void> fetchOfflineMessages(String roomId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final offlineMessages = await _getOfflineMessagesUseCase.execute(roomId);
      // 로컬 저장
      for (final msg in offlineMessages) {
        await _saveChatMessageUseCase.execute(msg);
        logger.i("message test: $msg");
      }
      state = state.copyWith(isLoading: false);
    } catch (e, st) {
      logger.e('chatroom connect error', error: e, stackTrace: st);
      state = state.copyWith(
        errorMessage: '채팅 중 오류가 발생했습니다.',
        isLoading: false,
      );
    }
  }

  Future<void> enterRoom(String roomId) async {
    try {
      await _chatRoomConnectUseCase.execute(roomId);
      // 기존 구독이 있다면 해제
      _subscription?.cancel();

      _subscription = _subscribeMessagesUseCase.execute().listen((msg) async {
        if (!state.nicknameMap.containsKey(msg.senderId)) {
          // 새로운 사용자 등장 → 닉네임 요청 후 상태 갱신
          final nicknameMap = await _getUserNicknamesUseCase.execute(msg.roomId);
          state = state.copyWith(nicknameMap: nicknameMap);
        }

        // 날짜 메시지
        if (_shouldInsertDateMessage(msg)) {
          final dateMessage = ChatMessage.dateMessage(msg.roomId, DateTime(msg.timestamp.year, msg.timestamp.month, msg.timestamp.day));
          await _saveChatMessageUseCase.execute(dateMessage);
          _ref.read(chatMessagesProvider.notifier).addMessage(dateMessage);
        }

        await _saveChatMessageUseCase.execute(msg);
        _ref.read(chatMessagesProvider.notifier).addMessage(msg);
        _latestMessage = msg;
      });
    } catch (e, st) {
      logger.e('chatroom connect error', error: e, stackTrace: st);
      state = state.copyWith(
        errorMessage: '채팅 중 오류가 발생했습니다.',
        isLoading: false,
      );
    }
  }

  bool _shouldInsertDateMessage(ChatMessage newMsg) {
    if (_latestMessage == null) return true;

    final prevDate = DateTime(_latestMessage!.timestamp.year, _latestMessage!.timestamp.month, _latestMessage!.timestamp.day);
    final newDate = DateTime(newMsg.timestamp.year, newMsg.timestamp.month, newMsg.timestamp.day);

    return prevDate != newDate;
  }

  void send(ChatMessageRequest request) {
    _sendMessageUseCase.execute(request);
  }

  void leaveRoom(String roomId) async {
    await _updateReadStatusUseCase.execute(roomId); // 읽음 상태 업데이트
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
    return state.nicknameMap[userId] ?? "{알 수 없음}";
  }

  Future<List<ChatMessage>> getPagedMessages(String roomId, int offset, int limit) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _getPagedMessages.execute(roomId, offset, limit);
      state = state.copyWith(isLoading: false);

      // 로컬 저장 최신 메시지
      if (result != null && result.isNotEmpty) {
        _latestMessage = result.first;
      }

      return result ?? [];
    } catch (e, st) {
      logger.e('get local message error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '채팅 내역을 불러오는 중 오류가 발생했습니다.',
      );
      return [];
    }
  }
}

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final Future<List<ChatMessage>> Function(String roomId, int offset, int limit) getPagedMessages;

  ChatMessagesNotifier(this.getPagedMessages) : super([]);

  String? _roomId;
  final int _pageSize = 50;
  bool _hasMore = true;
  bool _isLoading = false;

  Future<void> loadInitial(String roomId) async {
    _roomId = roomId;
    _hasMore = true;
    state = [];

    final messages = await getPagedMessages(roomId, 0, _pageSize);
    state = messages;
    if (messages.length < _pageSize) {
      _hasMore = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore || _roomId == null) return;

    _isLoading = true;
    final offset = state.length;
    final newMessages = await getPagedMessages(_roomId!, offset, _pageSize);

    if (newMessages.isEmpty) {
      _hasMore = false;
    } else {
      state = [...state, ...newMessages]; // prepend old messages
    }
    _isLoading = false;
  }

  void addMessage(ChatMessage message) {
    state = [message, ...state];
  }

  void clear() {
    _roomId = null;
    _hasMore = true;
    state = [];
  }
}