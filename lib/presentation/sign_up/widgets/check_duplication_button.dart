import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CheckDuplicationButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isLoading;
  final String enabledText;
  final String disabledText;

  const CheckDuplicationButton({
    super.key,
    required this.onTap,
    required this.isEnabled,
    this.isLoading = false,
    required this.enabledText,
    required this.disabledText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        height: 44,
        constraints: BoxConstraints(
          minWidth: 44,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isEnabled
          ? ColorStyles.primaryColor
          : ColorStyles.gray1,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          child: isLoading
          ? CircularProgressIndicator(color: ColorStyles.white)
          : Text(
            isEnabled ? enabledText : disabledText,
            style: TextStyles.smallTextBold.copyWith(
              color: isEnabled ? ColorStyles.white : ColorStyles.gray3,
            ),
          ),
        ),
      ),
    );
  }
}