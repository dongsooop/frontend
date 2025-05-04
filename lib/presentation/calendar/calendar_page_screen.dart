import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/calendar/temp/temp_calendar_data.dart';
import 'package:dongsoop/presentation/calendar/temp/temp_calendar_model.dart';
import 'package:dongsoop/presentation/calendar/widget/calendar_bottom_sheet.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CalendarPageScreen extends StatefulWidget {
  const CalendarPageScreen({super.key});

  @override
  State<CalendarPageScreen> createState() => _CalendarPageScreenState();
}

class _CalendarPageScreenState extends State<CalendarPageScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // 이전 달로 이동
  void _goToPreviousMonth() => setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
      });

  // 다음 달로 이동
  void _goToNextMonth() => setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
      });

  // 해당 날짜가 속한 주의 시작 날짜 계산
  DateTime getStartOfWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday % 7));

  // 주간 일정 필터링
  List<ScheduleEvent> getEventsForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return tempCalendarData.where((event) {
      return !(event.end.isBefore(weekStart) || event.start.isAfter(weekEnd));
    }).toList();
  }

  // 요일 텍스트 색상 지정
  Color _getTextColor(DateTime day) {
    if (day.weekday == DateTime.saturday) return ColorStyles.primary100;
    if (day.weekday == DateTime.sunday) return ColorStyles.warning100;
    return ColorStyles.black;
  }

  // 주 단위 UI 생성
  Widget _buildWeekRow(DateTime weekStart) {
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final weekEvents = getEventsForWeek(weekStart);

    // 학사일정 우선 정렬, 그 외는 시작시간 순
    weekEvents.sort((a, b) {
      if (a.type == ScheduleType.school && b.type != ScheduleType.school)
        return -1;
      if (a.type != ScheduleType.school && b.type == ScheduleType.school)
        return 1;
      return a.start.compareTo(b.start);
    });

    final calendarWidth = MediaQuery.of(context).size.width - 32;
    List<List<bool>> rowOccupancy = [];
    List<Widget> eventWidgets = [];
    List<int> hiddenCountByDay = List.filled(7, 0);

    // 일정 위젯 배치 처리
    for (final event in weekEvents) {
      final startDate =
          DateTime(event.start.year, event.start.month, event.start.day);
      final endDate = DateTime(event.end.year, event.end.month, event.end.day);

      int startIndex = days.indexWhere((d) => !d.isBefore(startDate));
      int endIndex = days.lastIndexWhere((d) => !d.isAfter(endDate));
      if (startIndex == -1 || endIndex == -1) continue;

      // 배치 가능한 줄 찾기
      int row = -1;
      for (int i = 0; i < rowOccupancy.length; i++) {
        bool canPlace = true;
        for (int j = startIndex; j <= endIndex; j++) {
          if (rowOccupancy[i][j]) {
            canPlace = false;
            break;
          }
        }
        if (canPlace) {
          row = i;
          break;
        }
      }

      // 새로운 줄이 필요한 경우
      if (row == -1) {
        if (rowOccupancy.length >= 3) {
          for (int i = startIndex; i <= endIndex; i++) {
            hiddenCountByDay[i]++;
          }
          continue;
        }
        row = rowOccupancy.length;
        rowOccupancy.add(List.filled(7, false));
      }

      for (int j = startIndex; j <= endIndex; j++) {
        rowOccupancy[row][j] = true;
      }

      // 해당 월이 아닌 이벤트 위젯
      final isOutOfMonth = event.start.month != _focusedDay.month;

      // 이벤트 표시 위젯 추가
      eventWidgets.add(
        Positioned(
          top: 24.0 + row * 22.0,
          left: (startIndex / 7) * calendarWidth,
          width: ((endIndex - startIndex + 1) / 7) * calendarWidth - 4,
          child: Opacity(
            opacity: isOutOfMonth ? 0.4 : 1.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: event.type == ScheduleType.school
                    ? ColorStyles.primary100
                    : ColorStyles.warning100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                event.title,
                style: TextStyles.smallTextRegular
                    .copyWith(color: ColorStyles.white),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ),
          ),
        ),
      );
    }

    // +N 표시
    for (int i = 0; i < 7; i++) {
      if (hiddenCountByDay[i] > 0) {
        eventWidgets.add(
          Positioned(
            top: 24.0 + 3 * 25.0,
            left: (i / 7) * calendarWidth,
            width: calendarWidth / 7,
            child: Center(
              child: Text(
                '+${hiddenCountByDay[i]}',
                style: TextStyles.smallTextRegular
                    .copyWith(color: ColorStyles.gray3),
              ),
            ),
          ),
        );
      }
    }

    // 날짜 셀 UI 구성
    final dayCells = days.map((day) {
      final isToday = DateTime.now().year == day.year &&
          DateTime.now().month == day.month &&
          DateTime.now().day == day.day;
      final isSelected = _selectedDay.year == day.year &&
          _selectedDay.month == day.month &&
          _selectedDay.day == day.day;

      final backgroundColor = isToday ? ColorStyles.gray1 : null;
      final border =
          isSelected ? Border.all(color: ColorStyles.black, width: 1.5) : null;

      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() => _selectedDay = day);

            final selectedEvents = tempCalendarData.where((event) {
              final start = DateTime(
                  event.start.year, event.start.month, event.start.day);
              final end =
                  DateTime(event.end.year, event.end.month, event.end.day);
              final target = DateTime(day.year, day.month, day.day);

              return !target.isBefore(start) && !target.isAfter(end);
            }).toList();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => CalendarBottomSheet(
                selectedDate: day,
                events: selectedEvents,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${day.day}',
              style: TextStyles.smallTextRegular.copyWith(
                color: day.month != _focusedDay.month
                    ? ColorStyles.gray3
                    : _getTextColor(day),
              ),
            ),
          ),
        ),
      );
    }).toList();

    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Row(children: dayCells),
          ...eventWidgets,
        ],
      ),
    );
  }

  // 한 달 기준 주차 리스트 생성
  List<Widget> _buildWeeks() {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final start = getStartOfWeek(firstDay);
    final end = getStartOfWeek(lastDay.add(const Duration(days: 7)));

    final weeks = <Widget>[];
    DateTime current = start;
    while (current.isBefore(end)) {
      weeks.add(_buildWeekRow(current));
      current = current.add(const Duration(days: 7));
    }
    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(title: '일정 관리'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_focusedDay.year}년 ${_focusedDay.month}월',
                      style: TextStyles.smallTextBold
                          .copyWith(color: ColorStyles.primaryColor)),
                  const SizedBox(height: 4),
                  Text('캘린더',
                      style: TextStyles.titleTextBold
                          .copyWith(color: ColorStyles.black)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! < 0) {
                      _goToNextMonth();
                    } else if (details.primaryVelocity! > 0) {
                      _goToPreviousMonth();
                    }
                  }
                },
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorStyles.gray2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 44,
                          child: Row(
                            children: weekDays
                                .asMap()
                                .entries
                                .map((entry) => Expanded(
                                      child: Center(
                                        child: Text(
                                          entry.value,
                                          style: TextStyles.smallTextRegular
                                              .copyWith(
                                            color: entry.key == 0
                                                ? ColorStyles.warning100
                                                : entry.key == 6
                                                    ? ColorStyles.primary100
                                                    : ColorStyles.black,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        ..._buildWeeks(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
