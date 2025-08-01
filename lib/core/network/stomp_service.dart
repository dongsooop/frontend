import 'dart:async';
import 'dart:convert';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';

class StompService {
  late StompClient _client;
  final _controller = StreamController<ChatMessage>.broadcast();
  final SecureStorageService _secureStorageService;

  StompService(this._secureStorageService);

  Future<void> connect(String roomId) async {
    try {
      final baseUrl = dotenv.get('BASE_URL');
      final endpoint = dotenv.get('WEBSOCKET_ENDPOINT');
      final url = '$baseUrl$endpoint';
      final accessToken = await _secureStorageService.read('accessToken');

      _client = StompClient(
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
            print('WebSocket error: $error');
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

      _client.activate();
    } catch (e) {
      rethrow;
    }
  }

  void _onConnect(StompFrame frame, String roomId) {
    final destination = dotenv.get('DESTINATION');

    _client.subscribe(
      destination: '$destination/$roomId',
      callback: (frame) {
        if (frame.body != null) {
          final jsonData = json.decode(frame.body!);
          final message = ChatMessage.fromJson(jsonData);
          _controller.add(message);
        }
      },
    );
  }

  void sendMessage(ChatMessageRequest message) {
    final endpoint = dotenv.get('SEND_MESSAGE_ENDPOINT');
    final destination = '$endpoint/${message.roomId}';

    final bodyData = json.encode({
      "content": message.content,
      "type": message.type,
    });

    _client.send(
      destination: destination,
      body: bodyData,
    );
  }

  void disconnect() {
    _client.deactivate();
  }

  Stream<ChatMessage> get messageStream => _controller.stream;
}
