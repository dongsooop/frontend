import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BottomCustomCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChanged;

  const BottomCustomCalendar({
    super.key,
    required this.selectedDate,
    required this.currentMonth,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);

    final firstWeekday = firstDayOfMonth.weekday % 7;
    final lastWeekday = lastDayOfMonth.weekday % 7;

    final daysBefore = firstWeekday; // 첫 주에 표시할 이전 달 날짜 수
    final daysAfter = 6 - lastWeekday; // 마지막 주에 표시할 다음 달 날짜 수

    // 전체 날짜 목록
    final totalDays = lastDayOfMonth.day + daysBefore + daysAfter;

    final startDate = firstDayOfMonth.subtract(Duration(days: daysBefore));

    List<DateTime> calendarDays = List.generate(
        totalDays, (index) => startDate.add(Duration(days: index)));

    final weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: canGoToPrevMonth(today)
                  ? () => onMonthChanged(
                      DateTime(currentMonth.year, currentMonth.month - 1))
                  : null,
            ),
            Text(
              '${currentMonth.year}년 ${currentMonth.month}월',
              style: TextStyles.largeTextBold,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => onMonthChanged(
                  DateTime(currentMonth.year, currentMonth.month + 1)),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
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
              ),
              const SizedBox(height: 8),
              Column(
                children: List.generate((calendarDays.length / 7).ceil(),
                    (weekIndex) {
                  final week = calendarDays.skip(weekIndex * 7).take(7);
                  return Row(
                    children: week.map((date) {
                      final isSelected = isSameDay(date, selectedDate);
                      final isPast = date.isBefore(
                          DateTime(today.year, today.month, today.day));
                      final isCurrentMonth = date.month == currentMonth.month;

                      return Expanded(
                        child: GestureDetector(
                          onTap: !isPast ? () => onDateSelected(date) : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? ColorStyles.primary100 : null,
                            ),
                            child: Text(
                              '${date.day}',
                              style: TextStyles.smallTextRegular.copyWith(
                                color: isCurrentMonth
                                    ? (isPast
                                        ? ColorStyles.gray2
                                        : isSelected
                                            ? ColorStyles.white
                                            : ColorStyles.black)
                                    : ColorStyles.gray2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool canGoToPrevMonth(DateTime today) {
    final current = DateTime(today.year, today.month);
    final compare = DateTime(currentMonth.year, currentMonth.month);
    return compare.isAfter(current);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
