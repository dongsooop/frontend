import 'package:dongsoop/core/presentation/components/meal_menu_view.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 홈의 학식 구획.
///
/// 오늘 카드에서 떼어 따로 세웠다. 수업·일정은 내 것이고 학식은 학교 것이라
/// 한 장에 묶으면 카드가 무슨 카드인지 흐려진다.
///
/// 캠퍼스 학식과 같은 판(`MealDeck`)에 같은 그릇(`MealFrame`)이다. 두 화면에서
/// 같은 것이 다르게 보일 이유가 없다.
class HomeMealSection extends ConsumerWidget {
  const HomeMealSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cafeteriaViewModelProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '학식',
            style: TextStyles.sectionTitleBold.copyWith(color: ColorStyles.black),
          ),
          const SizedBox(height: 12),
          state.when(
            // MealDeck 이 자기 그릇을 들고 있다. 오늘을 보고 있을 때만
            // 세로선이 켜져야 해서, 넘긴 장을 아는 쪽이 선도 그려야 한다
            data: (data) => MealDeck(
              weekMeals: data.weekMeals,
              staples: data.staples,
            ),
            loading: () => const MealFrame(
              muted: true,
              child: MealSkeletonView(),
            ),
            error: (_, __) => const MealFrame(
              muted: true,
              child: MealNoticeView('학식을 불러오지 못했어요'),
            ),
          ),
        ],
      ),
    );
  }
}
