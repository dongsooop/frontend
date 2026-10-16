import 'package:dongsoop/core/presentation/components/common_text_form_field.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_state.dart';
import 'package:dongsoop/presentation/my_page/admin/report/widgets/report_sanction_select_bottom_sheet.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportAdminSanctionScreen extends HookConsumerWidget {
  final ReportAdminSanction report;

  ReportAdminSanctionScreen({
    super.key,
    required this.report,
  }) : assert(report.targetMemberId != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = reportAdminSanctionViewModelProvider(report.chatRoomType);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final sanctionReasonController = useTextEditingController();

    Future<void> showDateTimePicker() async {
      final now = DateTime.now();
      var draft = state.sanctionEndAt ?? now.add(const Duration(hours: 1));
      if (!draft.isAfter(now)) {
        draft = now.add(const Duration(minutes: 10));
      }

      await showCupertinoModalPopup<void>(
        context: context,
        builder: (sheetContext) => Container(
          height: MediaQuery.sizeOf(sheetContext).height * 0.4,
          decoration: const BoxDecoration(
            color: ColorStyles.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      child: Text(
                        '취소',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.warning100,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        viewModel.selectSanctionEndAt(draft);
                        Navigator.of(sheetContext).pop();
                      },
                      child: Text(
                        '확인',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: ColorStyles.gray2),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: draft,
                  minimumDate: now,
                  use24hFormat: true,
                  onDateTimeChanged: (value) => draft = value,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Future<bool> confirmSanction() async {
      final sanctionType = state.sanctionType!;
      final target = report.targetMemberLabel;
      final endAt = state.sanctionEndAt;
      final endAtText = sanctionType.requiresEndAt && endAt != null
          ? '\n종료: ${_formatDateTime(endAt)}'
          : '';

      return await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => CustomConfirmDialog(
              title: '제재를 적용할까요?',
              content: '$target\n${sanctionType.message}$endAtText',
              confirmText: '적용',
              dismissOnConfirm: false,
              onConfirm: () => Navigator.of(dialogContext).pop(true),
            ),
          ) ??
          false;
    }

    Future<void> submit() async {
      FocusScope.of(context).unfocus();
      if (!viewModel.canSubmit || !await confirmSanction()) return;
      if (!context.mounted) return;

      final success = await viewModel.sanctionWrite(
        reportId: report.id,
        targetMemberId: report.targetMemberId!,
      );
      if (!context.mounted) return;

      if (success) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomConfirmDialog(
            title: '제재 완료',
            content: '제재가 정상적으로 적용됐어요.',
            isSingleAction: true,
            onConfirm: () {},
          ),
        );
        if (context.mounted) Navigator.of(context).pop(true);
        return;
      }

      final resultState = ref.read(provider);
      final failure = resultState.failure;
      if (failure == ReportAdminSanctionFailure.alreadyProcessed ||
          failure == ReportAdminSanctionFailure.notFound) {
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
        if (context.mounted) Navigator.of(context).pop(true);
      }
    }

    final reportType = ReportType.fromString(report.reportType);
    final reportReason = ReportReason.fromString(report.reportReason);
    final requiresEndAt = state.sanctionType?.requiresEndAt == true;

    return PopScope<void>(
      canPop: !state.isSubmitting,
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: const DetailHeader(title: '제재 처리'),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: IgnorePointer(
              ignoring: state.isSubmitting,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReportSummary(
                      report: report,
                      reportType: reportType,
                      reportReason: reportReason,
                    ),
                    const SizedBox(height: 28),
                    const _FieldLabel(label: '제재 유형', required: true),
                    const SizedBox(height: 8),
                    InkWell(
                      key: const Key('sanction-type-field'),
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        backgroundColor: ColorStyles.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (_) => ReportSanctionSelectBottomSheet(
                          selectedSanction: state.sanctionType,
                          onSelected: viewModel.selectSanctionType,
                          sanctions: viewModel.availableSanctions,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 48),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: state.sanctionType == null
                                ? ColorStyles.gray2
                                : ColorStyles.primaryColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.sanctionType?.message ?? '제재 유형 선택',
                                style: TextStyles.normalTextRegular.copyWith(
                                  color: state.sanctionType == null
                                      ? ColorStyles.gray4
                                      : ColorStyles.primaryColor,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: state.sanctionType == null
                                  ? ColorStyles.gray5
                                  : ColorStyles.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _FieldLabel(
                      label: '제재 사유',
                      required: state.sanctionType?.requiresReason == true,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.sanctionType?.requiresReason == true
                          ? '경고 사유는 필수이며 최대 500자까지 입력할 수 있어요.'
                          : '선택 사항이며 최대 500자까지 입력할 수 있어요.',
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.gray4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CommonTextFormField(
                      controller: sanctionReasonController,
                      hintText: '제재 사유를 입력해 주세요.',
                      maxLength: 500,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      onChanged: viewModel.updateSanctionReason,
                    ),
                    if (requiresEndAt) ...[
                      const SizedBox(height: 24),
                      const _FieldLabel(label: '제재 종료', required: true),
                      const SizedBox(height: 8),
                      InkWell(
                        key: const Key('sanction-end-at-field'),
                        onTap: showDateTimePicker,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 48),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: state.sanctionEndAt == null
                                  ? ColorStyles.gray2
                                  : ColorStyles.primaryColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.sanctionEndAt == null
                                      ? '종료 날짜와 시간 선택'
                                      : _formatDateTime(state.sanctionEndAt!),
                                  style: TextStyles.normalTextRegular.copyWith(
                                    color: state.sanctionEndAt == null
                                        ? ColorStyles.gray4
                                        : ColorStyles.primaryColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: state.sanctionEndAt == null
                                    ? ColorStyles.gray5
                                    : ColorStyles.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          state.errorMessage!,
                          key: const Key('sanction-submit-error'),
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.warning100,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          label: '제재 적용',
          isEnabled: viewModel.canSubmit,
          isLoading: state.isSubmitting,
          onPressed: viewModel.canSubmit ? submit : null,
        ),
      ),
    );
  }
}

class _ReportSummary extends StatelessWidget {
  final ReportAdminSanction report;
  final ReportType reportType;
  final ReportReason reportReason;

  const _ReportSummary({
    required this.report,
    required this.reportType,
    required this.reportReason,
  });

  @override
  Widget build(BuildContext context) {
    final roomTypeLabel = report.chatRoomType?.label;
    final summaryItems = [
      reportType.message,
      if (roomTypeLabel != null) roomTypeLabel,
      reportReason.message,
      '신고 #${report.id}',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.gray7,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.targetMemberLabel,
            style: TextStyles.normalTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            summaryItems.join(' · '),
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const _FieldLabel({required this.label, required this.required});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyles.normalTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          if (required)
            TextSpan(
              text: ' *',
              style: TextStyles.normalTextBold.copyWith(
                color: ColorStyles.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}

String _formatDateTime(DateTime value) {
  String twoDigits(int number) => number.toString().padLeft(2, '0');
  return '${value.year}.${twoDigits(value.month)}.${twoDigits(value.day)} '
      '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
}
