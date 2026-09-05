import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/presentation/home/widgets/home_today_row.dart';
import 'package:dongsoop/presentation/home/widgets/swipe_deck.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// 홈의 학식 구획.
///
/// 오늘 카드에서 떼어내 따로 세웠다. 수업·일정은 내 것이고 학식은 학교 것이라
/// 한 장에 묶으면 카드가 무슨 카드인지 흐려진다.
///
/// 제목의 날짜는 넘긴 쪽을 따라 바뀌므로 구획 안에서 상태를 들고 있는다.
class HomeMealSection extends HookConsumerWidget {
  const HomeMealSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cafeteriaState = ref.watch(cafeteriaViewModelProvider);
    final meals = cafeteriaState.maybeWhen(
      data: (data) => data.weekMeals,
      orElse: () => const <DailyMealEntity>[],
    );

    final todayIndex = _findTodayIndex(meals);
    final index = useState(todayIndex);

    useEffect(() {
      index.value = todayIndex;
      return null;
    }, [meals]);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(_dateLabel(meals, index.value)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: ColorStyles.gray1,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: cafeteriaState.when(
              data: (_) => SwipeDeck(
                itemCount: meals.isEmpty ? 1 : meals.length,
                initialPage: index.value,
                onPageChanged: (page) => index.value = page,
                itemBuilder: (context, page) => meals.isEmpty
                    ? const HomeTodayRow(
                        emoji: '🍚',
                        background: ColorStyles.gray2,
                        title: '이번 주 학식 정보가 없어요',
                        isMuted: true,
                      )
                    : HomeTodayRow(
                        emoji: '🍚',
                        background: ColorStyles.amberBg,
                        title: meals[page].koreanMenu,
                      ),
              ),
              loading: () => const SizedBox(
                height: 68,
                child: HomeTodayRow(
                  emoji: '🍚',
                  background: ColorStyles.gray2,
                  title: '학식을 불러오는 중...',
                  isMuted: true,
                ),
              ),
              error: (_, __) => const SizedBox(
                height: 68,
                child: HomeTodayRow(
                  emoji: '🍚',
                  background: ColorStyles.gray2,
                  title: '학식을 불러오지 못했어요',
                  isMuted: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 다른 구획 제목과 같은 크기로 두고, 날짜만 중점 뒤에 흐리게 붙인다.
  Widget _title(String? label) {
    final style = TextStyles.largeTextBold.copyWith(color: ColorStyles.black);

    if (label == null) return Text('학식', style: style);

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          const TextSpan(text: '학식'),
          const TextSpan(text: ' · ', style: TextStyle(color: ColorStyles.gray4)),
          TextSpan(text: label, style: const TextStyle(color: ColorStyles.gray6)),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  int _findTodayIndex(List<DailyMealEntity> meals) {
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

  /// 메뉴가 없는 날은 서버 요일이 비어 있으므로 날짜에서 직접 구한다.
  String? _dateLabel(List<DailyMealEntity> meals, int index) {
    if (meals.isEmpty) return null;
    final meal = meals[index.clamp(0, meals.length - 1)];

    final parsed = DateTime.tryParse(meal.date);
    if (parsed == null) return meal.date;

    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday =
        meal.dayOfWeek.isNotEmpty ? meal.dayOfWeek : weekdays[parsed.weekday - 1];
    return '${DateFormat('M월 d일', 'ko').format(parsed)}($weekday)';
  }
}
