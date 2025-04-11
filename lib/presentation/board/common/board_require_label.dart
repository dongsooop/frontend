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
            text: label == '태그' ? '    작성자의 학과와 모집 학과는 자동으로 입력돼요' : ' *',
            style: label == '태그'
                ? TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4)
                : TextStyles.largeTextBold
                    .copyWith(color: ColorStyles.primary100),
          ),
        ],
      ),
    );
  }
}
