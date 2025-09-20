import 'package:dongsoop/core/presentation/components/common_market_list_item.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/presentation/board/market/list/view_model/market_list_view_model.dart';
import 'package:dongsoop/presentation/board/market/price_formatter.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/presentation/board/utils/scroll_listener.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MarketItemListSection extends HookConsumerWidget {
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
    final provider = marketListViewModelProvider(type: marketType);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    useEffect(() {
      return setupScrollListener(
        scrollController: scrollController,
        getState: () => ref.read(provider),
        canFetchMore: (s) => !s.isLoading && s.hasMore,
        fetchMore: () => viewModel.fetchNext(),
      );
    }, [marketType, scrollController]);

    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            '${state.error}',
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.isLoading && state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: ColorStyles.primaryColor),
      );
    }

    if (state.items.isEmpty) {
      final emptyText =
          marketType == MarketType.SELL ? '판매 중인 게시글이 없어요!' : '구매 중인 게시글이 없어요!';
      return Center(child: Text(emptyText));
    }

    return RefreshIndicator(
      color: ColorStyles.primaryColor,
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        key: PageStorageKey(marketType.name),
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.items.length + ((state.hasMore && state.isLoading) ? 1 : 0),
        itemBuilder: (context, index) {
          final showLoading =
              index == state.items.length && state.hasMore && state.isLoading;

          if (showLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: ColorStyles.primaryColor),
              ),
            );
          }

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
