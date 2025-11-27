import 'dart:async';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:dongsoop/core/utils/use_search_reset.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';
import 'package:dongsoop/presentation/home/view_models/notice_list_view_model.dart';
import 'package:dongsoop/presentation/home/view_models/search_notice_view_model.dart';
import 'package:dongsoop/presentation/home/widgets/notice_list_view.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoticeListPageScreen extends HookConsumerWidget {
  const NoticeListPageScreen({super.key});

  NoticeTab selectedTab(int index) {
    return NoticeTab.values[index];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final keywordCtrl = useTextEditingController();
    final keyword = useState('');

    final isResetLoading = useState(false);

    final user = ref.watch(userSessionProvider);
    final isLoggedIn = user != null;

    final departmentName = user?.departmentType ?? '';
    final departmentType =
    DepartmentTypeExtension.fromDisplayName(departmentName);
    final departmentCode =
    (isLoggedIn && departmentType != DepartmentType.Unknown)
        ? departmentType.code
        : null;

    final args = useMemoized(() {
      return NoticeListArgs(
        tab: selectedTab(selectedIndex.value),
        departmentType: departmentCode,
      );
    }, [selectedIndex.value, departmentCode]);

    final noticeState = ref.watch(noticeListViewModelProvider(args));
    final listVM = ref.read(noticeListViewModelProvider(args).notifier);
    final isLastPageList = listVM.isLastPage;

    final tab = selectedTab(selectedIndex.value);
    final searchState = ref.watch(
      searchNoticeViewModelProvider(tab: tab, departmentName: departmentName),
    );
    final searchVM = ref.read(
      searchNoticeViewModelProvider(tab: tab, departmentName: departmentName).notifier,
    );

    final isSearching = keyword.value.trim().isNotEmpty;

    final scrollController = useScrollController();

    useSearchReset(
      controller: keywordCtrl,
      keyword: keyword,
      scrollController: scrollController,
      onReset: () {
        isResetLoading.value = true;
      },
    );

    useEffect(() {
      if (!isSearching && isResetLoading.value) {
        final timer = Timer(const Duration(milliseconds: 500), () {
          isResetLoading.value = false;
        });
        return timer.cancel;
      }
      return null;
    }, [isSearching, isResetLoading.value]);

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100) {
          if (isSearching) {
            if (tab == NoticeTab.department && !isLoggedIn) return;
            searchVM.loadMore();
          } else {
            listVM.fetchNextPage(args);
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, args, isSearching, tab, isLoggedIn, searchVM, listVM]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: const DetailHeader(title: '공지'),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 16),
                SearchBarComponent(
                  controller: keywordCtrl,
                  onSubmitted: (kw) async {
                    final trimmed = kw.trim();
                    if (trimmed.isEmpty) return;
                    if (tab == NoticeTab.department && !isLoggedIn) {
                      await LoginRequiredDialog(context);
                      return;
                    }

                    if (isResetLoading.value) {
                      isResetLoading.value = false;
                    }

                    keyword.value = trimmed;
                    await searchVM.search(trimmed);

                    if (scrollController.hasClients) {
                      scrollController.jumpTo(0);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      final labels = ['전체', '학교', '학과'];
                      final isSelected = selectedIndex.value == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: GestureDetector(
                          onTap: () async {
                            if (index == 2 && !isLoggedIn) {
                              await LoginRequiredDialog(context);
                              return;
                            }
                            selectedIndex.value = index;

                            if (isSearching) {
                              keywordCtrl.clear();
                              keyword.value = '';
                              FocusManager.instance.primaryFocus?.unfocus();
                              isResetLoading.value = true;
                            }

                            if (scrollController.hasClients) {
                              scrollController.jumpTo(0);
                            }
                          },
                          child: _buildUnderlineTab(labels[index], isSelected),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: isSearching
                      ? Builder(
                    builder: (_) {
                      final items = searchState.items;

                      if (items.isEmpty) {
                        if (searchState.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: ColorStyles.primaryColor,
                            ),
                          );
                        }
                        return Center(
                          child: Text(
                            '검색 결과가 없어요!',
                            style: TextStyles.largeTextRegular
                                .copyWith(color: ColorStyles.gray4),
                          ),
                        );
                      }

                      return NoticeListView<SearchNoticeEntity>(
                        items: items,
                        isLoading: searchState.isLoading,
                        isLastPage: !searchState.hasMore,
                        controller: scrollController,
                        titleOf: (e) => e.title,
                        isDepartmentOf: (e) => e.isDepartment,
                        linkOf: (e) => e.url,
                        onTap: (e) => context.pushNamed(
                          'noticeWebView',
                          queryParameters: {'path': e.url},
                        ),
                      );
                    },
                  )
                      : isResetLoading.value
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: ColorStyles.primaryColor,
                    ),
                  )
                      : noticeState.when(
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: ColorStyles.primaryColor,
                        )),
                    error: (e, _) => Center(child: Text('$e')),
                    data: (notices) {
                      if (notices.isEmpty) {
                        return Center(
                          child: Text('공지 리스트가 비어있어요!',
                              style: TextStyles.largeTextRegular
                                  .copyWith(color: ColorStyles.gray4)),
                        );
                      }
                      return NoticeListView<NoticeEntity>(
                        items: notices,
                        isLoading: false,
                        isLastPage: isLastPageList,
                        controller: scrollController,
                        titleOf: (e) => e.title,
                        isDepartmentOf: (e) => e.isDepartment,
                        linkOf: (e) => e.link,
                        onTap: (e) => context.pushNamed(
                          'noticeWebView',
                          queryParameters: {'path': e.link},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _buildUnderlineTab(String label, bool isSelected) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              label,
              style: isSelected
                  ? TextStyles.largeTextBold
                      .copyWith(color: ColorStyles.primary100)
                  : TextStyles.largeTextRegular
                      .copyWith(color: ColorStyles.gray4),
            ),
          ),
          if (isSelected)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: ColorStyles.primary100,
              ),
            ),
        ],
      ),
    );
  }
}
