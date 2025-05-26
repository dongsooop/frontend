class ValidateWriteUseCase {
  /// 시작 시간이 현재보다 미래인지 검사 (오늘이면 현재 이후)
  bool isValidStartTime(DateTime selected) {
    final now = DateTime.now();
    if (_isSameDay(selected, now)) {
      return selected.isAfter(now);
    }
    return true;
  }

  /// 마감일은 시작일보다 최소 하루(24시간) 이상 뒤여야 함
  bool isValidEndDateTime({
    required DateTime start,
    required DateTime end,
  }) {
    final diff = end.difference(start);
    return diff.inDays >= 1 || diff.inHours >= 24;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
