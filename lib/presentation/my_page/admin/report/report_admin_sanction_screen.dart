import 'package:dongsoop/presentation/my_page/admin/report/widgets/report_sanction_select_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

import '../../../../domain/report/enum/sanction_type.dart';
import '../../../../domain/report/model/report_admin_sanction_request.dart';

class ReportAdminSanctionScreen extends HookConsumerWidget {
  final int reportId;
  final int targetMemberId;

  const ReportAdminSanctionScreen({
    super.key,
    required this.reportId,
    required this.targetMemberId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(reportAdminSanctionViewModelProvider.notifier);
    final reportSanctionState = ref.watch(reportAdminSanctionViewModelProvider);

    final sanctionTextController = useTextEditingController();
    useListenable(sanctionTextController);

    final selectedReportReason = useState<SanctionType?>(null);

    final selectedDate = useState<DateTime?>(null);

    void showDateTimePicker() {
      final now = DateTime.now();
      final tenMinutesLater = now.add(Duration(minutes: 10));
      final initial = selectedDate.value ?? tenMinutesLater;

      showCupertinoModalPopup(
        context: context,
        builder: (_) {
          final screenHeight = MediaQuery.of(context).size.height;
          final pickerHeight = screenHeight * 0.4;

          return Container(
            height: pickerHeight,
            decoration: BoxDecoration(
              color: ColorStyles.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                // 상단에 취소/확인 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Text("취소", style: TextStyles.normalTextRegular
                            .copyWith(
                            color: ColorStyles.warning100
                        ),),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          selectedDate.value = null;
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text("확인", style: TextStyles.normalTextRegular
                            .copyWith(
                            color: ColorStyles.primaryColor
                        ),),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: ColorStyles.gray2,),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: initial,
                    minimumDate: now,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDateTime) {
                      selectedDate.value = newDateTime;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }


    // 다이얼로그
    useEffect(() {
      if (reportSanctionState.isSuccessed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '제재 완료',
              content: '제재가 정상적으로 적용됐어요',
              isSingleAction: true,
              confirmText: '확인',
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      } else if (!reportSanctionState.isSuccessed && reportSanctionState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '제재 실패',
              content: reportSanctionState.errorMessage!,
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
    }, [reportSanctionState.errorMessage, reportSanctionState.isSuccessed]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: DetailHeader(
            title: '제재 처리',
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
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
                          text: '제재 유형',
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
                    builder: (context) => ReportSanctionSelectBottomSheet(
                      selectedSanction: selectedReportReason.value,
                      onSelected: (type) {
                        selectedReportReason.value = type;
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
                            selectedReportReason.value?.message ?? '제재 방법 선택',
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
                  maxLines: 5,
                  maxLength: 500,
                  keyboardType: TextInputType.text,
                  controller: sanctionTextController,
                  textInputAction: TextInputAction.done,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '최대 500글자까지 입력 가능해요',
                    hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                    counterText: '',
                  ),
                ),
              )
              : SizedBox(),
              // 기간 설정
              selectedReportReason.value != null
              ? // 텍스트 필드 & 버튼
              GestureDetector(
                onTap: showDateTimePicker,
                child: Container(
                  height: 44,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: selectedDate.value != null
                          ? ColorStyles.primaryColor
                          : ColorStyles.gray2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate.value != null
                            ? '${selectedDate.value!.year}.${selectedDate.value!.month.toString().padLeft(2, '0')}.${selectedDate.value!.day.toString().padLeft(2, '0')} '
                            '${selectedDate.value!.hour.toString().padLeft(2, '0')}:${selectedDate.value!.minute.toString().padLeft(2, '0')}'
                            : '제재 적용 기간 선택',
                          style: TextStyles.normalTextRegular.copyWith(
                            color: selectedDate.value != null
                              ? ColorStyles.primaryColor
                              : ColorStyles.gray4,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_outlined,
                        size: 24,
                        color: selectedDate.value != null
                          ? ColorStyles.primaryColor
                          : ColorStyles.gray5,
                      ),
                    ],
                  ),
                ),
              )
              : SizedBox(),
            ],
          ),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          onPressed: () async {
            await viewModel.sanctionWrite(ReportAdminSanctionRequest(
              reportId: reportId,
              targetMemberId: targetMemberId,
              sanctionType: selectedReportReason.value!.message,
              sanctionReason: sanctionTextController.text,
              sanctionEndAt: selectedDate.value));
          },
          label: '제재',
          isLoading: reportSanctionState.isLoading,
          isEnabled: sanctionTextController.text.isNotEmpty,
        ),
      ),
    );
  }
}