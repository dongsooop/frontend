import 'dart:async';
import 'dart:convert';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room_ws.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';

class StompService {
  late StompClient _chatDetailClient;
  late StompClient _chatRoomClient;

  final _chatController = StreamController<ChatMessage>.broadcast();
  final _blockController = StreamController<String>.broadcast();
  final _chatRoomController = StreamController<ChatRoomWs>.broadcast();

  final SecureStorageService _secureStorageService;

  StompService(this._secureStorageService);

  // chat room list
  Future<void> connectRoomList(int userId) async {
    try {
      final baseUrl = dotenv.get('BASE_URL');
      final endpoint = dotenv.get('WEBSOCKET_ENDPOINT');
      final url = '$baseUrl$endpoint';
      final accessToken = await _secureStorageService.read('accessToken');

      _chatRoomClient = StompClient(
        config: StompConfig.sockJS(
          url: url,
          onConnect: (frame) => _onConnectRoomList(frame, userId),
          stompConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          webSocketConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          onWebSocketError: (error) {
            if (error.toString().contains('403')) {
              throw ChatForbiddenException();
            } else if (error.toString().contains('401')) {
              throw LoginRequiredException();
            } else {
              throw Exception('WebSocket Error: $error');
            }
          },
        ),
      );

      _chatRoomClient.activate();
    } catch (e) {
      rethrow;
    }
  }

  void _onConnectRoomList(StompFrame frame, int userId) {
    final chatRoomDestination = dotenv.get('CHAT_ROOM_DESTINATION');

    _chatRoomClient.subscribe(
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
    _chatRoomClient.deactivate();
  }

  Stream<ChatRoomWs> get chatRoomStream => _chatRoomController.stream;

  // chat detail
  Future<void> connect(String roomId) async {
    try {
      final baseUrl = dotenv.get('BASE_URL');
      final endpoint = dotenv.get('WEBSOCKET_ENDPOINT');
      final url = '$baseUrl$endpoint';
      final accessToken = await _secureStorageService.read('accessToken');

      _chatDetailClient = StompClient(
        config: StompConfig.sockJS(
          url: url,
          onConnect: (frame) => _onConnect(frame, roomId),
          stompConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          webSocketConnectHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
          onWebSocketError: (error) {
            if (error.toString().contains('403')) {
              throw ChatForbiddenException();
            } else if (error.toString().contains('401')) {
              throw LoginRequiredException();
            } else {
              throw Exception('WebSocket Error: $error');
            }
          },
        ),
      );

      _chatDetailClient.activate();
    } catch (e) {
      rethrow;
    }
  }

  void _onConnect(StompFrame frame, String roomId) {
    final enterDestination = dotenv.get('ENTER_DESTINATION');
    final chatDestination = dotenv.get('CHAT_DESTINATION');
    final blockDestination = dotenv.get('BLOCK_DESTINATION');

    _chatDetailClient.subscribe(
      destination: '$blockDestination/$roomId',
      callback: (frame) {
        if (frame.body != null) {
          final jsonData = json.decode(frame.body!);
          final blockStatus = jsonData['blockStatus'] as String;
          _blockController.add(blockStatus);
        }
      },
    );

    _chatDetailClient.subscribe(
      destination: '$chatDestination/$roomId',
      callback: (frame) {
        if (frame.body != null) {
          final jsonData = json.decode(frame.body!);
          final message = ChatMessage.fromJson(jsonData);
          _chatController.add(message);
        }
      },
    );

    _chatDetailClient.send(
      destination: '$enterDestination/$roomId',
    );
  }

  void sendMessage(ChatMessageRequest message) {
    final endpoint = dotenv.get('SEND_MESSAGE_ENDPOINT');
    final destination = '$endpoint/${message.roomId}';

    final bodyData = json.encode({
      "content": message.content,
      "type": message.type,
    });

    _chatDetailClient.send(
      destination: destination,
      body: bodyData,
    );
  }

  void disconnect() {
    _chatDetailClient.deactivate();
  }

  Stream<ChatMessage> get messageStream => _chatController.stream;
  Stream<String> get blockStream => _blockController.stream;
}
