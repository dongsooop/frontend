enum SanctionType {
  WARNING,
  TEMPORARY_BAN,
  PERMANENT_BAN,
  CONTENT_DELETION;

  String get message {
    switch (this) {
      case SanctionType.WARNING: return '경고';
      case SanctionType.TEMPORARY_BAN: return '일시정지';
      case SanctionType.PERMANENT_BAN: return '영구정지';
      case SanctionType.CONTENT_DELETION: return '게시글 삭제';
    }
  }

  static SanctionType fromString(String value) {
    switch (value) {
      case 'WARNING': return SanctionType.WARNING;
      case 'TEMPORARY_BAN': return SanctionType.TEMPORARY_BAN;
      case 'PERMANENT_BAN': return SanctionType.PERMANENT_BAN;
      case 'CONTENT_DELETION': return SanctionType.CONTENT_DELETION;

      default: return SanctionType.WARNING;
    }
  }
}