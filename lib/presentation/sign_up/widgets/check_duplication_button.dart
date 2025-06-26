import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CheckDuplicationButton extends StatelessWidget {
  final VoidCallback onTab;
  final bool isLoading;

  const CheckDuplicationButton({
    super.key,
    required this.onTab,
    this.isLoading = false,
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
          child: isLoading
          ? CircularProgressIndicator(color: ColorStyles.white)
          : Text(
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