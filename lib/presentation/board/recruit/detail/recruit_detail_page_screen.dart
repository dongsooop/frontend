import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/presentation/board/recruit/detail/view_models/recruit_detail_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/detail/widget/botton_button.dart';
import 'package:dongsoop/presentation/board/recruit/list/view_models/recruit_list_view_model.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecruitDetailPageScreen extends ConsumerWidget {
  final int id;
  final RecruitType type;
  final Future<bool?> Function() onTapRecruitApply;
  final void Function(String reportType, int targetId) onTapReport;
  final VoidCallback onTapApplicantList;

  const RecruitDetailPageScreen({
    required this.id,
    required this.type,
    required this.onTapRecruitApply,
    required this.onTapReport,
    required this.onTapApplicantList,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);

    final detailState = ref.watch(
      recruitDetailViewModelProvider(
        RecruitDetailArgs(id: id, type: type),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: DetailHeader(
            title: type.label,
            trailing: user == null
                ? null
                : detailState.maybeWhen(
                    data: (data) {
                      final viewType = data.recruitDetail?.viewType;
                      final isOwner = viewType == 'OWNER';

                      return IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          customActionSheet(
                            context,
                            deleteText: isOwner ? '삭제' : '신고',
                            onDelete: () {
                              if (isOwner) {
                                _showDeleteDialog(context, ref);
                              } else {
                                onTapReport(type.reportType.name, id);
                              }
                            },
                          );
                        },
                      );
                    },
                    orElse: () => null,
                  ),
          ),
        ),
        bottomNavigationBar: detailState.maybeWhen(
          data: (data) {
            final detail = data.recruitDetail;
            if (detail == null) return const SizedBox.shrink();

            final viewType = detail.viewType;
            final isAuthor = viewType == 'OWNER';
            final isGuest = viewType == 'GUEST';

            String buttonLabel;
            bool isEnabled = true;

            if (isAuthor) {
              buttonLabel = '지원자 확인';
            } else if (viewType == 'MEMBER' && detail.isAlreadyApplied) {
              buttonLabel = '지원 완료';
              isEnabled = false;
            } else {
              buttonLabel = '지원하기';
            }

            return RecruitBottomButton(
              label: buttonLabel,
              isEnabled: isEnabled,
              onPressed: () async {
                if (isAuthor) {
                  onTapApplicantList();
                } else if (isGuest) {
                  showDialog(
                    context: context,
                    builder: (_) => LoginRequiredDialog(),
                  );
                } else {
                  final didApply = await onTapRecruitApply();
                  if (didApply == true) {
                    ref.invalidate(
                      recruitDetailViewModelProvider(
                        RecruitDetailArgs(id: id, type: type),
                      ),
                    );
                  }
                }
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
        body: detailState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    showDialog(
      context: context,
      builder: (_) => CustomConfirmDialog(
        title: '게시글 삭제',
        content: '정말로 이 게시글을 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
        onConfirm: () async {
          final viewModel = ref.read(
            recruitDetailViewModelProvider(
              RecruitDetailArgs(id: id, type: type),
            ).notifier,
          );

          try {
            await viewModel.deleteRecruit(id, type);
            if (user == null) return;
            ref.invalidate(RecruitListViewModelProvider(
              type: type,
              departmentCode: user.departmentType,
            ));
            context.pop(true);
          } catch (e) {
            showDialog(
              context: context,
              builder: (_) => CustomConfirmDialog(
                title: '삭제 실패',
                content: '$e',
                confirmText: '확인',
                isSingleAction: true,
                onConfirm: () => context.pop(),
              ),
            );
          }
        },
      ),
    );
  }
}
