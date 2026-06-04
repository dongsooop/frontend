enum WeekDay {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY;

  String get korean {
    switch (this) {
      case WeekDay.MONDAY:
        return '월';
      case WeekDay.TUESDAY:
        return '화';
      case WeekDay.WEDNESDAY:
        return '수';
      case WeekDay.THURSDAY:
        return '목';
      case WeekDay.FRIDAY:
        return '금';
    }
  }
}