import 'package:flutter/cupertino.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class CheckDuplicationButton extends StatelessWidget {
  final VoidCallback onTab;

  const CheckDuplicationButton({
    super.key,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: ColorStyles.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          child: Text(
            '중복 확인',
            style: TextStyles.smallTextBold.copyWith(
              color: ColorStyles.white,
            ),
          ),
        ),
      ),
    );
  }
}