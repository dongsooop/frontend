import 'package:freezed_annotation/freezed_annotation.dart';

enum SanctionType {
  @JsonValue('WARNING')
  WARNING,
  @JsonValue('TEMPORARY_BAN')
  TEMPORARY_BAN,
  @JsonValue('PERMANENT_BAN')
  PERMANENT_BAN,
  @JsonValue('CHAT_KICK')
  CHAT_KICK;

  String get message {
    switch (this) {
      case SanctionType.WARNING:
        return '경고';
      case SanctionType.TEMPORARY_BAN:
        return '일시정지';
      case SanctionType.PERMANENT_BAN:
        return '영구정지';
      case SanctionType.CHAT_KICK:
        return '채팅방 추방';
    }
  }

  static SanctionType? tryFromString(String value) {
    switch (value) {
      case 'WARNING':
        return SanctionType.WARNING;
      case 'TEMPORARY_BAN':
        return SanctionType.TEMPORARY_BAN;
      case 'PERMANENT_BAN':
        return SanctionType.PERMANENT_BAN;
      case 'CHAT_KICK':
        return SanctionType.CHAT_KICK;
      default:
        return null;
    }
  }
}
