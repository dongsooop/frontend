import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/presentation/board/common/components/board_text_form_field.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class UserFeedbackScreen extends StatefulWidget {
  const UserFeedbackScreen({super.key});

  @override
  State<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> {
  static const List<String> _serviceOptions = [
    '교내 공지 알림 서비스',
    '학식 정보 확인 서비스',
    '학사 일정 확인 및 개인 일정 관리',
    '시간표 자동 입력 및 관리',
    '팀원 모집(스터디/튜터링/프로젝트)',
    '장터(교재 등 중고 거래)',
    '챗봇을 통한 교내 정보 확인',
  ];

  final Set<String> _selectedServices = {};
  final TextEditingController _improveController = TextEditingController();
  final TextEditingController _additionalController = TextEditingController();

  @override
  void dispose() {
    _improveController.dispose();
    _additionalController.dispose();
    super.dispose();
  }

  bool get _isSubmitEnabled =>
      _selectedServices.isNotEmpty &&
          _improveController.text.trim().isNotEmpty &&
          _additionalController.text.trim().isNotEmpty;

  void _toggleService(String label) {
    setState(() {
      if (_selectedServices.contains(label)) {
        _selectedServices.remove(label);
      } else {
        if (_selectedServices.length >= 3) return;
        _selectedServices.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailHeader(title: '사용자 피드백'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 24,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _requiredLabel("앱을 사용하며 가장 편리했던 서비스를 선택해주세요"),
              const SizedBox(height: 4),
              Text(
                "최대 3개까지 중복 선택 가능해요",
                style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 16,
                children: _serviceOptions.map((label) {
                  final isSelected = _selectedServices.contains(label);
                  return _selectServiceChip(
                    label: label,
                    value: isSelected,
                    loading: false,
                    onChanged: (_) => _toggleService(label),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              _requiredLabel("앱을 사용하며 개선되었으면 하는 부분이 있었나요?"),
              const SizedBox(height: 16),
              BoardTextFormField(
                controller: _improveController,
                hintText: '불편했던 점이나 개선 아이디어를 적어주세요',
                maxLines: 4,
                maxLength: 150,
                keyboardType: TextInputType.multiline,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 32),

              _requiredLabel("추가되었으면 하는 서비스가 있나요?"),
              const SizedBox(height: 4),
              Text(
                "여러분의 의견을 자유롭게 적어주세요",
                style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
              ),
              const SizedBox(height: 16),
              BoardTextFormField(
                controller: _additionalController,
                hintText: '있었으면 하는 기능이나 서비스를 적어주세요',
                maxLines: 4,
                maxLength: 150,
                keyboardType: TextInputType.multiline,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PrimaryBottomButton(
        label: '제출하기',
        isEnabled: _isSubmitEnabled,
        isLoading: false,
        onPressed: _isSubmitEnabled
            ? () {
          // TODO: 제출 로직 추가
        }
            : null,
      ),
    );
  }

  Widget _selectServiceChip({
    required String label,
    required bool value,
    required bool loading,
    required ValueChanged<bool> onChanged,
  }) {
    final isSelected = value;

    return GestureDetector(
      onTap: loading ? null : () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorStyles.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ColorStyles.primaryColor : ColorStyles.gray2,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.smallTextRegular.copyWith(
            color: isSelected ? ColorStyles.primaryColor : ColorStyles.gray4,
          ),
        ),
      ),
    );
  }

  Widget _requiredLabel(String label) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black),
        ),
        Text(
          " *",
          style: TextStyles.normalTextBold.copyWith(color: ColorStyles.primaryColor),
        ),
      ],
    );
  }
}
