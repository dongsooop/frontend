import 'package:dongsoop/domain/auth/model/department_type_ext.dart';
import 'package:dongsoop/presentation/sign_up/widgets/check_duplication_button.dart';
import 'package:dongsoop/presentation/sign_up/widgets/dept_select_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';

import '../../domain/auth/model/department_type.dart';

class SignUpScreen extends HookConsumerWidget {

  const SignUpScreen({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordCheckController = useTextEditingController();
    final nicknameController = useTextEditingController();
    final selectedDept = useState<DepartmentType?>(null);

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
              _buildEmailSection(emailController),
              _buildPasswordSection(passwordController, passwordCheckController),
              _buildNicknameSection(nicknameController),
              _buildDeptSection(context, selectedDept),
              // 이용약관
            ],
          ),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          onPressed: () {
            final email = emailController.text.trim();
            final password = passwordController.text.trim();
            final nickname = nicknameController.text.trim();
            final dept = selectedDept.value;
          },
          label: '가입하기',
          isEnabled: false,
        ),
      ),
    );
  }

  Widget _buildEmailSection(TextEditingController emailController) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 필드 구분 & 입력 체크 메시지
          _sectionLabel('이메일', '동양미래대학교 Gmail을 입력해 주세요'),
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
                      side: BorderSide(width: 1, color: ColorStyles.gray2),
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
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection(TextEditingController password, TextEditingController passwordCheck) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 필드 구분 & 입력 체크 메시지
          _sectionLabel('비밀번호', '영문, 숫자, 특수문자 포함 8자 이상 입력해 주세요'),
          // 텍스트 필드 & 버튼
          Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: ColorStyles.gray2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _customTextFormField(password, '비밀번호 입력'),
          ),
          Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: ColorStyles.gray2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _customTextFormField(passwordCheck, '비밀번호 확인'),
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameSection(TextEditingController nicknameController) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 필드 구분 & 입력 체크 메시지
          _sectionLabel('닉네임', '2자~8자의 닉네임을 입력해 주세요'),
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
                      side: BorderSide(width: 1, color: ColorStyles.gray2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _customTextFormField(nicknameController, '닉네임 입력'),
                ),
              ),
              CheckDuplicationButton(
                onTab: () {
                  // 중복 확인 메서드
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeptSection(BuildContext context, ValueNotifier<DepartmentType?> selectedDept) {
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
  // 학과 선택 바텀 시트


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
  Widget _customTextFormField(textController, String hintText) {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      controller: textController,
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
