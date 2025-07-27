import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
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
  final String? status;
  final void Function(UiChatRoom chatRoom) onTapChatDetail;

  const RecruitDetailPageScreen({
    required this.id,
    required this.type,
    required this.onTapRecruitApply,
    required this.onTapReport,
    required this.onTapApplicantList,
    this.status = '모집 중',
    required this.onTapChatDetail,
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

    return Scaffold(
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
                await LoginRequiredDialog(context);
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
            onIconPressed: () async {
              if (isAuthor) {
                showDialog(
                  context: context,
                  builder: (_) => CustomConfirmDialog(
                    title: '모집 문의',
                    content: '자기 자신과 채팅은 불가능해요.',
                    isSingleAction: true,
                    confirmText: '확인',
                    onConfirm: () async {},
                  ),
                );
              } else if (isGuest) {
                await LoginRequiredDialog(context);
              } else {
                showDialog(
                  context: context,
                  builder: (_) => CustomConfirmDialog(
                      title: '모집 문의',
                      content: '작성자에게 모집글과 관련한 문의를 할 수 있어요',
                      confirmText: '문의하기',
                      onConfirm: () async {
                        final viewModel = ref.read(
                          recruitDetailViewModelProvider(
                            RecruitDetailArgs(id: id, type: type),
                          ).notifier,
                        );

                        final chatRoom = await viewModel.createChatRoom(
                            detail.title, detail.authorId);
                        onTapChatDetail(chatRoom);
                      }),
                );
              }
            },
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: detailState.when(
          loading: () => const Center(
              child:
                  CircularProgressIndicator(color: ColorStyles.primaryColor)),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$e',
                    style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          data: (data) {
            final detail = data.recruitDetail;
            if (detail == null) {
              return const Center(child: Text('상세정보가 없습니다.'));
            }

            final allDepartments = DepartmentType.values
                .where((e) => e != DepartmentType.Unknown)
                .map((e) => e.code)
                .toSet();

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
                            color: (status ?? '모집 중') == '모집 중'
                                ? ColorStyles.primary5
                                : ColorStyles.gray1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status ?? '모집 중',
                            style: TextStyles.smallTextBold.copyWith(
                              color: (status ?? '모집 중') == '모집 중'
                                  ? ColorStyles.primaryColor
                                  : ColorStyles.gray3,
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
                          spacing: 4,
                          runSpacing: 8,
                          children: [
                            if (detail.departmentTypeList
                                .toSet()
                                .containsAll(allDepartments))
                              const CommonTag(
                                label: '전체 학과',
                                index: -1,
                              )
                            else
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
                onConfirm: () async {
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        },
      ),
    );
  }
}
