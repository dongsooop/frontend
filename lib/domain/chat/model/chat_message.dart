import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
@JsonSerializable()
class ChatMessage with _$ChatMessage{
  final String messageId;
  final String roomId;
  final int senderId;
  final String content;
  final DateTime timestamp;
  final String type;

  ChatMessage({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 1; // 고유 typeId, 충돌 없도록 주의

  @override
  ChatMessage read(BinaryReader reader) {
    return ChatMessage(
      messageId: reader.readString(),
      roomId: reader.readString(),
      senderId: reader.readInt(),
      content: reader.readString(),
      timestamp: DateTime.parse(reader.readString()),
      type: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer.writeString(obj.messageId);
    writer.writeString(obj.roomId);
    writer.writeInt(obj.senderId);
    writer.writeString(obj.content);
    writer.writeString(obj.timestamp.toIso8601String());
    writer.writeString(obj.type);
  }
}