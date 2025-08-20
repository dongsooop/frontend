import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/network/stomp_service.dart';
import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/model/chat_room_member.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/chat/model/chat_room_detail.dart';
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
  Future<String> createOneToOneChatRoom(String title, int targetUserId) async {
    final endpoint = dotenv.get('ONE_TO_ONE_CHAT');
    final requestBody = {'title': title, 'targetUserId': targetUserId};

    try {
      final response = await _authDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;
        final roomId = data['roomId'];

        return roomId;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatRoom>?> getChatRooms() async {
    final endpoint = dotenv.get('CHATROOMS_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;

        final List<ChatRoom> chatRooms = data
            .map((e) => ChatRoom.fromJson(e as Map<String, dynamic>))
            .toList();
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

        final serverUserIds = nicknameMap.keys.toSet();

        final localMembers = await _hiveService.getAllMembers(roomId);
        final localUserIds = localMembers.map((m) => m.userId).toSet();

        final leftUserIds = localUserIds.difference(serverUserIds);
        for (final userId in leftUserIds) {
          await _hiveService.updateChatMemberLeft(roomId, userId);
        }

        if (localMembers.isEmpty) {
          for (final entry in nicknameMap.entries) {
            await _hiveService.saveChatMember(
              roomId,
              ChatRoomMember(
                userId: entry.key,
                nickname: entry.value,
              ),
            );
          }
        } else {
          for (final entry in nicknameMap.entries) {
            final localMember = localMembers.firstWhere(
                (member) => member.userId == entry.key,
                orElse: () => ChatRoomMember(userId: '', nickname: ''));

            if (localMember.userId.isEmpty) {
              await _hiveService.saveChatMember(
                roomId,
                ChatRoomMember(
                  userId: entry.key,
                  nickname: entry.value,
                ),
              );
            } else if (localMember.nickname != entry.value) {
              await _hiveService.updateChatMemberNickname(
                  roomId, entry.key, entry.value);
            }
          }
        }
        final updatedMembers = await _hiveService.getAllMembers(roomId);
        return {
          for (var m in updatedMembers) m.userId: m.nickname,
        };
      }
      throw Exception();
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.forbidden) {
        throw ChatForbiddenException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatRoomDetail> getRoomDetailByRoomId(String roomId) async {
    try {
      return await _hiveService.getChatDetail(roomId);
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
  Future<void> saveChatDetail(ChatRoomDetail room) async {
    try {
      await _hiveService.saveChatDetail(room);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>?> getPagedMessages(
      String roomId, int offset, int limit) async {
    try {
      return await _hiveService.getPagedMessages(roomId, offset, limit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteChatBox() async {
    try {
      await _hiveService.deleteChatBox();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatMessage?> getLatestMessage(String roomId) async {
    try {
      final message = await _hiveService.getLatestMessage(roomId);

      if (message == null) return null;
      return message;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(List<ChatMessage>?, ChatRoomDetail)> getChatInitialize(String roomId) async {
    final chat = dotenv.get('CHAT');
    final initialize = dotenv.get('CHAT_INITIALEZE_ENDPOINT');
    final endpoint = '$chat/$roomId$initialize';

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<ChatMessage> messages = (response.data['messages'] as List)
            .map((e) => ChatMessage.fromJson(e))
            .toList();
        final room = ChatRoomDetail.fromJson(response.data['room']);

        return (messages, room);
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.forbidden) {
        throw ChatForbiddenException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>?> getChatMessagesAfter(
      String roomId, String messageId) async {
    final chat = dotenv.get('CHAT');
    final afterMessage = dotenv.get('CHAT_AFTER_MESSAGES_ENDPOINT');
    final endpoint = '$chat/$roomId$afterMessage/$messageId';

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<ChatMessage> messages = (response.data as List)
            .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
            .toList();
        return messages;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.forbidden) {
        throw ChatForbiddenException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateReadStatus(String roomId) async {
    final chat = dotenv.get('CHAT');
    final readStatus = dotenv.get('READ_STATUS_ENDPOINT');
    final endpoint = '$chat/$roomId$readStatus';

    try {
      await _authDio.post(endpoint, data: {});
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.forbidden.code) {
        throw ChatForbiddenException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> leaveChatRoom(String roomId) async {
    final chat = dotenv.get('CHAT');
    final leave = dotenv.get('LEAVE_ENDPOINT');
    final endpoint = '$chat/$roomId$leave';

    try {
      final response = await _authDio.post(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        await _hiveService.deleteChatMessagesByRoomId(roomId);
      } else ChatLeaveException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> kickUser(String roomId, int userId) async {
    final chat = dotenv.get('CHAT');
    final kick = dotenv.get('KICK_ENDPOINT');
    final endpoint = '$chat/$roomId$kick';
    final requestBody = {'userId': userId};

    try {
      final response = await _authDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.ok.code) {
      } else ChatLeaveException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> connect(String roomId) => _stompService.connect(roomId);

  @override
  void disconnect() => _stompService.disconnect();

  @override
  void sendMessage(ChatMessageRequest message) =>
      _stompService.sendMessage(message);

  @override
  Stream<ChatMessage> subscribeMessages() => _stompService.messageStream;

  @override
  Stream<String> subscribeBlock() => _stompService.blockStream;
}
