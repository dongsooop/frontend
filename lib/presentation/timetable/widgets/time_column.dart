import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class TimeColumn extends StatelessWidget {
  const TimeColumn({
    super.key,
    required this.columnLength,
    required this.firstRowHeight,
    required this.slotHeight,
  });

  final int columnLength;
  final double firstRowHeight;
  final double slotHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: firstRowHeight),
          ...List.generate(columnLength, (i) {
            if (i.isEven) return const Divider(color: ColorStyles.gray2, height: 0);
            return SizedBox(
              height: slotHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '${i ~/ 2 + 9}',
                  style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}