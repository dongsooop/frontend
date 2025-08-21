import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'chat_room_detail.freezed.dart';
part 'chat_room_detail.g.dart';

@freezed
@JsonSerializable()
class ChatRoomDetail with _$ChatRoomDetail {
  final String roomId;
  final String title;
  final List<int> participants;
  final int? managerId;
  final bool groupChat;

  ChatRoomDetail({
    required this.roomId,
    required this.title,
    required this.participants,
    this.managerId,
    required this.groupChat,
  });

  factory ChatRoomDetail.fromJson(Map<String, dynamic> json) => _$ChatRoomDetailFromJson(json);
}

class ChatRoomDetailAdapter extends TypeAdapter<ChatRoomDetail> {
  @override
  final int typeId = 2;

  @override
  ChatRoomDetail read(BinaryReader reader) {
    final roomId = reader.readString();
    final title = reader.readString();
    final participants = reader.readIntList();


    final hasManagerId = reader.readBool();
    final int? managerId = hasManagerId ? reader.readInt() : null;

    final groupChat = reader.readBool();

    return ChatRoomDetail(
      roomId: roomId,
      title: title,
      participants: participants,
      managerId: managerId,
      groupChat: groupChat,
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoomDetail obj) {
    writer.writeString(obj.roomId);
    writer.writeString(obj.title);
    writer.writeIntList(obj.participants);

    final hasManagerId = obj.managerId != null;
    writer.writeBool(hasManagerId);
    if (hasManagerId) {
      writer.writeInt(obj.managerId!);
    }

    writer.writeBool(obj.groupChat);
  }
}