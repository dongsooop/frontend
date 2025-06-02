import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/utils/department_mapper.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:dongsoop/presentation/board/recruit/detail/providers/recruit_detail_view_model_provider.dart';
import 'package:dongsoop/presentation/board/recruit/detail/widget/botton_button.dart';
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

  Widget _buildStatusTag(bool isOpen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: ColorStyles.primary5,
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isOpen ? '모집 중' : '모집 완료',
        style:
            TextStyles.smallTextBold.copyWith(color: ColorStyles.primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = GoRouterState.of(context);
    final extra = state.extra;

    if (extra is! Map<String, dynamic> ||
        extra['id'] is! int ||
        extra['type'] is! RecruitType) {
      return const Scaffold(
        body: Center(
          child: Text('잘못된 접근입니다.'),
        ),
      );
    }

    final int id = extra['id'];
    final RecruitType type = extra['type'];

    final viewModelState =
        ref.watch(recruitDetailViewModelProvider((type, id)));
    final recruitDetail = viewModelState.recruitDetail;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: DetailHeader(
            title: type.label,
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              iconSize: 24.0,
              onPressed: () {},
            ),
          ),
        ),
        bottomNavigationBar: BottomButton(
          label: '지원하기',
          onPressed: () {},
        ),
        body: viewModelState.isLoading || recruitDetail == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(recruitDetail.title,
                          style: TextStyles.largeTextBold
                              .copyWith(color: ColorStyles.black)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${recruitDetail.volunteer}명이 지원했어요',
                              style: TextStyles.smallTextRegular
                                  .copyWith(color: ColorStyles.gray4)),
                          Text('${formatFullDateTime(recruitDetail.createdAt)}',
                              style: TextStyles.smallTextRegular
                                  .copyWith(color: ColorStyles.gray4)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: ColorStyles.gray2, height: 1),
                      const SizedBox(height: 24),
                      // 재학생 인증 추가시 사용
                      // Row(
                      //   children: [
                      //     Icon(Icons.task_alt,
                      //         size: 16, color: ColorStyles.primaryColor),
                      //     const SizedBox(width: 8),
                      //     Text(
                      //       '재학생 인증이 완료된 사용자예요',
                      //       style: TextStyles.smallTextRegular
                      //           .copyWith(color: ColorStyles.gray4),
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(height: 24),
                      Text('모집 기간',
                          style: TextStyles.normalTextBold
                              .copyWith(color: ColorStyles.black)),
                      const SizedBox(height: 8),
                      Text(
                        '${formatFullDateTime(recruitDetail.startAt)} ~ ${formatFullDateTime(recruitDetail.endAt)}',
                        style: TextStyles.normalTextRegular
                            .copyWith(color: ColorStyles.black),
                      ),
                      const SizedBox(height: 32),
                      Text(recruitDetail.content,
                          style: TextStyles.normalTextRegular
                              .copyWith(color: ColorStyles.black)),
                      const SizedBox(height: 24),
                      Wrap(
                        children: [
                          ...recruitDetail.tags
                              .split(',')
                              .map((tag) => tag.trim())
                              .toList()
                              .asMap()
                              .entries
                              .map(
                                (entry) => CommonTag(
                                  label: entry.value,
                                  index: entry.key,
                                ),
                              ),

                          // 학과 (회색 고정)
                          ...recruitDetail.departmentTypeList.map(
                            (dep) => CommonTag(
                              label: DepartmentMapper.getName(dep) ?? dep,
                              index: -1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
