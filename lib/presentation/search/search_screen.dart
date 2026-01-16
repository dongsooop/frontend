import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/enum/board_type.dart';
import 'package:dongsoop/presentation/search/view_models/search_market_view_model.dart';
import 'package:dongsoop/presentation/search/view_models/search_recruit_view_model.dart';
import 'package:dongsoop/presentation/search/widget/search_market_list.dart';
import 'package:dongsoop/presentation/search/widget/search_notice_list.dart';
import 'package:dongsoop/presentation/search/widget/search_recruit_list.dart';
import 'package:dongsoop/presentation/home/view_models/notice_list_view_model.dart';
import 'package:dongsoop/presentation/home/view_models/search_notice_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends HookConsumerWidget {
  final SearchBoardType boardType;
  final Future<void> Function(int id, RecruitType type)? onTapRecruitDetail;
  final Future<void> Function(int id, MarketType type)? onTapMarketDetail;

  const SearchScreen({
    super.key,
    required this.boardType,
    this.onTapRecruitDetail,
    this.onTapMarketDetail,
  });

  static const _recruitTypes = <RecruitType>[
    RecruitType.TUTORING,
    RecruitType.STUDY,
    RecruitType.PROJECT,
  ];

  static const _marketTypes = <MarketType>[
    MarketType.SELL,
    MarketType.BUY,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywordCtrl = useTextEditingController();
    useListenable(keywordCtrl);

    final keyword = useState('');
    final scrollController = useScrollController();

    final user = ref.watch(userSessionProvider);
    String departmentName = '';
    if (user != null) {
      final dept = DepartmentTypeExtension.fromDisplayName(user.departmentType);
      departmentName = dept.displayName;
    }

    void handleClear() {
      keywordCtrl.clear();
      keyword.value = '';
      FocusManager.instance.primaryFocus?.unfocus();
      if (scrollController.hasClients) scrollController.jumpTo(0);
    }

    Future<void> onSubmit(String kw) async {
      final q = kw.trim();
      if (q.isEmpty) return;

      keyword.value = q;
      FocusManager.instance.primaryFocus?.unfocus();
      if (scrollController.hasClients) scrollController.jumpTo(0);

      if (boardType == SearchBoardType.recruit) {
        await ref
            .read(
          searchRecruitViewModelProvider(
            types: _recruitTypes,
            departmentName: departmentName,
          ).notifier,
        )
            .search(q);
        return;
      }

      if (boardType == SearchBoardType.market) {
        await ref
            .read(
          searchMarketViewModelProvider(types: _marketTypes).notifier,
        )
            .search(q);
        return;
      }

      await ref
          .read(
        searchNoticeViewModelProvider(
          tab: NoticeTab.all,
          departmentName: departmentName,
        ).notifier,
      )
          .search(q);
    }

    final isSearching = keyword.value.trim().isNotEmpty;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SearchBarComponent(
                        controller: keywordCtrl,
                        onSubmitted: onSubmit,
                        onClear: handleClear,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: isSearching
                      ? _SearchResultBody(
                    key: ValueKey('result-${boardType.name}-${keyword.value}'),
                    boardType: boardType,
                    keyword: keyword.value,
                    departmentName: departmentName,
                    scrollController: scrollController,
                    onTapRecruitDetail: onTapRecruitDetail,
                    onTapMarketDetail: onTapMarketDetail,
                  )
                      : Center(
                    child: Text(
                      '검색어를 입력해주세요',
                      style: TextStyles.largeTextRegular.copyWith(
                        color: ColorStyles.gray4,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultBody extends HookConsumerWidget {
  final SearchBoardType boardType;
  final String keyword;

  final String departmentName;
  final ScrollController scrollController;

  final Future<void> Function(int id, RecruitType type)? onTapRecruitDetail;
  final Future<void> Function(int id, MarketType type)? onTapMarketDetail;

  const _SearchResultBody({
    super.key,
    required this.boardType,
    required this.keyword,
    required this.departmentName,
    required this.scrollController,
    required this.onTapRecruitDetail,
    required this.onTapMarketDetail,
  });

  static const _recruitTypes = <RecruitType>[
    RecruitType.TUTORING,
    RecruitType.STUDY,
    RecruitType.PROJECT,
  ];

  static const _marketTypes = <MarketType>[
    MarketType.SELL,
    MarketType.BUY,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (boardType == SearchBoardType.recruit) {
      return SearchRecruitItemListSection(
        types: _recruitTypes,
        departmentName: departmentName,
        scrollController: scrollController,
        onTapRecruitDetail: (id, type) async {
          if (onTapRecruitDetail == null) return;
          await onTapRecruitDetail!(id, type);
        },
        query: keyword,
      );
    }

    if (boardType == SearchBoardType.market) {
      return SearchMarketItemListSection(
        types: _marketTypes,
        scrollController: scrollController,
        onTapMarketDetail: (id, type) async {
          if (onTapMarketDetail == null) return;
          await onTapMarketDetail!(id, type);
        },
        query: keyword,
      );
    }

    // notice
    final provider = searchNoticeViewModelProvider(
      tab: NoticeTab.all,
      departmentName: departmentName,
    );
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    useEffect(() {
      void onScroll() {
        if (!scrollController.hasClients) return;
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100) {
          if (!state.isLoading && state.hasMore) {
            vm.loadMore();
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, state.isLoading, state.hasMore, vm]);

    if (state.items.isEmpty) {
      if (state.isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: ColorStyles.primaryColor),
        );
      }
      return Center(
        child: Text(
          '검색 결과가 없어요!',
          style: TextStyles.largeTextRegular.copyWith(
            color: ColorStyles.gray4,
          ),
        ),
      );
    }

    return SearchNoticeList(
      items: state.items,
      controller: scrollController,
      isLoading: state.isLoading,
      hasMore: state.hasMore,
      onTap: (e) => context.pushNamed(
        'noticeWebView',
        queryParameters: {'path': e.url},
      ),
    );
  }
}