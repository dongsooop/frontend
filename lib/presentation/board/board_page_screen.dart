import 'package:dongsoop/core/presentation/components/single_action_dialog.dart';
import 'package:dongsoop/core/presentation/components/common_tap_section.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/timezone/providers/check_time_zone_use_case_provider.dart';
import 'package:dongsoop/presentation/board/common/components/board_write_button.dart';
import 'package:dongsoop/presentation/board/market/list/market_list_item.dart';
import 'package:dongsoop/presentation/board/market/list/view_model/market_list_view_model.dart';
import 'package:dongsoop/presentation/board/providers/board_taps_provider.dart';
import 'package:dongsoop/presentation/board/providers/post_update_provider.dart';
import 'package:dongsoop/presentation/board/recruit/list/recruit_list_item.dart';
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
    final pageController = usePageController();

    final isRecruit = tabState.categoryIndex == 0;
    final currentSubTabs = isRecruit ? recruitSubTabs : marketSubTabs;
    final selectedSubIndex =
        isRecruit ? tabState.recruitTabIndex : tabState.marketTabIndex;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentPage =
        pageController.hasClients ? pageController.page?.round() : null;
        if (currentPage != selectedSubIndex) {
          pageController.jumpToPage(selectedSubIndex);
        }
      });
      return null;
    }, [tabState.categoryIndex]);

    final user = ref.watch(userSessionProvider);
    final departmentCode = user != null
        ? DepartmentTypeExtension.fromDisplayName(user.departmentType).code
        : '';

    final safeIndex = selectedSubIndex.clamp(0, currentSubTabs.length - 1);

    final recruitType = isRecruit && safeIndex < RecruitType.values.length
        ? RecruitType.values[safeIndex]
        : null;

    final deletedRecruitIds = ref.watch(deletedRecruitIdsProvider);

    useEffect(() {
      if (deletedRecruitIds.isNotEmpty && isRecruit && recruitType != null) {
        Future.microtask(() async {
          await ref.read(
            recruitListViewModelProvider(
              type: recruitType,
              departmentCode: departmentCode,
            ).notifier,
          ).refresh();
          ref.read(deletedRecruitIdsProvider.notifier).update((_) => {});
        });
      }
      return null;
    }, [deletedRecruitIds, isRecruit, recruitType, departmentCode]);


    final marketType = !isRecruit && safeIndex < MarketType.values.length
        ? MarketType.values[safeIndex]
        : null;

    final editedMarketIds = ref.watch(editedMarketIdsProvider);

    useEffect(() {
      if (editedMarketIds.isNotEmpty && !isRecruit && marketType != null) {
        Future.microtask(() async {
          await ref.read(
            marketListViewModelProvider(type: marketType).notifier,
          ).refresh();

          ref.read(editedMarketIdsProvider.notifier).update((_) => {});
        });
      }
      return null;
    }, [editedMarketIds, isRecruit, marketType]);

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
          await ref
              .read(
                recruitListViewModelProvider(
                  type: recruitType,
                  departmentCode: departmentCode,
                ).notifier,
              )
              .refresh();
        } else if (marketType != null) {
          await ref
              .read(
                marketListViewModelProvider(type: marketType).notifier,
              )
              .refresh();
        }
      }
    }

    Future<void> handleRecruitDetail(int id, RecruitType type) async {
      final didApply = await onTapRecruitDetail(id, type);

      final deletedIds = ref.read(deletedRecruitIdsProvider);
      final isDeleted = deletedIds.contains(id);

      if ((didApply || isDeleted) && recruitType != null) {
        // 삭제된 항목 목록을 반영해서 refresh
        await ref.read(
          recruitListViewModelProvider(
            type: recruitType,
            departmentCode: departmentCode,
          ).notifier,
        ).refresh();
      }

      if (isDeleted) {
        // 삭제 처리 후, 전역 상태 초기화
        ref.read(deletedRecruitIdsProvider.notifier).update((_) => {});
      }
    }

    Future<void> handleMarketDetail(int id, MarketType type) async {
      final didComplete = await onTapMarketDetail(id, type);
      if (didComplete && marketType != null) {
        await ref
            .read(
              marketListViewModelProvider(type: marketType).notifier,
            )
            .refresh();
      }
    }

    final lastRetapAt = useRef<DateTime?>(null);

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
                  tabNotifier.setCategoryIndex(newIndex);
                },
                onSubTabSelected: (newSubIndex) {
                  final currentIndex = isRecruit
                      ? tabState.recruitTabIndex
                      : tabState.marketTabIndex;
                  final isSameIndex = newSubIndex == currentIndex;

                  if (isRecruit) {
                    tabNotifier.setRecruitTabIndex(newSubIndex);
                  } else {
                    tabNotifier.setMarketTabIndex(newSubIndex);
                  }

                  final delta = (newSubIndex - currentIndex).abs();
                  if (delta > 1) {
                    pageController.jumpToPage(newSubIndex);
                  } else {
                    pageController.animateToPage(
                      newSubIndex,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  }

                  if (!isSameIndex) return;

                  final controller = scrollControllers[newSubIndex];
                  final now = DateTime.now();
                  if (lastRetapAt.value == null ||
                      now.difference(lastRetapAt.value!) >
                          const Duration(milliseconds: 800)) {
                    lastRetapAt.value = now;

                    Future.microtask(() async {
                      if (isRecruit && newSubIndex < RecruitType.values.length) {
                        final type = RecruitType.values[newSubIndex];
                        final deletedIds = ref.read(deletedRecruitIdsProvider);

                        // 삭제된 게시글 ID가 있는 경우 무조건 refresh
                        if (deletedIds.isNotEmpty) {
                          await ref.read(recruitListViewModelProvider(
                            type: type,
                            departmentCode: departmentCode,
                          ).notifier).refresh();

                          // 삭제 ID 초기화
                          ref.read(deletedRecruitIdsProvider.notifier).update((_) => {});
                        } else {
                          await ref
                              .read(recruitListViewModelProvider(
                            type: type,
                            departmentCode: departmentCode,
                          ).notifier)
                              .refresh();
                        }
                      } else if (!isRecruit && newSubIndex < MarketType.values.length) {
                        final type = MarketType.values[newSubIndex];
                        await ref.read(marketListViewModelProvider(type: type).notifier).refresh();
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (controller.hasClients) {
                          controller.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    });
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
              ),
            ),
            Expanded(
              child: PageView.builder(
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
                  final scrollController = scrollControllers[index];

                  if (isRecruit && index < RecruitType.values.length) {
                    return isActive
                        ? RecruitItemListSection(
                      recruitType: RecruitType.values[index],
                      departmentCode: departmentCode,
                      onTapRecruitDetail: handleRecruitDetail,
                      scrollController: scrollController,
                    )
                        : const SizedBox.expand();
                  } else if (!isRecruit &&
                      index < MarketType.values.length) {
                    return isActive
                        ? MarketItemListSection(
                      marketType: MarketType.values[index],
                      onTapMarketDetail: handleMarketDetail,
                      scrollController: scrollController,
                    )
                        : const SizedBox.expand();
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
