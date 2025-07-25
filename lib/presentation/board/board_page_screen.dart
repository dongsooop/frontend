import 'package:dongsoop/core/presentation/components/common_tap_section.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/common/components/board_write_button.dart';
import 'package:dongsoop/presentation/board/market/list/market_list_item.dart';
import 'package:dongsoop/presentation/board/market/list/view_model/market_list_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/list/recruit_list_item.dart';
import 'package:dongsoop/presentation/board/recruit/list/view_models/recruit_list_view_model.dart';
import 'package:dongsoop/presentation/board/utils/scroll_listener.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardPageScreen extends HookConsumerWidget {
  final Future<bool> Function(int id, RecruitType type) onTapRecruitDetail;
  final Future<bool> Function(int id, MarketType type) onTapMarketDetail;
  final Future<bool?> Function(bool isRecruit) onTapWrite;

  const BoardPageScreen({
    super.key,
    required this.onTapRecruitDetail,
    required this.onTapMarketDetail,
    required this.onTapWrite,
  });

  static const categoryTabs = ['모집', '장터'];
  static const recruitSubTabs = ['튜터링', '스터디', '프로젝트'];
  static const marketSubTabs = ['판매', '구매'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final selectedSubIndex = useState(0);
    final recruitTabIndex = useState(0);
    final marketTabIndex = useState(0);

    final scrollControllers =
        useMemoized(() => List.generate(5, (_) => ScrollController()));
    final pageController = usePageController();

    final isRecruit = selectedIndex.value == 0;
    final currentSubTabs = isRecruit ? recruitSubTabs : marketSubTabs;

    // 탭 인덱스 동기화
    useEffect(() {
      selectedSubIndex.value =
          isRecruit ? recruitTabIndex.value : marketTabIndex.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageController.jumpToPage(selectedSubIndex.value);
      });
      return null;
    }, [selectedIndex.value]);

    final user = ref.watch(userSessionProvider);
    final departmentCode = user != null
        ? DepartmentTypeExtension.fromDisplayName(user.departmentType).code
        : '';

    final safeIndex =
        selectedSubIndex.value.clamp(0, currentSubTabs.length - 1);

    final recruitType = isRecruit && safeIndex < RecruitType.values.length
        ? RecruitType.values[safeIndex]
        : null;
    final marketType = !isRecruit && safeIndex < MarketType.values.length
        ? MarketType.values[safeIndex]
        : null;

    useEffect(() {
      final controller = scrollControllers[safeIndex];
      if (isRecruit && recruitType != null) {
        final provider = recruitListViewModelProvider(
          type: recruitType,
          departmentCode: departmentCode,
        );
        final notifier = ref.read(provider.notifier);

        return setupScrollListener(
          scrollController: controller,
          getState: () => ref.read(provider),
          canFetchMore: (state) => !state.isLoading && state.hasMore,
          fetchMore: () => notifier.loadNextPage(),
        );
      } else if (!isRecruit && marketType != null) {
        final provider = marketListViewModelProvider(type: marketType);
        final notifier = ref.read(provider.notifier);

        return setupScrollListener(
          scrollController: controller,
          getState: () => ref.read(provider),
          canFetchMore: (state) => !state.isLoading && state.hasMore,
          fetchMore: () => notifier.fetchNext(),
        );
      }
      return null;
    }, [
      safeIndex,
      selectedIndex.value,
      departmentCode,
    ]);

    Future<void> handleWriteAction() async {
      final user = ref.watch(userSessionProvider);
      if (user == null) {
        await LoginRequiredDialog(context);
        return;
      }

      final result = await onTapWrite(isRecruit);

      if (result == true) {
        if (isRecruit && recruitType != null) {
          ref
              .read(
                recruitListViewModelProvider(
                  type: recruitType,
                  departmentCode: departmentCode,
                ).notifier,
              )
              .refresh();
        } else if (marketType != null) {
          ref
              .read(
                marketListViewModelProvider(type: marketType).notifier,
              )
              .refresh();
        }
      }
    }

    Future<void> handleRecruitDetail(int id, RecruitType type) async {
      final didApply = await onTapRecruitDetail(id, type);
      if (didApply && recruitType != null) {
        ref
            .read(
              recruitListViewModelProvider(
                type: recruitType,
                departmentCode: departmentCode,
              ).notifier,
            )
            .refresh();
      }
    }

    Future<void> handleMarketDetail(int id, MarketType type) async {
      final didComplete = await onTapMarketDetail(id, type);
      if (didComplete && marketType != null) {
        ref
            .read(
              marketListViewModelProvider(type: marketType).notifier,
            )
            .refresh();
      }
    }

    return Scaffold(
      backgroundColor: ColorStyles.white,
      floatingActionButton: WriteButton(
        onPressed: handleWriteAction,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoardTabSection(
                categoryTabs: categoryTabs,
                selectedCategoryIndex: selectedIndex.value,
                selectedSubTabIndex: safeIndex,
                subTabs: currentSubTabs,
                onCategorySelected: (newIndex) {
                  // 이전 하위 탭 상태 저장
                  if (selectedIndex.value == 0) {
                    recruitTabIndex.value = selectedSubIndex.value;
                  } else {
                    marketTabIndex.value = selectedSubIndex.value;
                  }

                  selectedIndex.value = newIndex;
                },
                onSubTabSelected: (newSubIndex) {
                  selectedSubIndex.value = newSubIndex;

                  if (isRecruit) {
                    recruitTabIndex.value = newSubIndex;
                  } else {
                    marketTabIndex.value = newSubIndex;
                  }

                  pageController.animateToPage(
                    newSubIndex,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: currentSubTabs.length,
                onPageChanged: (index) {
                  selectedSubIndex.value = index;
                  if (isRecruit) {
                    recruitTabIndex.value = index;
                  } else {
                    marketTabIndex.value = index;
                  }
                },
                itemBuilder: (context, index) {
                  final scrollController = scrollControllers[index];

                  if (isRecruit && index < RecruitType.values.length) {
                    return RecruitItemListSection(
                      recruitType: RecruitType.values[index],
                      departmentCode: departmentCode,
                      onTapRecruitDetail: handleRecruitDetail,
                      scrollController: scrollController,
                    );
                  } else if (!isRecruit && index < MarketType.values.length) {
                    return MarketItemListSection(
                      marketType: MarketType.values[index],
                      onTapMarketDetail: handleMarketDetail,
                      scrollController: scrollController,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
