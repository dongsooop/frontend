import 'package:dongsoop/core/presentation/components/common_tap_section.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
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
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardPageScreen extends HookConsumerWidget {
  final void Function(int id, RecruitType type) onTapRecruitDetail;
  final void Function(int id, MarketType type) onTapMarketDetail;

  const BoardPageScreen({
    super.key,
    required this.onTapRecruitDetail,
    required this.onTapMarketDetail,
  });

  static const categoryTabs = ['모집', '장터'];
  static const recruitSubTabs = ['튜터링', '스터디', '프로젝트'];
  static const marketSubTabs = ['판매', '구매'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final selectedSubIndex = useState(0);
    final scrollController = useScrollController();

    final isRecruit = selectedIndex.value == 0;
    final currentSubTabs = isRecruit ? recruitSubTabs : marketSubTabs;

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
      if (isRecruit && recruitType != null) {
        final provider = recruitListViewModelProvider(
          type: recruitType,
          departmentCode: departmentCode,
        );
        final notifier = ref.read(provider.notifier);

        return setupScrollListener(
          scrollController: scrollController,
          getState: () => ref.read(provider),
          canFetchMore: (state) => !state.isLoading && state.hasMore,
          fetchMore: () => notifier.loadNextPage(),
        );
      } else if (!isRecruit && marketType != null) {
        final provider = marketListViewModelProvider(type: marketType);
        final notifier = ref.read(provider.notifier);

        return setupScrollListener(
          scrollController: scrollController,
          getState: () => ref.read(provider),
          canFetchMore: (state) => !state.isLoading && state.hasMore,
          fetchMore: () => notifier.fetchNext(),
        );
      }
      return null;
    }, [
      scrollController,
      selectedIndex.value,
      selectedSubIndex.value,
      departmentCode,
    ]);

    Future<void> handleWriteAction() async {
      final user = ref.watch(userSessionProvider);
      if (user == null) {
        await LoginRequiredDialog(context);
        return;
      }

      final result = isRecruit
          ? await context.push<bool>(RoutePaths.recruitWrite)
          : await context.push<bool>(
              RoutePaths.marketWrite,
              extra: {
                'isEditing': false,
                'marketId': null,
              },
            );

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

    Future<void> onTapRecruitDetail(int id, RecruitType type) async {
      final didApply = await context.push<bool>(
        RoutePaths.recruitDetail,
        extra: {'id': id, 'type': type},
      );

      if (didApply == true) {
        ref
            .read(
              recruitListViewModelProvider(
                type: type,
                departmentCode: departmentCode,
              ).notifier,
            )
            .refresh();
      }
    }

    Future<void> onTapMarketDetail(int id, MarketType type) async {
      final didComplete = await context.push<bool>(
        RoutePaths.marketDetail,
        extra: {'id': id, 'type': type},
      );

      if (didComplete == true) {
        ref
            .read(
              marketListViewModelProvider(type: type).notifier,
            )
            .refresh();
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        floatingActionButton: WriteButton(
          onPressed: handleWriteAction,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoardTabSection(
                categoryTabs: categoryTabs,
                selectedCategoryIndex: selectedIndex.value,
                selectedSubTabIndex: safeIndex,
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
              child: isRecruit && recruitType != null
                  ? RecruitItemListSection(
                      recruitType: recruitType,
                      departmentCode: departmentCode,
                      onTapRecruitDetail: onTapRecruitDetail,
                      scrollController: scrollController,
                    )
                  : !isRecruit && marketType != null
                      ? MarketItemListSection(
                          marketType: marketType,
                          onTapMarketDetail: onTapMarketDetail,
                          scrollController: scrollController,
                        )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
