import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dongsoop/core/network/stomp_service.dart';
import '../../../domain/chat/model/chat_room_member.dart';
import '../../../main.dart';
import 'chat_data_source.dart';

class ChatDataSourceImpl implements ChatDataSource {
  final Dio _authDio;
  final StompService _stompService;
  final HiveService _hiveService;

  ChatDataSourceImpl(
    this._authDio,
    this._stompService,
    this._hiveService,
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
  Future<Map<String, String>> getUserNicknamesByRoomId(String roomId) async {
    final chat = dotenv.get('CHAT');
    final nicknames = dotenv.get('CHATROOM_NICKNAMES_ENDPOINT');
    final endpoint = '$chat/$roomId$nicknames';

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final nicknameMap = Map<String, String>.from(response.data);

        // 로컬 저장 목록 조회
        final localMembers = await _hiveService.getAllMembers(roomId);
        logger.i('get local chatroom members: ${localMembers.map((m) => '(${m.userId}, ${m.nickname}, left: ${m.hasLeft})').toList()}');

        // 로컬 저장 목록이 비어있음 -> 응답값 전부 저장
        if (localMembers.isEmpty) {
          for (final entry in nicknameMap.entries) {
            await _hiveService.saveChatMember(
              roomId,
              ChatRoomMember(
                userId: entry.key,
                nickname: entry.value,
              )
            );
          }
        } else {
          // 로컬에 없는 userId 추가 또는 닉네임 업데이트
          for (final entry in nicknameMap.entries) {
            final localMember = localMembers.firstWhere(
              (member) => member.userId == entry.key,
              orElse: () => ChatRoomMember(userId: '', nickname: '')
            );

            if (localMember.userId.isEmpty) {
              // 로컬에 없는 사용자
              await _hiveService.saveChatMember(
                roomId,
                localMember
              );
            } else if (localMember.nickname != entry.value) {
              // 닉네임이 변경된 사용자
              await _hiveService.updateChatMemberNickname(roomId, entry.key, entry.value);
            }
          }
        }
        // 로컬 저장 목록 조회
        final updatedMembers = await _hiveService.getAllMembers(roomId);
        logger.i('get local updatedMembers: ${updatedMembers.map((m) => '(${m.userId}, ${m.nickname}, left: ${m.hasLeft})').toList()}');
        return {
          for (var m in updatedMembers) m.userId: m.nickname,
        };
      }
      throw Exception();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveChatMessage(ChatMessage message) async {
    try {
      await _hiveService.saveChatMessage(message.roomId, message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>?> getAllChatMessages(String roomId) async {
    try {
      return await _hiveService.getAllMessages(roomId);
    } catch (e) {
      rethrow;
    }
  }

  // STOMP
  @override
  Future<void> connect(String roomId) => _stompService.connect(roomId);

  @override
  void disconnect() => _stompService.disconnect();

  @override
  void sendMessage(ChatMessageRequest message) => _stompService.sendMessage(message);

  @override
  Stream<ChatMessage> subscribeMessages() => _stompService.messageStream;
}