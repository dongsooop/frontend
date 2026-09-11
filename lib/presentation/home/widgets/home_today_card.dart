import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 인사말 아래에서 오늘 수업과 일정을 좌우로 넘겨 보는 카드.
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
  static const _classColor = Color(0xFF2563EB);
  static const _classBackground = Color(0xFFF3F7FF);
  static const _scheduleColor = Color(0xFF0F8B78);
  static const _scheduleBackground = Color(0xFFF0FAF7);

  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.93);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleItems = widget.isLoggedOut
        ? widget.schedule
              .where((item) => item.type == ScheduleType.official)
              .toList(growable: false)
        : widget.schedule;

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 22),
      child: Column(
        children: [
          SizedBox(
            height: 190,
            child: PageView(
              controller: _controller,
              padEnds: false,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _TodayCard(
                    eyebrow: 'TODAY CLASS',
                    title: '오늘 수업',
                    count: widget.isLoggedOut ? null : widget.timeTable.length,
                    icon: Icons.auto_stories_rounded,
                    accent: _classColor,
                    background: _classBackground,
                    onTap: () => context.push(RoutePaths.timetable),
                    emptyIcon: widget.isLoggedOut
                        ? Icons.lock_outline_rounded
                        : Icons.weekend_outlined,
                    emptyMessage: widget.isLoggedOut
                        ? '로그인하면 오늘 수업을 볼 수 있어요'
                        : '오늘은 수업이 없어요',
                    items: widget.isLoggedOut
                        ? const []
                        : widget.timeTable
                              .take(3)
                              .map(
                                (slot) => _TodayItem(
                                  badge: formatHourMinute(slot.startAt),
                                  title: slot.title,
                                ),
                              )
                              .toList(growable: false),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _TodayCard(
                    eyebrow: 'TODAY SCHEDULE',
                    title: widget.isLoggedOut ? '학사 일정' : '오늘 일정',
                    count: scheduleItems.length,
                    icon: Icons.event_available_rounded,
                    accent: _scheduleColor,
                    background: _scheduleBackground,
                    onTap: () => context.push(RoutePaths.schedule),
                    emptyIcon: Icons.event_busy_outlined,
                    emptyMessage: widget.isLoggedOut
                        ? '오늘은 학사 일정이 없어요'
                        : '오늘은 등록된 일정이 없어요',
                    items: scheduleItems
                        .take(3)
                        .map(
                          (item) => _TodayItem(
                            badge: item.type == ScheduleType.official
                                ? '학사'
                                : formatHourMinute(item.startAt),
                            title: item.title,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  width: isActive ? 20 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: isActive
                        ? ColorStyles.primary100
                        : ColorStyles.gray2,
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.eyebrow,
    required this.title,
    required this.count,
    required this.icon,
    required this.accent,
    required this.background,
    required this.onTap,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.items,
  });

  final String eyebrow;
  final String title;
  final int? count;
  final IconData icon;
  final Color accent;
  final Color background;
  final VoidCallback onTap;
  final IconData emptyIcon;
  final String emptyMessage;
  final List<_TodayItem> items;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
          decoration: BoxDecoration(
            color: ColorStyles.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: accent.withValues(alpha: 0.13)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E293B).withValues(alpha: 0.07),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, size: 21, color: accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eyebrow,
                          style: TextStyles.smallTextBold.copyWith(
                            color: accent,
                            fontSize: 10,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              title,
                              style: TextStyles.largeTextBold.copyWith(
                                color: ColorStyles.black,
                              ),
                            ),
                            if (count != null && count! > 0) ...[
                              const SizedBox(width: 7),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: background,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '$count',
                                  style: TextStyles.smallTextBold.copyWith(
                                    color: accent,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: ColorStyles.gray7,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: ColorStyles.gray4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: items.isEmpty
                    ? _EmptyState(
                        icon: emptyIcon,
                        message: emptyMessage,
                        accent: accent,
                        background: background,
                      )
                    : Column(
                        children: items
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 54,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: background,
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: Text(
                                        item.badge,
                                        style: TextStyles.smallTextBold
                                            .copyWith(
                                              color: accent,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyles.normalTextRegular
                                            .copyWith(
                                              color: ColorStyles.black,
                                              fontSize: 14,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
    required this.accent,
    required this.background,
  });

  final IconData icon;
  final String message;
  final Color accent;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: accent.withValues(alpha: 0.75)),
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

class _TodayItem {
  const _TodayItem({required this.badge, required this.title});

  final String badge;
  final String title;
}

/// 서버가 초까지 내려주는 시간을 카드용 시:분 형식으로 줄인다.
String formatHourMinute(String value) {
  final match = RegExp(r'^\s*(\d{1,2}):(\d{2})(?::\d{2})?\s*$')
      .firstMatch(value);
  if (match == null) return value;
  return '${match.group(1)!.padLeft(2, '0')}:${match.group(2)!}';
}
