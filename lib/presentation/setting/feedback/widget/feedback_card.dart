import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class FeedbackCard extends StatelessWidget {
  final String content;

  const FeedbackCard({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorStyles.gray2),
      ),
      child: Text(
        content,
        style: TextStyles.smallTextRegular.copyWith(
          color: ColorStyles.black,
        ),
      ),
    );
  }
}