import 'dart:async';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/use_case/blind_connect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_disconnect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_broadcast_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_disconnect_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_freeze_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_join_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_joined_stream_use_case.dart';
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

  final BlindJoinedStreamUseCase _joined$;
  final BlindStartStreamUseCase _start$;
  final BlindSystemStreamUseCase _system$;
  final BlindFreezeStreamUseCase _freeze$;
  final BlindBroadcastStreamUseCase _broadcast$;
  final BlindJoinStreamUseCase _join$;
  final BlindParticipantsStreamUseCase _participants$;
  final BlindDisconnectStreamUseCase _disconnect$;

  BlindDateDetailViewModel(
    this._ref,
    this._connectUseCase,
    this._disconnectUseCase,
    this._joined$,
    this._start$,
    this._system$,
    this._freeze$,
    this._broadcast$,
    this._join$,
    this._participants$,
    this._disconnect$,
  ) : super(BlindDateDetailState());

  final _subs = <StreamSubscription>[];

  Future<void> connect(int userId) async {
    if (state.isConnecting) return;
    state = state.copyWith(isConnecting: true);

    // 구독 설정
    _subs.add(_joined$().listen((data) {
      print('📲 joined ${Map<String, dynamic>.from(data)}');
      state = state.copyWith(joined: data);
    }));

    _subs.add(_start$().listen((sid) {
      print('🚗 start session Id: $sid');
      state = state.copyWith(sessionId: sid);
    }));

    _subs.add(_system$().listen((msg) {
      print('🤖 system: $msg');
      _ref.read(blindDateMessagesProvider.notifier).addMessage(msg);
    }));

    _subs.add(_freeze$().listen((frozen) {
      print('🥶🥵: $frozen');
      state = state.copyWith(isFrozen: frozen);
    }));

    _subs.add(_broadcast$().listen((msg) {
      print('💬 broadcast: $msg}');
      _ref.read(blindDateMessagesProvider.notifier).addMessage(msg);
    }));

    _subs.add(_join$().listen((info) {
      print('🚪 join: ${Map<String, dynamic>.from(info)}');
      state = state.copyWith(joinInfo: info);
    }));

    _subs.add(_participants$().listen((map) {
      print('👤 participants: $map');
      state = state.copyWith(participants: map);
    }));

    _subs.add(_disconnect$().listen((reason) {
      print('🔌 socket.io disconnected: $reason');
      state = state.copyWith(disconnectReason: reason);
    }));

    // 웹소켓 연결
    await _connectUseCase.execute(userId);

    state = state.copyWith(isConnecting: false);
  }

  // void emit(String event, dynamic data) => _emitEvent.execute(event, data);
  // void sendBroadcast(String message) => _sendBroadcast.execute(message);

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