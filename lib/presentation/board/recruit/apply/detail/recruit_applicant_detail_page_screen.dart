import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/enum/recruit_applicant_viewer.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/recruit/apply/detail/widget/applicant_status_bar.dart';
import 'package:dongsoop/presentation/board/recruit/apply/detail/widget/owner_decision_button.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_applicant_detail_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_decision_view_model.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecruitApplicantDetailPage extends ConsumerWidget {
  final RecruitApplicantViewer viewer;
  final RecruitType type;
  final int boardId;
  final int? memberId;

  const RecruitApplicantDetailPage({
    super.key,
    required this.viewer,
    required this.type,
    required this.boardId,
    this.memberId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApplicant = viewer == RecruitApplicantViewer.APPLICANT;
    final defaultTitle = isApplicant ? '지원 상태' : '지원자 상세';

    final state = ref.watch(
      recruitApplicantDetailViewModelProvider(
        RecruitApplicantDetailArgs(
          viewer: viewer,
          type: type,
          boardId: boardId,
          memberId: memberId,
        ),
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: state.when(
          data: (detail) => DetailHeader(
            title: isApplicant ? '${detail.title}' : '${detail.title} 지원자'
          ),
          loading: () => DetailHeader(title: defaultTitle),
          error: (_, __) => DetailHeader(title: defaultTitle),
        ),
      ),
      body: SafeArea(
        child: state.when(
          data: (detail) => _ApplicantDetailBody(detail: detail),
          loading: () => const Center(
            child: CircularProgressIndicator(color: ColorStyles.primaryColor),
          ),
          error: (e, _) => SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '$e',
                  style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: state.when(
        data: (detail) {
          if (viewer == RecruitApplicantViewer.APPLICANT) {
            return ApplicantStatusBar(status: detail.status);
          }
          return OwnerDecisionButton(
            status: detail.status,
            onPass: () async {
              final decisionNotifier = ref.read(recruitDecisionViewModelProvider.notifier);
              try {
                await decisionNotifier.decide(
                  type: type,
                  boardId: boardId,
                  applierId: detail.applierId,
                  status: 'PASS',
                );
                if (context.mounted) context.pop('PASS');
              } catch (e) {
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  builder: (_) => CustomConfirmDialog(
                    title: '결정 처리 실패',
                    content: '$e',
                    isSingleAction: true,
                    confirmText: '확인',
                    onConfirm: () => Navigator.of(context).pop(),
                  ),
                );
              }
            },
            onFail: () async {
              final decisionNotifier =
              ref.read(recruitDecisionViewModelProvider.notifier);
              try {
                await decisionNotifier.decide(
                  type: type,
                  boardId: boardId,
                  applierId: detail.applierId,
                  status: 'FAIL',
                );
                if (context.mounted) context.pop('FAIL');
              } catch (e) {
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  builder: (_) => CustomConfirmDialog(
                    title: '결정 처리 오류',
                    content: '$e',
                    isSingleAction: true,
                    confirmText: '확인',
                    onConfirm: () => Navigator.of(context).pop(),
                  ),
                );
              }
            },
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
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

          _InfoSectionCard(
            title: '자기소개',
            text: detail.introduction,
            ),
          const SizedBox(height: 40),
          _InfoSectionCard(
            title: '지원 동기',
            text: detail.motivation,
            ),
        ],
      ),
    );
  }
}

class _InfoSectionCard extends StatelessWidget {
  final String title;
  final String? text;

  const _InfoSectionCard({
    required this.title,
    required this.text,
  });

  bool get _hasContent => (text?.trim().isNotEmpty ?? false);

  String get _emptyMessage {
    switch (title) {
      case '자기소개':
        return '자기소개를 작성하지 않았어요';
      case '지원 동기':
        return '지원 동기를 작성하지 않았어요';
      default:
        return '작성 내용이 없어요.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 120),
          child: Text(
            _hasContent ? text! : _emptyMessage,
            style: TextStyles.normalTextRegular.copyWith(
              color: _hasContent ? ColorStyles.black : ColorStyles.gray3,
            ),
          ),
        ),
      ],
    );
  }
}