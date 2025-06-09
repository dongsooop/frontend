import 'package:dongsoop/core/presentation/components/common_img_style.dart';
import 'package:dongsoop/presentation/board/market/temp/temp_market_data.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class MarketItemListSection extends StatelessWidget {
  final ScrollController scrollController;
  final void Function(Map<String, dynamic> item)? onTapItem;

  const MarketItemListSection({
    super.key,
    required this.scrollController,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: marketList.length,
      itemBuilder: (context, index) {
        final market = marketList[index];
        final isLast = index == marketList.length - 1;

        return _MarketListItem(
          market: market,
          isLastItem: isLast,
          onTap: () => onTapItem?.call(market),
        );
      },
    );
  }
}

class _MarketListItem extends StatelessWidget {
  final Map<String, dynamic> market;
  final VoidCallback onTap;
  final bool isLastItem;

  const _MarketListItem({
    required this.market,
    required this.onTap,
    required this.isLastItem,
  });

  String formatRelativeTime(dynamic rawDate) {
    final dateTime = rawDate is DateTime
        ? rawDate
        : DateTime.tryParse(rawDate.toString()) ?? DateTime.now();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return '방금 전';
    if (difference.inMinutes < 60) return '${difference.inMinutes}분 전';
    if (difference.inHours < 24) return '${difference.inHours}시간 전';
    if (difference.inDays < 7) return '${difference.inDays}일 전';

    return '${dateTime.year}. ${dateTime.month}. ${dateTime.day}. ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final imageList = market['images'];
    final hasImage =
        imageList != null && imageList is List && imageList.isNotEmpty;
    final firstImage = hasImage ? imageList.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonImgStyle(imagePath: hasImage ? firstImage : null),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(market['market_title'] ?? '',
                          style: TextStyles.largeTextRegular
                              .copyWith(color: ColorStyles.black)),
                      Text(
                        formatRelativeTime(market['market_created_at']),
                        style: TextStyles.smallTextRegular
                            .copyWith(color: ColorStyles.gray4),
                      ),
                      Text('${market['market_prices'] ?? 0}원',
                          style: TextStyles.largeTextBold
                              .copyWith(color: ColorStyles.black)),
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
