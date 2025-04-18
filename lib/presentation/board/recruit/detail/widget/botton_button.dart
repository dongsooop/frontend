import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isEnabled;

  const BottomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ColorStyles.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                onPressed: isEnabled ? onPressed : null,
                icon: const Icon(Icons.chat_bubble_outline, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
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
