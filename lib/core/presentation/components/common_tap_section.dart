import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BoardTabSection extends StatelessWidget {
  final List<String> categoryTabs;
  final int selectedCategoryIndex;
  final int selectedSubTabIndex;
  final List<String> subTabs;
  final void Function(int) onCategorySelected;
  final void Function(int) onSubTabSelected;
  final bool showHelpIcon;
  final VoidCallback? onHelpPressed;
  final TextEditingController searchController;
  final Future<void> Function(String) onSubmitted;

  const BoardTabSection({
    super.key,
    required this.categoryTabs,
    required this.selectedCategoryIndex,
    required this.selectedSubTabIndex,
    required this.subTabs,
    required this.onCategorySelected,
    required this.onSubTabSelected,
    this.showHelpIcon = false,
    this.onHelpPressed,
    required this.searchController,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Row(
            children: List.generate(categoryTabs.length, (index) {
              return Row(
                children: [
                  _buildCategoryButton(categoryTabs[index], index),
                  if (index != categoryTabs.length - 1)
                    const SizedBox(width: 16),
                ],
              );
            }),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SearchBarComponent(
            controller: searchController,
            onSubmitted: onSubmitted,
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                spacing: 8,
                children: [
                  for (int i = 0; i < subTabs.length; i++) ...[
                    Expanded(
                      child: InkWell(
                        onTap: () => onSubTabSelected(i),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: _buildUnderlineTab(
                          subTabs[i],
                          selectedSubTabIndex == i,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showHelpIcon && onHelpPressed != null)
              SizedBox(
                height: 44,
                child: IconButton(
                  icon: const Icon(Icons.help_outline, size: 24),
                  onPressed: onHelpPressed,
                  padding: EdgeInsets.zero,
                  color: ColorStyles.primaryColor,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String label, int index) {
    final isSelected = selectedCategoryIndex == index;
    return Container(
      height: 44,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => onCategorySelected(index),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            overlayColor: Colors.transparent,
            minimumSize: Size(44, 44)),
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
      padding: EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: isSelected
                ? TextStyles.largeTextBold.copyWith(color: ColorStyles.primary100)
                : TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray4),
            ),
          ),
          if (isSelected)
            SizedBox(
              width: double.infinity,
              child: Container(height: 2, color: ColorStyles.primary100),
            )
          else
            const SizedBox(height: 2),
        ],
      ),
    );
  }
}
