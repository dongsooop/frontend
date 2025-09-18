import 'package:dongsoop/core/presentation/components/common_recruit_list_item.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/recruit/list/view_models/recruit_list_view_model.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/presentation/board/utils/scroll_listener.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecruitItemListSection extends HookConsumerWidget {
  final RecruitType recruitType;
  final String departmentCode;
  final Future<void> Function(int id, RecruitType type) onTapRecruitDetail;
  final ScrollController scrollController;

  const RecruitItemListSection({
    super.key,
    required this.recruitType,
    required this.departmentCode,
    required this.onTapRecruitDetail,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = recruitListViewModelProvider(
      type: recruitType,
      departmentCode: departmentCode,
    );

    final state = ref.watch(viewModelProvider);
    final viewModel = ref.read(viewModelProvider.notifier);

    useEffect(() {
      return setupScrollListener(
        scrollController: scrollController,
        getState: () => ref.read(viewModelProvider),
        canFetchMore: (s) => !s.isLoading && s.hasMore,
        fetchMore: () => viewModel.loadNextPage(),
      );
    }, [recruitType, departmentCode, scrollController]);

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

    if (state.isLoading && state.posts.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: ColorStyles.primaryColor));
    }

    if (state.posts.isEmpty) {
      return const Center(child: Text('모집 중인 게시글이 없어요!'));
    }

    return RefreshIndicator(
      color: ColorStyles.primaryColor,
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        key: PageStorageKey(recruitType.name),
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.posts.length + ((state.hasMore && state.isLoading) ? 1 : 0),
        itemBuilder: (context, index) {
          final showLoading =
              index == state.posts.length && state.hasMore && state.isLoading;

          if (showLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: CircularProgressIndicator(
                      color: ColorStyles.primaryColor)),
            );
          }

          final recruit = state.posts[index];
          final isLast = index == state.posts.length - 1;

          return RecruitListItem(
            recruit: recruit,
            isLastItem: isLast,
            onTap: () async => onTapRecruitDetail(recruit.id, recruitType),
          );
        },
      ),
    );
  }
}

class RecruitListItem extends StatelessWidget {
  final RecruitListEntity recruit;
  final Future<void> Function() onTap;
  final bool isLastItem;

  const RecruitListItem({
    super.key,
    required this.recruit,
    required this.onTap,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = '모집 중';
    final volunteerText = '${recruit.volunteer}명이 지원했어요';
    final periodText = formatRecruitPeriod(recruit.startAt, recruit.endAt);

    final rawTags =
        recruit.tags.split(',').where((tag) => tag.trim().isNotEmpty).toList();
    final tags = rawTags.isEmpty ? [''] : rawTags;

    return CommonRecruitListItem(
      statusText: statusText,
      volunteerText: volunteerText,
      periodText: periodText,
      title: recruit.title,
      content: recruit.content,
      tags: tags,
      onTapAsync: onTap,
      isLastItem: isLastItem,
    );
  }
}
