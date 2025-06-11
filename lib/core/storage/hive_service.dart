import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:dongsoop/domain/chat/model/chat_room_member.dart';

class HiveService {
  static const _chatMessage = 'chat_message';

  // 채팅방 사용자 목록 저장
  Future<void> saveChatMember(String roomId, ChatRoomMember member) async {
    final box = await ChatMemberBoxManager.getChatMemberBox(roomId); // roomId로 box 오픈
    await box.put(member.userId, member); // userId를 key로 저장
  }

  // 특정 참여자 조회
  Future<ChatRoomMember?> getChatMember(String roomId, String userId) async {
    final box = await ChatMemberBoxManager.getChatMemberBox(roomId);
    return box.get(userId);
  }

  // 전체 참여자 조회
  Future<List<ChatRoomMember>> getAllMembers(String roomId) async {
    final box = await ChatMemberBoxManager.getChatMemberBox(roomId);
    return box.values.toList();
  }

  // 닉네임 업데이트
  Future<void> updateChatMemberNickname(String roomId, String userId, String nickname) async {
    final box = await ChatMemberBoxManager.getChatMemberBox(roomId);

    // userId에 해당하는 멤버 찾기
    final member = box.get(userId);

    if (member != null) {
      member.nickname = nickname; // 값 수정
      await member.save();   // 변경 내용 저장
    }
  }

  // 참여자 채팅방 떠남
  Future<void> updateChatMemberLeft(String roomId, String userId) async {
    final box = await ChatMemberBoxManager.getChatMemberBox(roomId);

    // userId에 해당하는 멤버 찾기
    final member = box.get(userId);

    if (member != null) {
      member.hasLeft = true; // 값 수정
      await member.save();   // 변경 내용 저장
    }
  }


}

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class ChatMemberBoxManager {
  static final Map<String, Box<ChatRoomMember>> _boxes = {};
  static const _chatRoom = 'chat_room';

  // box 가져오기 (이미 열려있으면 재사용)
  static Future<Box<ChatRoomMember>> getChatMemberBox(String roomId) async {
    final boxName = '${_chatRoom}_$roomId';

    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      return _boxes[boxName]!;
    }

    final box = await Hive.openBox<ChatRoomMember>(boxName);
    _boxes[boxName] = box;
    return box;
  }

  // 전체 박스 닫기 (앱 종료 시 등)
  static Future<void> closeAllChatMemberBox() async {
    for (final box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }

  // 특정 박스 닫기
  static Future<void> closeChatBox(String roomId) async {
    final boxName = '${_chatRoom}_$roomId';
    if (_boxes.containsKey(boxName)) {
      await _boxes[boxName]!.close();
      _boxes.remove(boxName);
    }
  }
}