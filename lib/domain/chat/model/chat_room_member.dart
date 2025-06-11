import 'package:hive/hive.dart';

class ChatRoomMember extends HiveObject {
  String userId;
  String nickname;
  bool hasLeft;

  ChatRoomMember({
    required this.userId,
    required this.nickname,
    this.hasLeft = false,
  });
}

class ChatRoomMemberAdapter extends TypeAdapter<ChatRoomMember> {
  @override
  final int typeId = 0;

  @override
  ChatRoomMember read(BinaryReader reader) {
    return ChatRoomMember(
      userId: reader.readString(),
      nickname: reader.readString(),
      hasLeft: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoomMember obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.nickname);
    writer.writeBool(obj.hasLeft);
  }
}