import 'package:dongsoop/core/presentation/components/common_market_list_item.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/presentation/board/market/price_formatter.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/presentation/board/market/list/view_model/search_market_view_model.dart';
import 'package:dongsoop/presentation/board/utils/scroll_listener.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchMarketItemListSection extends HookConsumerWidget {
  final MarketType marketType;
  final ScrollController scrollController;
  final Future<void> Function(int id, MarketType type) onTapMarketDetail;
  final String query;

  const SearchMarketItemListSection({
    super.key,
    required this.marketType,
    required this.scrollController,
    required this.onTapMarketDetail,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchMarketViewModelProvider(type: marketType));
    final viewModel = ref.read(searchMarketViewModelProvider(type: marketType).notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final q = query.trim();
        if (q.isEmpty) {
          viewModel.clear();
        } else {
          viewModel.search(q);
        }
      });
      return null;
    }, [query, marketType]);

    useEffect(() {
      return setupScrollListener(
        scrollController: scrollController,
        getState: () => ref.read(searchMarketViewModelProvider(type: marketType)),
        canFetchMore: (s) => !s.isLoading && s.hasMore,
        fetchMore: () => viewModel.loadMore(),
      );
    }, [scrollController, marketType, viewModel]);

    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: ColorStyles.primaryColor));
    }
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

    if (!state.isLoading && state.items.isEmpty) {
      return Center(child: Text(
        '검색 결과가 없어요',
        style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        textAlign: TextAlign.center),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.items.length,
      itemBuilder: (_, i) {
        final e = state.items[i];
        return CommonMarketListItem(
          imagePath: null,
          title: e.title,
          relativeTime: formatRelativeTime(e.createdAt),
          priceText: '${PriceFormatter.format(e.price)}원',
          contactCount: e.contactCount,
          isLastItem: i == state.items.length - 1,
          onTap: () => onTapMarketDetail(e.id, marketType),
          hideImage: true,
        );
      },
    );
  }
}