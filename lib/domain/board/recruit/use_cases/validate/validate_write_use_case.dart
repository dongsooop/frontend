class ValidateWriteUseCase {
  bool isValidStartTime(DateTime selected) {
    final now = DateTime.now();
    if (_isSameDay(selected, now)) {
      return selected.isAfter(now);
    }
    return true;
  }

  bool isValidEndDateTime({
    required DateTime start,
    required DateTime end,
  }) {
    final diff = end.difference(start);
    return diff.inDays >= 1 || diff.inHours >= 24;
  }

  bool isValidTitle(String title) {
    final trimmed = title.trim();
    return trimmed.isNotEmpty && trimmed.length <= 20;
  }

  bool isValidContent(String content) {
    final trimmed = content.trim();
    return trimmed.isNotEmpty && trimmed.length <= 600;
  }

  bool isValidRecruitType(int? selectedIndex) {
    return selectedIndex != null;
  }

  bool isValidTags(List<String> tags) {
    return tags.length <= 3 && tags.every((t) => t.length <= 8);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isFormValid({
    required int? selectedIndex,
    required String title,
    required String content,
  }) {
    return isValidRecruitType(selectedIndex) &&
        isValidTitle(title) &&
        isValidContent(content);
  }
}
