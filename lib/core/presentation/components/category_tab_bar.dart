import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CategoryTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback? onWriteTab;
  final isBoard;

  const CategoryTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    this.onWriteTab,
    required this.isBoard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(
            color: ColorStyles.primaryGray.withValues(alpha: 0.16),
            blurRadius: 10,
            offset: Offset(0, 4)
          ),
        ],
      ),
      child: Row(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 카테고리
          Row(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(tabs.length, (i) {
              final isSelected = selectedIndex == i;
              return GestureDetector(
                onTap: () => onSelected(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    tabs[i],
                    style: isSelected
                        ? TextStyles.largeTextBold.copyWith(color: ColorStyles.primary100)
                        : TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray5),
                  ),
                ),
              );
            }),
          ),

          if (isBoard) ...[
            // 나눔선
            Container(
              color: ColorStyles.gray2,
              height: 16,
              width: 2,
            ),

            // 글작성
            GestureDetector(
              onTap: onWriteTab ?? () {},
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.create_outlined,
                color: ColorStyles.gray5,
                size: 24,
              ),
            )
          ]
        ],
      )
    );
  }
}