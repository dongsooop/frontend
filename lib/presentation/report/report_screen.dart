import 'package:dongsoop/presentation/report/widgets/report_select_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/presentation/components/custom_confirm_dialog.dart';
import '../../core/presentation/components/primary_bottom_button.dart';
import '../../domain/report/enum/report_reason.dart';
import '../../providers/report_providers.dart';
import '../../ui/color_styles.dart';
import '../../ui/text_styles.dart';

class ReportScreen extends HookConsumerWidget {

  const ReportScreen({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(reportViewModelProvider.notifier);
    final reportState = ref.watch(reportViewModelProvider);

    final textController = useTextEditingController();
    final selectedReportReason = useState<ReportReason?>(null);

    // 오류
    useEffect(() {
      if (reportState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '신고 실패',
              content: reportState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [reportState.errorMessage]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
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
                      text: '신고를 제출하면 동숲에서 조사를 시작하며,\n이때 사실 관계 확인을 위해',
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
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    controller: textController,
                    textInputAction: TextInputAction.done,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '최대 500글자까지 입력 가능해요',
                      hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                      // contentPadding: EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                )
              : SizedBox(),
            ],
          ),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          onPressed: () {},
          label: '신고하기',
          isLoading: reportState.isLoading,
          isEnabled: false,
        )
      ),
    );
  }
}