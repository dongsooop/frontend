enum SanctionType {
  WARNING('경고'),
  TEMPORARY_BAN('일시정지'),
  PERMANENT_BAN('영구정지'),
  CONTENT_DELETION('게시글 삭제');

  final String type;
  const SanctionType(this.type);

  static SanctionType? fromApiValue(String value) {
    switch (value) {
      case 'WARNING':
        return SanctionType.WARNING;
      case 'TEMPORARY_BAN':
        return SanctionType.TEMPORARY_BAN;
      case 'PERMANENT_BAN':
        return SanctionType.PERMANENT_BAN;
      case 'CONTENT_DELETION':
        return SanctionType.CONTENT_DELETION;
    }
    return null;
  }
}