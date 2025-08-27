import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:dongsoop/presentation/timetable/widgets/time_column.dart';
import 'package:flutter/material.dart';

import 'day_background_column.dart';

typedef DayChildrenBuilder = List<Widget> Function(WeekDay day, double dayWidth);

class TimetableGrid extends StatelessWidget {
  const TimetableGrid({
    super.key,
    required this.columnLength,
    required this.firstRowHeight,
    required this.slotHeight,
    required this.dayChildrenBuilder,
  });

  final int columnLength;
  final double firstRowHeight;
  final double slotHeight;
  final DayChildrenBuilder dayChildrenBuilder;

  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width - 28;
    final dayWidth = totalWidth / 5;

    return Row(
      children: [
        TimeColumn(
          columnLength: columnLength,
          firstRowHeight: firstRowHeight,
          slotHeight: slotHeight,
        ),
        ...WeekDay.values.map((day) {
          final isFirst = day == WeekDay.values.first;
          return DayBackgroundColumn(
            day: day,
            columnLength: columnLength,
            firstRowHeight: firstRowHeight,
            slotHeight: slotHeight,
            showLeftDivider: true,
            children: dayChildrenBuilder(day, dayWidth),
          );
        }),
      ],
    );
  }
}