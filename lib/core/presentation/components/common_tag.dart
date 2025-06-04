import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CommonTag extends StatelessWidget {
  final String label;
  final int index;
  final bool isDeletable;
  final VoidCallback? onDeleted;
  final TextStyle? textStyle;

  const CommonTag({
    super.key,
    required this.label,
    required this.index,
    this.isDeletable = false,
    this.onDeleted,
    this.textStyle,
  });

  Map<String, Color> _getColorsByIndex(int index) {
    if (index < 0) {
      // 학과용 기본 회색 스타일
      return {
        'bg': ColorStyles.gray1,
        'text': ColorStyles.gray3,
      };
    }

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
          'text': ColorStyles.gray3,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColorsByIndex(index);

    final effectiveTextStyle =
        (textStyle ?? TextStyles.smallTextBold).copyWith(color: colors['text']);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: effectiveTextStyle,
          ),
          if (isDeletable && onDeleted != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(
                Icons.close,
                size: 16,
                color: colors['text'],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
