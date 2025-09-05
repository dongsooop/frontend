import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/presentation/calendar/providers/calendar_filter_provider.dart';
import 'package:dongsoop/presentation/calendar/util/calendar_date_utils.dart';
import 'package:dongsoop/presentation/calendar/util/calendar_utils.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CalendarBottomSheet extends ConsumerWidget {
  const CalendarBottomSheet({
    super.key,
    required this.selectedDate,
    this.onTapCalendarDetail,
  });

  final DateTime selectedDate;
  final Future<bool?> Function(CalendarListEntity? item, DateTime selectedDate)?
  onTapCalendarDetail;

  String _formatFullDate(DateTime date) {
    final weekdayLabel = weekdays[date.weekday % 7];
    return '${date.year}년 ${date.month}월 ${date.day}일 ($weekdayLabel)';
  }

  String _formatHHmm(DateTime dateTime) {
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mm = dateTime.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEvents = ref.watch(filterProvider);
    final dayEvents = (deduplicateEvents(eventsOnDay(allEvents, selectedDate))
      ..sort((a, b) {
        final s = a.startAt.compareTo(b.startAt);
        return s != 0 ? s : a.title.compareTo(b.title);
      }));

    final selectedDateText = _formatFullDate(selectedDate);

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
                  selectedDateText,
                  style: TextStyles.titleTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: dayEvents.length,
                itemBuilder: (context, index) {
                  final event = dayEvents[index];
                  final isLastItem = index == dayEvents.length - 1;

                  final titleText = event.title;
                  final locationText = event.location ?? '';

                  final startTimeText = _formatHHmm(event.startAt);
                  final endTimeText =
                  (event.endAt.hour == 23 && event.endAt.minute == 59)
                      ? '24:00'
                      : _formatHHmm(event.endAt);

                  return Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          await onTapCalendarDetail?.call(event, selectedDate);
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        startTimeText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyles.normalTextRegular.copyWith(
                                          color: ColorStyles.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        endTimeText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyles.normalTextRegular.copyWith(
                                          color: ColorStyles.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 4,
                                  height: double.infinity,
                                  margin: const EdgeInsets.symmetric(horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: ColorStyles.warning100,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),

                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              titleText,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyles.normalTextRegular.copyWith(
                                                color: ColorStyles.black,
                                              ),
                                            ),
                                            _buildLocationLine(locationText),
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

                      if (!isLastItem)
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
                  await onTapCalendarDetail?.call(null, selectedDate);
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

  Widget _buildLocationLine(String locationText) {
    if (locationText.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Icon(Icons.place_outlined, size: 14, color: ColorStyles.gray3),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              locationText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.smallTextRegular.copyWith(
                color: ColorStyles.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
