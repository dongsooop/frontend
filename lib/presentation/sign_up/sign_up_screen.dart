import 'package:dongsoop/domain/auth/model/department_type_ext.dart';
import 'package:dongsoop/presentation/sign_up/widgets/check_duplication_button.dart';
import 'package:dongsoop/presentation/sign_up/widgets/dept_select_bottom_sheet.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/auth/model/department_type.dart';

class SignUpScreen extends HookConsumerWidget {

  const SignUpScreen({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(signUpViewModelProvider.notifier);
    final signUpState = ref.watch(signUpViewModelProvider);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordCheckController = useTextEditingController();
    final nicknameController = useTextEditingController();
    final selectedDept = useState<DepartmentType?>(null);

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

    useEffect(() {
      nicknameController.addListener(() {
        viewModel.onNicknameChanged(nicknameController.text.trim());
      });
      return null;
    }, [nicknameController]);

    if (signUpState.errorMessage != null) {
      return Center(
        child: Text(
          signUpState.errorMessage!,
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 24,
              color: ColorStyles.black,
            ),
          ),
          centerTitle: true,
          title: Text(
            '동숲 회원가입',
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 48,
            children: [
              _buildEmailSection(emailController, ref),
              _buildPasswordSection(passwordController, passwordCheckController, ref),
              _buildNicknameSection(nicknameController, ref),
              _buildDeptSection(context, selectedDept, ref),
              // 이용약관
            ],
          ),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          onPressed: () async {
            if (!signUpState.isEmailValid || !signUpState.isNicknameValid || !signUpState.isPasswordValid || !signUpState.isDeptValid)
              return;
            // 회원가입
            final isSuccessed = await viewModel.signUp();
            if (isSuccessed) context.pop();
          },
          label: '가입하기',
          isLoading: signUpState.isLoading,
          isEnabled: (!signUpState.isEmailValid || !signUpState.isNicknameValid || !signUpState.isPasswordValid || !signUpState.isDeptValid)
            ? false
            : true,
        ),
      ),
    );
  }

  Widget _buildEmailSection(TextEditingController emailController, WidgetRef ref) {
    final emailState = ref.watch(signUpViewModelProvider).email;

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
              Text(
                emailState.message ?? '동양미래대학교 Gmail을 입력해 주세요',
                style: TextStyles.smallTextRegular.copyWith(
                  color: (emailState.isError == true)
                    ? ColorStyles.warning100
                    : ColorStyles.gray4,
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
                        child: _customTextFormField(emailController, '학교 Gmail 입력'),
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
                  // 중복 확인 메서드
                  if (emailController.text.isEmpty) return;
                  ref.read(signUpViewModelProvider.notifier).checkEmailDuplication(emailController.text.trim());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection(TextEditingController password, TextEditingController passwordCheck, WidgetRef ref) {
    final passwordState = ref.watch(signUpViewModelProvider).password;

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
              Text(
                passwordState.message ?? '영문, 숫자, 특수문자 포함 8자 이상 입력해 주세요',
                style: TextStyles.smallTextRegular.copyWith(
                  color: (passwordState.isError == true)
                    ? ColorStyles.warning100
                    : ColorStyles.gray4,
                ),
              ),
            ],
          ),
          // 텍스트 필드 & 버튼
          Container(
            height: 44,
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
            child: _customTextFormField(password, '비밀번호 입력', obscureText: true),
          ),
          Container(
            height: 44,
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
            child: _customTextFormField(passwordCheck, '비밀번호 확인', obscureText: true),
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameSection(TextEditingController nicknameController, WidgetRef ref) {
    final nicknameState = ref.watch(signUpViewModelProvider).nickname;

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
                      text: '닉네임',
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
              Text(
                nicknameState.message ?? '2~8글자로 입력해 주세요',
                style: TextStyles.smallTextRegular.copyWith(
                  color: (nicknameState.isError == true)
                    ? ColorStyles.warning100
                    : ColorStyles.gray4,
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: nicknameState.isError == null
                          ? ColorStyles.gray2
                          : nicknameState.isError == true
                            ? ColorStyles.warning100
                            : ColorStyles.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _customTextFormField(nicknameController, '닉네임 입력'),
                ),
              ),
              CheckDuplicationButton(
                onTab: () {
                  // 중복 확인 메서드
                  // 중복 확인 메서드
                  if (nicknameController.text.isEmpty) return;
                  ref.read(signUpViewModelProvider.notifier).checkNicknameDuplication(nicknameController.text.trim());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeptSection(BuildContext context, ValueNotifier<DepartmentType?> selectedDept, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 필드 구분 & 입력 체크 메시지
          _sectionLabel('학과', ''),
          // 텍스트 필드 & 버튼
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DeptSelectBottomSheet(
                  selectedDept: selectedDept.value,
                  onSelected: (dept) {
                    selectedDept.value = dept;
                    ref.read(signUpViewModelProvider.notifier).selectDept(selectedDept.value);
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
                    color: selectedDept.value == null
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
                      selectedDept.value?.displayName ?? '학과 선택',
                      style: TextStyles.normalTextRegular.copyWith(
                        color: selectedDept.value == null
                          ? ColorStyles.gray4
                          : ColorStyles.primaryColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_outlined,
                    size: 24,
                    color: selectedDept.value == null
                      ? ColorStyles.gray5
                      : ColorStyles.primaryColor,
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

  // 필드 구분 & 입력 상태 메시지
  Widget _sectionLabel(String label, String inputState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 8,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
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
        Text(
          inputState,
          style: TextStyles.smallTextRegular.copyWith(
            color: ColorStyles.gray4,
          ),
        ),
      ],
    );
  }

  // 텍스트 폼 필드
  Widget _customTextFormField(textController, String hintText, {bool obscureText = false}) {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      controller: textController,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyles.normalTextRegular.copyWith(
        color: ColorStyles.black,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
        contentPadding: EdgeInsets.symmetric(vertical: 11),
      ),
    );
  }
}
