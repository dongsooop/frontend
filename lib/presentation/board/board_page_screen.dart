import 'package:dongsoop/core/presentation/components/common_tap_section.dart';
import 'package:dongsoop/core/presentation/components/single_action_dialog.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/timezone/providers/check_time_zone_use_case_provider.dart';
import 'package:dongsoop/presentation/board/common/components/board_write_button.dart';
import 'package:dongsoop/presentation/board/market/list/market_list_item.dart';
import 'package:dongsoop/presentation/board/market/list/search_market_list.dart';
import 'package:dongsoop/presentation/board/market/list/view_model/market_list_view_model.dart';
import 'package:dongsoop/presentation/board/providers/board_taps_provider.dart';
import 'package:dongsoop/presentation/board/providers/post_update_provider.dart';
import 'package:dongsoop/presentation/board/recruit/list/recruit_list_item.dart';
import 'package:dongsoop/presentation/board/recruit/list/search_recruit_list.dart';
import 'package:dongsoop/presentation/board/recruit/list/view_models/recruit_list_view_model.dart';
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
    final tabState = ref.watch(boardTabProvider);
    final tabNotifier = ref.read(boardTabProvider.notifier);

    final scrollControllers =
        useMemoized(() => List.generate(5, (_) => ScrollController()));
    final recruitController = useMemoized(
          () => PageController(initialPage: ref.read(boardTabProvider).recruitTabIndex),
    );
    final marketController = useMemoized(
          () => PageController(initialPage: ref.read(boardTabProvider).marketTabIndex),
    );

    final searchCtrl = useTextEditingController();
    final keyword = useState('');
    final isSearching = useState(false);

    useEffect(() {
      isSearching.value = false;
      keyword.value = '';
      return null;
    }, const []);

    final isRecruit = tabState.categoryIndex == 0;
    final currentSubTabs = isRecruit ? recruitSubTabs : marketSubTabs;
    final selectedSubIndex =
    isRecruit ? tabState.recruitTabIndex : tabState.marketTabIndex;

    final pageController = isRecruit ? recruitController : marketController;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!pageController.hasClients) return;
        final target = selectedSubIndex;
        final current = pageController.page?.round();
        if (current != target) {
          pageController.jumpToPage(target);
        }
      });
      return null;
    }, [isRecruit, selectedSubIndex]);

    final user = ref.watch(userSessionProvider);
    String departmentCode = '';
    String departmentName = '';
    if (user != null) {
      final dept = DepartmentTypeExtension.fromDisplayName(user.departmentType);
      departmentCode = dept.code;
      departmentName = dept.displayName;
    }

    final safeIndex = selectedSubIndex.clamp(0, currentSubTabs.length - 1);

    final recruitType =
    isRecruit && safeIndex < RecruitType.values.length ? RecruitType.values[safeIndex] : null;

    final marketType =
    !isRecruit && safeIndex < MarketType.values.length ? MarketType.values[safeIndex] : null;

    Future<void> handleWriteAction() async {
      final user = ref.watch(userSessionProvider);
      if (user == null) {
        await LoginRequiredDialog(context);
        return;
      }

      final isAllowed = await ref.read(checkTimeZoneUseCaseProvider).isUserTimezone();

      if (!isAllowed) {
        await SingleActionDialog(
          context,
          title: '현재 시간대가 달라요.',
          content: '한국 시간대로 변경 후에\n사용해주세요.',
          confirmText: '확인',
          onConfirm: () {},
        );
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
      final wasSearching = isSearching.value;
      final didApply = await onTapRecruitDetail(id, type);

      final deletedIds = ref.read(deletedRecruitIdsProvider);
      final isDeleted = deletedIds.contains(id);

      if ((didApply || isDeleted) && recruitType != null) {
        if (wasSearching) {
          await ref
              .read(
            recruitListViewModelProvider(
              type: recruitType,
              departmentCode: departmentCode,
            ).notifier,
          )
              .refresh();

          final controller = scrollControllers[safeIndex];
          if (controller.hasClients) controller.jumpTo(0);
          searchCtrl.clear();
          keyword.value = '';
          isSearching.value = false;
          FocusManager.instance.primaryFocus?.unfocus();

          if (isDeleted) {
            ref.read(deletedRecruitIdsProvider.notifier).update((_) => {});
          }
          return;
        } else {
          await ref
              .read(
            recruitListViewModelProvider(
              type: recruitType,
              departmentCode: departmentCode,
            ).notifier,
          )
              .refresh();

          final controller = scrollControllers[safeIndex];
          if (controller.hasClients) controller.jumpTo(0);

          if (isDeleted) {
            ref.read(deletedRecruitIdsProvider.notifier).update((_) => {});
          }
        }
      } else {
        if (isDeleted) {
          ref.read(deletedRecruitIdsProvider.notifier).update((_) => {});
        }
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

    Future<void> performSearch(String kw) async {
      final q = kw.trim();
      if (q.isEmpty) return;
      keyword.value = q;
      isSearching.value = true;
    }

    void cancelSearch() {
      searchCtrl.clear();
      keyword.value = '';
      isSearching.value = false;
      FocusManager.instance.primaryFocus?.unfocus();
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
                selectedCategoryIndex: tabState.categoryIndex,
                selectedSubTabIndex: safeIndex,
                subTabs: currentSubTabs,
                onCategorySelected: (newIndex) {
                  if (isSearching.value) cancelSearch();
                  tabNotifier.setCategoryIndex(newIndex);
                },
                onSubTabSelected: (newSubIndex) {
                  if (isSearching.value) cancelSearch();
                  if (isRecruit) {
                    tabNotifier.setRecruitTabIndex(newSubIndex);
                    recruitController.jumpToPage(newSubIndex);
                  } else {
                    tabNotifier.setMarketTabIndex(newSubIndex);
                    marketController.jumpToPage(newSubIndex);
                  }
                },
                showHelpIcon: isRecruit,
                onHelpPressed: () {
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.removeCurrentSnackBar();
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('현재 모집 중인 게시글만 보여져요.'),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: ColorStyles.black,
                    ),
                  );
                },
                searchController: searchCtrl,
                isSearching: isSearching.value,
                onSearch: performSearch,
                onCancel: cancelSearch,
              ),
            ),
            Expanded(
              child: PageView.builder(
                key: ValueKey(isRecruit ? 'pv-recruit' : 'pv-market'),
                controller: pageController,
                itemCount: currentSubTabs.length,
                onPageChanged: (index) {
                  if (isRecruit) {
                    tabNotifier.setRecruitTabIndex(index);
                  } else {
                    tabNotifier.setMarketTabIndex(index);
                  }
                },
                itemBuilder: (context, index) {
                  final isActive = index == safeIndex;
                  final controller = scrollControllers[index];
                  if (!isActive) return const SizedBox.shrink();

                  if (isSearching.value) {
                    if (isRecruit && index < RecruitType.values.length) {
                      return SearchRecruitItemListSection(
                        key: ValueKey(
                          'search-recruit-${RecruitType.values[index].name}-${keyword.value}',
                        ),
                        recruitType: RecruitType.values[index],
                        departmentName: departmentName,
                        scrollController: controller,
                        onTapRecruitDetail: handleRecruitDetail,
                        query: keyword.value,
                      );
                    } else if (!isRecruit && index < MarketType.values.length) {
                      return SearchMarketItemListSection(
                        key: ValueKey(
                          'search-market-${MarketType.values[index].name}-${keyword.value}',
                        ),
                        marketType: MarketType.values[index],
                        scrollController: controller,
                        onTapMarketDetail: handleMarketDetail,
                        query: keyword.value,
                      );
                    }
                  } else {
                    if (isRecruit && index < RecruitType.values.length) {
                      return RecruitItemListSection(
                        key: ValueKey(
                          'recruit-${RecruitType.values[index].name}-$departmentCode',
                        ),
                        recruitType: RecruitType.values[index],
                        departmentCode: departmentCode,
                        onTapRecruitDetail: handleRecruitDetail,
                        scrollController: controller,
                      );
                    } else if (!isRecruit && index < MarketType.values.length) {
                      return MarketItemListSection(
                        key: ValueKey('market-${MarketType.values[index].name}'),
                        marketType: MarketType.values[index],
                        onTapMarketDetail: handleMarketDetail,
                        scrollController: controller,
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}