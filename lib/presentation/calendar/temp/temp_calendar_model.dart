// 모델 파일이지만 백엔드와 연동시 삭제 예정이라 temp 폴더에 작성
enum ScheduleType { school, personal }

class ScheduleEvent {
  final String title;
  final DateTime start;
  final DateTime end;
  final bool isAllDay;
  final ScheduleType type;

  ScheduleEvent({
    required this.title,
    required this.start,
    required this.end,
    required this.isAllDay,
    required this.type,
  });
}
