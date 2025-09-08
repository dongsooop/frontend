enum NoticeType { official, department}
typedef Slot    = ({String title, String startAt, String endAt});
typedef Notice  = ({String title, String link, NoticeType type});
typedef Recruit = ({String title, String content, List<String> tags});

class HomeEntity {
  final DateTime date;
  final List<Slot> timeTable;
  final List<Slot> calendar;
  final List<Notice> notices;
  final List<Recruit> popularRecruits;

  const HomeEntity({
    required this.date,
    this.timeTable = const [],
    this.calendar = const [],
    this.notices = const [],
    this.popularRecruits = const [],
  });
}
