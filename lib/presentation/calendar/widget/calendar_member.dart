import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/presentation/calendar/util/calendar_utils.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/presentation/calendar/util/calendar_date_utils.dart';
import 'package:dongsoop/presentation/calendar/widget/calendar_bottom_sheet.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

Color weekdayColor(DateTime day) {
  if (day.weekday == DateTime.saturday) return ColorStyles.primary100;
  if (day.weekday == DateTime.sunday) return ColorStyles.warning100;
  return ColorStyles.black;
}

class CalendarMemberView extends StatefulWidget {
  const CalendarMemberView({
    super.key,
    required this.focusedMonth,
    required this.items,
    required this.onPrevMonth,
    required this.onNextMonth,
    this.onTapCalendarDetail,
    this.onRefresh,
  });

  final DateTime focusedMonth;
  final List<CalendarListEntity> items;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final Future<bool?> Function(CalendarListEntity? event, DateTime selectedDate)?
  onTapCalendarDetail;
  final Future<void> Function()? onRefresh;

  @override
  State<CalendarMemberView> createState() => _CalendarMemberViewState();
}

class _CalendarMemberViewState extends State<CalendarMemberView> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedMonth;
    _selectedDay = DateTime.now();
  }

  @override
  void didUpdateWidget(covariant CalendarMemberView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusedMonth != widget.focusedMonth) {
      _focusedDay = widget.focusedMonth;
    }
  }

  Widget _buildWeekRow(BuildContext context, DateTime weekStart) {
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final calendarWidth = MediaQuery.of(context).size.width - 32;

    final weekEvents = eventsInWeek(widget.items, weekStart);
    final uniqueWeekEvents = deduplicateEvents(weekEvents);

    final layout = layoutWeekEvents(
      daysInWeek: days,
      weekEvents: uniqueWeekEvents,
      focusedMonth: _focusedDay,
      maxRows: 3,
    );

    final positioned = <Widget>[];
    const eventColor = ColorStyles.warning100;

    for (final p in layout.placements) {
      positioned.add(
        Positioned(
          top: 24.0 + p.rowIndex * 22.0,
          left: (p.startDayIndex / 7) * calendarWidth,
          width: ((p.endDayIndex - p.startDayIndex + 1) / 7) * calendarWidth - 4,
          child: Opacity(
            opacity: p.isOutOfMonth ? 0.4 : 1.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: eventColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                p.event.title,
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.white,
                ),
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
      final hidden = layout.hiddenCount[i];
      if (hidden > 0) {
        positioned.add(
          Positioned(
            top: 24.0 + 3 * 25.0,
            left: (i / 7) * calendarWidth,
            width: calendarWidth / 7,
            child: Center(
              child: Text(
                '+$hidden',
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray3,
                ),
              ),
            ),
          ),
        );
      }
    }

    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          // 날짜 헤더 행
          Row(
            children: days.map((day) {
              final isToday = isSameDay(DateTime.now(), day);
              final isSelected = isSameDay(_selectedDay, day);

              final bg = isToday ? ColorStyles.gray1 : null;
              final border =
              isSelected ? Border.all(color: ColorStyles.black, width: 1.5) : null;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: bg, border: border),
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${day.day}',
                    style: TextStyles.smallTextRegular.copyWith(
                      // 해당 월 판정은 _focusedDay 기준
                      color: day.month != _focusedDay.month
                          ? ColorStyles.gray3
                          : weekdayColor(day),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // 이벤트 막대
          ...positioned,

          // 탭 영역
          Row(
            children: days.map((day) {
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    setState(() => _selectedDay = day);

                    final dayEvents = eventsOnDay(widget.items, day);

                    final result = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) => CalendarBottomSheet(
                        selectedDate: day,
                        items: dayEvents,
                        onTapCalendarDetail: widget.onTapCalendarDetail,
                      ),
                    );

                    if (result == true) {
                      await widget.onRefresh?.call();
                    }
                  },
                  child: const SizedBox.expand(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks() =>
      weekStartsInMonth(_focusedDay)
          .map((ws) => _buildWeekRow(context, ws))
          .toList();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity;
        if (velocity == null) return;
        if (velocity < 0) {
          widget.onNextMonth();
        } else if (velocity > 0) {
          widget.onPrevMonth();
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  children: weekdays.asMap().entries.map((e) {
                    final color = e.key == 0
                        ? ColorStyles.warning100
                        : e.key == 6
                        ? ColorStyles.primary100
                        : ColorStyles.black;
                    return Expanded(
                      child: Center(
                        child: Text(
                          e.value,
                          style: TextStyles.smallTextRegular.copyWith(color: color),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              ..._buildWeeks(),
            ],
          ),
        ),
      ),
    );
  }
}
