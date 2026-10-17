import 'dart:async';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_choice.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_choice_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_connect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_disconnect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_broadcast_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_disconnect_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_ended_stream_use_case.dart';
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
  final BlindSendMessageUseCase _blindSendMessageUseCase;
  final BlindChoiceUseCase _blindChoiceUseCase;

  final BlindJoinedStreamUseCase _joined$;
  final BlindStartStreamUseCase _start$;
  final BlindSystemStreamUseCase _system$;
  final BlindFreezeStreamUseCase _freeze$;
  final BlindBroadcastStreamUseCase _broadcast$;
  final BlindJoinStreamUseCase _join$;
  final BlindParticipantsStreamUseCase _participants$;
  final BlindEndedStreamUseCase _ended$;
  final BlindDisconnectStreamUseCase _disconnect$;

  BlindDateDetailViewModel(
    this._ref,
    this._connectUseCase,
    this._disconnectUseCase,
    this._blindSendMessageUseCase,
    this._blindChoiceUseCase,
    this._joined$,
    this._start$,
    this._system$,
    this._freeze$,
    this._broadcast$,
    this._join$,
    this._participants$,
    this._ended$,
    this._disconnect$,
  ) : super(BlindDateDetailState());

  final _subs = <StreamSubscription>[];
  Timer? _voteIntroTimer;
  Future<void>? _disconnectFuture;
  bool _hasVoteParticipants = false;
  bool _isLeaving = false;
  String _systemSenderName = '동냥이';

  Future<void> connect(int userId) async {
    if (state.isConnecting) return;

    _voteIntroTimer?.cancel();
    _voteIntroTimer = null;
    _hasVoteParticipants = false;
    _isLeaving = false;
    _disconnectFuture = null;
    _ref.read(blindDateMessagesProvider.notifier).clear();
    state = state.copyWith(
      clearSessionId: true,
      isConnecting: true,
      isLoading: true,
      clearEnded: true,
      clearDisconnectReason: true,
      isKicked: false,
      voteIntroStage: BlindDateVoteIntroStage.none,
      isVoteTime: false,
      participants: const {},
      nickname: '',
    );

    _subs.add(_joined$().listen((data) {
      if (_isLeaving) return;
      state = state.copyWith(volunteer: data);
    }));

    _subs.add(_start$().listen((sid) async {
      if (_isLeaving) return;
      state = state.copyWith(sessionId: sid, isLoading: false);
    }));

    _subs.add(_system$().listen((msg) {
      if (_isLeaving) return;
      if (msg.name.isNotEmpty) _systemSenderName = msg.name;
      _ref.read(blindDateMessagesProvider.notifier).addMessage(msg);
    }));

    _subs.add(_freeze$().listen((frozen) {
      if (_isLeaving) return;
      state = state.copyWith(isFrozen: frozen);
    }));

    _subs.add(_broadcast$().listen((msg) {
      if (_isLeaving) return;
      _ref.read(blindDateMessagesProvider.notifier).addMessage(msg);
    }));

    _subs.add(_join$().listen((info) {
      final joinState = info.state.toUpperCase();
      if (_isLeaving && joinState != 'KICKED') return;
      switch (joinState) {
        case 'WAITING':
          state = state.copyWith(
            sessionId: info.sessionId,
            nickname: info.name,
            maxCount: info.maxCount,
            isLoading: true,
          );
        case 'PROCESSING':
          state = state.copyWith(
            sessionId: info.sessionId,
            nickname: info.name,
            maxCount: info.maxCount,
            isLoading: false,
          );
        case 'FAILED':
          _cancelVotePreparation();
          state = state.copyWith(isLoading: false, ended: 'failed');
        case 'TERMINATED':
          _cancelVotePreparation();
          state = state.copyWith(isLoading: false, ended: 'ended');
        case 'KICKED':
          unawaited(_handleKicked());
      }
    }));

    _subs.add(_participants$().listen((map) {
      if (_isLeaving || state.ended != null) return;
      state = state.copyWith(participants: map);
      // A repeated participants event must not restart the announcement or vote.
      if (_hasVoteParticipants) return;
      _hasVoteParticipants = true;
      _addLocalSystemMessage('이제 과팅의 마지막 순서인 사랑의 작대기 시간이에요!');
      state =
          state.copyWith(voteIntroStage: BlindDateVoteIntroStage.firstMessage);
    }));

    _subs.add(_ended$().listen((data) {
      if (_isLeaving) return;
      _cancelVotePreparation();
      state = state.copyWith(ended: data);
    }));

    _subs.add(_disconnect$().listen((reason) async {
      if (_isLeaving) return;
      _cancelVotePreparation();
      state = state.copyWith(disconnectReason: reason);
    }));

    try {
      // 웹소켓 연결
      await _connectUseCase.execute(userId);
    } on SessionExpiredException {
      state = state.copyWith(isLoading: false);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isConnecting: false);
    }
  }

  Future<void> _handleKicked() async {
    if (_isLeaving || state.isKicked) return;

    _isLeaving = true;
    _cancelVotePreparation();
    if (mounted) {
      state = state.copyWith(
        isKicked: true,
        isLoading: false,
        isFrozen: true,
        participants: const {},
        voteIntroStage: BlindDateVoteIntroStage.none,
        isVoteTime: false,
      );
    }

    try {
      await disconnect();
    } catch (_) {
      // 추방 안내와 화면 종료는 연결 해제 결과와 무관하게 진행한다.
    }
  }

  void _addLocalSystemMessage(String message) {
    _ref.read(blindDateMessagesProvider.notifier).addMessage(
          BlindDateMessage(
            message: message,
            memberId: 0,
            name: _systemSenderName,
            sendAt: DateTime.now(),
            type: 'SYSTEM',
          ),
        );
  }

  // Each delay starts after the screen has rendered the corresponding message.
  void onVoteIntroDisplayed(BlindDateVoteIntroStage stage) {
    if (!mounted ||
        _isLeaving ||
        !state.isVotePreparing ||
        state.voteIntroStage != stage ||
        _voteIntroTimer != null) return;

    final isFirstMessage = stage == BlindDateVoteIntroStage.firstMessage;
    _voteIntroTimer = Timer(Duration(seconds: isFirstMessage ? 2 : 3), () {
      _voteIntroTimer = null;
      if (!mounted ||
          _isLeaving ||
          state.voteIntroStage != stage ||
          state.ended != null) return;
      if (isFirstMessage) {
        _addLocalSystemMessage(
          '투표가 끝나면 과팅은 종료되고, 사랑의 작대기가 이어진 경우 알림으로 전달해 드려요!\n'
          '여러분 다음에 다시 만나요~',
        );
        state = state.copyWith(
          voteIntroStage: BlindDateVoteIntroStage.secondMessage,
        );
      } else {
        state = state.copyWith(
          voteIntroStage: BlindDateVoteIntroStage.none,
          isVoteTime: true,
        );
      }
    });
  }

  void _cancelVotePreparation() {
    _voteIntroTimer?.cancel();
    _voteIntroTimer = null;
    if (mounted && state.isVotePreparing) {
      state = state.copyWith(voteIntroStage: BlindDateVoteIntroStage.none);
    }
  }

  Future<void> disconnect() {
    _isLeaving = true;
    _cancelVotePreparation();
    return _disconnectFuture ??= _disconnect();
  }

  Future<void> _disconnect() async {
    try {
      await _disconnectUseCase.execute();
    } on SessionExpiredException {
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _voteIntroTimer?.cancel();
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    super.dispose();
  }

  bool send(BlindDateRequest message) {
    if (!mounted ||
        _isLeaving ||
        state.isKicked ||
        state.ended != null ||
        state.isLoading ||
        state.isFrozen ||
        state.sessionId == null) {
      return false;
    }
    try {
      _blindSendMessageUseCase.execute(message);
    } on SessionExpiredException {
      return false;
    } catch (e) {
      rethrow;
    }
    return true;
  }

  Future<bool> choice(BlindChoice data) async {
    if (!mounted ||
        _isLeaving ||
        state.isKicked ||
        !state.isVoteTime ||
        state.ended != null) {
      return false;
    }
    state = state.copyWith(isVoteTime: false);
    if (data.targetId != null) {
      _blindChoiceUseCase.execute(data);
    }
    await disconnect();
    return true;
  }
}

class BlindDateMessagesNotifier extends StateNotifier<List<BlindDateMessage>> {
  BlindDateMessagesNotifier() : super([]);

  void addMessage(BlindDateMessage message) {
    state = [message, ...state];
  }

  void clear() {
    state = [];
  }
}
