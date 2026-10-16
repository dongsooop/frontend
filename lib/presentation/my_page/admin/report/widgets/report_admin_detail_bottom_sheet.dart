import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_message_context.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_dismiss_state.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ReportAdminDetailResult {
  reviewSanction,
  refresh,
}

class ReportAdminDetailBottomSheet extends ConsumerWidget {
  final ReportAdminSanction report;
  final bool canReviewSanction;
  final bool canDismiss;

  const ReportAdminDetailBottomSheet({
    super.key,
    required this.report,
    required this.canReviewSanction,
    required this.canDismiss,
  });

  static Future<ReportAdminDetailResult?> show(
    BuildContext context, {
    required ReportAdminSanction report,
    required bool canReviewSanction,
    required bool canDismiss,
  }) {
    return showModalBottomSheet<ReportAdminDetailResult>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: ColorStyles.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ReportAdminDetailBottomSheet(
        report: report,
        canReviewSanction: canReviewSanction,
        canDismiss: canDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dismissState = canDismiss
        ? ref.watch(reportAdminDismissViewModelProvider)
        : const ReportAdminDismissState();
    final reportType = ReportType.fromString(report.reportType);
    final reportReason = ReportReason.fromString(report.reportReason);
    final roomTypeLabel = report.chatRoomType?.label;
    final relatedResolutionLabel = report.relatedResolutionLabel;
    final sanctionType = report.sanctionType == null
        ? null
        : SanctionType.tryFromString(report.sanctionType!);

    Future<bool> confirmDismiss() async {
      return await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => CustomConfirmDialog(
              title: '제재 없이 처리할까요?',
              content: '신고는 처리 완료로 이동하며, 대상 회원에게 제재는 적용되지 않습니다.',
              confirmText: '처리',
              dismissOnConfirm: false,
              onConfirm: () => Navigator.of(dialogContext).pop(true),
            ),
          ) ??
          false;
    }

    Future<void> dismiss() async {
      if (dismissState.isSubmitting || !await confirmDismiss()) return;
      if (!context.mounted) return;

      final success = await ref
          .read(reportAdminDismissViewModelProvider.notifier)
          .dismiss(report.id);
      if (!context.mounted) return;

      if (success) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomConfirmDialog(
            title: '신고 처리 완료',
            content: '신고를 제재 없이 처리했어요.',
            isSingleAction: true,
            onConfirm: () {},
          ),
        );
        if (context.mounted) {
          Navigator.of(context).pop(ReportAdminDetailResult.refresh);
        }
        return;
      }

