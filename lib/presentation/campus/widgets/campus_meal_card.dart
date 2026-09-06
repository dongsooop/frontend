import 'package:dongsoop/core/presentation/components/meal_menu_view.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 이번 주 학식.
///
/// 홈과 같은 조각(`MealDeck`)을 써서 같은 모양으로 읽히고 같이 좌우로
/// 넘어간다 — 대표 메뉴를 뽑지 않고, 그 주 내내 되풀이되는 밥·김치·요구르트만
/// 아래로 물린다. 날짜는 판 안에서 넘긴 장을 따라간다.
///
/// 다만 그릇은 홈과 다르다. 홈은 바로 위 오늘 카드와 겹치지 않으려고 면을
/// 걷어냈지만, 여기 이웃은 모두 회색 면을 가진 카드(맛집·도서관·챗봇)라
/// 혼자 면을 벗으면 그쪽에서 겉돈다.
class CampusMealCard extends ConsumerWidget {
  const CampusMealCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cafeteriaViewModelProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: BoxDecoration(
        color: ColorStyles.gray1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: state.when(
        data: (data) => MealDeck(
          weekMeals: data.weekMeals,
          staples: data.staples,
        ),
        loading: () => const MealSkeletonView(),
        error: (_, __) => const MealNoticeView('학식을 불러오지 못했어요'),
      ),
    );
  }
}
