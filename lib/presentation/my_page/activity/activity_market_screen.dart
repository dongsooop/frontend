import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/presentation/components/common_market_list_item.dart';
import '../../../core/presentation/components/custom_confirm_dialog.dart';
import '../../../core/presentation/components/detail_header.dart';
import '../../../domain/board/market/enum/market_type.dart';
import '../../../main.dart';
import '../../../providers/activity_providers.dart';
import '../../../ui/color_styles.dart';
import '../../board/market/price_formatter.dart';
import '../../board/utils/date_time_formatter.dart';

class ActivityMarketScreen extends HookConsumerWidget {
  final void Function(int id, MarketType type, String status) onTapMarketDetail;

  const ActivityMarketScreen({
    super.key,
    required this.onTapMarketDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityMarketState = ref.watch(activityMarketViewModelProvider);
    final viewModel = ref.read(activityMarketViewModelProvider.notifier);

    final scrollController = useScrollController();
    final posts = activityMarketState.posts ?? [];

    useEffect(() {
      Future.microtask(() async {
        await viewModel.loadPosts();
      });
      return null;
    }, []);

    useEffect(() {
      void scrollListener() {
        if (!scrollController.hasClients) return;
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          viewModel.fetchNextPage();
        }
      }
      scrollController.addListener(scrollListener);

      return () {
        scrollController.removeListener(scrollListener);
      };
    }, [scrollController]);
    // 오류
    useEffect(() {
      if (activityMarketState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '마이페이지 오류',
              content: activityMarketState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [activityMarketState.errorMessage]);

    // 로딩 상태 표시
    if (activityMarketState.isLoading) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorStyles.white,
          body: Center(
            child: CircularProgressIndicator(color: ColorStyles.primaryColor,),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: DetailHeader(
            title: '장터 내역',
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final isLast = index == posts.length - 1;
                        logger.i('status: ${post.status}');
                        return CommonMarketListItem(
                          imagePath: post.imageUrl,
                          title: post.title,
                          relativeTime: formatRelativeTime(post.createdAt),
                          priceText: '${PriceFormatter.format(post.price)}원',
                          contactCount: post.contactCount,
                          onTap: () => onTapMarketDetail(post.id, post.type, post.status),
                          isLastItem: isLast,
                        );
                      }
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
