import 'package:dongsoop/core/presentation/components/common_img_style.dart';
import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/common_tap_section.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/board/recruit/entities/list/recruit_list_entity.dart';
import 'package:dongsoop/presentation/board/common/board_write_button.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:dongsoop/presentation/board/market/temp/temp_market_data.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_list_view_model_provider.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_project_data.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_study_data.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BoardPageScreen extends ConsumerStatefulWidget {
  final void Function(int id, RecruitType type) onTapRecruitDetail;
  const BoardPageScreen({super.key, required this.onTapRecruitDetail});

  @override
  ConsumerState<BoardPageScreen> createState() => _BoardPageScreenState();
}

class _BoardPageScreenState extends ConsumerState<BoardPageScreen> {
  int selectedIndex = 0;
  int selectedSubIndex = 0;
  final ScrollController _scrollController = ScrollController();

  RecruitType get recruitType {
    switch (selectedSubIndex) {
      case 0:
        return RecruitType.tutoring;
      case 1:
        return RecruitType.study;
      case 2:
        return RecruitType.project;
      default:
        throw Exception('Invalid sub index');
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100;
    final isRecruit = selectedIndex == 0 && selectedSubIndex == 0;
    if (isBottom && isRecruit) {
      ref
          .read(recruitListViewModelProvider(RecruitType.tutoring).notifier)
          .loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecruit = selectedIndex == 0;
    final isTutoring = isRecruit && selectedSubIndex == 0;

    final state = isTutoring
        ? ref.watch(recruitListViewModelProvider(recruitType))
        : null;
    final tutorList = isTutoring ? state?.posts ?? [] : [];
    final list = isRecruit
        ? isTutoring
            ? tutorList
            : selectedSubIndex == 1
                ? studyList
                : projectList
        : marketList;

    final hasMore = state?.hasMore ?? false;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        floatingActionButton: WriteButton(
          onPressed: () {
            final route = isRecruit ? RoutePaths.recruitWrite : '/market/write';
            context.push(route);
          },
        ),
        body: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: hasMore ? list.length + 2 : list.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return BoardTabSection(
                categoryTabs: ['모집', '장터'],
                selectedCategoryIndex: selectedIndex,
                selectedSubTabIndex: selectedSubIndex,
                subTabs: isRecruit ? ['튜터링', '스터디', '프로젝트'] : ['판매', '구매'],
                onCategorySelected: (selectIndex) {
                  setState(() {
                    selectedIndex = selectIndex;
                    selectedSubIndex = 0;
                  });
                },
                onSubTabSelected: (subIndex) {
                  setState(() {
                    selectedSubIndex = subIndex;
                  });
                },
              );
            }

            if (index == list.length + 1 && hasMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final isLast = index - 1 == list.length - 1;

            if (isRecruit && isTutoring) {
              final RecruitListEntity recruit = list[index - 1];
              return RecruitListItem(
                recruit: recruit,
                isLastItem: isLast,
                onTap: () => widget.onTapRecruitDetail(recruit.id, recruitType),
              );
            } else if (isRecruit) {
              final data = list[index - 1];
              return Text(data['title'] ?? '');
            } else {
              final market = list[index - 1];
              return MarketListItem(
                market: market,
                isLastItem: isLast,
                onTap: () {},
              );
            }
          },
        ),
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.task_alt,
                            size: 16, color: ColorStyles.primaryColor),
                        const SizedBox(width: 4),
                        if (recruit.state)
                          Text('모집 중',
                              style: TextStyles.smallTextBold
                                  .copyWith(color: ColorStyles.black)),
                        const SizedBox(width: 8),
                        Text('${recruit.volunteer}명이 지원했어요',
                            style: TextStyles.smallTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                      ],
                    ),
                    Text(
                      '${recruit.startAt.month.toString().padLeft(2)}. ${recruit.startAt.day.toString().padLeft(2)}. ~ ${recruit.endAt.month.toString().padLeft(2)}. ${recruit.endAt.day.toString().padLeft(2)}.',
                      style: TextStyles.smallTextRegular
                          .copyWith(color: ColorStyles.gray4),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(recruit.title,
                    style: TextStyles.largeTextBold
                        .copyWith(color: ColorStyles.black)),
                const SizedBox(height: 8),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Text(
                    recruit.content,
                    style: TextStyles.smallTextRegular
                        .copyWith(color: ColorStyles.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  children: recruit.tags
                      .split(',')
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
          if (!isLastItem) const Divider(color: ColorStyles.gray2, height: 1),
        ],
      ),
    );
  }
}

class MarketListItem extends StatelessWidget {
  final Map<String, dynamic> market;
  final VoidCallback onTap;
  final bool isLastItem;

  const MarketListItem({
    super.key,
    required this.market,
    required this.onTap,
    required this.isLastItem,
  });

  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return '방금 전';
    if (difference.inMinutes < 60) return '${difference.inMinutes}분 전';
    if (difference.inHours < 24) return '${difference.inHours}시간 전';
    if (difference.inDays < 7) return '${difference.inDays}일 전';

    return '${dateTime.year}. ${dateTime.month}. ${dateTime.day}. ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final imageList = market['images'];
    final hasImage =
        imageList != null && imageList is List && imageList.isNotEmpty;
    final firstImage = hasImage ? imageList.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonImgStyle(imagePath: hasImage ? firstImage : null),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(market['market_title'] ?? '',
                          style: TextStyles.largeTextRegular
                              .copyWith(color: ColorStyles.black)),
                      Text(
                        formatRelativeTime(
                            market['market_created_at'] ?? DateTime.now()),
                        style: TextStyles.smallTextRegular
                            .copyWith(color: ColorStyles.gray4),
                      ),
                      Text('${market['market_prices'] ?? 0}원',
                          style: TextStyles.largeTextBold
                              .copyWith(color: ColorStyles.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLastItem) const Divider(color: ColorStyles.gray2, height: 1),
        ],
      ),
    );
  }
}
