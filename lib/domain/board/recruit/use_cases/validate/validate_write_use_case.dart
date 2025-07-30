class ValidateWriteUseCase {
  bool isValidStartTime(DateTime selected) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !selected.isBefore(today);
  }

  bool isValidEndDateTime({
    required DateTime start,
    required DateTime end,
  }) {
    final diff = end.difference(start);
    return diff >= const Duration(hours: 24) &&
        diff <= Duration(days: 27, hours: 23, minutes: 59);
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

  bool isWithinThreeMonths(DateTime selected) {
    final now = DateTime.now();
    final threeMonthsLater  = DateTime(now.year, now.month + 3, now.day)
        .subtract(const Duration(days: 1));

    final selectedDate = DateTime(selected.year, selected.month, selected.day);
    final limitDate = DateTime(threeMonthsLater.year, threeMonthsLater.month, threeMonthsLater.day);

    return selectedDate.isBefore(limitDate) ||
        selectedDate.isAtSameMomentAs(limitDate);
  }

  bool isWithinRecruitPeriod(DateTime start, DateTime end) {
    final diff = end.difference(start);
    return diff >= const Duration(hours: 24) &&
        diff <= const Duration(days: 27);
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

  bool isAfterToday(DateTime selected) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !selected.isBefore(today);
  }
}
