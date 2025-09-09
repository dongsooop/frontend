enum NoticeType {official, department}
typedef Slot    = ({String title, String startAt, String endAt});
typedef Notice  = ({String title, String link, NoticeType type});
typedef Recruit = ({String title, String content, String tags, int volunteer});

class HomeEntity {
  final List<Slot> timeTable;
  final List<Slot> calendar;
  final List<Notice> notices;
  final List<Recruit> popularRecruits;

  const HomeEntity({
    this.timeTable = const [],
    this.calendar = const [],
    this.notices = const [],
    this.popularRecruits = const [],
  });
}
