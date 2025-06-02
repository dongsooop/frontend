import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../main.dart';
import 'chat_data_source.dart';

class ChatDataSourceImpl implements ChatDataSource {
  final Dio _authDio;

  ChatDataSourceImpl(
    this._authDio,
  );

  @override
  Future<List<ChatRoom>?> getChatRooms() async {
    final endpoint = dotenv.get('CHATROOMS_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;

        logger.i('get chat rooms: $data');

        final List<ChatRoom> chatRooms = data.map((e) => ChatRoom.fromJson(e as Map<String, dynamic>)).toList();
        return chatRooms;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}