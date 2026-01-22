import 'package:dongsoop/core/presentation/components/common_search_bar.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/enum/board_type.dart';
import 'package:dongsoop/presentation/home/view_models/notice_list_view_model.dart';
import 'package:dongsoop/presentation/search/view_models/auto_complete_view_model.dart';
import 'package:dongsoop/presentation/search/view_models/popular_search_view_model.dart'; // ✅ 추가
import 'package:dongsoop/presentation/search/view_models/search_market_view_model.dart';
import 'package:dongsoop/presentation/search/view_models/search_notice_view_model.dart';
import 'package:dongsoop/presentation/search/view_models/search_recruit_view_model.dart';
import 'package:dongsoop/presentation/search/widget/auto_complete_list.dart';
import 'package:dongsoop/presentation/search/widget/search_market_list.dart';
import 'package:dongsoop/presentation/search/widget/search_notice_list.dart';
import 'package:dongsoop/presentation/search/widget/search_recruit_list.dart';
import 'package:dongsoop/presentation/search/widget/popular_search_list.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _RecentMenu { clearAll, cancel }

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

    final query = keywordCtrl.text.trim();

    final user = ref.watch(userSessionProvider);
    String departmentName = '';
    if (user != null) {
      final dept = DepartmentTypeExtension.fromDisplayName(user.departmentType);
      departmentName = dept.displayName;
    }

    final isSearching = keyword.value.trim().isNotEmpty;

    final isTyping = !isSearching && query.isNotEmpty;

    final autoAsync = ref.watch(autocompleteViewModelProvider);
    final autoItems = autoAsync.valueOrNull ?? const <String>[];

    void handleClear() {
      keywordCtrl.clear();
      keyword.value = '';

      ref.read(autocompleteViewModelProvider.notifier).clear();

      FocusManager.instance.primaryFocus?.unfocus();
      if (scrollController.hasClients) scrollController.jumpTo(0);
    }

    Future<void> onSubmit(String kw) async {
      final q = kw.trim();
      if (q.isEmpty) return;

      await ref.read(preferencesProvider).addRecentSearch(q);

      keyword.value = q;

      ref.read(autocompleteViewModelProvider.notifier).clear();

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

    if (isSearching) {
      if (boardType == SearchBoardType.recruit) {
        ref.watch(
          searchRecruitViewModelProvider(
            types: _recruitTypes,
            departmentName: departmentName,
          ),
        );
      } else if (boardType == SearchBoardType.market) {
        ref.watch(
          searchMarketViewModelProvider(types: _marketTypes),
        );
      } else {
        ref.watch(
          searchNoticeViewModelProvider(
            tab: NoticeTab.all,
            departmentName: departmentName,
          ),
        );
      }
    }

    final searchFocusNode = useFocusNode();

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: CommonSearchAppBar(
        controller: keywordCtrl,
        focusNode: searchFocusNode,
        hintText: _hintByBoardType(boardType),
        onBack: () => context.pop(),
        onTap: () => onSubmit(keywordCtrl.text),
        onClear: handleClear,

        onChanged: (text) {
          if (keyword.value.trim().isEmpty) {
            ref
                .read(autocompleteViewModelProvider.notifier)
                .onQueryChanged(text, boardType: boardType);
          }
        },
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: isSearching
                      ? _SearchResultBody(
                    key: ValueKey(
                      'result-${boardType.name}-${keyword.value}',
                    ),
                    boardType: boardType,
                    keyword: keyword.value,
                    departmentName: departmentName,
                    scrollController: scrollController,
                    onTapRecruitDetail: onTapRecruitDetail,
                    onTapMarketDetail: onTapMarketDetail,
                  )
                      : isTyping
                      ? AutocompleteList(
                    key: ValueKey('auto-$query'),
                    scrollController: scrollController,
                    query: query,
                    items: autoItems,
                    onTapSuggestion: (suggestion) async {
                      keywordCtrl.text = suggestion;
                      keywordCtrl.selection =
                          TextSelection.fromPosition(
                            TextPosition(offset: suggestion.length),
                          );

                      await onSubmit(suggestion);
                    },
                  )
                      : _PopularAndRecentBody(
                    key: const ValueKey('popular+recent'),
                    scrollController: scrollController,
                    onTapKeyword: (kw) async {
                      keywordCtrl.text = kw;
                      keywordCtrl.selection =
                          TextSelection.fromPosition(
                            TextPosition(offset: kw.length),
                          );
                      keyword.value = kw.trim();
                      await onSubmit(kw);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _hintByBoardType(SearchBoardType boardType) {
    switch (boardType) {
      case SearchBoardType.recruit:
        return '모집 게시글을 검색해 주세요';
      case SearchBoardType.market:
        return '장터 게시글을 검색해 주세요';
      case SearchBoardType.notice:
        return '공지 게시글을 검색해 주세요';
    }
  }
}

class _PopularAndRecentBody extends HookConsumerWidget {
  final ScrollController scrollController;
  final void Function(String keyword) onTapKeyword;

  const _PopularAndRecentBody({
    super.key,
    required this.scrollController,
    required this.onTapKeyword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);
    final recent = useState<List<String>>([]);
    final popularAsync = ref.watch(popularSearchViewModelProvider);

    final loadRecent = useCallback(() async {
      recent.value = await prefs.getRecentSearches();
    }, [prefs]);

    final removeOne = useCallback((String keyword) async {
      await prefs.removeRecentSearch(keyword);
      await loadRecent();
    }, [prefs, loadRecent]);

    final clearAll = useCallback(() async {
      await prefs.clearRecentSearches();
      await loadRecent();
    }, [prefs, loadRecent]);

    useEffect(() {
      loadRecent();
      return null;
    }, [loadRecent]);

    final recentItems = recent.value.take(5).toList();

    Widget recentHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '최근 검색',
            style: TextStyles.normalTextBold.copyWith(color: ColorStyles.gray6),
          ),
          SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: PopupMenuButton<_RecentMenu>(
                enabled: recentItems.isNotEmpty,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.more_horiz, color: ColorStyles.gray4),
                onSelected: (value) async {
                  if (value == _RecentMenu.clearAll) await clearAll();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _RecentMenu.clearAll,
                    child: Text(
                      '전체 삭제',
                      style: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.black),
                    ),
                  ),
                  PopupMenuItem(
                    value: _RecentMenu.cancel,
                    child: Text(
                      '취소',
                      style: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        popularAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, st) => const SizedBox.shrink(),
          data: (keywords) => PopularSearchList(
            keywords: keywords,
            onTapKeyword: onTapKeyword,
            maxItems: 10,
          ),
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              recentHeader(),
              const SizedBox(height: 8),
              if (recentItems.isEmpty)
                SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      '최근 검색어가 없어요',
                      style: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray4),
                    ),
                  ),
                )
              else
                ...recentItems.map((k) {
                  return _RecentKeywordRow(
                    key: ValueKey(k),
                    keyword: k,
                    onTap: () => onTapKeyword(k),
                    onRemove: () => removeOne(k),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentKeywordRow extends StatelessWidget {
  final String keyword;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentKeywordRow({
    super.key,
    required this.keyword,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    keyword,
                    style: TextStyles.largeTextRegular
                        .copyWith(color: ColorStyles.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close,
                      size: 20, color: ColorStyles.gray4),
                  padding: EdgeInsets.zero,
                  constraints:
                  const BoxConstraints(minWidth: 44, minHeight: 44),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
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