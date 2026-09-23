import 'package:dongsoop/domain/cafeteria/entities/meal_price_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 식권·단품 가격표.
///
/// 학교 식단 페이지에 없는 값이라 서버 설정 파일이 들고 있다. 날짜와 무관해
/// 요일을 바꿔도 이 자리는 그대로다 — 대신 요일 한정 메뉴에는 파는 요일을
/// 붙여 둔다.
class MealPriceSection extends StatelessWidget {
  final MealPriceEntity prices;

  /// 지금 보고 있는 요일(`월`~`금`). 그날 파는 메뉴를 앞세우는 데 쓴다.
  final String selectedDay;

  const MealPriceSection({
    super.key,
    required this.prices,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '전체 가격표',
          style: TextStyles.sectionTitleBold.copyWith(color: ColorStyles.black),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < prices.categories.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _CategoryCard(
            category: prices.categories[i],
            selectedDay: selectedDay,
          ),
        ],
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final MealPriceCategoryEntity category;
  final String selectedDay;

  const _CategoryCard({
    required this.category,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final items = _sortedItems();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        border: Border.all(color: ColorStyles.gray2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                category.name,
                style: TextStyles.largeTextRegular.copyWith(
                  color: ColorStyles.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (category.note != null) ...[
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    category.note!,
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray5,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, thickness: 1, color: ColorStyles.gray1),
            _PriceRow(item: items[i], selectedDay: selectedDay),
          ],
        ],
      ),
    );
  }

  /// 고른 요일에 파는 것을 위로 올린다.
  ///
  /// 요일 한정 메뉴를 감추지는 않는다. 수요일에 삼겹살덮밥이 있다는 걸
  /// 화요일에도 알 수 있어야 그날 다시 온다.
  List<MealPriceItemEntity> _sortedItems() {
    final sold = <MealPriceItemEntity>[];
    final others = <MealPriceItemEntity>[];

    for (final item in category.items) {
      if (item.isEveryday || item.days.contains(selectedDay)) {
        sold.add(item);
      } else {
        others.add(item);
      }
    }

    return [...sold, ...others];
  }
}

class _PriceRow extends StatelessWidget {
  final MealPriceItemEntity item;
  final String selectedDay;

  const _PriceRow({required this.item, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    // 오늘 안 파는 메뉴는 글자를 물린다. 목록에서 빼지 않는 대신 지금
    // 살 수 있는 것과 눈에 띄게 갈라 둔다
    final isSoldToday = item.isEveryday || item.days.contains(selectedDay);
    final textColor = isSoldToday ? ColorStyles.black : ColorStyles.gray5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  item.name,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: textColor,
                  ),
                ),
                if (!item.isEveryday)
                  _DayBadge(item.days.join('·'), active: isSoldToday),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatWon(item.price),
                style: TextStyles.normalTextBold.copyWith(color: textColor),
              ),
              if (item.largePrice != null)
                Text(
                  '곱빼기 ${formatWon(item.largePrice!)}',
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  final String label;

  /// 고른 요일에 파는 메뉴면 강조색, 아니면 회색.
  final bool active;

  const _DayBadge(this.label, {required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: active ? ColorStyles.primary5 : ColorStyles.gray1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyles.smallTextBold.copyWith(
          color: active ? ColorStyles.primary100 : ColorStyles.gray5,
        ),
      ),
    );
  }
}

String formatWon(int price) => '${NumberFormat('#,###').format(price)}원';
