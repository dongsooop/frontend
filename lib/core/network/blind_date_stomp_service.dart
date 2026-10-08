import 'dart:async';
import 'dart:convert';

import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_choice.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_join_info.dart';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class BlindDateStompService {
  final SecureStorageService _secureStorageService;

  StompClient? _client;
  final _sessionSubscriptions = <StompUnsubscribe>[];
  Timer? _joinResponseTimer;

  String? _sessionId;
  int? _memberId;
  bool _isDisconnecting = false;

  final _joinedController = StreamController<int>.broadcast();
  final _startController = StreamController<String>.broadcast();
  final _systemController = StreamController<BlindDateMessage>.broadcast();
  final _freezeController = StreamController<bool>.broadcast();
  final _messageController = StreamController<BlindDateMessage>.broadcast();
  final _joinController = StreamController<BlindJoinInfo>.broadcast();
  final _participantsController =
      StreamController<Map<int, String>>.broadcast();
  final _endedController = StreamController<String>.broadcast();
  final _disconnectController = StreamController<String>.broadcast();

  BlindDateStompService(this._secureStorageService);

  Future<void> connect({
    required String url,
    required int memberId,
  }) async {
    final accessToken = await _secureStorageService.read('accessToken');

    _isDisconnecting = false;
    _memberId = memberId;
    _sessionId = null;

    _client?.deactivate();
    _sessionSubscriptions.clear();

    _log(
      'CONNECT transport=SockJS url=$url '
      'accessToken=${accessToken?.isNotEmpty == true ? 'present' : 'missing'}',
    );

    final client = StompClient(
      config: StompConfig.sockJS(
        url: url,
        reconnectDelay: const Duration(milliseconds: 600),
        onDebugMessage: _logFrame,
        onConnect: _onConnect,
        stompConnectHeaders: {
          'Authorization': 'Bearer $accessToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $accessToken',
        },
        onDisconnect: (frame) {
          _joinResponseTimer?.cancel();
          _log('DISCONNECTED body=${frame.body ?? '-'}');
          if (!_isDisconnecting) {
            _disconnectController.add(
              frame.body ?? 'STOMP connection disconnected',
            );
          }
        },
        onStompError: (frame) {
          _joinResponseTimer?.cancel();
          _log('STOMP_ERROR body=${frame.body ?? '-'}');
          _disconnectController.add(frame.body ?? 'STOMP protocol error');
        },
        onWebSocketError: (error) {
          _joinResponseTimer?.cancel();
          _log('WEBSOCKET_ERROR error=$error');
          _disconnectController.add(error.toString());
        },
        onWebSocketDone: () {
          _joinResponseTimer?.cancel();
          _log('WEBSOCKET_CLOSED reconnecting=${!_isDisconnecting}');
          if (!_isDisconnecting) {
            _disconnectController.add('WebSocket connection closed');
          }
        },
      ),
    );

    _client = client;
    client.activate();
    _log('ACTIVATED waitingFor=CONNECTED');
  }

  void _onConnect(StompFrame frame) {
    final client = _client;
    if (client == null || !client.connected) return;

    _log('CONNECTED');
    _sessionSubscriptions.clear();
    const joinDestination = '/user/queue/blinddate/join';
    _log('SUBSCRIBE destination=$joinDestination');
    client.subscribe(
      destination: joinDestination,
      callback: (frame) => _handleFrame(
        frame,
        destination: joinDestination,
        onData: _handleJoin,
      ),
    );
    _joinResponseTimer?.cancel();
    _joinResponseTimer = Timer(const Duration(seconds: 5), () {
      _log(
        'JOIN_TIMEOUT destination=$joinDestination '
        'message=STOMP 연결과 구독은 완료됐지만 입장 응답을 받지 못했습니다.',
      );
    });

    final sessionId = _sessionId;
    final memberId = _memberId;
    if (sessionId != null && memberId != null) {
      _subscribeSession(sessionId, memberId);
    }
  }

  void _handleJoin(Map<String, dynamic> data) {
    _joinResponseTimer?.cancel();
    final state = data['state']?.toString().toUpperCase() ?? '';
    _log(
      'JOIN state=$state name=${data['name'] ?? '-'} '
      'sessionId=${data['sessionId'] ?? '-'} '
      'volunteer=${data['volunteer'] ?? '-'} '
      'maxCount=${data['maxCount'] ?? '-'}',
    );

    if (state == 'WAITING' || state == 'PROCESSING') {
      final sessionId = data['sessionId']?.toString();
      final memberId = _memberId;
      if (sessionId == null || sessionId.isEmpty || memberId == null) {
        _disconnectController.add('Invalid blind-date join payload');
        return;
      }

      _joinController.add(
        BlindJoinInfo(
          name: data['name']?.toString() ?? '',
          state: state,
          maxCount: (data['maxCount'] as num?)?.toInt(),
        ),
      );
      _joinedController.add((data['volunteer'] as num?)?.toInt() ?? 0);

      if (_sessionId != sessionId || _sessionSubscriptions.isEmpty) {
        _sessionId = sessionId;
        _subscribeSession(sessionId, memberId);
      }
      return;
    }

    _joinController.add(BlindJoinInfo(name: '', state: state));
    if (state == 'TERMINATED') {
      _endedController.add('ended');
    } else if (state == 'FAILED') {
      _endedController.add('failed');
    }
  }

  void _subscribeSession(String sessionId, int memberId) {
    final client = _client;
    if (client == null || !client.connected) return;

    _log('SESSION_SUBSCRIBE sessionId=$sessionId memberId=$memberId');
    for (final unsubscribe in _sessionSubscriptions) {
      unsubscribe();
    }
    _sessionSubscriptions.clear();

    final base = '/topic/blinddate/session/$sessionId';

    _subscribe('$base/start', (data) {
      final startedSessionId = data['sessionId']?.toString();
      if (startedSessionId != null) {
        _startController.add(startedSessionId);
      }
    });
    _subscribe(
      '$base/message',
      (data) => _messageController.add(BlindDateMessage.fromUserJson(data)),
    );
    _subscribe('$base/joined', (data) {
      final volunteer = (data['volunteer'] as num?)?.toInt();
      if (volunteer != null) {
        _joinedController.add(volunteer);
      }
    });
    _subscribe(
      '$base/system',
      (data) => _systemController.add(BlindDateMessage.fromSystemJson(data)),
    );
    _subscribe('$base/freeze', (_) => _freezeController.add(true));
    _subscribe('$base/thaw', (_) => _freezeController.add(false));
    _subscribe('$base/participants', (data) {
      final rawParticipants = data['participants'];
      if (rawParticipants is! Map) return;

      final participants = <int, String>{};
      for (final entry in rawParticipants.entries) {
        final id = int.tryParse(entry.key.toString());
        if (id != null) {
          participants[id] = entry.value?.toString() ?? '';
        }
      }
      _participantsController.add(participants);
    });
  }

  void _subscribe(
    String destination,
    void Function(Map<String, dynamic>) onData,
  ) {
    final client = _client;
    if (client == null || !client.connected) return;

    _log('SUBSCRIBE destination=$destination');
    final unsubscribe = client.subscribe(
      destination: destination,
      callback: (frame) => _handleFrame(
        frame,
        destination: destination,
        onData: onData,
      ),
    );
    _sessionSubscriptions.add(unsubscribe);
  }

  void _handleFrame(
    StompFrame frame, {
    required String destination,
    required void Function(Map<String, dynamic>) onData,
  }) {
    final body = frame.body;
    if (body == null || body.isEmpty) {
      _log('RECEIVE destination=$destination body=<empty>');
      return;
    }

    _log('RECEIVE destination=$destination body=$body');

    try {
      final decoded = json.decode(body);
      if (decoded is! Map) {
        throw const FormatException('Expected a JSON object');
      }
      onData(Map<String, dynamic>.from(decoded));
    } catch (error) {
      _log('PAYLOAD_ERROR destination=$destination error=$error body=$body');
      _disconnectController.add('Invalid payload from $destination: $error');
    }
  }

  void sendUserMessage(BlindDateRequest message) {
    final client = _client;
    if (client == null || !client.connected) {
      throw StateError('STOMP is not connected');
    }

    const destination = '/app/blinddate/message';
    final body = json.encode({'message': message.message});
    _log('SEND destination=$destination body=$body');
    client.send(
      destination: destination,
      headers: const {'content-type': 'application/json'},
      body: body,
    );
  }

  void userChoice(BlindChoice choice) {
    final client = _client;
    if (client == null || !client.connected) {
      throw StateError('STOMP is not connected');
    }

    const destination = '/app/blinddate/choice';
    final body = json.encode({'targetId': choice.targetId});
    _log('SEND destination=$destination body=$body');
    client.send(
      destination: destination,
      headers: const {'content-type': 'application/json'},
      body: body,
    );
  }

  Future<void> disconnect() async {
    _log(
      'DISCONNECT sessionId=${_sessionId ?? '-'} memberId=${_memberId ?? '-'}',
    );
    _isDisconnecting = true;
    _joinResponseTimer?.cancel();
    _joinResponseTimer = null;
    for (final unsubscribe in _sessionSubscriptions) {
      unsubscribe();
    }
    _sessionSubscriptions.clear();
    _client?.deactivate();
    _client = null;
    _sessionId = null;
    _memberId = null;
  }

  Stream<int> get joinedStream => _joinedController.stream;
  Stream<String> get startStream => _startController.stream;
  Stream<BlindDateMessage> get systemStream => _systemController.stream;
  Stream<bool> get freezeStream => _freezeController.stream;
  Stream<BlindDateMessage> get broadcastStream => _messageController.stream;
  Stream<BlindJoinInfo> get joinStream => _joinController.stream;
  Stream<Map<int, String>> get participantsStream =>
      _participantsController.stream;
  Stream<String> get endedStream => _endedController.stream;
  Stream<String> get disconnectStream => _disconnectController.stream;

  bool get isConnected => _client?.connected ?? false;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[BlindDate STOMP] $message');
    }
  }

  void _logFrame(String message) {
    final sanitized = message.replaceAll(
      RegExp(r'Authorization:Bearer [^\\\s"]+', caseSensitive: false),
      'Authorization:Bearer <redacted>',
    );
    _log('FRAME $sanitized');
  }
}
