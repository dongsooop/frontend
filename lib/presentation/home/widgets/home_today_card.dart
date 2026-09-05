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

  const HomeTodayCard({super.key, required this.timeTable});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealIndex = useState(0);
    final meals = ref.watch(cafeteriaViewModelProvider).maybeWhen(
          data: (data) => data.weekMeals,
          orElse: () => const <DailyMealEntity>[],
        );

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
            SwipeDeck(
              itemCount: timeTable.isEmpty ? 1 : timeTable.length,
              itemBuilder: (context, index) => timeTable.isEmpty
                  ? const _TodayRow(
                      emoji: '📘',
                      background: ColorStyles.primary5,
                      title: '오늘은 수업이 없어요',
                    )
                  : _classRow(timeTable[index]),
              onTapItem: () => context.push(RoutePaths.timetable),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
            ),
            _MealHeader(meals: meals, index: mealIndex.value),
            SwipeDeck(
              itemCount: meals.isEmpty ? 1 : meals.length,
              onPageChanged: (index) => mealIndex.value = index,
              itemBuilder: (context, index) => meals.isEmpty
                  ? const _TodayRow(
                      emoji: '🍚',
                      background: ColorStyles.gray2,
                      title: '이번 주 학식 정보가 없어요',
                    )
                  : _TodayRow(
                      emoji: '🍚',
                      background: const Color(0xFFFFF6E0),
                      title: meals[index].koreanMenu,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _classRow(Slot slot) {
    return _TodayRow(
      emoji: '📘',
      background: ColorStyles.primary5,
      title: slot.title,
      description: '${slot.startAt} - ${slot.endAt}',
      showChevron: true,
    );
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
                  TextSpan(
                    text: ' · ',
                    style: TextStyle(color: ColorStyles.gray4),
                  ),
                  TextSpan(
                    text: label,
                    style: TextStyle(color: ColorStyles.gray6),
                  ),
                ],
              ],
            ),
          ),
    );
  }

  /// 서버가 `dayOfWeek` 를 함께 내려주므로 요일을 따로 계산하지 않는다.
  String? _dateLabel(int index) {
    if (meals.isEmpty) return null;
    final meal = meals[index.clamp(0, meals.length - 1)];

    final parsed = DateTime.tryParse(meal.date);
    if (parsed == null) return meal.date;

    return '${DateFormat('M월 d일', 'ko').format(parsed)}(${meal.dayOfWeek})';
  }
}

class _TodayRow extends StatelessWidget {
  final String emoji;
  final Color background;
  final String title;
  final String? description;
  final bool showChevron;

  const _TodayRow({
    required this.emoji,
    required this.background,
    required this.title,
    this.description,
    this.showChevron = false,
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
                    color: ColorStyles.gray7 == background
                        ? ColorStyles.gray4
                        : ColorStyles.black,
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
