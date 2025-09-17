import 'dart:async';
import 'package:dongsoop/domain/chat/model/blind_date/blind_choice.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_choice_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_connect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_disconnect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/get_blind_session_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/save_blind_session_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_broadcast_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_disconnect_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_freeze_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_join_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_joined_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_match_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_participants_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_start_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_system_stream_use_case.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_detail_state.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlindDateDetailViewModel extends StateNotifier<BlindDateDetailState> {
  final Ref _ref;

  final BlindConnectUseCase _connectUseCase;
  final BlindDisconnectUseCase _disconnectUseCase;
  final GetBlindSessionUseCase _getBlindSessionUseCase;
  final SaveBlindSessionUseCase _saveBlindSessionUseCase;
  final BlindSendMessageUseCase _blindSendMessageUseCase;
  final BlindChoiceUseCase _blindChoiceUseCase;

  final BlindJoinedStreamUseCase _joined$;
  final BlindStartStreamUseCase _start$;
  final BlindSystemStreamUseCase _system$;
  final BlindFreezeStreamUseCase _freeze$;
  final BlindBroadcastStreamUseCase _broadcast$;
  final BlindJoinStreamUseCase _join$;
  final BlindParticipantsStreamUseCase _participants$;
  final BlindMatchStreamUseCase _match$;
  final BlindDisconnectStreamUseCase _disconnect$;

  BlindDateDetailViewModel(
    this._ref,
    this._connectUseCase,
    this._disconnectUseCase,
    this._getBlindSessionUseCase,
    this._saveBlindSessionUseCase,
    this._blindSendMessageUseCase,
    this._blindChoiceUseCase,
    this._joined$,
    this._start$,
    this._system$,
    this._freeze$,
    this._broadcast$,
    this._join$,
    this._participants$,
    this._match$,
    this._disconnect$,
  ) : super(BlindDateDetailState());

  final _subs = <StreamSubscription>[];
  bool _didPersistSessionToday = false;

  Future<String?> connectWithDailySession() async {
    // 1) 오늘자 저장된 sessionId 있는지 확인 / 없으면 null return
    String? sessionId = await _getBlindSessionUseCase.execute();
    print('🎯 local save session id: $sessionId');

    return sessionId;
  }

  Future<void> connect(int userId) async {
    if (state.isConnecting) return;
    state = state.copyWith(isConnecting: true, isLoading: true);

    // 구독 설정
    _subs.add(_joined$().listen((data) {
      state = state.copyWith(volunteer: data);
    }));

    _subs.add(_start$().listen((sid) async {
      state = state.copyWith(sessionId: sid, isLoading: false);

      if (_didPersistSessionToday) return;
      final saved = await _getBlindSessionUseCase.execute();
      if (saved == null || saved.isEmpty) {
        await _saveBlindSessionUseCase.execute(sid);
        // (선택) 어제 기록 등 정리하고 싶으면:
        // await _hive.keepOnlyToday();
      }
      _didPersistSessionToday = true;
    }));

    _subs.add(_system$().listen((msg) {
      _ref.read(blindDateMessagesProvider.notifier).addMessage(msg);
    }));

    _subs.add(_freeze$().listen((frozen) {
      state = state.copyWith(isFrozen: frozen);
    }));

    _subs.add(_broadcast$().listen((msg) {
      _ref.read(blindDateMessagesProvider.notifier).addMessage(msg);
    }));

    _subs.add(_join$().listen((info) {
      state = state.copyWith(sessionId: info.sessionId, nickname: info.name);
    }));

    _subs.add(_participants$().listen((map) {
      print('👤 participants: $map');
      state = state.copyWith(participants: map, isVoteTime: true);
    }));

    _subs.add(_match$().listen((data) {
      print('🥰 match: $data');
      state = state.copyWith(match: data);
    }));

    _subs.add(_disconnect$().listen((reason) async {
      print('🔌 socket.io disconnected: $reason');
      state = state.copyWith(disconnectReason: reason);
      // 테스트용
      // await _hive.clearAllBlindDailySessions();
    }));

    // 로컬에 저장된 오늘날짜 sessionId가 있는지
    final sessionId = await connectWithDailySession();
    if (sessionId != null) state = state.copyWith(isLoading: false, sessionId: sessionId);

    // 웹소켓 연결
    await _connectUseCase.execute(userId, sessionId);

    state = state.copyWith(isConnecting: false);
  }

  Future<void> disconnect() async {
    await _disconnectUseCase.execute();
  }

  @override
  void dispose() {
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    super.dispose();
  }

  void send(BlindDateRequest message) {
    _blindSendMessageUseCase.execute(message);
  }

  void choice(BlindChoice data) {
    state = state.copyWith(isVoteTime: false);
    _blindChoiceUseCase.execute(data);
  }
}

class BlindDateMessagesNotifier extends StateNotifier<List<BlindDateMessage>> {
  // final Future<List<BlindDateMessage>> Function(String roomId, int offset, int limit) getPagedMessages;

  BlindDateMessagesNotifier() : super([]);

  String? _roomId;
  final int _pageSize = 50;
  bool _hasMore = true;
  bool _isLoading = false;

  // Future<void> loadChatInitial(String roomId) async {
  //   _roomId = roomId;
  //   _hasMore = true;
  //   state = [];
  //
  //   final messages = await getPagedMessages(roomId, 0, _pageSize);
  //   state = messages;
  //   if (messages.length < _pageSize) {
  //     _hasMore = false;
  //   }
  // }

  // Future<void> loadMore() async {
  //   if (_isLoading || !_hasMore || _roomId == null) return;
  //
  //   _isLoading = true;
  //   final offset = state.length;
  //   final newMessages = await getPagedMessages(_roomId!, offset, _pageSize);
  //
  //   if (newMessages.isEmpty) {
  //     _hasMore = false;
  //   } else {
  //     state = [...state, ...newMessages]; // prepend old messages
  //   }
  //   _isLoading = false;
  // }

  void addMessage(BlindDateMessage message) {
    state = [message, ...state];
  }

  void clear() {
    _roomId = null;
    _hasMore = true;
    state = [];
  }
}