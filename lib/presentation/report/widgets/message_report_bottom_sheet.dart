import 'package:dongsoop/core/presentation/components/common_text_form_field.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/presentation/report/model/message_report_target.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReportBottomSheet extends ConsumerStatefulWidget {
  final MessageReportTarget target;

  const MessageReportBottomSheet({
    super.key,
    required this.target,
  });

  static Future<bool?> show(
    BuildContext context, {
    required MessageReportTarget target,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: ColorStyles.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => MessageReportBottomSheet(target: target),
    );
  }

  @override
  ConsumerState<MessageReportBottomSheet> createState() =>
      _MessageReportBottomSheetState();
}

class _MessageReportBottomSheetState
    extends ConsumerState<MessageReportBottomSheet> {
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = messageReportViewModelProvider(widget.target);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final availableHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom -
        keyboardHeight;

    return PopScope<bool>(
      canPop: !state.isSubmitting,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: SizedBox(
          height: availableHeight * 0.9,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '메시지 신고',
                        style: TextStyles.titleTextBold.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: '닫기',
                      onPressed: state.isSubmitting
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
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: IgnorePointer(
                    ignoring: state.isSubmitting,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '신고 사유를 선택해 주세요.',
                            style: TextStyles.normalTextBold.copyWith(
                              color: ColorStyles.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...ReportReason.values.map(
                            (reason) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _ReasonTile(
                                reason: reason,
                                selected: state.selectedReason == reason,
                                onTap: () => viewModel.selectReason(reason),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '추가 설명',
                            style: TextStyles.normalTextBold.copyWith(
                              color: ColorStyles.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '선택 사항이며 최대 500자까지 입력할 수 있어요.',
                            style: TextStyles.smallTextRegular.copyWith(
                              color: ColorStyles.gray4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CommonTextFormField(
                            controller: _descriptionController,
                            hintText: '신고 사유에 대한 자세한 내용을 입력해 주세요.',
                            maxLines: 4,
                            maxLength: 500,
                            keyboardType: TextInputType.multiline,
                            onChanged: viewModel.updateDescription,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Semantics(
                    liveRegion: true,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.errorMessage!,
                        key: const Key('message-report-error'),
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.warning100,
                        ),
                      ),
                    ),
                  ),
                ),
              PrimaryBottomButton(
                label: '신고하기',
                isEnabled: state.canSubmit,
                isLoading: state.isSubmitting,
                onPressed: state.canSubmit
                    ? () async {
                        FocusScope.of(context).unfocus();
                        final success = await viewModel.submit();
                        if (!context.mounted || !success) return;
                        Navigator.of(context).pop(true);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final ReportReason reason;
  final bool selected;
  final VoidCallback onTap;

  const _ReasonTile({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? ColorStyles.primary5 : ColorStyles.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? ColorStyles.primaryColor : ColorStyles.gray2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  reason.message,
                  style: TextStyles.normalTextRegular.copyWith(
                    color:
                        selected ? ColorStyles.primaryColor : ColorStyles.black,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? ColorStyles.primaryColor : ColorStyles.gray5,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
