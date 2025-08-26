enum Semester {
  FIRST,
  SECOND,
  SUMMER,
  WINTER;

  String get label {
    switch (this) {
      case Semester.FIRST:
        return '1학기';
      case Semester.SECOND:
        return '2학기';
      case Semester.SUMMER:
        return '하계 계절학기';
      case Semester.WINTER:
        return '동계 계절학기';
    }
  }
}