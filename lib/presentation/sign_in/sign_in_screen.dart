import 'package:dongsoop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/providers/auth_providers.dart';

import '../../core/presentation/components/detail_header.dart';

class SignInScreen extends HookConsumerWidget {
  final VoidCallback onTapSignUp;

  const SignInScreen({
    super.key,
    required this.onTapSignUp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // text field controller - emial, password
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    // providers
    final loginState = ref.watch(signInViewModelProvider);
    final viewModel = ref.watch(signInViewModelProvider.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              SizedBox(height: 24,),
              SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 128,
                height: 128,
                colorFilter: const ColorFilter.mode(
                  ColorStyles.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 8),
              // 이메일 입력
              Container(
                width: double.infinity,
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 16,),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: ColorStyles.gray2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: emailController,
                        hintText: '학교 Gmail을 입력해 주세요',
                        obscureText: false,
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

              // 비밀번호 입력
              Container(
                width: double.infinity,
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 16,),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: ColorStyles.gray2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:  _buildTextField(
                  controller: passwordController,
                  hintText: '비밀번호를 입력해 주세요',
                  obscureText: true,
                ),
              ),
              // 에러 메시지 표시
              SizedBox(
                height: 32,
                child: loginState.hasError
                  ? Text(
                    loginState.error.toString(),
                    style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.warning100),
                  )
                  : null,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  backgroundColor: ColorStyles.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0
                ),
                onPressed: loginState is AsyncLoading
                  ? null
                  : () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    await viewModel.login(email, password);

                    final loginResult = ref.read(signInViewModelProvider);
                    loginResult.whenOrNull(
                      data: (_) => context.go(RoutePaths.mypage),
                      error: (e, _) => logger.i("로그인 실패: $e"),
                    );
                  },
                child: loginState is AsyncLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('로그인', style: TextStyles.normalTextBold.copyWith(color: ColorStyles.white)),
              ),
              OutlinedButton(
                onPressed: onTapSignUp,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: ColorStyles.primaryColor),
                ),
                child: Text('회원가입', style: TextStyles.normalTextBold.copyWith(color: ColorStyles.primaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: TextInputType.text,
      cursorColor: ColorStyles.gray4,
      style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 11,),
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
      ),
    );
  }
}
