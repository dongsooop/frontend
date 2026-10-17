import 'dart:async';
import 'dart:convert';
import 'package:dongsoop/core/network/session_end_reason_parser.dart';
import 'package:dongsoop/domain/auth/enum/session_end_reason.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room_ws.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';

class StompService {
  StompClient? _chatDetailClient;
  StompClient? _chatRoomClient;
  bool _chatDetailHasConnected = false;
  bool _chatRoomHasConnected = false;

  final _chatController = StreamController<ChatMessage>.broadcast();
  final _blockController = StreamController<String>.broadcast();
  final _chatRoomController = StreamController<ChatRoomWs>.broadcast();
  final _sessionEndController = StreamController<SessionEndReason>.broadcast();

  final SecureStorageService _secureStorageService;

  StompService(this._secureStorageService);

  // chat room list
  Future<void> connectRoomList(int userId) async {
    try {
      _chatRoomHasConnected = false;
      final baseUrl = 'https://dongsoop.site';
      final endpoint = '/ws/chat';
      final url = '$baseUrl$endpoint';
      final accessToken = await _secureStorageService.read('accessToken');

      final client = StompClient(
        config: StompConfig.sockJS(
          url: url,
          onConnect: (frame) => _onConnectRoomList(frame, userId),
          onDisconnect: (_) => _chatRoomHasConnected = false,
          onWebSocketDone: () => _chatRoomHasConnected = false,
          stompConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          webSocketConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          onStompError: (frame) => _handleRealtimeError(
            '${frame.headers} ${frame.body ?? ''}',
            hasConnected: _chatRoomHasConnected,
          ),
          onWebSocketError: (error) => _handleRealtimeError(
            error,
            hasConnected: _chatRoomHasConnected,
          ),
        ),
      );

      _chatRoomClient = client;
      client.activate();
    } catch (e) {
      rethrow;
    }
  }

  void _onConnectRoomList(StompFrame frame, int userId) {
    final client = _chatRoomClient;
    if (client == null || !client.connected) return;
    _chatRoomHasConnected = true;
    final chatRoomDestination = '/topic/user';

    client.subscribe(
      destination: '$chatRoomDestination/$userId',
      callback: (frame) {
        if (frame.body != null) {
          final jsonData = json.decode(frame.body!);
          final data = ChatRoomWs.fromJson(jsonData);
          _chatRoomController.add(data);
        }
      },
    );
  }

  void disconnectChatRoom() {
    _chatRoomClient?.deactivate();
    _chatRoomClient = null;
    _chatRoomHasConnected = false;
  }

  Stream<ChatRoomWs> get chatRoomStream => _chatRoomController.stream;

  // chat detail
  Future<void> connect(String roomId) async {
    try {
      _chatDetailHasConnected = false;
      final baseUrl = 'https://dongsoop.site';
      final endpoint = '/ws/chat';
      final url = '$baseUrl$endpoint';
      final accessToken = await _secureStorageService.read('accessToken');

      final client = StompClient(
        config: StompConfig.sockJS(
          url: url,
          onConnect: (frame) => _onConnect(frame, roomId),
          onDisconnect: (_) => _chatDetailHasConnected = false,
          onWebSocketDone: () => _chatDetailHasConnected = false,
          stompConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          webSocketConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          onStompError: (frame) => _handleRealtimeError(
            '${frame.headers} ${frame.body ?? ''}',
            hasConnected: _chatDetailHasConnected,
          ),
          onWebSocketError: (error) => _handleRealtimeError(
            error,
            hasConnected: _chatDetailHasConnected,
          ),
        ),
      );

      _chatDetailClient = client;
      client.activate();
    } catch (e) {
      rethrow;
    }
  }

  void _onConnect(StompFrame frame, String roomId) {
    final client = _chatDetailClient;
    if (client == null || !client.connected) return;
    _chatDetailHasConnected = true;
    final enterDestination = '/app/enter';
    final chatDestination = '/topic/chat/room';
    final blockDestination = '/user/topic/chat/room';

    client.subscribe(
      destination: '$blockDestination/$roomId',
      callback: (frame) {
        if (frame.body != null) {
          final jsonData = json.decode(frame.body!);
          final blockStatus = jsonData['blockStatus'] as String;
          _blockController.add(blockStatus);
        }
      },
    );

    client.subscribe(
      destination: '$chatDestination/$roomId',
      callback: (frame) {
        if (frame.body != null) {
          final jsonData = json.decode(frame.body!);
          final message = ChatMessage.fromJson(jsonData);
          _chatController.add(message);
        }
      },
    );

    client.send(
      destination: '$enterDestination/$roomId',
    );
  }

  void sendMessage(ChatMessageRequest message) {
    final client = _chatDetailClient;
    if (client == null || !client.connected) {
      throw StateError('STOMP is not connected');
    }
    final endpoint = '/app/message';
    final destination = '$endpoint/${message.roomId}';

    final bodyData = json.encode({
      "content": message.content,
      "type": message.type,
    });

    client.send(
      destination: destination,
      body: bodyData,
    );
  }

  void disconnect() {
    _chatDetailClient?.deactivate();
    _chatDetailClient = null;
    _chatDetailHasConnected = false;
  }

  void disconnectAll() {
    disconnectChatRoom();
    disconnect();
  }

  void _handleRealtimeError(
    Object? error, {
    required bool hasConnected,
  }) {
    final reason = sessionEndReasonFromRealtimeConnectError(
      error,
      hasConnected: hasConnected,
    );
    if (reason != null) {
      _sessionEndController.add(reason);
    }
  }

  Stream<ChatMessage> get messageStream => _chatController.stream;
  Stream<String> get blockStream => _blockController.stream;
  Stream<SessionEndReason> get sessionEndStream => _sessionEndController.stream;
}
