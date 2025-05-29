import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class SignInScreen extends ConsumerStatefulWidget {
  final VoidCallback onTapSignUp;

  const SignInScreen({
    super.key,
    required this.onTapSignUp,
  });

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.chevron_left_outlined, size: 24, color: ColorStyles.black,
            ),
          ),
        ),
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
              _buildTextField(
                controller: _userEmailController,
                hintText: '동양미래대학교 이메일을 입력해 주세요',
                obscureText: false,
              ),
              _buildTextField(
                controller: _userPwController,
                hintText: '비밀번호를 입력해 주세요',
                obscureText: true,
              ),
              const SizedBox(height: 8),
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
                    final email = _userEmailController.text.trim();
                    final password = _userPwController.text;
                    await viewModel.login(email, password);

                    // 성공 시 화면 전환
                    final state = ref.read(loginViewModelProvider);
                    state.whenOrNull(
                      data: (_) {
                        logger.i("로그인 성공");
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('로그인 성공')),
                        // );
                        // context.go('/home');
                      },
                      error: (err, _) {
                        logger.i("로그인 실패: ${err.toString()}");
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text(err.toString())),
                        // );
                      },
                    );
                  },
                child: loginState is AsyncLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('로그인', style: TextStyles.normalTextBold.copyWith(color: ColorStyles.white)),
              ),
              OutlinedButton(
                onPressed: widget.onTapSignUp,
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
    return Container(
      width: double.infinity,
      height: 44,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: ColorStyles.gray2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.text,
        cursorColor: ColorStyles.gray4,
        style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
        ),
      ),
    );
  }
}
