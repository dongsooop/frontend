import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BoardTabSection extends StatelessWidget {
  final List<String> categoryTabs; // '모집', '장터' 등 카테고리 탭
  final int selectedCategoryIndex;
  final int selectedSubTabIndex;
  final List<String> subTabs; // ['튜터링', '스터디', '프로젝트'] 등 서브 탭
  final void Function(int) onCategorySelected;
  final void Function(int) onSubTabSelected;

  const BoardTabSection({
    super.key,
    required this.categoryTabs,
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
        // 상단 카테고리 탭
        Padding(
          padding: const EdgeInsets.only(top: 36),
          child: Row(
            children: List.generate(categoryTabs.length, (index) {
              return Row(
                children: [
                  _buildCategoryButton(categoryTabs[index], index),
                  if (index != categoryTabs.length - 1)
                    const SizedBox(width: 16), // 버튼 사이 간격
                ],
              );
            }),
          ),
        ),

        // 검색바
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: SearchBarComponent(),
        ),

        // 하단 서브 탭
        Container(
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

  // 카테고리 탭 스타일
  Widget _buildCategoryButton(String label, int index) {
    final isSelected = selectedCategoryIndex == index;
    return Container(
      width: 44,
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => onCategorySelected(index),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          overlayColor: Colors.transparent,
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

  // 서브 탭 스타일
  Widget _buildUnderlineTab(String label, bool isSelected) {
    return Container(
      height: 44,
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
