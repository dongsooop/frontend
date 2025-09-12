import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

enum NoticeType {official, department}
enum CalendarType {official, member}
typedef Slot    = ({String title, String startAt, String endAt});
typedef Calendar = ({String title, String startAt, String endAt, CalendarType type});
typedef Notice  = ({String title, String link, NoticeType type});
typedef Recruit = ({
    int id,
    String title,
    String content,
    String tags,
    int volunteer,
    RecruitType type,
});

class HomeEntity {
  final List<Slot> timeTable;
  final List<Calendar> calendar;
  final List<Notice> notices;
  final List<Recruit> popularRecruits;

  const HomeEntity({
    this.timeTable = const [],
    this.calendar = const [],
    this.notices = const [],
    this.popularRecruits = const [],
  });
}