      final resultState = ref.read(reportAdminDismissViewModelProvider);
      if (resultState.failure == ReportAdminDismissFailure.notFound ||
          resultState.failure == ReportAdminDismissFailure.alreadyProcessed) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomConfirmDialog(
            title: '신고 상태가 변경됐어요',
            content: resultState.errorMessage!,
            isSingleAction: true,
            onConfirm: () {},
          ),
        );
        if (context.mounted) {
          Navigator.of(context).pop(ReportAdminDetailResult.refresh);
        }
      }
    }

    return PopScope<ReportAdminDetailResult>(
      canPop: !dismissState.isSubmitting,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '신고 상세',
                      style: TextStyles.titleTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: '닫기',
                    onPressed: dismissState.isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: ColorStyles.black,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: ColorStyles.gray2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _DetailTag(
                          label: reportType.message,
                          backgroundColor: ColorStyles.primary5,
                          textColor: ColorStyles.primaryColor,
                        ),
                        if (roomTypeLabel != null)
                          _DetailTag(
                            label: roomTypeLabel,
                            backgroundColor: ColorStyles.gray7,
                            textColor: ColorStyles.gray6,
                          ),
                        _DetailTag(
                          label: reportReason.message,
                          backgroundColor: ColorStyles.labelColorRed10,
                          textColor: ColorStyles.labelColorRed100,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(label: '신고 대상'),
                    const SizedBox(height: 8),
                    Text(
                      report.targetMemberLabel,
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(label: '신고된 메시지'),
                    const SizedBox(height: 8),
                    Container(
                      key: const Key('reported-message'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorStyles.labelColorRed10,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorStyles.warning10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.messageContent ?? '메시지 내용을 확인할 수 없습니다.',
                            style: TextStyles.normalTextRegular.copyWith(
                              color: ColorStyles.black,
                              height: 1.5,
                            ),
                          ),
                          if (report.messageSentAt != null &&
                              report.messageSentAt!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              report.messageSentAt!,
                              style: TextStyles.smallTextRegular.copyWith(
                                color: ColorStyles.gray4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(label: '메시지 문맥'),
                    const SizedBox(height: 4),
                    Text(
                      '서버에서 전달된 순서대로 표시됩니다.',
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.gray4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (report.messageContext.isEmpty)
                      Text(
                        '함께 확인할 메시지가 없습니다.',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.gray4,
                        ),
                      )
                    else
                      ...report.messageContext.map(
                        (message) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _ContextMessage(
                            message: message,
                            isTarget: message.senderId == report.targetMemberId,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _SectionTitle(label: '신고 내용'),
                    const SizedBox(height: 8),
                    Text(
                      report.description?.trim().isNotEmpty == true
                          ? report.description!
                          : '추가 설명이 없습니다.',
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.black,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _InfoRow(label: '신고자', value: report.reporterNickname),
                    const SizedBox(height: 8),
                    _InfoRow(label: '신고 시각', value: report.createdAt),
                    if (relatedResolutionLabel != null) ...[
                      const SizedBox(height: 24),
                      _RelatedResolutionNotice(
                        label: relatedResolutionLabel,
                      ),
                    ],
                    if (sanctionType != null) ...[
                      const SizedBox(height: 24),
                      _SectionTitle(label: '제재 처리'),
                      const SizedBox(height: 8),
                      _InfoRow(label: '제재 유형', value: sanctionType.message),
                      if (report.adminNickname?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        _InfoRow(label: '처리 관리자', value: report.adminNickname!),
                      ],
                      if (report.sanctionReason?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        _InfoRow(label: '처리 사유', value: report.sanctionReason!),
                      ],
                      if (report.sanctionStartDate?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: '제재 시작',
                          value: report.sanctionStartDate!,
                        ),
                      ],
                      if (report.sanctionEndDate?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: '제재 종료',
                          value: report.sanctionEndDate!,
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            if (canDismiss || canReviewSanction)
              _ReportActions(
                canDismiss: canDismiss,
                canReviewSanction: canReviewSanction,
                isSubmitting: dismissState.isSubmitting,
                errorMessage: dismissState.errorMessage,
                onDismiss: dismiss,
                onReviewSanction: () => Navigator.of(context).pop(
                  ReportAdminDetailResult.reviewSanction,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RelatedResolutionNotice extends StatelessWidget {
  final String label;

  const _RelatedResolutionNotice({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('report-related-resolution-detail'),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorStyles.primary5,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.normalTextBold.copyWith(
              color: ColorStyles.primaryGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '이 신고에 별도 제재가 생성된 것은 아닙니다.',
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportActions extends StatelessWidget {
  final bool canDismiss;
  final bool canReviewSanction;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback onDismiss;
  final VoidCallback onReviewSanction;

  const _ReportActions({
    required this.canDismiss,
    required this.canReviewSanction,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onDismiss,
    required this.onReviewSanction,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: const BoxDecoration(
          color: ColorStyles.white,
          border: Border(top: BorderSide(color: ColorStyles.gray2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorMessage != null) ...[
              Semantics(
                liveRegion: true,
                child: Text(
                  errorMessage!,
                  key: const Key('report-dismiss-error'),
                  textAlign: TextAlign.center,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.warning100,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                if (canDismiss)
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('report-dismiss-button'),
                      onPressed: isSubmitting ? null : onDismiss,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        foregroundColor: ColorStyles.primaryColor,
                        side: const BorderSide(color: ColorStyles.primaryColor),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorStyles.primaryColor,
                              ),
                            )
                          : const Text('제재 없이 처리'),
                    ),
                  ),
                if (canDismiss && canReviewSanction) const SizedBox(width: 8),
                if (canReviewSanction)
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('report-sanction-review-button'),
                      onPressed: isSubmitting ? null : onReviewSanction,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        elevation: 0,
                        backgroundColor: ColorStyles.primaryColor,
                        foregroundColor: ColorStyles.white,
                      ),
                      child: const Text('제재 검토'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContextMessage extends StatelessWidget {
  final ReportMessageContext message;
  final bool isTarget;

  const _ContextMessage({
    required this.message,
    required this.isTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('report-context-message-${message.senderId}-${message.sentAt}'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTarget ? ColorStyles.primary5 : ColorStyles.gray7,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isTarget ? ColorStyles.primaryColor : ColorStyles.gray2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isTarget ? '신고 대상' : '참여자 #${message.senderId}',
                style: TextStyles.smallTextBold.copyWith(
                  color:
                      isTarget ? ColorStyles.primaryColor : ColorStyles.gray4,
                ),
              ),
              const Spacer(),
              Text(
                message.sentAt,
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message.content,
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.black,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;

  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Text(
            label,
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailTag extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _DetailTag({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        label,
        style: TextStyles.smallTextBold.copyWith(color: textColor),
      ),
    );
  }
}
