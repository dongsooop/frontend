import 'dart:async';
import 'package:dongsoop/core/network/socket_io_service.dart';
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
      print('🤖 system: ${Map<String, dynamic>.from(msg)}');
      state = state.copyWith(system: [...state.system, msg]);
    }));

    _subs.add(_freeze$().listen((frozen) {
      print('🥶🥵: $frozen');
      state = state.copyWith(isFrozen: frozen);
    }));

    _subs.add(_broadcast$().listen((msg) {
      print('💬 broadcast: ${Map<String, dynamic>.from(msg)}');
      state = state.copyWith(system: [...state.system, {'type': 'broadcast', ...msg}]);
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