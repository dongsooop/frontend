import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_date_message.freezed.dart';
part 'blind_date_message.g.dart';

@freezed
@JsonSerializable()
class BlindDateMessage with _$BlindDateMessage {
  final String message;
  final int memberId;
  final String name;
  final DateTime sendAt;
  @Default('SYSTEM')
  String type;

  BlindDateMessage({
    required this.message,
    required this.memberId,
    required this.name,
    required this.sendAt,
    required this.type,
  });

  factory BlindDateMessage.fromJson(Map<String, dynamic> json) =>
      _$BlindDateMessageFromJson(json);

  Map<String, dynamic> toJson() => _$BlindDateMessageToJson(this);

  factory BlindDateMessage.fromSystemJson(Map<String, dynamic> json) {
    return BlindDateMessage(
      message: _parseMessage(json['message']),
      memberId: (json['senderId'] as num?)?.toInt() ?? 0,
      name: json['senderName'] as String? ?? 'SYSTEM',
      sendAt: _parseTimestamp(json['timestamp']),
      type: 'SYSTEM',
    );
  }

  // user payload -> USER
  factory BlindDateMessage.fromUserJson(Map<String, dynamic> json) {
    return BlindDateMessage(
      message: _parseMessage(json['message']),
      memberId: (json['senderId'] as num?)?.toInt() ?? 0,
      name: json['senderName'] as String? ?? '익명',
      sendAt: _parseTimestamp(json['timestamp']),
      type: 'USER',
    );
  }

  static String _parseMessage(Object? value) {
    return (value?.toString() ?? '')
        .replaceAll(r'\r\n', '\n')
        .replaceAll(r'\n', '\n');
  }

  static DateTime _parseTimestamp(Object? value) {
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }

    if (value is String) {
      final milliseconds = int.tryParse(value);
      if (milliseconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(milliseconds);
      }

      final dateTime = DateTime.tryParse(value);
      if (dateTime != null) return dateTime;
    }

    throw FormatException('Invalid blind-date timestamp: $value');
  }
}
