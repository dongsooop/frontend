import 'package:dongsoop/core/presentation/components/common_market_list_item.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/presentation/board/market/list/view_model/market_list_view_model.dart';
import 'package:dongsoop/presentation/board/market/price_formatter.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/ui/color_styles.dart';
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

    if (state.items.isEmpty) {
      final emptyText =
          marketType == MarketType.SELL ? '판매 중인 게시글이 없어요!' : '구매 중인 게시글이 없어요!';
      return Center(child: Text(emptyText));
    }

    return RefreshIndicator(
      color: ColorStyles.primaryColor,
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final market = state.items[index];
          final isLast = index == state.items.length - 1;

          return CommonMarketListItem(
            imagePath: market.imageUrl,
            title: market.title,
            relativeTime: formatRelativeTime(market.createdAt),
            priceText: '${PriceFormatter.format(market.price)}원',
            contactCount: market.contactCount,
            onTap: () => onTapMarketDetail(market.id, marketType),
            isLastItem: isLast,
          );
        },
      ),
    );
  }
}
