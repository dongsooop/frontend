import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/network/stomp_service.dart';
import '../../../main.dart';
import 'chat_data_source.dart';

class ChatDataSourceImpl implements ChatDataSource {
  final Dio _authDio;
  final StompService _stompService;

  ChatDataSourceImpl(
    this._authDio,
    this._stompService,
  );

  @override
  Future<List<ChatRoom>?> getChatRooms() async {
    final endpoint = dotenv.get('CHATROOMS_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;

        final List<ChatRoom> chatRooms = data.map((e) => ChatRoom.fromJson(e as Map<String, dynamic>)).toList();
        return chatRooms;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> connect(String roomId) => _stompService.connect(roomId);

  @override
  void disconnect() => _stompService.disconnect();

  @override
  void sendMessage(ChatMessageRequest message) => _stompService.sendMessage(message);

  @override
  Stream<ChatMessage> subscribeMessages() => _stompService.messageStream;
}