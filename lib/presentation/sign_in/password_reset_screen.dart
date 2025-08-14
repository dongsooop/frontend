import 'package:dongsoop/presentation/sign_in/widgets/password_reset_email_section.dart';
import 'package:dongsoop/presentation/sign_in/widgets/password_reset_section.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';

class PasswordResetScreen extends HookConsumerWidget {

  const PasswordResetScreen({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(passwordResetViewModelProvider.notifier);
    final PWResetState = ref.watch(passwordResetViewModelProvider);

    final emailController = useTextEditingController();
    final emailCodeController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordCheckController = useTextEditingController();

    useEffect(() {
      emailController.addListener(() {
        viewModel.onEmailChanged(emailController.text.trim() + '@dongyang.ac.kr');
      });
      return null;
    }, [emailController]);

    useEffect(() {
      passwordController.addListener(() {
        viewModel.onPasswordChanged(passwordController.text.trim(), passwordCheckController.text.trim());
      });
      passwordCheckController.addListener(() {
        viewModel.onPasswordCheckChanged(passwordCheckController.text.trim());
      });
      return null;
    }, [passwordController, passwordCheckController]);

    // 오류
    useEffect(() {
      if (PWResetState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '비밀번호 변경 오류',
              content: PWResetState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [PWResetState.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '비밀번호 재설정',
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 48,
              children: [
                PWResetState.isEmailStep
                ? PasswordResetEmailSection(
                  emailController: emailController,
                  emailCodeController: emailCodeController,
                )
                : PasswordResetSection(
                  passwordController: passwordController,
                  passwordCheckController: passwordCheckController,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PWResetState.isEmailStep
      ? PrimaryBottomButton(
        onPressed: () {
          if (!PWResetState.isEmailValid) return;
          viewModel.next();
        },
        label: '다음',
        isLoading: false,
        isEnabled: PWResetState.isEmailValid,
      )
      : PrimaryBottomButton(
        onPressed: () async {
          if (!PWResetState.isEmailValid) return;
          final isSuccessed = await viewModel.passwordReset();
          if (!context.mounted) return;
          
          if (isSuccessed) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => CustomConfirmDialog(
                title: '비밀번호 변경',
                content: '비밀번호 변경에 성공했어요.\n로그인 페이지로 이동할까요?',
                isSingleAction: true,
                confirmText: '확인',
                dismissOnConfirm: false,
                onConfirm: () {
                  Navigator.of(context).pop();
                  context.pop();
                },
              ),
            );
          }
        },
        label: '비밀번호 변경하기',
        isLoading: PWResetState.isLoading,
        isEnabled: PWResetState.isPasswordValid,
      ),
    );
  }
}
