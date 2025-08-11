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
  final String blockStatus;

  ChatMessage({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.blockStatus,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  // 날짜 메시지 생성용
  factory ChatMessage.dateMessage(String roomId, DateTime date) {
    return ChatMessage(
      messageId: 'date-${date.toIso8601String()}',
      roomId: roomId,
      senderId: 0, // 시스템 메시지
      content: _formatDateText(date),
      timestamp: DateTime(date.year, date.month, date.day),
      type: 'DATE',
      blockStatus: 'NONE',
    );
  }

  static String _formatDateText(DateTime date) {
    // 예시: 2025년 6월 17일 화요일
    final weekday = ['월', '화', '수', '목', '금', '토', '일'][date.weekday - 1];
    return '${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일 $weekday요일';
  }
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 1;

  @override
  ChatMessage read(BinaryReader reader) {
    return ChatMessage(
      messageId: reader.readString(),
      roomId: reader.readString(),
      senderId: reader.readInt(),
      content: reader.readString(),
      timestamp: DateTime.parse(reader.readString()),
      type: reader.readString(),
      blockStatus: reader.readString(),
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
    writer.writeString(obj.blockStatus);
  }
}