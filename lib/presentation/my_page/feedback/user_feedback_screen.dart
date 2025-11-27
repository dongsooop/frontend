import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/feedback/enum/service_feature.dart';
import 'package:dongsoop/presentation/my_page/feedback/view_model/feedback_write_view_model.dart';
import 'package:dongsoop/presentation/board/common/components/board_text_form_field.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Map<ServiceFeature, String> _serviceFeatureOptions = {
  ServiceFeature.noticeAlert: '교내 공지 알림 서비스',
  ServiceFeature.mealInformation: '학식 정보 확인 서비스',
  ServiceFeature.academicSchedule: '학사 일정 확인 및 개인 일정 관리',
  ServiceFeature.timetableAutoManage: '시간표 자동 입력 및 관리',
  ServiceFeature.teamRecruitment: '팀원 모집(스터디/튜터링/프로젝트)',
  ServiceFeature.marketplace: '장터(교재 등 중고 거래)',
  ServiceFeature.chatbotCampusInfo: '챗봇을 통한 교내 정보 확인',
};

class UserFeedbackScreen extends ConsumerStatefulWidget {
  const UserFeedbackScreen({super.key});

  @override
  ConsumerState<UserFeedbackScreen> createState() =>
      _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends ConsumerState<UserFeedbackScreen> {
  late final TextEditingController _improveController;
  late final TextEditingController _additionalController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(feedbackWriteViewModelProvider);

    _improveController =
        TextEditingController(text: state.improvementSuggestions);
    _additionalController =
        TextEditingController(text: state.featureRequests);

    _improveController.addListener(() {
      ref
          .read(feedbackWriteViewModelProvider.notifier)
          .updateImprovementSuggestions(_improveController.text);
    });

    _additionalController.addListener(() {
      ref
          .read(feedbackWriteViewModelProvider.notifier)
          .updateFeatureRequests(_additionalController.text);
    });
  }

  @override
  void dispose() {
    _improveController.dispose();
    _additionalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedbackWriteViewModelProvider);
    final viewmodel = ref.read(feedbackWriteViewModelProvider.notifier);

    final isSubmitEnabled = viewmodel.isFormValid && !state.isLoading;

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
                children: ServiceFeature.values.map((feature) {
                  final label = _serviceFeatureOptions[feature]!;
                  final isSelected =
                  state.serviceFeatureList.contains(feature);

                  return _selectServiceChip(
                    label: label,
                    value: isSelected,
                    loading: state.isLoading,
                    onChanged: (_) => viewmodel.toggleFeature(feature),
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
              ),
              if (state.improvementError != null) ...[
                const SizedBox(height: 4),
                Text(
                  state.improvementError!,
                  style: TextStyles.smallTextRegular
                      .copyWith(color: ColorStyles.warning100),
                ),
              ],

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
              ),
              if (state.featureError != null) ...[
                const SizedBox(height: 4),
                Text(
                  state.featureError!,
                  style: TextStyles.smallTextRegular
                      .copyWith(color: ColorStyles.warning100),
                ),
              ],

              if (state.errMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  state.errMessage!,
                  style: TextStyles.smallTextRegular
                      .copyWith(color: ColorStyles.warning100),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: PrimaryBottomButton(
        label: '제출하기',
        isEnabled: isSubmitEnabled,
        isLoading: state.isLoading,
        onPressed: isSubmitEnabled
            ? () async {
          final success = await viewmodel.submit();
          if (!context.mounted) return;

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('피드백이 제출되었습니다. 감사합니다.')),
            );
            Navigator.of(context).pop();
          }
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
