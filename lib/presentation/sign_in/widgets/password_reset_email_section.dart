import 'package:dongsoop/presentation/sign_up/widgets/check_duplication_button.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'custom_text_field.dart';

class PasswordResetEmailSection extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController emailCodeController;

  const PasswordResetEmailSection({
    super.key,
    required this.emailController,
    required this.emailCodeController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PWResetState = ref.watch(passwordResetViewModelProvider);
    final emailState = PWResetState.email;
    final emailCodeState = PWResetState.emailCode;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '이메일',
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
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    emailState.message ?? '가입하신 동양 Gmail을 입력해 주세요',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: (emailState.isDuplicate == false && emailState.message == '이메일 인증이 필요해요')
                        ? ColorStyles.warning100
                        : (emailState.isError == true || emailCodeState.isError == true)
                          ? ColorStyles.warning100
                          : ColorStyles.gray4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 텍스트 필드 & 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: emailState.isError == true
                            ? ColorStyles.warning100
                            : emailState.isError == false
                            ? ColorStyles.primaryColor
                            : ColorStyles.gray2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: emailController,
                          hintText: '학교 Gmail 입력',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Text(
                        '@dongyang.ac.kr',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.gray4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CheckDuplicationButton(
                onTab: () {
                  if (emailController.text.isEmpty) return;
                  ref.read(passwordResetViewModelProvider.notifier).checkEmailDuplication(emailController.text.trim());
                },
                isEnabled: emailState.isFormatValid == true && emailState.isDuplicate == null,
                enabledText: '확인',
                disabledText: (emailState.isDuplicate == false) ? '확인 완료' : '확인',
                isLoading: emailState.isLoading,
              ),
            ],
          ),
          // 이메일 인증
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: emailCodeState.isError == true
                            ? ColorStyles.warning100
                            : emailCodeState.isError == false
                            ? ColorStyles.primaryColor
                            : ColorStyles.gray2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: emailCodeController,
                          hintText: '인증 코드 입력',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CheckDuplicationButton(
                onTab: () async {
                  await ref.read(passwordResetViewModelProvider.notifier).sendEmailVerificationCode(emailController.text.trim());
                },
                isEnabled: emailState.isDuplicate == false &&
                    emailCodeState.isTimerRunning != true &&
                    emailCodeState.isChecked != true,
                enabledText: '인증 요청',
                disabledText: (emailCodeState.isTimerRunning == true) ? formatDuration(emailCodeState.remainingSeconds!) : '인증 요청',
                isLoading: emailCodeState.isCodeLoading,
              ),
              CheckDuplicationButton(
                onTab: () async {
                  if (emailCodeController.text.isEmpty) return;
                  await ref.read(passwordResetViewModelProvider.notifier).checkEmailVerificationCode(emailController.text.trim(), emailCodeController.text.trim());
                },
                isEnabled: emailCodeState.isChecked != true &&
                    emailCodeState.isTimerRunning == true &&
                    emailCodeState.failCount < 3,
                enabledText: '확인',
                disabledText: (emailCodeState.isChecked == true) ? '확인 완료' : '확인',
                isLoading: emailCodeState.isCheckLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
