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
        return '여름학기';
      case Semester.WINTER:
        return '겨울학기';
    }
  }
}
