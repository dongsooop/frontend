import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/presentation/home/widgets/swipe_deck.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// 오늘 챙길 것 한 장 — 수업과 학식.
///
/// `오늘` 제목과 `시간표 ›` 버튼은 두지 않는다. 수업 칸 자체가 시간표로 가는 링크이고
/// 우측 셰브런만 그 사실을 알린다. 제목 줄을 없애면 카드가 한 뼘 짧아진다.
class HomeTodayCard extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final cafeteriaState = ref.watch(cafeteriaViewModelProvider);
    final meals = cafeteriaState.maybeWhen(
      data: (data) => data.weekMeals,
      orElse: () => const <DailyMealEntity>[],
    );
    final todayMealIndex = _findTodayMealIndex(meals);
    final mealIndex = useState(todayMealIndex);

    useEffect(() {
      mealIndex.value = todayMealIndex;
      return null;
    }, [meals]);

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
                    ? const _TodayRow(
                        emoji: '📘',
                        background: ColorStyles.primary5,
                        title: '오늘은 수업이 없어요',
                        isMuted: true,
                      )
                    : _classRow(timeTable[index]),
                onTapItem: () => context.push(RoutePaths.timetable),
              ),
              _divider(),
            ],
            _scheduleDeck(context),
            _divider(),
            cafeteriaState.when(
              data: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MealHeader(meals: meals, index: mealIndex.value),
                  SwipeDeck(
                    itemCount: meals.isEmpty ? 1 : meals.length,
                    initialPage: mealIndex.value,
                    onPageChanged: (index) => mealIndex.value = index,
                    itemBuilder: (context, index) => meals.isEmpty
                        ? const _TodayRow(
                            emoji: '🍚',
                            background: ColorStyles.gray2,
                            title: '이번 주 학식 정보가 없어요',
                            isMuted: true,
                          )
                        : _TodayRow(
                            emoji: '🍚',
                            background: ColorStyles.amberBg,
                            title: meals[index].koreanMenu,
                          ),
                  ),
                ],
              ),
              loading: () => const _TodayRow(
                emoji: '🍚',
                background: ColorStyles.gray2,
                title: '학식을 불러오는 중...',
                isMuted: true,
              ),
              error: (_, __) => const _TodayRow(
                emoji: '🍚',
                background: ColorStyles.gray2,
                title: '학식을 불러오지 못했어요',
                isMuted: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
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
          ? _TodayRow(
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
    return _TodayRow(
      emoji: '🗓️',
      background: ColorStyles.mintBg,
      title: item.title,
      description: item.type == ScheduleType.official
          ? '학사'
          : _formatHourMinute(item.startAt),
      showChevron: true,
    );
  }

  int _findTodayMealIndex(List<DailyMealEntity> meals) {
    if (meals.isEmpty) return 0;

    final now = DateTime.now();
    final index = meals.indexWhere((meal) {
      final date = DateTime.tryParse(meal.date);
      if (date == null) return false;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    });

    return index >= 0 ? index : 0;
  }

  Widget _classRow(Slot slot) {
    return _TodayRow(
      emoji: '📘',
      background: ColorStyles.primary5,
      title: slot.title,
      description: '${_formatHourMinute(slot.startAt)} - ${_formatHourMinute(slot.endAt)}',
      showChevron: true,
    );
  }

  // 기존 HomeToday에서 사용하던 서버 시간 표시 형식.
  String _formatHourMinute(String value) {
    final match = RegExp(r'^\s*(\d{1,2}):(\d{2})(?::\d{2})?\s*$').firstMatch(value);
    if (match == null) return value;
    return '${match.group(1)!.padLeft(2, '0')}:${match.group(2)!}';
  }
}

/// 학식 제목. 넘긴 날짜를 따라 `학식 · 9월 5일(금)` 로 바뀐다.
class _MealHeader extends StatelessWidget {
  final List<DailyMealEntity> meals;
  final int index;

  const _MealHeader({required this.meals, required this.index});

  @override
  Widget build(BuildContext context) {
    final label = _dateLabel(index);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Text.rich(
        TextSpan(
          style: TextStyles.normalTextBold.copyWith(
            color: ColorStyles.black,
          ),
          children: [
            const TextSpan(text: '학식'),
            if (label != null) ...[
              const TextSpan(
                text: ' · ',
                style: TextStyle(color: ColorStyles.gray4),
              ),
              TextSpan(
                text: label,
                style: const TextStyle(color: ColorStyles.gray6),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 메뉴가 없는 날은 서버 요일이 비어 있으므로 기존 요일 표기를 사용한다.
  String? _dateLabel(int index) {
    if (meals.isEmpty) return null;
    final meal = meals[index.clamp(0, meals.length - 1)];

    final parsed = DateTime.tryParse(meal.date);
    if (parsed == null) return meal.date;

    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = meal.dayOfWeek.isNotEmpty
        ? meal.dayOfWeek
        : weekdays[parsed.weekday - 1];
    return '${DateFormat('M월 d일', 'ko').format(parsed)}($weekday)';
  }
}

class _TodayRow extends StatelessWidget {
  final String emoji;
  final Color background;
  final String title;
  final String? description;
  final bool showChevron;

  /// 비어 있음을 알리는 줄은 흐리게 둔다
  final bool isMuted;

  const _TodayRow({
    required this.emoji,
    required this.background,
    required this.title,
    this.description,
    this.showChevron = false,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 19)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.normalTextBold.copyWith(
                    color: isMuted ? ColorStyles.gray4 : ColorStyles.black,
                    height: 1.4,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    description!,
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray6,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: ColorStyles.gray4,
            ),
          ],
        ],
      ),
    );
  }
}
