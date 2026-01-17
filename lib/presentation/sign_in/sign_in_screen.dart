import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/domain/auth/enum/login_entry.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
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
  final VoidCallback onTapPasswordReset;

  const SignInScreen({
    super.key,
    required this.onTapSignUp,
    required this.onTapPasswordReset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // text field controller - emial, password
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    // providers
    final loginState = ref.watch(signInViewModelProvider);
    final viewModel = ref.watch(signInViewModelProvider.notifier);

    ref.listen(signInViewModelProvider, (prev, next) {
      final wasLoading = prev?.isLoading ?? false;
      if (!wasLoading || next.isLoading) return;

      final user = ref.read(userSessionProvider);
      final hasAnyError = next.errorMessage != null || next.dialogMessage != null;

      if (!hasAnyError && user != null) {
        context.go(RoutePaths.mypage);
      }
    });

    useEffect(() {
      final message = loginState.dialogMessage;
      if (message == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        viewModel.clearErrorMessage();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => CustomConfirmDialog(
            title: '소셜 로그인 오류',
            content: message,
            onConfirm: () {},
            onCancel: () {},
          ),
        );
      });

      return null;
    }, [loginState.dialogMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: [
                  SizedBox(height: 16,),
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
                    alignment: Alignment.center,
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
                    alignment: Alignment.center,
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
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 24),
                    child: (loginState.errorMessage != null)
                      ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          loginState.errorMessage!,
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.warning100,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
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
                    onPressed: loginState.isLoading
                      ? null
                      : () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text;
                        await viewModel.login(email, password);
                      },
                    child: loginState.isLoading
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
                  InkWell(
                    onTap: onTapPasswordReset,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 44,
                      ),
                      child: Text(
                        '비밀번호 변경',
                        style: TextStyles.smallTextBold.copyWith(color: ColorStyles.gray4)
                      ),
                    ),
                  ),

                  // 소셜 로그인
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 24,
                    children: [
                      // 카카오
                      GestureDetector(
                        onTap: () async {
                          KakaoLoginFlow.entry = LoginEntry.signIn;
                          await viewModel.socialLogin(LoginPlatform.kakao);
                        },
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/kakao_symbol.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 구글
                      GestureDetector(
                        onTap: () async {
                          await viewModel.socialLogin(LoginPlatform.google);
                        },
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/google_symbol.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 애플
                      GestureDetector(
                        onTap: () async {
                          await viewModel.socialLogin(LoginPlatform.apple);
                        },
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/apple_symbol.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0,),
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
      ),
    );
  }
}
