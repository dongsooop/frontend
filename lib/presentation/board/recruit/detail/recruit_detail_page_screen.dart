import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/chat/model/chat_room_request.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/presentation/board/providers/post_update_provider.dart';
import 'package:dongsoop/presentation/board/recruit/detail/view_models/recruit_detail_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/detail/widget/botton_button.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/presentation/home/providers/home_update_provider.dart';
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
  final VoidCallback onTapApplicantDetail;
  final String? status;
  final void Function(String roomId) onTapChatDetail;

  const RecruitDetailPageScreen({
    required this.id,
    required this.type,
    required this.onTapRecruitApply,
    required this.onTapReport,
    required this.onTapApplicantList,
    required this.onTapApplicantDetail,
    this.status = '모집 중',
    required this.onTapChatDetail,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(
      recruitDetailViewModelProvider(
        RecruitDetailArgs(id: id, type: type),
      ),
    );

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: type.label,
        trailing: detailState.maybeWhen(
          data: (data) {
            final viewType = data.recruitDetail?.viewType;
            if (viewType == 'GUEST' || viewType == null) return null;

            final isOwner = viewType == 'OWNER';

            return IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                if (isOwner) {
                  customActionSheet(
                    context,
                    deleteText: isOwner ? '삭제' : '신고',
                    onDelete: () => _showDeleteDialog(context, ref),
                  );
                } else {
                  customActionSheet(
                    context,
                    deleteText: '신고',
                    onDelete: () => onTapReport(type.reportType.name, id),
                    onBlock: () => _showBlockDialog(context, ref, data.recruitDetail!.authorId),
                  );
                }
              },
            );
          },
          orElse: () => null,
        ),
      ),
      bottomNavigationBar: detailState.maybeWhen(
        data: (data) {
          final detail = data.recruitDetail;
          if (detail == null) return const SizedBox.shrink();

          final viewType = detail.viewType;
          final isAuthor = viewType == 'OWNER';
          final isGuest = viewType == 'GUEST';
          final bool isRecruiting = (status ?? '모집 중') == '모집 중';

          String buttonLabel = '지원하기';
          bool isPrimaryButtonEnabled = isRecruiting;
          VoidCallback? onPrimaryPressed;

          if (isAuthor) {
            // 작성자 → 지원자 확인
            buttonLabel = '지원자 확인';
            isPrimaryButtonEnabled = true;
            onPrimaryPressed = () => onTapApplicantList();
          } else if (isGuest) {
            // 게스트 → 로그인 필요
            isPrimaryButtonEnabled = true;
            onPrimaryPressed = () async => await LoginRequiredDialog(context);
          } else if (detail.isAlreadyApplied) {
            // 일반 유저 + 이미 지원한 경우
            buttonLabel = '지원 상태 확인';
            isPrimaryButtonEnabled = true;
            onPrimaryPressed = () => onTapApplicantDetail();
          } else {
            // 일반 유저 + 아직 지원 안 한 경우
            onPrimaryPressed = () async {
              final didApply = await onTapRecruitApply();
              if (didApply == true) {
                ref.invalidate(
                  recruitDetailViewModelProvider(
                    RecruitDetailArgs(id: id, type: type),
                  ),
                );
              }
            };
          }

          final bool canInquire = isRecruiting;

          return RecruitBottomButton(
            label: buttonLabel,
            isApplyEnabled: isPrimaryButtonEnabled,
            isInquiryEnabled: canInquire,
            onPressed: onPrimaryPressed,
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
                          ChatRoomRequest(
                            targetUserId: detail.authorId,
                            boardType: type,
                            boardId: id,
                            boardTitle: detail.title,
                          )
                        );
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

  void _showBlockDialog(BuildContext context, WidgetRef ref, int authorId) {
    final user = ref.watch(userSessionProvider);
    if (user == null) return;

    showDialog(
      context: context,
      builder: (_) => CustomConfirmDialog(
        title: '차단',
        content: '차단한 사용자와 1:1 채팅 및\n게시글 열람은 불가능해요.\n그래도 차단하시겠어요?',
        confirmText: '확인',
        cancelText: '취소',
        onConfirm: () async {
          final viewModel = ref.read(
            recruitDetailViewModelProvider(
              RecruitDetailArgs(id: id, type: type),
            ).notifier,
          );
          try {
            await viewModel.userBlock(user.id, authorId);
            context.pop(true);
          } catch (e) {
            showDialog(
              context: context,
              builder: (_) => CustomConfirmDialog(
                title: '차단 실패',
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
            ref.read(deletedRecruitIdsProvider.notifier).update(
                  (prev) => {...prev, id},
            );
            ref.read(homeNeedsRefreshProvider.notifier).state = true;
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