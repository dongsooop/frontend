import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class EclassAssignmentEmptyState extends StatelessWidget {
  const EclassAssignmentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: ColorStyles.primary5,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 28,
              color: ColorStyles.primary100,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '제출할 과제가 없어요',
            key: const Key('eclass-assignment-empty-message'),
            style: TextStyles.largeTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 과제가 생기면 이곳에서 확인할 수 있어요.',
            textAlign: TextAlign.center,
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ],
      ),
    );
  }
}
