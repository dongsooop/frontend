import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/presentation/sign_up/widgets/agreement_bottom_sheet.dart';
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
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/auth/enum/agreement_type.dart';

import '../../core/utils/time_formatter.dart';

class SignUpScreen extends HookConsumerWidget {

  const SignUpScreen({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(signUpViewModelProvider.notifier);
    final signUpState = ref.watch(signUpViewModelProvider);

    final emailController = useTextEditingController();
    final emailCodeController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordCheckController = useTextEditingController();
    final nicknameController = useTextEditingController();
    final selectedDept = useState<DepartmentType?>(null);
    final agreement = useState<Map<AgreementType, bool>>({
      AgreementType.termsOfService: false,
      AgreementType.privacyPolicy: false,
    });

    const termsOfService = 'https://zircon-football-529.notion.site/Dongsoop-2333ee6f2561800cb85fdc87fbe9b4c2';
    const privacyPolicy = 'https://zircon-football-529.notion.site/Dongsoop-2333ee6f256180a0821fdbf087345a1d';

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

    // 오류
    useEffect(() {
      if (signUpState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '회원가입 오류',
              content: signUpState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [signUpState.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '동숲 회원가입',
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
                _buildEmailSection(emailController, emailCodeController, ref),
                _buildPasswordSection(passwordController, passwordCheckController, ref),
                _buildNicknameSection(nicknameController, ref),
                _buildDeptSection(context, selectedDept, ref),
                _buildAgreement(context, agreement, ref, termsOfService, privacyPolicy),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PrimaryBottomButton(
        onPressed: () async {
          if (!signUpState.isEmailValid ||
              !signUpState.isNicknameValid ||
              !signUpState.isPasswordValid ||
              !signUpState.isDeptValid ||
              !agreement.value.values.every((v) => v)) {
            return;
          }
          // 회원가입
          final isSuccessed = await viewModel.signUp();
          if (isSuccessed) context.pop();
        },
        label: '가입하기',
        isLoading: signUpState.isLoading,
        isEnabled: signUpState.isEmailValid &&
            signUpState.isNicknameValid &&
            signUpState.isPasswordValid &&
            signUpState.isDeptValid &&
            agreement.value.values.every((v) => v),
      ),
    );
  }

  Widget _buildEmailSection(TextEditingController emailController, TextEditingController emailCodeController, WidgetRef ref) {
    final emailState = ref.watch(signUpViewModelProvider).email;
    final emailCodeState = ref.watch(signUpViewModelProvider).emailCode;

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
                  color: (emailState.isDuplicate == false && emailState.message == '이메일 인증이 필요해요')
                    ? ColorStyles.warning100
                    : (emailState.isError == true || emailCodeState.isError == true)
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
                  if (emailController.text.isEmpty) return;
                  ref.read(signUpViewModelProvider.notifier).checkEmailDuplication(emailController.text.trim());
                },
                isEnabled: emailState.isFormatValid == true && emailState.isDuplicate == null,
                enabledText: '중복 검사',
                disabledText: (emailState.isDuplicate == false) ? '확인 완료' : '중복 검사',
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
                      Expanded(child: _customTextFormField(emailCodeController, '인증 코드 입력')),
                    ],
                  ),
                ),
              ),
              CheckDuplicationButton(
                onTab: () async {
                  await ref.read(signUpViewModelProvider.notifier).sendEmailVerificationCode(emailController.text.trim());
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
                  await ref.read(signUpViewModelProvider.notifier).checkEmailVerificationCode(emailController.text.trim(), emailCodeController.text.trim());
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
            child: _customTextFormField(password, '비밀번호 입력', obscureText: true),
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
                  alignment: Alignment.center,
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
                  if (nicknameController.text.isEmpty) return;
                  ref.read(signUpViewModelProvider.notifier).checkNicknameDuplication(nicknameController.text.trim());
                },
                isEnabled: (nicknameState.isNumberFormatValid == true && nicknameState.isSpecialCharacterValid == true && nicknameState.isDuplicate != true),
                enabledText: '중복 검사',
                disabledText: (nicknameState.isDuplicate == false) ? '확인 완료' : '중복 검사',
                isLoading: nicknameState.isLoading,
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

  Widget _buildAgreement(BuildContext context, ValueNotifier<Map<AgreementType, bool>> agreement, WidgetRef ref, String termsOfService, String privacyPolicy) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 필드 구분 & 입력 체크 메시지
          _sectionLabel('이용약관 동의', ''),
          // 텍스트 필드 & 버튼
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AgreementBottomSheet(
                  initialValues: {
                    AgreementType.termsOfService: false,
                    AgreementType.privacyPolicy: false,
                  },
                  onViewDetail: (type) {
                    if (type == AgreementType.termsOfService) {
                      context.push(
                        '/mypageWebView?url=$termsOfService&title=서비스 이용약관'
                      );
                    } else if (type == AgreementType.privacyPolicy) {
                      context.push(
                        '/mypageWebView?url=$privacyPolicy&title=개인정보처리방침'
                      );
                    }
                  },
                  onChanged: (state) {
                    agreement.value = state;
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
                      color: agreement.value.values.every((v) => v)
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
                        agreement.value.values.every((v) => v)
                            ? '약관에 동의했어요'
                            : '이용약관 확인 및 동의',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: agreement.value.values.every((v) => v)
                              ? ColorStyles.primaryColor
                              : ColorStyles.gray4,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_outlined,
                      size: 24,
                      color: agreement.value.values.every((v) => v)
                          ? ColorStyles.primaryColor
                          : ColorStyles.gray5,
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
        isDense: true,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
        contentPadding: EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}
