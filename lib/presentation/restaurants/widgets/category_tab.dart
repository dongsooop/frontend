import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 44,
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: isSelected
                  ? TextStyles.largeTextBold.copyWith(color: ColorStyles.primaryColor,)
                  : TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray4,),
              ),
              const SizedBox(height: 4),
              Container(
                height: 1,
                width: double.infinity,
                color:
                isSelected ? ColorStyles.primaryColor : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}