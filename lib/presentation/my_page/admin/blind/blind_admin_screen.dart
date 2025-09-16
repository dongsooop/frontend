import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/presentation/my_page/admin/report/widgets/blind_date_member_count_picker_bottom_sheet.dart';
import 'package:dongsoop/presentation/my_page/admin/report/widgets/blind_date_picker_bottom_sheet.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class BlindAdminScreen extends HookConsumerWidget {
  const BlindAdminScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(blindAdminViewModelProvider.notifier);
    final state = ref.watch(blindAdminViewModelProvider);

    final selectedTime = useState<DateTime?>(null);
    final selectedMemberCount = useState<int?>(null);

    Future<void> pickTime() async {
      final now = DateTime.now();
      final result = await BlindDatePickerBottomSheet.show(
        context,
        initial: selectedTime.value ?? now,
        title: '마감 시간 선택',
        onChanged: (dt) => selectedTime.value = dt,
      );
      if (result != null) {
        selectedTime.value = DateTime(
          now.year, now.month, now.day, result.hour, result.minute,
        );
      }
    }

    Future<void> pickMemberCount() async {
      final result = await BlindDateMemberCountPickerBottomSheet.show(
        context,
        initial: 2,
        title: '한 과팅방의 모집 인원 수',
        onChanged: (count) => selectedMemberCount.value = count,
      );
      if (result != null) {
        selectedTime.value = result;
      }
    }

    final isTimeValid = selectedTime.value != null;
    final isCountValid = selectedMemberCount.value != null;

    useEffect(() {
      if (state.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: '과팅 오픈 오류',
              content: state.errorMessage!,
              isSingleAction: true,
              confirmText: '확인',
              onConfirm: () async {},
            ),
          );
        });
      }
      return null;
    }, [state.errorMessage]);

    useEffect(() {
      if (state.result) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: '과팅 오픈 성공',
              content: '성공적으로 과팅을 오픈했어요.',
              isSingleAction: true,
              onConfirm: () {},
            ),
          );
        });
      }
      return null;
    }, [state.result]);

    return Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(
          title: '과팅 오픈',
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
                    '현 시간 이후부터 과팅을 진행해요.\n과팅 마감 시간을 정해주세요.',
                    style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.black,
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
                              text: '마감 시간',
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: pickTime,
                    child: Container(
                      height: 44,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: isTimeValid ? ColorStyles.primaryColor : ColorStyles.gray2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              isTimeValid
                                ? formatBlindDate(selectedTime.value!)
                                : '마감 시간 선택',
                              style: TextStyles.normalTextRegular.copyWith(
                                color: isTimeValid
                                  ? ColorStyles.primaryColor
                                  : ColorStyles.gray4,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: 24,
                            color: isTimeValid
                              ? ColorStyles.primaryColor
                              : ColorStyles.gray5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 8,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '한 과팅방의 모집 인원 수',
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: pickMemberCount,
                    child: Container(
                      height: 44,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: isCountValid ? ColorStyles.primaryColor : ColorStyles.gray2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              isCountValid
                                  ? '${selectedMemberCount.value}명'
                                  : '인원 수 선택',
                              style: TextStyles.normalTextRegular.copyWith(
                                color: isCountValid
                                  ? ColorStyles.primaryColor
                                  : ColorStyles.gray4,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: 24,
                            color: isCountValid
                                ? ColorStyles.primaryColor
                                : ColorStyles.gray5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          onPressed: () async {
            if (!isCountValid || !isTimeValid) return;
            final ok = viewModel.validateSelectedTime(selectedTime.value!);
            if (ok) {
              await viewModel.open(BlindDateOpenRequest(
                expiredDate: selectedTime.value!,
                maxSessionMemberCount: selectedMemberCount.value!
              ));
            }
          },
          label: '오픈하기',
          isLoading: state.isLoading,
          isEnabled: isTimeValid && isCountValid ? true : false,
        )
    );
  }
}