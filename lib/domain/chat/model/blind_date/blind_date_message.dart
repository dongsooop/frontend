import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_date_message.freezed.dart';
part 'blind_date_message.g.dart';

@freezed
@JsonSerializable()
class BlindDateMessage with _$BlindDateMessage{
  final String message;
  final int memberId;
  final String name;
  final DateTime sendAt;
  @Default('SYSTEM') String type;

  BlindDateMessage({
    required this.message,
    required this.memberId,
    required this.name,
    required this.sendAt,
    required this.type,
  });

  factory BlindDateMessage.fromJson(Map<String, dynamic> json) => _$BlindDateMessageFromJson(json);

  Map<String, dynamic> toJson() => _$BlindDateMessageToJson(this);


  factory BlindDateMessage.fromSystemJson(Map<String, dynamic> json) {
    return BlindDateMessage(
      message: json['message'] as String? ?? '',
      memberId: (json['memberId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'SYSTEM',
      sendAt: DateTime.parse(json['sendAt'] as String),
      type: 'SYSTEM',
    );
  }

  // user payload -> USER
  factory BlindDateMessage.fromUserJson(Map<String, dynamic> json) {
    return BlindDateMessage(
      message: json['message'] as String? ?? '',
      memberId: (json['memberId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '익명',
      sendAt: DateTime.parse(json['sendAt'] as String),
      type: 'USER',
    );
  }
}