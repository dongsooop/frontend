import 'package:dongsoop/core/presentation/components/common_img_style.dart';
import 'package:dongsoop/domain/board/market/entities/market_list_entity.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/presentation/board/market/list/view_model/market_list_view_model.dart';
import 'package:dongsoop/presentation/board/market/price_formatter.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketItemListSection extends ConsumerWidget {
  final MarketType marketType;
  final void Function(int id, MarketType type) onTapMarketDetail;
  final ScrollController scrollController;

  const MarketItemListSection({
    super.key,
    required this.marketType,
    required this.onTapMarketDetail,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketListViewModelProvider(type: marketType));
    final viewModel =
        ref.read(marketListViewModelProvider(type: marketType).notifier);

    // 추후 수정
    if (state.items.isEmpty) {
      final emptyText =
          marketType == MarketType.SELL ? '판매 중인 게시글이 없어요!' : '구매 중인 게시글이 없어요!';
      return Center(child: Text(emptyText));
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final market = state.items[index];
          final isLast = index == state.items.length - 1;

          return _MarketListItem(
            market: market,
            isLastItem: isLast,
            onTap: () => onTapMarketDetail(market.id, marketType),
          );
        },
      ),
    );
  }
}

class _MarketListItem extends StatelessWidget {
  final MarketListEntity market;
  final VoidCallback onTap;
  final bool isLastItem;

  const _MarketListItem({
    required this.market,
    required this.onTap,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = market.imageUrl;

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
                      Text(
                        market.title,
                        style: TextStyles.largeTextRegular.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRelativeTime(market.createdAt),
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.gray4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${PriceFormatter.format(market.price)}원',
                        style: TextStyles.largeTextBold.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (market.contactCount > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 20,
                              color: ColorStyles.gray4,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${market.contactCount}',
                              style: TextStyles.smallTextRegular.copyWith(
                                color: ColorStyles.gray4,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLastItem)
            const Divider(
              color: ColorStyles.gray2,
              height: 1,
            ),
        ],
      ),
    );
  }
}
