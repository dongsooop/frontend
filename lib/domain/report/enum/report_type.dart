import 'package:freezed_annotation/freezed_annotation.dart';

enum ReportType {
  @JsonValue('CHAT_MESSAGE')
  CHAT_MESSAGE,
  @JsonValue('BLINDDATE_MESSAGE')
  BLINDDATE_MESSAGE,
  UNKNOWN;

  String get message {
    switch (this) {
      case ReportType.CHAT_MESSAGE:
        return '채팅 메시지';
      case ReportType.BLINDDATE_MESSAGE:
        return '과팅 메시지';
      case ReportType.UNKNOWN:
        return '알 수 없는 신고';
    }
  }

  static ReportType fromString(String value) {
    switch (value) {
      case 'CHAT_MESSAGE':
        return ReportType.CHAT_MESSAGE;
      case 'BLINDDATE_MESSAGE':
        return ReportType.BLINDDATE_MESSAGE;
      default:
        return ReportType.UNKNOWN;
    }
  }
}
