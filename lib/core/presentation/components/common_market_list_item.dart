import 'package:dongsoop/core/presentation/components/common_img_style.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CommonMarketListItem extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String relativeTime;
  final String priceText;
  final int contactCount;
  final VoidCallback onTap;
  final bool isLastItem;

  const CommonMarketListItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.relativeTime,
    required this.priceText,
    required this.contactCount,
    required this.onTap,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonImgStyle(imagePath: imagePath),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyles.largeTextRegular
                              .copyWith(color: ColorStyles.black)),
                      const SizedBox(height: 4),
                      Text(relativeTime,
                          style: TextStyles.smallTextRegular
                              .copyWith(color: ColorStyles.gray4)),
                      const SizedBox(height: 4),
                      Text(priceText,
                          style: TextStyles.largeTextBold
                              .copyWith(color: ColorStyles.black)),
                      const SizedBox(width: 16),
                      if (contactCount > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.chat_bubble_outline,
                                size: 20, color: ColorStyles.gray4),
                            const SizedBox(width: 4),
                            Text(
                              '$contactCount',
                              style: TextStyles.smallTextRegular
                                  .copyWith(color: ColorStyles.gray4),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLastItem) const Divider(color: ColorStyles.gray2, height: 1),
        ],
      ),
    );
  }
}
