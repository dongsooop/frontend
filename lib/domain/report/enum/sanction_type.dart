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

  static const List<SanctionType> messageReportValues = [
    WARNING,
    TEMPORARY_BAN,
    PERMANENT_BAN,
  ];

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

  String get description {
    switch (this) {
      case SanctionType.WARNING:
        return '경고를 누적하고 횟수에 따라 자동 정지를 적용합니다.';
      case SanctionType.TEMPORARY_BAN:
        return '선택한 시각까지 로그인을 제한합니다.';
      case SanctionType.PERMANENT_BAN:
        return '로그인을 영구적으로 제한합니다.';
      case SanctionType.CHAT_KICK:
        return '그룹 채팅방에서 추방하고 재입장을 제한합니다.';
    }
  }

  bool get requiresEndAt => this == SanctionType.TEMPORARY_BAN;

  bool get isAvailableForMessageReport => messageReportValues.contains(this);

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
