import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class RequiredLabel extends StatelessWidget {
  final String label;

  const RequiredLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          TextSpan(
            text: (label == '모집 학과' || label == '태그' || label == '사진')
                ? ''
                : ' *',
            style: TextStyles.largeTextBold
                .copyWith(color: ColorStyles.primary100),
          ),
        ],
      ),
    );
  }
}
