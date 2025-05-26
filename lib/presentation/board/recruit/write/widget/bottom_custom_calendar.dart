import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BottomCustomCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChanged;
  final bool Function(DateTime date) isDateEnabled;
  final bool Function(DateTime currentMonth) canMoveToPreviousMonth;
  final bool Function(DateTime month) canMoveToNextMonth;

  const BottomCustomCalendar(
      {super.key,
      required this.selectedDate,
      required this.currentMonth,
      required this.onDateSelected,
      required this.onMonthChanged,
      required this.isDateEnabled,
      required this.canMoveToPreviousMonth,
      required this.canMoveToNextMonth});

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);

    final daysBefore = firstDayOfMonth.weekday % 7;
    final daysAfter = 6 - (lastDayOfMonth.weekday % 7);
    final totalDays = lastDayOfMonth.day + daysBefore + daysAfter;
    final startDate = firstDayOfMonth.subtract(Duration(days: daysBefore));

    final calendarDays =
        List.generate(totalDays, (i) => startDate.add(Duration(days: i)));
    const weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthSelector(),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              _buildWeekDaysRow(weekDays),
              const SizedBox(height: 8),
              ..._buildCalendarRows(calendarDays),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final disablePrev = !canMoveToPreviousMonth(currentMonth);
    final disableNext = !canMoveToNextMonth(
      DateTime(currentMonth.year, currentMonth.month + 1),
    );

    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: disablePrev
                ? null
                : () => onMonthChanged(
                      DateTime(currentMonth.year, currentMonth.month - 1),
                    ),
          ),
          const SizedBox(width: 24),
          Text(
            '${currentMonth.year}년 ${currentMonth.month}월',
            style: TextStyles.largeTextBold,
          ),
          const SizedBox(width: 24),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: disableNext
                ? null
                : () => onMonthChanged(
                      DateTime(currentMonth.year, currentMonth.month + 1),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysRow(List<String> weekDays) {
    return Row(
      children: weekDays
          .map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  List<Widget> _buildCalendarRows(List<DateTime> calendarDays) {
    return List.generate((calendarDays.length / 7).ceil(), (weekIndex) {
      final week = calendarDays.skip(weekIndex * 7).take(7);
      return Row(
        children: week.map((date) {
          final isSelected = _isSameDay(date, selectedDate);
          final isCurrentMonth = date.month == currentMonth.month;
          final isEnabled = isDateEnabled(date);

          return Expanded(
            child: GestureDetector(
              onTap: isEnabled ? () => onDateSelected(date) : null,
              child: Container(
                height: 44,
                alignment: Alignment.center,
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? ColorStyles.primary100 : null,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyles.normalTextRegular.copyWith(
                      color: isCurrentMonth
                          ? (isEnabled
                              ? (isSelected
                                  ? ColorStyles.white
                                  : ColorStyles.black)
                              : Colors.black.withAlpha(128))
                          : ColorStyles.gray2,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
