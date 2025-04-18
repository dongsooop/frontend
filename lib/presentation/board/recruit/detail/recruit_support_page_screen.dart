import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class RecruitSupportPageScreen extends StatefulWidget {
  const RecruitSupportPageScreen({super.key});

  @override
  State<RecruitSupportPageScreen> createState() =>
      _RecruitSupportPageScreenState();
}

class _RecruitSupportPageScreenState extends State<RecruitSupportPageScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final introduceController = TextEditingController();
  final supportController = TextEditingController();

  // 작성자의 학과 (자동 포함)
  final String writerMajor = '컴퓨터소프트웨어공학과';

  // 폼 유효성 여부 (상태로 관리)
  bool isFormValid = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: DetailHeader(title: '지원하기'),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          label: '지원하기',
          isEnabled: isFormValid,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CustomConfirmDialog(
                title: '모집 지원',
                content: '제출한 글은 수정할 수 없어요\n글을 제출할까요?',
                cancelText: '취소',
                confirmText: '제출',
                onConfirm: () {
                  // 제출 처리 로직
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              onChanged: () {
                // 추후 입력 로직 작성
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '학과',
                    style: TextStyles.largeTextBold
                        .copyWith(color: ColorStyles.black),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: false,
                    initialValue: writerMajor,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: writerMajor,
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '자기소개',
                    style: TextStyles.largeTextBold
                        .copyWith(color: ColorStyles.black),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: introduceController,
                    // onChanged: (_) => _updateFormValidState(),
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '자기소개를 적어주세요',
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '지원 동기',
                    style: TextStyles.largeTextBold
                        .copyWith(color: ColorStyles.black),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: supportController,
                    // onChanged: (_) => _updateFormValidState(),
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '지원 동기를 적어주세요',
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
