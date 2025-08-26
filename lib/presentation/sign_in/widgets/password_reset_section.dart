import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'custom_text_field.dart';

class PasswordResetSection extends ConsumerWidget {
  final TextEditingController passwordController;
  final TextEditingController passwordCheckController;

  const PasswordResetSection({
    super.key,
    required this.passwordController,
    required this.passwordCheckController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordState = ref.watch(passwordResetViewModelProvider).password;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 필드 구분 & 입력 체크 메시지
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '비밀번호',
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
                    passwordState.message ?? '영문, 숫자, 특수문자 포함 8자 이상 입력해 주세요',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: (passwordState.isError == true)
                          ? ColorStyles.warning100
                          : ColorStyles.gray4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 텍스트 필드 & 버튼
          Container(
            height: 44,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: passwordState.isError == true
                      ? ColorStyles.warning100
                      : passwordState.isError == false
                      ? ColorStyles.primaryColor
                      : ColorStyles.gray2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: CustomTextField(
              controller: passwordController,
              hintText: '비밀번호 입력',
              obscureText: true,
            ),
          ),
          Container(
            height: 44,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: passwordState.isChecked == null
                      ? ColorStyles.gray2
                      : passwordState.isChecked == false
                      ? ColorStyles.warning100
                      : ColorStyles.primaryColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: CustomTextField(
              controller: passwordCheckController,
              hintText: '비밀번호 확인',
              obscureText: true,
            ),
          ),
        ],
      ),
    );
  }
}