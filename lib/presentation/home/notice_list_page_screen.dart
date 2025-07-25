import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
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
    final viewModel = ref.watch(noticeListViewModelProvider(args).notifier);
    final isLastPage = viewModel.isLastPage;

    final scrollController = useScrollController();

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100) {
          viewModel.fetchNextPage(args);
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, args]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(title: '공지'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // const SearchBarComponent(),
              // const SizedBox(height: 24),
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
                          scrollController.jumpTo(0);
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
                  loading: () => const Center(
                      child: CircularProgressIndicator(
                    color: ColorStyles.primaryColor,
                  )),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (notices) => ListView.separated(
                    controller: scrollController,
                    itemCount: notices.length + (isLastPage ? 0 : 1),
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: ColorStyles.gray2,
                    ),
                    itemBuilder: (context, index) {
                      if (index == notices.length) {
                        return const SizedBox.shrink();
                      }

                      final item = notices[index];
                      final tags =
                          item.isDepartment ? ['학과공지', '학부'] : ['동양공지', '학교생활'];

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
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
