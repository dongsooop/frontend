// full_calendar_screen.dart
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/calendar/temp/temp_calendar_data.dart';
import 'package:dongsoop/presentation/calendar/temp/temp_calendar_model.dart';
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

  void _goToPreviousMonth() => setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
      });

  void _goToNextMonth() => setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
      });

  DateTime getStartOfWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday % 7));

  List<ScheduleEvent> getEventsForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return tempCalendarData.where((event) {
      return !(event.end.isBefore(weekStart) || event.start.isAfter(weekEnd));
    }).toList();
  }

  List<ScheduleEvent> getEventsForDay(DateTime day) {
    final dayOnly = DateTime(day.year, day.month, day.day);
    return tempCalendarData.where((event) {
      final startDate =
          DateTime(event.start.year, event.start.month, event.start.day);
      final endDate = DateTime(event.end.year, event.end.month, event.end.day);
      return !dayOnly.isBefore(startDate) && !dayOnly.isAfter(endDate);
    }).toList();
  }

  Color _getTextColor(DateTime day) {
    if (day.weekday == DateTime.saturday) return ColorStyles.primary100;
    if (day.weekday == DateTime.sunday) return ColorStyles.warning100;
    return ColorStyles.black;
  }

  Widget _buildWeekRow(DateTime weekStart) {
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final events = getEventsForWeek(weekStart);

    final List<List<ScheduleEvent>> layeredRows = [];

    for (final event in events) {
      bool placed = false;
      for (final row in layeredRows) {
        if (row.every(
            (e) => e.end.isBefore(event.start) || e.start.isAfter(event.end))) {
          row.add(event);
          placed = true;
          break;
        }
      }
      if (!placed) layeredRows.add([event]);
    }

    final maxVisible = 3;
    final visibleRows = layeredRows.take(maxVisible).toList();

    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: days
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyles.smallTextRegular.copyWith(
                            color: day.month != _focusedDay.month
                                ? ColorStyles.gray3
                                : _getTextColor(day),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 2),
          ...visibleRows.map((row) {
            return Row(
              children: List.generate(7, (index) {
                final day = days[index];
                final dayOnly = DateTime(day.year, day.month, day.day);
                final event = row.firstWhere(
                  (e) {
                    final start =
                        DateTime(e.start.year, e.start.month, e.start.day);
                    final end = DateTime(e.end.year, e.end.month, e.end.day);
                    return !dayOnly.isBefore(start) && !dayOnly.isAfter(end);
                  },
                  orElse: () => ScheduleEvent(
                    title: '',
                    start: DateTime(_focusedDay.year),
                    end: DateTime(_focusedDay.year),
                    isAllDay: true,
                    type: ScheduleType.personal,
                  ),
                );

                if (event.title.isEmpty)
                  return const Expanded(child: SizedBox());
                if (!dayOnly.isAtSameMomentAs(DateTime(
                    event.start.year, event.start.month, event.start.day)))
                  return const SizedBox.shrink();

                final spanEnd =
                    event.end.isAfter(days.last) ? days.last : event.end;
                final spanLength = spanEnd.difference(day).inDays + 1;

                return Expanded(
                  flex: spanLength,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: event.type == ScheduleType.school
                          ? ColorStyles.primary100
                          : ColorStyles.warning100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      event.title,
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }),
            );
          }),
          Row(
            children: List.generate(7, (index) {
              final day = days[index];
              final eventsForDay = getEventsForDay(day);
              if (eventsForDay.length > maxVisible) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '+${eventsForDay.length - maxVisible}개',
                      style: TextStyles.smallTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return const Expanded(child: SizedBox());
            }),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks() {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final start = getStartOfWeek(firstDay);
    return List.generate(
        6, (i) => _buildWeekRow(start.add(Duration(days: i * 7))));
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: DetailHeader(title: '캘린더'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed:
                            _focusedDay.month == 1 ? null : _goToPreviousMonth,
                        icon: const Icon(Icons.chevron_left, size: 24),
                        color: _focusedDay.month == 1
                            ? Colors.transparent
                            : ColorStyles.black,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      Text('${_focusedDay.year}년 ${_focusedDay.month}월',
                          style: TextStyles.largeTextBold
                              .copyWith(color: ColorStyles.black)),
                      IconButton(
                        onPressed:
                            _focusedDay.month == 12 ? null : _goToNextMonth,
                        icon: const Icon(Icons.chevron_right, size: 24),
                        color: _focusedDay.month == 12
                            ? Colors.transparent
                            : ColorStyles.black,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
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
                              .map((day) => Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyles.smallTextRegular,
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
          ],
        ),
      ),
    );
  }
}
