import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:dongsoop/core/providers/user_provider.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_use_case.dart';
import 'package:dongsoop/presentation/home/view_models/notice_list_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NoticeListPageScreen extends ConsumerStatefulWidget {
  const NoticeListPageScreen({super.key});

  @override
  ConsumerState<NoticeListPageScreen> createState() =>
      _NoticeListPageScreenState();
}

class _NoticeListPageScreenState extends ConsumerState<NoticeListPageScreen> {
  int selectedNoticeIndex = 0;
  final ScrollController _scrollController = ScrollController();

  NoticeTab getSelectedTab(int index) {
    switch (index) {
      case 0:
        return NoticeTab.all;
      case 1:
        return NoticeTab.school;
      case 2:
        return NoticeTab.department;
      default:
        return NoticeTab.school;
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        final user = ref.read(userProvider);
        ref
            .read(
              noticeListViewModelProvider(
                NoticeListArgs(
                  tab: getSelectedTab(selectedNoticeIndex),
                  departmentType: user?.departmentType,
                ),
              ).notifier,
            )
            .fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final args = NoticeListArgs(
      tab: getSelectedTab(selectedNoticeIndex),
      departmentType: user?.departmentType,
    );
    final noticeState = ref.watch(noticeListViewModelProvider(args));
    final viewModel = ref.watch(noticeListViewModelProvider(args).notifier);
    final isLastPage = viewModel.isLastPage;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(title: '공지'),
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const SearchBarComponent(),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      final labels = ['전체', '학교', '학과'];
                      final isSelected = selectedNoticeIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedNoticeIndex = index;
                              _scrollController.jumpTo(0);
                            });
                          },
                          child: _buildUnderlineTab(labels[index], isSelected),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: noticeState.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('에러: $e')),
                    data: (notices) => ListView.separated(
                      controller: _scrollController,
                      itemCount: notices.length + (isLastPage ? 0 : 1),
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: ColorStyles.gray2,
                      ),
                      itemBuilder: (context, index) {
                        if (index == notices.length) {
                          // 마지막 인덱스인데 isLastPage면 이 블럭 호출 안 됨
                          return const SizedBox.shrink();
                        }

                        final item = notices[index];
                        final tags = item.isDepartment
                            ? ['학과공지', '학부']
                            : ['동양공지', '학교생활'];

                        return GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              'noticeWebView',
                              queryParameters: {'path': item.link},
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyles.largeTextBold.copyWith(
                                    color: ColorStyles.black,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  children: tags
                                      .asMap()
                                      .entries
                                      .map((entry) => CommonTag(
                                            label: entry.value,
                                            index: entry.key,
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
