import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class PrimaryBottomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isEnabled;
  final bool isLoading;

  const PrimaryBottomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 56,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEnabled ? ColorStyles.primary100 : ColorStyles.gray1,
              textStyle: TextStyles.largeTextBold,
              foregroundColor:
                  isEnabled ? ColorStyles.white : ColorStyles.gray3,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: isLoading
              ? CircularProgressIndicator(color: ColorStyles.white)
              : Text(label),
          ),
        ),
      ),
    );
  }
}
