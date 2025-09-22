import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class RecruitBottomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onIconPressed;
  final bool isApplyEnabled;
  final bool isInquiryEnabled;

  const RecruitBottomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onIconPressed,
    this.isApplyEnabled = true,
    this.isInquiryEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: ColorStyles.white,
          boxShadow: [
            BoxShadow(
              color: ColorStyles.gray1,
              offset: const Offset(0, -4),
              blurRadius: 5,
              spreadRadius: -5,
            ),
            BoxShadow(
              color: ColorStyles.gray1,
              offset: const Offset(0, -8),
              blurRadius: 15,
              spreadRadius: -10,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: ColorStyles.gray4, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: isInquiryEnabled ? onIconPressed : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 24,
                style: IconButton.styleFrom(
                  foregroundColor: ColorStyles.gray4,
                  disabledForegroundColor: ColorStyles.gray4,
                  highlightColor: Colors.transparent,
                ),
                icon: const Icon(Icons.chat_bubble_outline, size: 24, color: ColorStyles.gray4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isApplyEnabled ? onPressed : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor:
                        isApplyEnabled ? ColorStyles.primary100 : ColorStyles.gray1,
                    textStyle: TextStyles.largeTextBold,
                    foregroundColor:
                        isApplyEnabled ? ColorStyles.white : ColorStyles.gray3,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(label),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
