import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/common_recruit_list_item.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/providers/activity_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';

class ActivityRecruitScreen extends HookConsumerWidget {
  final bool isApply;
  final Future<bool> Function(int id, RecruitType type, String status) onTapRecruitDetail;

  const ActivityRecruitScreen({
    super.key,
    required this.isApply,
    required this.onTapRecruitDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityRecruitState = ref.watch(activityRecruitViewModelProvider);
    final viewModel = ref.read(activityRecruitViewModelProvider.notifier);

    final scrollController = useScrollController();
    final posts = activityRecruitState.posts ?? [];

    useEffect(() {
      Future.microtask(() async {
        await viewModel.loadPosts(isApply);
      });
      return null;
    }, []);

    useEffect(() {
      void scrollListener() {
        if (!scrollController.hasClients) return;
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          viewModel.fetchNextPage(isApply);
        }
      }
      scrollController.addListener(scrollListener);

      return () {
        scrollController.removeListener(scrollListener);
      };
    }, [scrollController]);
    // 오류
    useEffect(() {
      if (activityRecruitState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '마이페이지 오류',
              content: activityRecruitState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [activityRecruitState.errorMessage]);

    // 로딩 상태 표시
    if (activityRecruitState.isLoading) {
      return Scaffold(
        backgroundColor: ColorStyles.white,
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(color: ColorStyles.primaryColor,),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: isApply ? '지원한 모집글' : '개설한 모집글',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final isLast = index == posts.length - 1;
                    final volunteerText = '${post.volunteer}명이 지원했어요';
                    final periodText = formatRecruitPeriod(post.startAt, post.endAt);

                    return CommonRecruitListItem(
                      statusText: post.status,
                      volunteerText: volunteerText,
                      periodText: periodText,
                      title: post.title,
                      content: post.content,
                      tags: post.tags,
                      onTap: () async {
                        final isDeleted = await onTapRecruitDetail(post.id, post.boardType, post.status);
                        if (isDeleted) {
                          await viewModel.loadPosts(isApply);
                        }
                      },
                      isLastItem: isLast,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
