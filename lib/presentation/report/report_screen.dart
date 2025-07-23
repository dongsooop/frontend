import 'package:dongsoop/domain/report/model/report_write_request.dart';
import 'package:dongsoop/presentation/report/widgets/report_select_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class ReportScreen extends HookConsumerWidget {
  final String reportType;
  final int targetId;

  const ReportScreen({
    super.key,
    required this.reportType,
    required this.targetId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(reportViewModelProvider.notifier);
    final reportState = ref.watch(reportViewModelProvider);

    final textController = useTextEditingController();
    final selectedReportReason = useState<ReportReason?>(null);

    // 다이얼로그
    useEffect(() {
      if (reportState.isSuccessed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '신고 완료',
              content: '신고가 정상적으로 접수되었어요',
              isSingleAction: true,
              confirmText: '확인',
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      } else if (!reportState.isSuccessed && reportState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '신고 실패',
              content: reportState.errorMessage!,
              isSingleAction: true,
              confirmText: '확인',
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [reportState.errorMessage, reportState.isSuccessed]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
        appBar: DetailHeader(
          title: '신고',
        ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                SizedBox(height: 24,),
                Text(
                  '신고 대상이 정확한지 다시 한 번 확인해 주시기 바랍니다.',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '신고를 제출하면 동숲에서 조사를 시작하며,\n이때 사실 관계 확인을 위해 ',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                      TextSpan(
                        text: '신고자에게 객관적인 자료를 요청',
                        style: TextStyles.normalTextBold.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                      TextSpan(
                        text: '할 수 있습니다.',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 8,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '신고 유형',
                            style: TextStyles.normalTextBold.copyWith(
                              color: ColorStyles.black,
                            ),
                          ),
                          TextSpan(
                            text: ' *',
                            style: TextStyles.normalTextBold.copyWith(
                              color: ColorStyles.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // 텍스트 필드 & 버튼
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ReportSelectBottomSheet(
                        selectedReason: selectedReportReason.value,
                        onSelected: (reason) {
                          selectedReportReason.value = reason;
                          // ref.read(signUpViewModelProvider.notifier).selectDept(selectedReportReason.value);
                        },
                      ),
                    );
                  },
                  child: Container(
                      height: 44,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: selectedReportReason.value == null
                                ? ColorStyles.gray2
                                : ColorStyles.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedReportReason.value?.message ?? '신고 사유 선택',
                              style: TextStyles.normalTextRegular.copyWith(
                                color: selectedReportReason.value == null
                                    ? ColorStyles.gray4
                                    : ColorStyles.primaryColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: 24,
                            color: selectedReportReason.value == null
                                ? ColorStyles.gray5
                                : ColorStyles.primaryColor,
                          ),
                        ],
                      )
                  ),
                ),
                selectedReportReason.value != null
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: ColorStyles.gray2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextFormField(
                      maxLines: 5,
                      maxLength: 500,
                      keyboardType: TextInputType.text,
                      controller: textController,
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.black,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        border: InputBorder.none,
                        hintText: '최대 500글자까지 입력 가능해요',
                        hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                        counterText: '',
                      ),
                    ),
                  )
                : SizedBox(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PrimaryBottomButton(
        onPressed: () async {
          await viewModel.reportWrite(ReportWriteRequest(reportType: reportType, targetId: targetId, reason: selectedReportReason.value!.name, description: textController.text));
        },
        label: '신고하기',
        isLoading: reportState.isLoading,
        isEnabled: selectedReportReason.value != null ? true : false,
      )
    );
  }
}