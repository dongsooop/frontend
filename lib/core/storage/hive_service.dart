import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:dongsoop/domain/chat/model/chat_room_member.dart';
import 'package:dongsoop/domain/chat/model/chat_room_detail.dart';

class HiveService {
  final chatMemberBoxManager = BoxManager<ChatRoomMember>('chat_members');
  final chatRoomBoxManager = BoxManager<ChatRoomDetail>('chat_room');
  final chatMessageBoxManager = BoxManager<ChatMessage>('chat_messages');

  // timetable
  static const String _timetableBoxName = 'local_timetables';

  Future<void> saveTimetableInfo(int year, Semester semester) async {
    final box = await Hive.openBox<LocalTimetableInfo>(_timetableBoxName);
    final info = LocalTimetableInfo(year: year, semester: semester);

    if (!box.values.contains(info)) {
      await box.add(info);
    }
  }

  Future<bool> hasLocalTimetable(int year, Semester semester) async {
    final box = await Hive.openBox<LocalTimetableInfo>(_timetableBoxName);
    final info = LocalTimetableInfo(year: year, semester: semester);
    return box.values.contains(info);
  }

  Future<void> deleteTimetableInfo(int year, Semester semester) async {
    final box = await Hive.openBox<LocalTimetableInfo>(_timetableBoxName);

    final keyToDelete = box.keys.firstWhere(
          (key) {
        final value = box.get(key);
        return value?.year == year && value?.semester == semester;
      },
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }

  // Chat
  Future<void> saveChatMember(String roomId, ChatRoomMember member) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);
    await memberBox.put(member.userId, member);
  }

  Future<ChatRoomMember?> getChatMember(String roomId, String userId) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);
    return memberBox.get(userId);
  }

  Future<List<ChatRoomMember>> getAllMembers(String roomId) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);
    return memberBox.values.toList();
  }

  Future<void> updateChatMemberNickname(String roomId, String userId, String nickname) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);

    final member = memberBox.get(userId);

    if (member != null) {
      member.nickname = nickname;
      await member.save();
    }
  }

  Future<void> updateChatMemberLeft(String roomId, String userId) async {
    final memberBox = await chatMemberBoxManager.getBox(roomId);

    final member = memberBox.get(userId);

    if (member != null) {
      member.hasLeft = true;
      await member.save();
    }
  }

  Future<void> saveChatMessage(String roomId, ChatMessage message) async {
    final messageBox = await chatMessageBoxManager.getBox(roomId);
    await messageBox.put(message.messageId, message);
  }

  Future<void> saveChatDetail(ChatRoomDetail room) async {
    final chatRoomBox = await chatRoomBoxManager.getBox(room.roomId);
    await chatRoomBox.put('detail', room);
  }

  Future<ChatRoomDetail> getChatDetail(String roomId) async {
    final chatRoomBox = await chatRoomBoxManager.getBox(roomId);
    final detail = chatRoomBox.get('detail') as ChatRoomDetail;
    return detail;
  }

  Future<List<ChatMessage>> getPagedMessages(String roomId, int offset, int limit) async {
    final messageBox = await chatMessageBoxManager.getBox(roomId);
    final allMessages = messageBox.values.cast<ChatMessage>().toList();

    allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return allMessages.skip(offset).take(limit).toList();
  }

  Future<ChatMessage?> getLatestMessage(String roomId) async {
    final messageBox = await chatMessageBoxManager.getBox(roomId);

    if (messageBox.isEmpty) return null;

    final messages = messageBox.values.cast<ChatMessage>().toList();
    messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return messages.first;
  }

  Future<void> deleteChatBox() async {
    await chatMessageBoxManager.deleteAll();
    await chatMemberBoxManager.deleteAll();
  }

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

  Future<Box<T>> getBox(String roomId) async {
    final boxName = '${boxPrefix}_$roomId';

    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      return _boxes[boxName]!;
    }

    final box = await Hive.openBox<T>(boxName);
    _boxes[boxName] = box;
    return box;
  }

  Future<void> closeBox(String roomId) async {
    final boxName = '${boxPrefix}_$roomId';
    if (_boxes.containsKey(boxName)) {
      await _boxes[boxName]!.close();
      _boxes.remove(boxName);
    }
  }

  Future<void> closeAll() async {
    for (final box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }

  Future<void> deleteAll() async {
    final boxList = _boxes.values.toList();

    for (final box in boxList) {
      final name = box.name;
      await box.close();
      await Hive.deleteBoxFromDisk(name);
      _boxes.remove(name);
    }
  }

  Future<void> deleteChatBox(String roomId) async {
    final boxName = '${boxPrefix}_$roomId';
    await _boxes[boxName]?.close();
    await Hive.deleteBoxFromDisk(boxName);
  }
}