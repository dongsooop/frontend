import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 오늘의 학식 한 장.
///
/// 날짜는 구획 제목 옆에 이미 붙으므로 카드 안에는 메뉴만 둔다.
/// 어떤 메뉴가 앞에 올지 데이터가 보장하지 않아 대표 메뉴를 따로 뽑지 않고
/// 전부 같은 무게로 나열한다.
class CampusMealCard extends ConsumerWidget {
  const CampusMealCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cafeteriaViewModelProvider);

    final menu = state.when(
      data: (data) {
        final menu = data.todayMeal?.koreanMenu;
        return menu?.isNotEmpty == true ? menu! : '오늘은 학식이 제공되지 않아요';
      },
      loading: () => '학식을 불러오는 중...',
      error: (_, __) => '학식을 불러오지 못했어요',
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColorStyles.gray1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🍚', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              menu,
              style: TextStyles.normalTextBold.copyWith(
                color: state.hasValue ? ColorStyles.gray6 : ColorStyles.gray4,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
