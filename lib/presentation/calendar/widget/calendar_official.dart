import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/presentation/calendar/util/calendar_date_utils.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CalendarOfficialList extends StatelessWidget {
  const CalendarOfficialList({
    super.key,
    required this.events,
    required this.focusedMonth,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final List<CalendarListEntity> events;
  final DateTime focusedMonth;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final monthEvents = List<CalendarListEntity>.from(events)
      ..sort((event1, event2) {
        final startComparison = event1.startAt.compareTo(event2.startAt);
        if (startComparison != 0) return startComparison;
        final endComparison = event1.endAt.compareTo(event2.endAt);
        if (endComparison != 0) return endComparison;
        return event1.title.compareTo(event2.title);
      });

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity;
        if (velocity == null) return;
        if (velocity < 0) {
          onNextMonth();
        } else if (velocity > 0) {
          onPrevMonth();
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: ColorStyles.white,
            border: Border.all(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: monthEvents.map((event) {
              final hasRange = !isSameDay(event.startAt, event.endAt);
              final dateText = hasRange
                  ? '${formatDateWithWeekday(event.startAt)} ~ ${formatDateWithWeekday(event.endAt)}'
                  : formatDateWithWeekday(event.startAt);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 0,
                      child: Text(
                        dateText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        textAlign: TextAlign.left,
                        style: TextStyles.smallTextBold.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          event.title,
                          textAlign: TextAlign.right,
                          softWrap: true,
                          style: TextStyles.smallTextBold.copyWith(
                            color: ColorStyles.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
