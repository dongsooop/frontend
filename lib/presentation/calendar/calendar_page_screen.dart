import 'package:dongsoop/presentation/calendar/temp/temp_calendar_data.dart';
import 'package:dongsoop/presentation/calendar/temp/temp_calendar_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPageScreen extends StatefulWidget {
  const CalendarPageScreen({super.key});

  @override
  State<CalendarPageScreen> createState() => _CalendarPageScreenState();
}

class _CalendarPageScreenState extends State<CalendarPageScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _goToPreviousMonth() => setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
      });

  void _goToNextMonth() => setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
      });

  List<ScheduleEvent> getEventsForDay(DateTime day) {
    return tempCalendarData.where((event) {
      final start =
          DateTime(event.start.year, event.start.month, event.start.day);
      final end = DateTime(event.end.year, event.end.month, event.end.day);
      final selected = DateTime(day.year, day.month, day.day);

      return selected.isAtSameMomentAs(start) ||
          (selected.isAfter(start) && selected.isBefore(end)) ||
          selected.isAtSameMomentAs(end);
    }).toList();
  }

  Color _getTextColor(DateTime day) {
    if (day.weekday == DateTime.saturday) return ColorStyles.primary100;
    if (day.weekday == DateTime.sunday) return ColorStyles.warning100;
    return ColorStyles.black;
  }

  Widget _buildDayBox({
    required DateTime day,
    required Color textColor,
    Color? backgroundColor,
    BoxBorder? border,
  }) {
    final events = getEventsForDay(day);

    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          Text(
            '${day.day}',
            style: TextStyles.smallTextRegular.copyWith(color: textColor),
          ),
          const SizedBox(height: 8),
          ...events.take(3).map((event) {
            final duration = event.end.difference(event.start).inDays + 1;
            final bgColor = event.type == ScheduleType.school
                ? ColorStyles.primary100
                : ColorStyles.warning100;

            return Row(
              children: [
                Expanded(
                  flex: duration,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      event.title,
                      style: TextStyles.smallTextRegular
                          .copyWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          }),
          if (events.length > 3)
            Text(
              '+${events.length - 3}',
              style: TextStyles.smallTextRegular
                  .copyWith(color: ColorStyles.gray3),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            backgroundColor: ColorStyles.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateTime.now().year}년',
                    style: TextStyles.smallTextBold
                        .copyWith(color: ColorStyles.primaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text('캘린더',
                      style: TextStyles.titleTextBold
                          .copyWith(color: ColorStyles.black)),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
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
                  Text('${_focusedDay.month}월',
                      style: TextStyles.largeTextBold
                          .copyWith(color: ColorStyles.black)),
                  IconButton(
                    onPressed: _focusedDay.month == 12 ? null : _goToNextMonth,
                    icon: const Icon(Icons.chevron_right, size: 24),
                    color: _focusedDay.month == 12
                        ? Colors.transparent
                        : ColorStyles.black,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorStyles.gray2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TableCalendar(
                    eventLoader: getEventsForDay,
                    rowHeight: 120,
                    daysOfWeekHeight: 44,
                    focusedDay: _focusedDay,
                    firstDay: DateTime(_focusedDay.year - 1, 12, 1),
                    lastDay: DateTime(_focusedDay.year + 1, 1, 31),
                    locale: 'ko-KR',
                    headerVisible: false,
                    onDaySelected: _onDaySelected,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDate, day),
                    calendarStyle: const CalendarStyle(
                      markerSize: 0,
                      markersAlignment: Alignment.bottomCenter,
                      markerDecoration: BoxDecoration(),
                    ),
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        final text = [
                          '일',
                          '월',
                          '화',
                          '수',
                          '목',
                          '금',
                          '토'
                        ][day.weekday % 7];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              text,
                              style: TextStyles.smallTextRegular
                                  .copyWith(color: _getTextColor(day)),
                            ),
                          ),
                        );
                      },
                      todayBuilder: (context, day, _) => _buildDayBox(
                        day: day,
                        textColor: _getTextColor(day),
                        backgroundColor: ColorStyles.gray1,
                      ),
                      selectedBuilder: (context, day, _) => _buildDayBox(
                        day: day,
                        textColor: _getTextColor(day),
                        border: Border.all(color: ColorStyles.black),
                        backgroundColor: isSameDay(day, DateTime.now())
                            ? ColorStyles.gray1
                            : null,
                      ),
                      outsideBuilder: (context, day, _) => _buildDayBox(
                        day: day,
                        textColor: ColorStyles.gray3,
                      ),
                      defaultBuilder: (context, day, _) => _buildDayBox(
                        day: day,
                        textColor: _getTextColor(day),
                      ),
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
