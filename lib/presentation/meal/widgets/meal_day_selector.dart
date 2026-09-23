import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 이번 주 월~금을 고르는 줄.
///
/// 홈·캠퍼스 카드는 좌우로 넘겨 보지만 여기서는 눌러서 고른다. 한 화면에
/// 닷새가 다 보이면 어느 날이 급식을 하는지 한눈에 들어오고, 찾던 날로
/// 곧장 갈 수 있다.
class MealDaySelector extends StatelessWidget {
  final List<DailyMealEntity> weekMeals;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const MealDaySelector({
    super.key,
    required this.weekMeals,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Row(
      children: [
        for (var i = 0; i < weekMeals.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: _DayTile(
              meal: weekMeals[i],
              isSelected: i == selectedIndex,
              isToday: weekMeals[i].date == todayKey,
              onTap: () => onSelected(i),
            ),
          ),
        ],
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  final DailyMealEntity meal;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayTile({
    required this.meal,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final parsed = DateTime.tryParse(meal.date);
    final hasMenu = meal.koreanMenu.isNotEmpty || meal.specialMenu.isNotEmpty;

    final labelColor = isSelected
        ? ColorStyles.white
        : hasMenu
            ? ColorStyles.gray6
            // 급식이 없는 날은 고를 수는 있어도 뒤로 물러나 있다
            : ColorStyles.gray3;

    return Material(
      color: isSelected ? ColorStyles.primary100 : ColorStyles.gray7,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                meal.dayOfWeek,
                style: TextStyles.smallTextRegular.copyWith(color: labelColor),
              ),
              const SizedBox(height: 3),
              Text(
                parsed == null ? '-' : '${parsed.day}',
                style: TextStyles.normalTextBold.copyWith(color: labelColor),
              ),
              const SizedBox(height: 4),
              // 오늘 자리에만 점이 찍힌다. 날짜를 세지 않아도 오늘이 어디인지 안다
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !isToday
                      ? Colors.transparent
                      : isSelected
                          ? ColorStyles.white
                          : ColorStyles.primary100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
