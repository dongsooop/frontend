import 'package:dongsoop/core/presentation/components/meal_menu_view.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 이번 주 학식.
///
/// 홈과 완전히 같은 모양이다 — 같은 판(`MealDeck`)에 같은 그릇(`MealFrame`).
/// 두 화면에서 같은 것이 다르게 보일 이유가 없다.
///
/// 회색 카드를 벗겼다. 캠퍼스 생활 카드들과 나란히 두면 면이 하나 더 늘 뿐
/// 이었고, 그 카드들에 색을 넣으면서 회색 면이 오히려 겉돌았다.
class CampusMealCard extends ConsumerWidget {
  const CampusMealCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cafeteriaViewModelProvider);

    return state.when(
      data: (data) => MealDeck(
        weekMeals: data.weekMeals,
        staples: data.staples,
      ),
      loading: () => const MealFrame(muted: true, child: MealSkeletonView()),
      error: (_, __) => const MealFrame(
        muted: true,
        child: MealNoticeView('학식을 불러오지 못했어요'),
      ),
    );
  }
}
