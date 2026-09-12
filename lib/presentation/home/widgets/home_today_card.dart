import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 오늘 수업과 일정을 한 카드 안에서 바로 전환해 보는 영역.
class HomeTodayCard extends StatefulWidget {
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
  State<HomeTodayCard> createState() => _HomeTodayCardState();
}

class _HomeTodayCardState extends State<HomeTodayCard> {
  static const _accent = ColorStyles.primary100;
  static const _accentBackground = ColorStyles.primary5;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final scheduleItems = widget.isLoggedOut
        ? widget.schedule
            .where((item) => item.type == ScheduleType.official)
            .toList(growable: false)
        : widget.schedule;
    final isClassSelected = _selectedIndex == 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorStyles.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _accent.withValues(alpha: 0.11)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF21395C).withValues(alpha: 0.09),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 13, 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _accentBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: _accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '오늘의 캠퍼스',
                      style: TextStyles.largeTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(
                      isClassSelected
                          ? RoutePaths.timetable
                          : RoutePaths.schedule,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: ColorStyles.gray5,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 7,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '전체보기 ›',
                      style: TextStyles.smallTextBold.copyWith(
                        color: ColorStyles.gray5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                height: 46,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ColorStyles.gray7,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TodayTab(
                        label: '수업',
                        count:
                            widget.isLoggedOut ? null : widget.timeTable.length,
                        isSelected: isClassSelected,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _TodayTab(
                        label: '일정',
                        count: scheduleItems.length,
                        isSelected: !isClassSelected,
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: Padding(
                key: ValueKey(_selectedIndex),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                child: isClassSelected
                    ? _ClassContent(
                        items: widget.isLoggedOut ? const [] : widget.timeTable,
                        isLoggedOut: widget.isLoggedOut,
                      )
                    : _ScheduleContent(
                        items: scheduleItems,
                        isLoggedOut: widget.isLoggedOut,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayTab extends StatelessWidget {
  const _TodayTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? ColorStyles.white : Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyles.smallTextBold.copyWith(
                color: isSelected ? ColorStyles.primaryGray : ColorStyles.gray5,
                fontSize: 14,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                constraints: const BoxConstraints(minWidth: 20),
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isSelected ? ColorStyles.primary100 : ColorStyles.gray2,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '$count',
                  style: TextStyles.smallTextBold.copyWith(
                    color: isSelected ? ColorStyles.white : ColorStyles.gray6,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClassContent extends StatelessWidget {
  const _ClassContent({required this.items, required this.isLoggedOut});

  final List<Slot> items;
  final bool isLoggedOut;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(
        icon: isLoggedOut ? Icons.lock_outline_rounded : Icons.weekend_outlined,
        message: isLoggedOut ? '로그인하면 오늘 수업을 볼 수 있어요' : '오늘은 수업이 없어요',
      );
    }

    return Column(
      children: items
          .take(3)
          .map(
            (slot) => _TodayItem(
              badge: formatHourMinute(slot.startAt),
              title: slot.title,
              description:
                  '${formatHourMinute(slot.startAt)}–${formatHourMinute(slot.endAt)}',
            ),
          )
          .toList(growable: false),
    );
  }
}

class _ScheduleContent extends StatelessWidget {
  const _ScheduleContent({required this.items, required this.isLoggedOut});

  final List<Schedule> items;
  final bool isLoggedOut;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(
        icon: Icons.event_busy_outlined,
        message: isLoggedOut ? '오늘은 학사 일정이 없어요' : '오늘은 등록된 일정이 없어요',
      );
    }

    return Column(
      children: items
          .take(3)
          .map(
            (item) => _TodayItem(
              badge: item.type == ScheduleType.official
                  ? '학사'
                  : formatHourMinute(item.startAt),
              title: item.title,
              description: item.type == ScheduleType.official
                  ? '학사 일정'
                  : '${formatHourMinute(item.startAt)}–${formatHourMinute(item.endAt)}',
            ),
          )
          .toList(growable: false),
    );
  }
}

class _TodayItem extends StatelessWidget {
  const _TodayItem({
    required this.badge,
    required this.title,
    required this.description,
  });

  final String badge;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 54,
            child: Text(
              badge,
              style: TextStyles.smallTextBold.copyWith(
                color: ColorStyles.primaryGray,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.normalTextBold.copyWith(
                    color: ColorStyles.black,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray5,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 92,
      decoration: BoxDecoration(
        color: ColorStyles.primary5.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: ColorStyles.primary100),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.smallTextRegular.copyWith(
                color: ColorStyles.gray6,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 서버가 초까지 내려주는 시간을 카드용 시:분 형식으로 줄인다.
String formatHourMinute(String value) {
  final match =
      RegExp(r'^\s*(\d{1,2}):(\d{2})(?::\d{2})?\s*$').firstMatch(value);
  if (match == null) return value;
  return '${match.group(1)!.padLeft(2, '0')}:${match.group(2)!}';
}
