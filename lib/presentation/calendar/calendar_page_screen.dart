import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';
import 'package:dongsoop/presentation/calendar/common/type_ui_color.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_view_model.dart';
import 'package:dongsoop/presentation/calendar/widget/calendar_bottom_sheet.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CalendarPageScreen extends HookConsumerWidget {
  final Future<bool?> Function(
      CalendarListEntity? event, DateTime selectedDate)? onTapCalendarDetail;

  const CalendarPageScreen({super.key, this.onTapCalendarDetail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final now = DateTime.now();
    final focusedDay = useState<DateTime>(now);
    final selectedDay = useState<DateTime>(now);

    final calendarAsync = ref.watch(
      calendarViewModelProvider(user!.id, focusedDay.value),
    );

    // 이전 달로 이동
    void goToPreviousMonth() => focusedDay.value =
        DateTime(focusedDay.value.year, focusedDay.value.month - 1);

    // 다음 달로 이동
    void goToNextMonth() => focusedDay.value =
        DateTime(focusedDay.value.year, focusedDay.value.month + 1);

    // 해당 날짜가 속한 주의 시작 날짜 계산
    DateTime getStartOfWeek(DateTime date) =>
        date.subtract(Duration(days: date.weekday % 7));

    // 요일 텍스트 색상 지정
    Color _getTextColor(DateTime day) {
      if (day.weekday == DateTime.saturday) return ColorStyles.primary100;
      if (day.weekday == DateTime.sunday) return ColorStyles.warning100;
      return ColorStyles.black;
    }

    // 주 단위 UI 생성
    Widget buildWeekRow(BuildContext context, DateTime weekStart,
        List<CalendarListEntity> events) {
      final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
      final calendarWidth = MediaQuery.of(context).size.width - 32;

      final weekEvents = events.where((event) {
        final start = event.startAt;
        final end = event.endAt;
        return !(end.isBefore(weekStart) ||
            start.isAfter(weekStart.add(const Duration(days: 7))));
      }).toList();

      final seen = <String>{};
      final dedupedEvents = weekEvents.where((e) {
        final key = '${e.title}_${e.startAt}_${e.endAt}';
        if (seen.contains(key)) return false;
        seen.add(key);
        return true;
      }).toList();

      final officialEvents =
          dedupedEvents.where((e) => e.type == CalendarType.official).toList();
      final otherEvents =
          dedupedEvents.where((e) => e.type != CalendarType.official).toList();

      final Set<int> officialDays = {};
      for (final event in officialEvents) {
        final start = DateTime(
            event.startAt.year, event.startAt.month, event.startAt.day);
        final end =
            DateTime(event.endAt.year, event.endAt.month, event.endAt.day);
        for (var i = 0; i < 7; i++) {
          final day = days[i];
          if (!day.isBefore(start) && !day.isAfter(end)) {
            officialDays.add(i);
          }
        }
      }

      // 학사일정 우선 정렬, 그 외는 시작시간 순
      otherEvents.sort((a, b) => a.startAt.compareTo(b.startAt));

      List<List<bool>> rowOccupancy = [];
      List<Widget> eventWidgets = [];
      List<int> hiddenCountByDay = List.filled(7, 0);

      // 일정 위젯 배치 처리
      for (final event in otherEvents) {
        final startDate = DateTime(
            event.startAt.year, event.startAt.month, event.startAt.day);
        final endDate =
            DateTime(event.endAt.year, event.endAt.month, event.endAt.day);

        int startIndex = days.indexWhere((d) => !d.isBefore(startDate));
        int endIndex = days.lastIndexWhere((d) => !d.isAfter(endDate));
        if (startIndex == -1 || endIndex == -1) continue;

        // 배치 가능한 줄 찾기
        int row = -1;
        for (int i = 0; i < rowOccupancy.length; i++) {
          bool canPlace = true;
          for (int j = startIndex; j <= endIndex; j++) {
            if (rowOccupancy[i][j]) {
              canPlace = false;
              break;
            }
          }
          if (canPlace) {
            row = i;
            break;
          }
        }

        // 새로운 줄이 필요한 경우
        if (row == -1) {
          if (rowOccupancy.length >= 3) {
            for (int i = startIndex; i <= endIndex; i++) {
              hiddenCountByDay[i]++;
            }
            continue;
          }
          row = rowOccupancy.length;
          rowOccupancy.add(List.filled(7, false));
        }

        for (int j = startIndex; j <= endIndex; j++) {
          rowOccupancy[row][j] = true;
        }

        // 해당 월이 아닌 이벤트 위젯
        final firstDayOfMonth =
            DateTime(focusedDay.value.year, focusedDay.value.month, 1);
        final lastDayOfMonth =
            DateTime(focusedDay.value.year, focusedDay.value.month + 1, 0);

        final isOutOfMonth = event.endAt.isBefore(firstDayOfMonth) ||
            event.startAt.isAfter(lastDayOfMonth);

        // 이벤트 표시 위젯 추가
        eventWidgets.add(
          Positioned(
            top: 24.0 + row * 22.0,
            left: (startIndex / 7) * calendarWidth,
            width: ((endIndex - startIndex + 1) / 7) * calendarWidth - 4,
            child: Opacity(
              opacity: isOutOfMonth ? 0.4 : 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: event.type.color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  event.title,
                  style: TextStyles.smallTextRegular
                      .copyWith(color: ColorStyles.white),
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
        if (hiddenCountByDay[i] > 0) {
          eventWidgets.add(
            Positioned(
              top: 24.0 + 3 * 25.0,
              left: (i / 7) * calendarWidth,
              width: calendarWidth / 7,
              child: Center(
                child: Text(
                  '+${hiddenCountByDay[i]}',
                  style: TextStyles.smallTextRegular
                      .copyWith(color: ColorStyles.gray3),
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
            Row(
              children: days.asMap().entries.map((entry) {
                final i = entry.key;
                final day = entry.value;
                final isToday = DateTime.now().year == day.year &&
                    DateTime.now().month == day.month &&
                    DateTime.now().day == day.day;
                final isSelected = selectedDay.value.year == day.year &&
                    selectedDay.value.month == day.month &&
                    selectedDay.value.day == day.day;

                final backgroundColor = isToday ? ColorStyles.gray1 : null;
                final border = isSelected
                    ? Border.all(color: ColorStyles.black, width: 1.5)
                    : null;

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: border,
                    ),
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      children: [
                        Text(
                          '${day.day}',
                          style: TextStyles.smallTextRegular.copyWith(
                            color: day.month != weekStart.month
                                ? ColorStyles.gray3
                                : _getTextColor(day),
                          ),
                        ),
                        if (officialDays.contains(i))
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: ColorStyles.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            ...eventWidgets,
            Row(
              children: days.map((day) {
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      selectedDay.value = day;
                      final target = DateTime(day.year, day.month, day.day);
                      final selectedEvents = events.where((event) {
                        final start = DateTime(event.startAt.year,
                            event.startAt.month, event.startAt.day);
                        final end = DateTime(event.endAt.year,
                            event.endAt.month, event.endAt.day);
                        return !target.isBefore(start) && !target.isAfter(end);
                      }).toList();

                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => CalendarBottomSheet(
                          selectedDate: day,
                          events: selectedEvents,
                          onTapCalendarDetail: onTapCalendarDetail,
                        ),
                      );

                      if (result == true) {
                        ref.invalidate(calendarViewModelProvider(
                            user.id, focusedDay.value));
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

    // 한 달 기준 주차 리스트 생성
    List<Widget> buildWeeks(List<CalendarListEntity> events) {
      final firstDay =
          DateTime(focusedDay.value.year, focusedDay.value.month, 1);
      final lastDay =
          DateTime(focusedDay.value.year, focusedDay.value.month + 1, 0);
      final start = getStartOfWeek(firstDay);
      final end = getStartOfWeek(lastDay.add(const Duration(days: 7)));

      final weeks = <Widget>[];
      DateTime current = start;
      while (current.isBefore(end)) {
        weeks.add(buildWeekRow(context, current, events));
        current = current.add(const Duration(days: 7));
      }
      return weeks;
    }

    final weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(title: '일정 관리'),
      body: SafeArea(
        child: calendarAsync.when(
          data: (events) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${focusedDay.value.year}년 ${focusedDay.value.month}월',
                        style: TextStyles.smallTextBold
                            .copyWith(color: ColorStyles.primaryColor)),
                    const SizedBox(height: 4),
                    Text('캘린더',
                        style: TextStyles.titleTextBold
                            .copyWith(color: ColorStyles.black)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null) {
                      if (details.primaryVelocity! < 0) {
                        goToNextMonth();
                      } else if (details.primaryVelocity! > 0) {
                        goToPreviousMonth();
                      }
                    }
                  },
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
                                  .asMap()
                                  .entries
                                  .map((entry) => Expanded(
                                        child: Center(
                                          child: Text(
                                            entry.value,
                                            style: TextStyles.smallTextRegular
                                                .copyWith(
                                              color: entry.key == 0
                                                  ? ColorStyles.warning100
                                                  : entry.key == 6
                                                      ? ColorStyles.primary100
                                                      : ColorStyles.black,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          ...buildWeeks(events),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => SizedBox.expand(
            child: Center(
              child: Text(
                '$e',
                textAlign: TextAlign.center,
                style: TextStyles.normalTextRegular
                    .copyWith(color: ColorStyles.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
