import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class EclassSubmissionBadge extends StatelessWidget {
  final bool submitted;

  const EclassSubmissionBadge({
    super.key,
    required this.submitted,
  });

  @override
  Widget build(BuildContext context) {
    final label = submitted ? '제출 완료' : '미제출';
    final backgroundColor =
        submitted ? ColorStyles.primary5 : ColorStyles.labelColorYellow10;
    final foregroundColor =
        submitted ? ColorStyles.primary100 : ColorStyles.labelColorYellow100;

    return Semantics(
      label: '과제 제출 상태: $label',
      excludeSemantics: true,
      child: Container(
        key: Key(
          submitted
              ? 'eclass-submission-completed'
              : 'eclass-submission-pending',
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyles.smallTextBold.copyWith(
                color: foregroundColor,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
