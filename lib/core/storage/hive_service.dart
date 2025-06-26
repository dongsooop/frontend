import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:dongsoop/domain/chat/model/chat_room_member.dart';

class HiveService {
  final chatMemberBoxManager = BoxManager<ChatRoomMember>('chat_members');
  final chatMessageBoxManager = BoxManager<ChatMessage>('chat_messages');

  // 채팅방 사용자 목록 저장
  Future<void> saveChatMember(String roomId, ChatRoomMember member) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId); // roomId로 box 오픈
    await memberBox.put(member.userId, member); // userId를 key로 저장
  }

  // 특정 참여자 조회
  Future<ChatRoomMember?> getChatMember(String roomId, String userId) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);
    return memberBox.get(userId);
  }

  // 전체 참여자 조회
  Future<List<ChatRoomMember>> getAllMembers(String roomId) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);
    return memberBox.values.toList();
  }

  // 닉네임 업데이트
  Future<void> updateChatMemberNickname(String roomId, String userId, String nickname) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);

    // userId에 해당하는 멤버 찾기
    final member = memberBox.get(userId);

    if (member != null) {
      member.nickname = nickname; // 값 수정
      await member.save();   // 변경 내용 저장
    }
  }

  // 참여자 채팅방 떠남
  Future<void> updateChatMemberLeft(String roomId, String userId) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);

    // userId에 해당하는 멤버 찾기
    final member = memberBox.get(userId);

    if (member != null) {
      member.hasLeft = true; // 값 수정
      await member.save();   // 변경 내용 저장
    }
  }


  // 채팅 내역 저장
  Future<void> saveChatMessage(String roomId, ChatMessage message) async {
    final messageBox = await chatMessageBoxManager.getBox(roomId); // roomId로 box 오픈
    await messageBox.put(message.messageId, message); // userId를 key로 저장
  }

  // 페이징
  Future<List<ChatMessage>> getPagedMessages(String roomId, int offset, int limit) async {
    final messageBox = await chatMessageBoxManager.getBox(roomId);
    final allMessages = messageBox.values.cast<ChatMessage>().toList();

    allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // 최신순 정렬
    return allMessages.skip(offset).take(limit).toList();
  }

  // 가장 최신 메시지 조회
  Future<ChatMessage?> getLatestMessage(String roomId) async {
    final messageBox = await chatMessageBoxManager.getBox(roomId);

    if (messageBox.isEmpty) return null;

    final messages = messageBox.values.cast<ChatMessage>().toList();
    messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return messages.first;
  }

  // 데이터 삭제
  Future<void> deleteChatBox() async {
    await chatMessageBoxManager.deleteAll();
    await chatMemberBoxManager.deleteAll();
  }

  // 특정 채팅방 내역 삭제
  Future<void> deleteChatMessagesByRoomId(String roomId) async {
    await chatMessageBoxManager.deleteChatBox(roomId);
  }
}

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class BoxManager<T> {
  final String boxPrefix;
  final Map<String, Box<T>> _boxes = {};

  BoxManager(this.boxPrefix);

  // box 가져오기 (이미 열려있으면 재사용)
  Future<Box<T>> getBox(String roomId) async {
    final boxName = '${boxPrefix}_$roomId';

    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      return _boxes[boxName]!;
    }

    final box = await Hive.openBox<T>(boxName);
    _boxes[boxName] = box;
    return box;
  }

  // 특정 박스 닫기
  Future<void> closeBox(String roomId) async {
    final boxName = '${boxPrefix}_$roomId';
    if (_boxes.containsKey(boxName)) {
      await _boxes[boxName]!.close();
      _boxes.remove(boxName);
    }
  }

  // 전체 박스 닫기 (앱 종료 시 등)
  Future<void> closeAll() async {
    for (final box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }

  // 전체 박스 삭제
  Future<void> deleteAll() async {
    for (final box in _boxes.values) {
      final name = box.name;
      await box.close();
      await Hive.deleteBoxFromDisk(name);
    }
    _boxes.clear();
  }

  // 특정 박스 삭제
  Future<void> deleteChatBox(String roomId) async {
    final boxName = '${boxPrefix}_$roomId';
    await _boxes[boxName]?.close();
    await Hive.deleteBoxFromDisk(boxName);
  }
}