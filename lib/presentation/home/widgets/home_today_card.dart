import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/presentation/home/widgets/home_today_row.dart';
import 'package:dongsoop/presentation/home/widgets/swipe_deck.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 오늘 챙길 것 한 장 — 수업과 일정.
///
/// `오늘` 제목과 `시간표 ›` 버튼은 두지 않는다. 각 칸이 그대로 링크이고
/// 우측 셰브런만 그 사실을 알린다. 제목 줄을 없애면 카드가 한 뼘 짧아진다.
///
/// 학식은 `HomeMealSection` 으로 따로 뺐다. 수업·일정은 내 것이고 학식은
/// 학교 것이라, 한 장에 묶으면 이 카드가 무슨 카드인지 흐려진다.
class HomeTodayCard extends StatelessWidget {
  final List<Slot> timeTable;
  final List<Schedule> schedule;
  final bool isLoggedOut;

  const HomeTodayCard({
    super.key,
    required this.timeTable,
    required this.schedule,
    required this.isLoggedOut,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorStyles.gray1,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isLoggedOut) ...[
              SwipeDeck(
                itemCount: timeTable.isEmpty ? 1 : timeTable.length,
                itemBuilder: (context, index) => timeTable.isEmpty
                    ? const HomeTodayRow(
                        emoji: '📘',
                        background: ColorStyles.primary5,
                        title: '오늘은 수업이 없어요',
                        isMuted: true,
                      )
                    : _classRow(timeTable[index]),
                onTapItem: () => context.push(RoutePaths.timetable),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                child:
                    Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
              ),
            ],
            _scheduleDeck(context),
          ],
        ),
      ),
    );
  }

  /// 오늘 일정. 비회원에게는 개인 일정이 없으므로 학사 일정만 남긴다.
  Widget _scheduleDeck(BuildContext context) {
    final items = isLoggedOut
        ? schedule.where((s) => s.type == ScheduleType.official).toList()
        : schedule;

    return SwipeDeck(
      itemCount: items.isEmpty ? 1 : items.length,
      itemBuilder: (context, index) => items.isEmpty
          ? HomeTodayRow(
              emoji: '🗓️',
              background: ColorStyles.mintBg,
              title: isLoggedOut ? '오늘 학사 일정이 없어요' : '오늘 일정이 없어요',
              isMuted: true,
            )
          : _scheduleRow(items[index]),
      onTapItem: () => context.push(RoutePaths.schedule),
    );
  }

  Widget _scheduleRow(Schedule item) {
    return HomeTodayRow(
      emoji: '🗓️',
      background: ColorStyles.mintBg,
      title: item.title,
      description: item.type == ScheduleType.official
          ? '학사'
          : formatHourMinute(item.startAt),
      showChevron: true,
    );
  }

  Widget _classRow(Slot slot) {
    return HomeTodayRow(
      emoji: '📘',
      background: ColorStyles.primary5,
      title: slot.title,
      description:
          '${formatHourMinute(slot.startAt)} - ${formatHourMinute(slot.endAt)}',
      showChevron: true,
    );
  }
}

/// 기존 HomeToday 에서 쓰던 서버 시간 표시 형식. 서버가 초까지 내려준다.
String formatHourMinute(String value) {
  final match =
      RegExp(r'^\s*(\d{1,2}):(\d{2})(?::\d{2})?\s*$').firstMatch(value);
  if (match == null) return value;
  return '${match.group(1)!.padLeft(2, '0')}:${match.group(2)!}';
}
