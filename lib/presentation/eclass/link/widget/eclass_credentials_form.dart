import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class EclassCredentialsForm extends StatelessWidget {
  final TextEditingController eclassIdController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isSubmitting;
  final bool canSubmit;
  final String? errorMessage;
  final ValueChanged<String> onChanged;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSubmit;

  const EclassCredentialsForm({
    super.key,
    required this.eclassIdController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isSubmitting,
    required this.canSubmit,
    required this.errorMessage,
    required this.onChanged,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이클래스 계정',
            style: TextStyles.largeTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),
          _EclassTextField(
            key: const Key('eclass-id-field'),
            controller: eclassIdController,
            hintText: '이클래스 아이디',
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
            onChanged: onChanged,
          ),
          const SizedBox(height: 12),
          _EclassTextField(
            key: const Key('eclass-password-field'),
            controller: passwordController,
            hintText: '이클래스 비밀번호',
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onChanged: onChanged,
            onSubmitted: (_) {
              if (canSubmit && !isSubmitting) onSubmit();
            },
            suffix: IconButton(
              tooltip: obscurePassword ? '비밀번호 표시' : '비밀번호 숨기기',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              onPressed: onTogglePasswordVisibility,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: ColorStyles.gray4,
              ),
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              errorMessage!,
              key: const Key('eclass-form-error'),
              style: TextStyles.smallTextRegular.copyWith(
                color: ColorStyles.warning100,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('eclass-link-button'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              backgroundColor: ColorStyles.primary100,
              disabledBackgroundColor: ColorStyles.gray2,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: canSubmit && !isSubmitting ? onSubmit : null,
            child: isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorStyles.white,
                    ),
                  )
                : Text(
                    '연동하기',
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EclassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  const _EclassTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    required this.textInputAction,
    required this.autofillHints,
    required this.onChanged,
    this.onSubmitted,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorStyles.gray2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enableSuggestions: false,
        autocorrect: false,
        keyboardType: TextInputType.text,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        cursorColor: ColorStyles.gray4,
        style: TextStyles.normalTextRegular.copyWith(
          color: ColorStyles.black,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyles.normalTextRegular.copyWith(
            color: ColorStyles.gray4,
          ),
          contentPadding: EdgeInsets.zero,
          suffixIcon: suffix,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
        ),
      ),
    );
  }
}
