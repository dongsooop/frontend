import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class MyActivityItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const MyActivityItem({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.black,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: ColorStyles.black,
            ),
          ],
        ),
      ),
    );
  }
}
