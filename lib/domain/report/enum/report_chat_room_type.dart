import 'package:freezed_annotation/freezed_annotation.dart';

enum ReportChatRoomType {
  @JsonValue('ONE_TO_ONE')
  ONE_TO_ONE,
  @JsonValue('GROUP')
  GROUP,
  @JsonValue('CONTACT')
  CONTACT,
  @JsonValue('BLINDDATE')
  BLINDDATE,
  UNKNOWN;

  String? get label {
    switch (this) {
      case ReportChatRoomType.ONE_TO_ONE:
        return '1:1 채팅';
      case ReportChatRoomType.GROUP:
        return '단체 채팅';
      case ReportChatRoomType.CONTACT:
        return '문의 채팅';
      case ReportChatRoomType.BLINDDATE:
        return '과팅';
      case ReportChatRoomType.UNKNOWN:
        return null;
    }
  }

  bool get allowsChatKick =>
      this == ReportChatRoomType.GROUP || this == ReportChatRoomType.BLINDDATE;
}
