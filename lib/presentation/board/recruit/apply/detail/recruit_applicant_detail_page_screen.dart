import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_applicant_detail_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_decision_view_model.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecruitApplicantDetailPage extends ConsumerWidget {
  final RecruitType type;
  final int boardId;
  final int memberId;

  const RecruitApplicantDetailPage({
    super.key,
    required this.type,
    required this.boardId,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      recruitApplicantDetailViewModelProvider(
        RecruitApplicantDetailArgs(
          type: type,
          boardId: boardId,
          memberId: memberId,
        ),
      ),
    );

    return state.when(
      data: (detail) => SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: DetailHeader(title: "${detail.title} 지원자"),
          ),
          body: _ApplicantDetailBody(detail: detail),
          bottomNavigationBar: _DecisionButtons(
            status: detail.status,
            onPass: () async {
              final decisionNotifier =
                  ref.read(recruitDecisionViewModelProvider.notifier);
              await decisionNotifier.decide(
                type: type,
                boardId: boardId,
                applierId: memberId,
                status: 'PASS',
              );
              if (context.mounted) context.pop('PASS');
            },
            onFail: () async {
              final decisionNotifier =
                  ref.read(recruitDecisionViewModelProvider.notifier);
              await decisionNotifier.decide(
                type: type,
                boardId: boardId,
                applierId: memberId,
                status: 'FAIL',
              );
              if (context.mounted) context.pop('FAIL');
            },
          ),
        ),
      ),
      loading: () => const SafeArea(
        child: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => SafeArea(
        child: Scaffold(
          body: Center(child: Text('$e')),
        ),
      ),
    );
  }
}

class _ApplicantDetailBody extends StatelessWidget {
  final RecruitApplicantDetailEntity detail;

  const _ApplicantDetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/profile.png',
                width: 48,
                height: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.applierName,
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            detail.departmentName,
                            style: TextStyles.smallTextRegular.copyWith(
                              color: ColorStyles.gray4,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          formatFullDateTime(detail.applyTime),
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: ColorStyles.gray2, height: 1),
          const SizedBox(height: 32),
          Text('자기소개', style: TextStyles.normalTextBold),
          const SizedBox(height: 16),
          Text(
            detail.introduction ?? '자기소개를 작성하지 않았어요',
            style: TextStyles.normalTextRegular,
          ),
          const SizedBox(height: 40),
          Text('지원 동기', style: TextStyles.normalTextBold),
          const SizedBox(height: 16),
          Text(
            detail.motivation ?? '',
            style: TextStyles.normalTextRegular,
          ),
        ],
      ),
    );
  }
}

class _DecisionButtons extends StatelessWidget {
  final String status;
  final Future<void> Function() onPass;
  final Future<void> Function() onFail;

  const _DecisionButtons({
    required this.status,
    required this.onPass,
    required this.onFail,
  });

  @override
  Widget build(BuildContext context) {
    if (status == 'PASS' || status == 'FAIL') {
      final label = status == 'PASS' ? '합격' : '불합격';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: ColorStyles.white,
        width: double.infinity,
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: TextButton(
            onPressed: null,
            style: TextButton.styleFrom(
              backgroundColor: ColorStyles.gray1,
              foregroundColor: ColorStyles.gray4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(label, style: TextStyles.largeTextBold),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: ColorStyles.white,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextButton(
                onPressed: () async {
                  await showDialog<bool>(
                    context: context,
                    builder: (_) => CustomConfirmDialog(
                      title: '지원 결과',
                      content: '한번 결정하면 되돌릴 수 없어요.\n 해당 지원자를 불합격 처리할까요?',
                      cancelText: '취소',
                      confirmText: '확인',
                      onConfirm: () async {
                        context.pop();
                        await onFail();
                      },
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: ColorStyles.warning10,
                  foregroundColor: ColorStyles.warning100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('불합격', style: TextStyles.largeTextBold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextButton(
                onPressed: () async {
                  await showDialog<bool>(
                    context: context,
                    builder: (_) => CustomConfirmDialog(
                      title: '지원 결과',
                      content: '한번 결정하면 되돌릴 수 없어요.\n 해당 지원자를 합격 처리할까요?',
                      cancelText: '취소',
                      confirmText: '확인',
                      onConfirm: () async {
                        context.pop();
                        await onPass();
                      },
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: ColorStyles.primaryColor,
                  foregroundColor: ColorStyles.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('합격', style: TextStyles.largeTextBold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
