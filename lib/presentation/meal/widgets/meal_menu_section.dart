import 'package:dongsoop/domain/cafeteria/entities/meal_price_entity.dart';
import 'package:dongsoop/domain/cafeteria/meal_menu.dart';
import 'package:dongsoop/presentation/meal/widgets/meal_price_section.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

/// 하루치 한식 또는 단품 카드.
///
/// 되풀이 항목(`staples`)을 내리지 않는다. 그건 두세 줄만 보여줄 수 있는
/// 홈 카드의 사정이고, 여기서는 그날 나오는 것을 다 보여주는 게 맞다.
///
/// [priceOf] 가 있으면 항목마다 값을 오른쪽에 붙여 한 줄씩 세우고(단품),
/// 없으면 항목을 칩으로 흘려 놓는다(한식 — 값은 식권 한 장이라 제목 옆
/// [headerPrice] 하나로 충분하다).
class MealMenuSection extends StatelessWidget {
  final String title;
  final String menu;

  /// 메뉴가 없을 때 대신 적을 말. 한식과 단품이 서로 다른 말을 쓴다.
  final String emptyMessage;

  final int? headerPrice;

  /// 메뉴 이름으로 가격표 항목을 찾는다. 가격표에 없는 이름이면 null 이다.
  final MealPriceItemEntity? Function(String name)? priceOf;

  const MealMenuSection({
    super.key,
    required this.title,
    required this.menu,
    required this.emptyMessage,
    this.headerPrice,
    this.priceOf,
  });

  @override
  Widget build(BuildContext context) {
    final items = splitMealMenu(menu);
    final priceOf = this.priceOf;

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
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.normalTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
              ),
              if (headerPrice != null)
                Text(
                  formatWon(headerPrice!),
                  style: TextStyles.normalTextBold.copyWith(
                    color: ColorStyles.primary100,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Text(
              emptyMessage,
              style: TextStyles.smallTextRegular.copyWith(
                color: ColorStyles.gray4,
              ),
            )
          else if (priceOf == null)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final item in items) _MenuChip(item)],
            )
          else
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: ColorStyles.gray1,
                  ),
                ),
              _PricedLine(name: items[i], price: priceOf(items[i])),
            ],
        ],
      ),
    );
  }
}

class _MenuChip extends StatelessWidget {
  final String name;

  const _MenuChip(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorStyles.gray7,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black),
      ),
    );
  }
}

class _PricedLine extends StatelessWidget {
  final String name;
  final MealPriceItemEntity? price;

  const _PricedLine({required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    final price = this.price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
        ),
        if (price != null) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatWon(price.price),
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              if (price.largePrice != null)
                Text(
                  '곱빼기 ${formatWon(price.largePrice!)}',
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
