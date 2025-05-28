import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CommonTag extends StatelessWidget {
  final String label;
  final int index;

  const CommonTag({
    super.key,
    required this.label,
    required this.index,
  });

  Map<String, Color> _getColorsByIndex(int index) {
    switch (index) {
      case 0:
        return {
          'bg': ColorStyles.primary5,
          'text': ColorStyles.primary100,
        };
      case 1:
        return {
          'bg': ColorStyles.labelColorRed10,
          'text': ColorStyles.labelColorRed100,
        };
      case 2:
        return {
          'bg': ColorStyles.labelColorYellow10,
          'text': ColorStyles.labelColorYellow100,
        };
      default:
        return {
          'bg': ColorStyles.gray1,
          'text': ColorStyles.gray4,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColorsByIndex(index);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        label,
        style: TextStyles.smallTextBold.copyWith(color: colors['text']),
      ),
    );
  }
}
