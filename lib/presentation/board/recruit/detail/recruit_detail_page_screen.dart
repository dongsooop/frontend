import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/auth/model/department_type_ext.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:dongsoop/presentation/board/recruit/detail/view_models/recruit_detail_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/detail/widget/botton_button.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecruitDetailPageScreen extends ConsumerWidget {
  const RecruitDetailPageScreen({super.key});

  String formatFullDateTime(DateTime dt) {
    return '${dt.year}. ${dt.month.toString().padLeft(2, '0')}. ${dt.day.toString().padLeft(2, '0')}. '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerState = GoRouterState.of(context);
    final extra = routerState.extra;

    if (extra is! Map<String, dynamic> ||
        extra['id'] is! int ||
        extra['type'] is! RecruitType) {
      return const Scaffold(
        body: Center(child: Text('잘못된 접근입니다.')),
      );
    }

    final args = RecruitDetailArgs(id: extra['id'], type: extra['type']);
    final detailState = ref.watch(recruitDetailViewModelProvider(args));
    final user = ref.watch(userSessionProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: DetailHeader(
            title: args.type.label,
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
        ),
        bottomNavigationBar: detailState.maybeWhen(
          data: (data) {
            final detail = data.recruitDetail;
            if (detail == null) return const SizedBox.shrink();

            final isAuthor = user?.nickname == detail.author;

            return RecruitBottomButton(
              label: isAuthor ? '지원자 확인' : '지원하기',
              onPressed: () {
                if (isAuthor) {
                  // TODO: 지원자 확인 화면 이동
                } else {
                  // TODO: 지원하기 처리
                }
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
        body: detailState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('에러: $e')),
          data: (data) {
            final detail = data.recruitDetail;
            if (detail == null) {
              return const Center(child: Text('상세정보가 없습니다.'));
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: ColorStyles.primary5,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '모집 중',
                            style: TextStyles.smallTextBold.copyWith(
                              color: ColorStyles.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          detail.title,
                          style: TextStyles.largeTextBold.copyWith(
                            color: ColorStyles.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${detail.volunteer}명이 지원했어요',
                            style: TextStyles.smallTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                        Text(formatFullDateTime(detail.createdAt),
                            style: TextStyles.smallTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: ColorStyles.gray2, height: 1),
                    const SizedBox(height: 24),
                    Text('모집 기간',
                        style: TextStyles.normalTextBold
                            .copyWith(color: ColorStyles.black)),
                    const SizedBox(height: 8),
                    Text(
                      '${formatFullDateTime(detail.startAt)} ~ ${formatFullDateTime(detail.endAt)}',
                      style: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.black),
                    ),
                    const SizedBox(height: 32),
                    Text(detail.content,
                        style: TextStyles.normalTextRegular
                            .copyWith(color: ColorStyles.black)),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            ...detail.tags
                                .split(',')
                                .map((tag) => tag.trim())
                                .where((tag) => tag.isNotEmpty)
                                .toList()
                                .asMap()
                                .entries
                                .map(
                                  (entry) => CommonTag(
                                    label: entry.value,
                                    index: entry.key,
                                  ),
                                ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          children: [
                            ...detail.departmentTypeList.map(
                              (dep) => CommonTag(
                                label: DepartmentTypeExtension.fromCode(dep)
                                    .displayName,
                                index: -1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
