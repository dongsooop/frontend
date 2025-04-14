import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BoardTabSection extends StatelessWidget {
  final int selectedCategoryIndex; // 모집 / 장터 탭 인덱스
  final int selectedSubTabIndex; // 하단 텍스트 탭 인덱스
  final List<String> subTabs; // ['튜터링', '스터디', '프로젝트'] or ['판매', '구매']
  final void Function(int) onCategorySelected;
  final void Function(int) onSubTabSelected;

  const BoardTabSection({
    super.key,
    required this.selectedCategoryIndex,
    required this.selectedSubTabIndex,
    required this.subTabs,
    required this.onCategorySelected,
    required this.onSubTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36),
          child: Row(
            children: [
              _buildCategoryButton('모집', 0),
              const SizedBox(width: 16),
              _buildCategoryButton('장터', 1),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: SearchBarComponent(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: List.generate(subTabs.length, (index) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () => onSubTabSelected(index),
                    child: _buildUnderlineTab(
                      subTabs[index],
                      selectedSubTabIndex == index,
                    ),
                  ),
                  if (index != subTabs.length - 1) const SizedBox(width: 24),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String label, int index) {
    final isSelected = selectedCategoryIndex == index;
    return Container(
      width: 44,
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => onCategorySelected(index),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          overlayColor:
              MaterialStateColor.resolveWith((_) => Colors.transparent),
        ),
        child: Text(
          label,
          style: isSelected
              ? TextStyles.titleTextBold.copyWith(color: ColorStyles.primary100)
              : TextStyles.titleTextRegular.copyWith(color: ColorStyles.gray4),
        ),
      ),
    );
  }

  Widget _buildUnderlineTab(String label, bool isSelected) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              label,
              style: isSelected
                  ? TextStyles.largeTextBold
                      .copyWith(color: ColorStyles.primary100)
                  : TextStyles.largeTextRegular
                      .copyWith(color: ColorStyles.gray4),
            ),
          ),
          if (isSelected)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: ColorStyles.primary100,
              ),
            ),
        ],
      ),
    );
  }
}
