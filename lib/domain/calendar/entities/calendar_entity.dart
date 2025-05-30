class CalendarEntity {
  final int id;
  final String title;
  final String location;
  final DateTime startAt;
  final DateTime endAt;
  final String type;

  const CalendarEntity(
      {required this.id,
      required this.title,
      required this.location,
      required this.startAt,
      required this.endAt,
      required this.type});
}
