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
/// 캠퍼스 학식과 같은 조각(`MealDeck`)을 써서 같은 모양으로 읽히고 같이
/// 좌우로 넘어간다. 다른 것은 그릇뿐이다 — 여기는 채운 면 대신 왼쪽 세로선을
/// 쓴다. 바로 위 오늘 카드가 이미 둥근 회색 면이라, 학식까지 면을 깔면 색만
/// 다른 같은 덩어리 둘이 붙어 있게 된다.
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
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          const SizedBox(height: 12),
          state.when(
            data: (data) => _MealFrame(
              child: MealDeck(
                weekMeals: data.weekMeals,
                staples: data.staples,
              ),
            ),
            loading: () => const _MealFrame(
              muted: true,
              child: MealSkeletonView(),
            ),
            error: (_, __) => const _MealFrame(
              muted: true,
              child: MealNoticeView('학식을 불러오지 못했어요'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 왼쪽 세로선 + 본문.
///
/// 선은 회색이다. 오늘 카드와 갈라 보이려고 한때 따뜻한 색을 썼는데, 갈라
/// 주는 건 색이 아니라 면을 쓰지 않는다는 사실이라 색이 할 일이 없다.
class _MealFrame extends StatelessWidget {
  final Widget child;

  /// 보여줄 메뉴가 없는 상태에서는 선도 함께 물러난다
  final bool muted;

  const _MealFrame({required this.child, this.muted = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 3,
            decoration: BoxDecoration(
              color: muted ? ColorStyles.gray1 : ColorStyles.gray2,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(child: child),
        ],
      ),
    );
  }
}
