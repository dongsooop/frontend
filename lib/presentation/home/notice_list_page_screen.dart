import 'package:dongsoop/core/presentation/components/common_notice_list_item.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/search/enum/board_type.dart';
import 'package:dongsoop/presentation/home/view_models/notice_list_view_model.dart';
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

    final scrollController = useScrollController();

    useEffect(() {
      void onScroll() {
        if (!scrollController.hasClients) return;

        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100) {
          listVM.fetchNextPage(args);
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, args, listVM]);

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
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
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
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: ColorStyles.gray3),
                        onPressed: () {
                          context.push(
                            RoutePaths.search,
                            extra: SearchBoardType.notice,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: noticeState.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: ColorStyles.primaryColor),
                    ),
                    error: (e, _) => Center(child: Text('$e')),
                    data: (notices) {
                      if (notices.isEmpty) {
                        return Center(
                          child: Text(
                            '공지 리스트가 비어있어요!',
                            style: TextStyles.largeTextRegular
                                .copyWith(
                                color: ColorStyles.gray4),
                          ),
                        );
                      }
                      return CommonNoticeList<NoticeEntity>(
                        items: notices,
                        isLoading: false,
                        hasMore: !isLastPageList,
                        controller: scrollController,
                        titleOf: (e) => e.title,
                        isDepartmentOf: (e) => e.isDepartment,
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
        ),
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
