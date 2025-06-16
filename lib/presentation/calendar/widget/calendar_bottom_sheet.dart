import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';
import 'package:dongsoop/presentation/calendar/common/type_ui_color.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CalendarBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final List<CalendarListEntity> events;
  final Future<bool?> Function(
      CalendarListEntity? event, DateTime selectedDate)? onTapCalendarDetail;

  const CalendarBottomSheet({
    super.key,
    required this.selectedDate,
    required this.events,
    this.onTapCalendarDetail,
  });

  String formatFullDate(DateTime date) {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final year = date.year;
    final month = date.month;
    final day = date.day;
    final weekday = weekdays[date.weekday % 7];
    return '$year년 $month월 $day일 ($weekday)';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatFullDate(selectedDate);

    final seen = <String>{};
    final filteredEvents = events.where((event) {
      final key =
          '${event.title}_${event.startAt}_${event.endAt}_${event.type}';
      if (seen.contains(key)) return false;
      seen.add(key);
      final target =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final start =
          DateTime(event.startAt.year, event.startAt.month, event.startAt.day);
      final end =
          DateTime(event.endAt.year, event.endAt.month, event.endAt.day);
      return !target.isBefore(start) && !target.isAfter(end);
    }).toList();

    filteredEvents.sort((a, b) {
      if (a.type == CalendarType.official && b.type != CalendarType.official) {
        return -1;
      } else if (a.type != CalendarType.official &&
          b.type == CalendarType.official) {
        return 1;
      } else {
        return a.startAt.compareTo(b.startAt);
      }
    });

    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  formattedDate,
                  style: TextStyles.titleTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  final isLast = index == filteredEvents.length - 1;

                  final start = event.startAt;
                  final end = event.endAt;

                  final isAllDay = start.hour == 0 &&
                      start.minute == 0 &&
                      end.hour == 23 &&
                      end.minute == 59;

                  final startHour = start.hour.toString().padLeft(2, '0');
                  final startMinute = start.minute.toString().padLeft(2, '0');
                  String endTimeText;
                  if (end.hour == 23 && end.minute == 59) {
                    endTimeText = '24:00';
                  } else {
                    final endHour = end.hour.toString().padLeft(2, '0');
                    final endMinute = end.minute.toString().padLeft(2, '0');
                    endTimeText = '$endHour:$endMinute';
                  }

                  return Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          final result = await onTapCalendarDetail?.call(
                              event, selectedDate);
                          if (result == true && context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 56,
                            maxWidth: double.infinity,
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    width: 72,
                                    child: isAllDay
                                        ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '하루 종일',
                                              style: TextStyles
                                                  .normalTextRegular
                                                  .copyWith(
                                                      color: ColorStyles.black),
                                            ),
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('$startHour:$startMinute',
                                                  style: TextStyles
                                                      .normalTextRegular
                                                      .copyWith(
                                                          color: ColorStyles
                                                              .black)),
                                              Text(endTimeText,
                                                  style: TextStyles
                                                      .normalTextRegular
                                                      .copyWith(
                                                          color: ColorStyles
                                                              .black)),
                                            ],
                                          ),
                                  ),
                                ),
                                Container(
                                  width: 4,
                                  height: double.infinity,
                                  margin: const EdgeInsets.only(right: 24),
                                  decoration: BoxDecoration(
                                    color: event.type.color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyles
                                                  .normalTextRegular
                                                  .copyWith(
                                                      color: ColorStyles.black),
                                            ),
                                            if (event.location.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.place_outlined,
                                                      size: 14,
                                                      color: ColorStyles.gray3,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        event.location,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyles
                                                            .smallTextRegular
                                                            .copyWith(
                                                                color:
                                                                    ColorStyles
                                                                        .black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        size: 24,
                                        color: ColorStyles.gray3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: ColorStyles.gray2,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  final result =
                      await onTapCalendarDetail?.call(null, selectedDate);
                  if (result == true && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  backgroundColor: ColorStyles.primary100,
                  foregroundColor: ColorStyles.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '일정 추가하기',
                  style: TextStyles.largeTextBold.copyWith(
                    color: ColorStyles.white,
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
