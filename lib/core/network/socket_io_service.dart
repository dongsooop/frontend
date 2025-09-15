import 'dart:async';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_choice.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_join_info.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIoService {
  final SecureStorageService _secureStorageService;

  SocketIoService(this._secureStorageService);

  IO.Socket? _socket;

  // 이벤트
  // 사용자 참여(대기화면)
  final _joinedCtrl = StreamController<int>.broadcast();
  // 과팅 시작
  final _startCtrl = StreamController<String>.broadcast();
  // 동냥이 메시지(서버)
  final _systemCtrl = StreamController<BlindDateMessage>.broadcast();
  // 채팅 입력 비활성화/활성화
  final _freezeCtrl = StreamController<bool>.broadcast();
  // 메시지 수신 브로드캐스트
  final _broadcastCtrl = StreamController<BlindDateMessage>.broadcast();
  // 입장 시 정보 받기
  final _joinCtrl = StreamController<BlindJoinInfo>.broadcast();
  // 모든 사용자 받기
  final _participantsCtrl = StreamController<Map<int, String>>.broadcast();
  // 매칭 성공
  final _matchCtrl = StreamController<String>.broadcast();
  // 연결 해제
  final _disconnectCtrl= StreamController<String>.broadcast();

  Stream<int> get joinedStream => _joinedCtrl.stream; // { sessionId, volunteer }
  Stream<String> get startStream => _startCtrl.stream; // sessionId
  Stream<BlindDateMessage> get systemStream => _systemCtrl.stream;
  Stream<bool> get freezeStream  => _freezeCtrl.stream;
  Stream<BlindDateMessage> get broadcastStream => _broadcastCtrl.stream;  // message
  Stream<BlindJoinInfo> get joinStream => _joinCtrl.stream;
  Stream<Map<int, String>> get participantsStream => _participantsCtrl.stream;
  Stream<String> get disconnectStream=> _disconnectCtrl.stream; // reason
  Stream<String> get matchStream => _matchCtrl.stream;

  bool get isConnected => _socket?.connected ?? false;


  // 연결
  Future<void> connect({
    required String url,
    required String sessionId,
    required int memberId,
  }) async {
    // Socket.IO 옵션 구성
    final opts = IO.OptionBuilder()
        .setTransports(['websocket'])
        .setQuery({'sessionId': sessionId, 'memberId': memberId.toString()})
        // .setExtraHeaders(headers ?? {})
        .disableAutoConnect()
        .setReconnectionAttempts(10)
        .setReconnectionDelay(600)
        .build();

    _socket = IO.io(url, opts);

    // 콜백 등록
    _socket!
      ..onConnect((_) {
      })
      ..on('joined', (data) {
        _joinedCtrl.add(data['volunteer']);
      })
      ..on('start', (data) {
        if (data is Map && data['sessionId'] is String) {
          _startCtrl.add(data['sessionId'] as String);
        } else if (data is String) {
          _startCtrl.add(data);
        }
      })
      ..on('system', (data) {
        final message = BlindDateMessage.fromSystemJson(data);
        _systemCtrl.add(message);
      })
      ..on('freeze', (_) {
        _freezeCtrl.add(true);
      })
      ..on('thaw', (_){
        _freezeCtrl.add(false);
      })
      ..on('broadcast', (msg) {
        final message = BlindDateMessage.fromUserJson(msg);
        _broadcastCtrl.add(message);
      })
      ..on('message', (msg) {
        print('🛠️ message: $msg');
      })
      ..on('join', (data) {
        final info = BlindJoinInfo.fromJson(data);
        _joinCtrl.add(info);
      })
      ..on('create_chat', (data) {
        print('🥰 roomId: $data');
        _matchCtrl.add(data);
      })
      ..on('participants', (data) {
        if (data is List) {
          final map = <int, String>{};
          for (final row in data) {
            if (row is List && row.length >= 2) {
              final id = int.tryParse(row[0].toString());
              final name = row[1]?.toString() ?? '';
              if (id != null) map[id] = name;
            }
          }
          _participantsCtrl.add(map);
        } else {
         print('❗ invalid participants payload: $data');
        }
      })
      ..onDisconnect((reason) {
        _disconnectCtrl.add(reason?.toString() ?? 'unknown');
      })
      ..onError((err) {
        print('❗ socket.io error: $err');
      });

    _socket!.connect();
  }

  void sendUserMessage(BlindDateRequest message) {
    if (_socket == null || !_socket!.connected) {
      throw StateError('Socket is not connected');
    }

    _socket!.emit('message', message.toJson());
  }

  void userChoice(BlindChoice data) async {
    final accessToken = await _secureStorageService.read('accessToken') ?? '';

    if (_socket?.connected != true) {
      throw StateError('Socket is not connected');
    }

    final updated = data.copyWith(choicerToken: accessToken);
    print('update: $updated');
    _socket!.emit('choice', updated.toJson());
  }

  // 연결 해제
  Future<void> disconnect() async {
    _socket?.disconnect();
  }

  // 자원 정리
  Future<void> dispose() async {
    await _joinedCtrl.close();
    await _startCtrl.close();
    await _systemCtrl.close();
    await _freezeCtrl.close();
    await _broadcastCtrl.close();
    await _disconnectCtrl.close();
    await _joinCtrl.close();
    await _participantsCtrl.close();
    await _matchCtrl.close();
    _socket?.dispose();
    _socket = null;
  }
}