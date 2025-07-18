import 'package:dongsoop/core/presentation/components/common_recruit_list_item.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/recruit/list/view_models/recruit_list_view_model.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecruitItemListSection extends ConsumerWidget {
  final RecruitType recruitType;
  final String departmentCode;
  final void Function(int id, RecruitType type) onTapRecruitDetail;
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

    // 상태 처리
    if (state.error != null) {
      return Center(child: Text('에러: ${state.error}'));
    }

    if (state.isLoading && state.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 추후 수정
    if (state.posts.isEmpty) {
      return const Center(child: Text('모집 중인 게시글이 없어요!'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(viewModelProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.posts.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.posts.length && state.hasMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final recruit = state.posts[index];
          final isLast = index == state.posts.length - 1;

          return RecruitListItem(
            recruit: recruit,
            isLastItem: isLast,
            onTap: () => onTapRecruitDetail(recruit.id, recruitType),
          );
        },
      ),
    );
  }
}

class RecruitListItem extends StatelessWidget {
  final RecruitListEntity recruit;
  final VoidCallback onTap;
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

    final tags = recruit.tags.split(',');

    return CommonRecruitListItem(
      statusText: statusText,
      volunteerText: volunteerText,
      periodText: periodText,
      title: recruit.title,
      content: recruit.content,
      tags: tags,
      onTap: onTap,
      isLastItem: isLastItem,
    );
  }
}
