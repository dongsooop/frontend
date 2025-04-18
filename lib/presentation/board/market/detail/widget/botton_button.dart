import 'package:dongsoop/presentation/board/market/temp/temp_market_data.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isEnabled;

  BottomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  State<BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  final market = marketList[0];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ColorStyles.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('거래 희망 가격',
                    style: TextStyles.smallTextRegular
                        .copyWith(color: ColorStyles.gray4)),
                Text(market['market_prices'] + '원',
                    style: TextStyles.largeTextBold
                        .copyWith(color: ColorStyles.black))
              ],
            ),
            const SizedBox(width: 48),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.isEnabled ? widget.onPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.primary100,
                    textStyle: TextStyles.largeTextBold,
                    foregroundColor: ColorStyles.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(widget.label),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
