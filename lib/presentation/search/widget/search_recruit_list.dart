import 'package:dongsoop/core/presentation/components/common_recruit_list_item.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/presentation/search/view_models/search_recruit_view_model.dart';
import 'package:dongsoop/presentation/board/utils/scroll_listener.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchRecruitItemListSection extends HookConsumerWidget {
  final List<RecruitType> types;
  final String departmentName;
  final ScrollController scrollController;
  final Future<void> Function(int id, RecruitType type) onTapRecruitDetail;
  final String query;

  const SearchRecruitItemListSection({
    super.key,
    required this.types,
    required this.departmentName,
    required this.scrollController,
    required this.onTapRecruitDetail,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = searchRecruitViewModelProvider(
      types: types,
      departmentName: departmentName,
    );

    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final q = query.trim();
        if (q.isEmpty) {
          if (state.items.isNotEmpty || state.keyword.isNotEmpty) {
            viewModel.clear();
          }
        }
      });
      return null;
    }, [query, types, departmentName, state.items.isNotEmpty, state.keyword, viewModel]);

    useEffect(() {
      return setupScrollListener(
        scrollController: scrollController,
        getState: () => ref.read(provider),
        canFetchMore: (s) => query.trim().isNotEmpty && !s.isLoading && s.hasMore,
        fetchMore: () => viewModel.loadMore(),
      );
    }, [scrollController, provider, viewModel, query]);

    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: ColorStyles.primaryColor));
    }

    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            '${state.error}',
            style:
            TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!state.isLoading && state.items.isEmpty) {
      return Center(child: Text(
          '검색 결과가 없어요',
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
          textAlign: TextAlign.center),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.items.length,
      itemBuilder: (_, i) {
        final recruit = state.items[i];
        return CommonRecruitListItem(
          statusText: '모집 중',
          volunteerText: '${recruit.volunteer}명이 지원했어요',
          periodText: formatRecruitPeriod(recruit.startAt, recruit.endAt),
          title: recruit.title,
          content: recruit.content,
          tags: recruit.tags.split(',').where((t) => t.trim().isNotEmpty).toList(),
          onTapAsync: () async => onTapRecruitDetail(recruit.id, recruit.boardType),
          isLastItem: i == state.items.length - 1,
        );
      },
    );
  }
}
