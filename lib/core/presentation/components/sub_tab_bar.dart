import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class SubTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  final double gap;
  final EdgeInsets tabPadding;
  final bool showHelpIcon;
  final VoidCallback? onHelpPressed;

  const SubTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    this.gap = 8,
    this.tabPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.showHelpIcon = false,
    this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            spacing: gap,
            children: [
              for (int i = 0; i < tabs.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(i),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: _UnderlineTab(
                      label: tabs[i],
                      isSelected: selectedIndex == i,
                      padding: tabPadding,
                    ),
                  ),
                ),
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
    );
  }
}

class _UnderlineTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final EdgeInsets padding;

  const _UnderlineTab({
    required this.label,
    required this.isSelected,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
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