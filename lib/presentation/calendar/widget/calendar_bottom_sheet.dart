import 'package:dongsoop/presentation/calendar/calendar_detail_page_screen.dart';
import 'package:dongsoop/presentation/calendar/temp/temp_calendar_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final List<ScheduleEvent> events;

  const CalendarBottomSheet({
    super.key,
    required this.selectedDate,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(selectedDate);

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
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final isLast = index == events.length - 1;

                  final isAllDay = event.isAllDay;
                  final startHour = event.start.hour.toString().padLeft(2, '0');
                  final startMinute =
                      event.start.minute.toString().padLeft(2, '0');
                  final endHour = event.end.hour.toString().padLeft(2, '0');
                  final endMinute = event.end.minute.toString().padLeft(2, '0');

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CalendarDetailPageScreen(
                                selectedDate: selectedDate,
                                event: event,
                              ),
                            ),
                          );
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
                                              Text('',
                                                  style: TextStyles
                                                      .normalTextRegular),
                                              Text('$endHour:$endMinute',
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
                                    color: event.type == ScheduleType.school
                                        ? ColorStyles.primary100
                                        : ColorStyles.warning100,
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
                                            if (event.location != null &&
                                                event.location!.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.place_outlined,
                                                      size: 14,
                                                      color: ColorStyles.gray3,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        event.location!,
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
                                      Icon(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CalendarDetailPageScreen(
                        selectedDate: selectedDate,
                      ),
                    ),
                  );
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
