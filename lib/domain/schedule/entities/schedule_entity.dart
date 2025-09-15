class ScheduleEntity {
  final int? id;
  final String title;
  final String location;
  final DateTime startAt;
  final DateTime endAt;

  const ScheduleEntity(
      {this.id,
      required this.title,
      this.location = "",
      required this.startAt,
      required this.endAt,
    });
}
