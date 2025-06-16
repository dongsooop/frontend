import 'package:dongsoop/core/presentation/components/common_tap_section.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/auth/model/department_type_ext.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/presentation/board/common/components/board_write_button.dart';
import 'package:dongsoop/presentation/board/market/list/market_list_item.dart';
import 'package:dongsoop/presentation/board/recruit/list/recruit_list_item.dart';
import 'package:dongsoop/presentation/board/recruit/list/view_models/recruit_list_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardPageScreen extends HookConsumerWidget {
  final void Function(int id, RecruitType type) onTapRecruitDetail;

  const BoardPageScreen({super.key, required this.onTapRecruitDetail});

  static const categoryTabs = ['모집', '장터'];
  static const recruitSubTabs = ['튜터링', '스터디', '프로젝트'];
  static const marketSubTabs = ['판매', '구매'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final selectedSubIndex = useState(0);
    final showLoginDialog = useState(false);
    final scrollController = useScrollController();

    final isRecruit = selectedIndex.value == 0;
    final currentSubTabs = isRecruit ? recruitSubTabs : marketSubTabs;
    final recruitType = RecruitType.values[selectedSubIndex.value];

    final user = ref.watch(userSessionProvider);
    final departmentCode = user != null
        ? DepartmentTypeExtension.fromDisplayName(user.departmentType).code
        : '';

    useEffect(() {
      final viewModelProvider = recruitListViewModelProvider(
        type: recruitType,
        departmentCode: departmentCode,
      );

      void _onScroll() {
        final current = ref.read(viewModelProvider);
        final notifier = ref.read(viewModelProvider.notifier);

        final isBottom = scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100;

        if (isBottom && !current.isLoading && current.hasMore) {
          notifier.loadNextPage();
        }
      }

      scrollController.addListener(_onScroll);
      return () => scrollController.removeListener(_onScroll);
    }, [
      scrollController,
      recruitType,
      departmentCode,
    ]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        floatingActionButton: WriteButton(
          onPressed: () {
            if (user == null) {
              showDialog(
                context: context,
                builder: (_) => CustomConfirmDialog(
                  title: '로그인이 필요해요',
                  content: '이 서비스를 이용하려면\n로그인을 해야 해요!',
                  isSingleAction: false,
                  confirmText: '확인',
                  onConfirm: () {
                    context.pop(); // 다이얼로그 닫기
                    context.go(RoutePaths.mypage); // 라우팅
                  },
                  dismissOnConfirm: false,
                  onCancel: () {
                    showLoginDialog.value = false;
                  },
                ),
              );
            } else {
              final route =
                  isRecruit ? RoutePaths.recruitWrite : '/market/write';
              context.push(route);
            }
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoardTabSection(
                categoryTabs: categoryTabs,
                selectedCategoryIndex: selectedIndex.value,
                selectedSubTabIndex: selectedSubIndex.value,
                subTabs: currentSubTabs,
                onCategorySelected: (newIndex) {
                  selectedIndex.value = newIndex;
                  selectedSubIndex.value = 0;
                },
                onSubTabSelected: (newSubIndex) {
                  selectedSubIndex.value = newSubIndex;
                },
              ),
            ),
            Expanded(
              child: isRecruit
                  ? RecruitItemListSection(
                      recruitType: recruitType,
                      departmentCode: departmentCode,
                      onTapRecruitDetail: onTapRecruitDetail,
                      scrollController: scrollController,
                    )
                  : MarketItemListSection(
                      scrollController: scrollController,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
