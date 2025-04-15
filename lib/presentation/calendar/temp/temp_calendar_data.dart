import 'package:dongsoop/presentation/calendar/temp/temp_calendar_model.dart';

final List<ScheduleEvent> tempCalendarData = [
  ScheduleEvent(
    title: '1차 강의평가',
    start: DateTime.parse('2025-04-01'),
    end: DateTime.parse('2025-04-07'),
    isAllDay: true,
    type: ScheduleType.school,
  ),
  ScheduleEvent(
    title: '학기개시 후 30일차',
    start: DateTime.parse('2025-04-02'),
    end: DateTime.parse('2025-04-02'),
    isAllDay: true,
    type: ScheduleType.school,
  ),
  ScheduleEvent(
    title: '등록금 분할납부(3회차)',
    start: DateTime.parse('2025-04-16'),
    end: DateTime.parse('2025-04-17'),
    isAllDay: true,
    type: ScheduleType.school,
  ),
  ScheduleEvent(
    title: '중간고사',
    start: DateTime.parse('2025-04-22'),
    end: DateTime.parse('2025-04-28'),
    isAllDay: true,
    type: ScheduleType.school,
  ),
  ScheduleEvent(
    title: '밥약속',
    start: DateTime.parse('2025-04-16T12:30:00'),
    end: DateTime.parse('2025-04-16T13:30:00'),
    isAllDay: false,
    type: ScheduleType.personal,
  ),
  ScheduleEvent(
    title: '프로젝트 회의',
    start: DateTime.parse('2025-04-16T09:00:00'),
    end: DateTime.parse('2025-04-16T12:00:00'),
    isAllDay: false,
    type: ScheduleType.personal,
  ),
  ScheduleEvent(
    title: '점심 약속',
    start: DateTime.parse('2025-04-16T12:00:00'),
    end: DateTime.parse('2025-04-16T13:00:00'),
    isAllDay: false,
    type: ScheduleType.personal,
  ),
  ScheduleEvent(
    title: 'DB 프로그래밍 과제',
    start: DateTime.parse('2025-04-16T13:00:00'),
    end: DateTime.parse('2025-04-16T15:00:00'),
    isAllDay: false,
    type: ScheduleType.personal,
  ),
  ScheduleEvent(
    title: '저녁 약속',
    start: DateTime.parse('2025-04-16T19:00:00'),
    end: DateTime.parse('2025-04-16T20:00:00'),
    isAllDay: false,
    type: ScheduleType.personal,
  ),
  ScheduleEvent(
    title: '술약속',
    start: DateTime.parse('2025-04-16T20:00:00'),
    end: DateTime.parse('2025-04-16T23:30:00'),
    isAllDay: false,
    type: ScheduleType.personal,
  ),
];
