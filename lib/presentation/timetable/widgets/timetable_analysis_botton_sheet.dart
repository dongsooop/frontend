import 'dart:io';
import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/providers/timetable_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Future<void> TimetableAnalysisBottomSheet(
  BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        minChildSize: 0.6,
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return AnalysisDetailSheet(
            scrollController: scrollController,
          );
        },
      );
    },
  );
}

class AnalysisDetailSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const AnalysisDetailSheet({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timetableDetailViewModelProvider);
    final viewModel = ref.read(timetableDetailViewModelProvider.notifier);

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final img = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 2000,
      );
      if (img != null) viewModel.setAnalysisImage(img);
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              '강의 시간표 자동 작성',
              style: TextStyles.titleTextBold.copyWith(color: ColorStyles.black),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'e서비스 -> 수강신청내역조회(시간표) -> 강의시간표 화면',
                    style: TextStyles.smallTextBold.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                  TextSpan(
                    text: '을\n아래와 같이 캡처해서 제출해 주세요',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray4,
                    ),
                  ),
                ],
              ),
            ),
            // 시간표 예시 이미지
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.asset(
                  'assets/images/timetable.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
      
            // 시간표 선택 버튼
            Text(
              '시간표 사진',
              style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
            ),
      
            GestureDetector(
              onTap: () {
                if (state.analysisImage == null) {
                  _pickImage();
                } else {
                  customActionSheet(
                    context,
                    onEdit: _pickImage,
                    editText: '사진 변경',
                    onDelete: viewModel.clearAnalysisImage,
                    deleteText: '삭제',
                  );
                }
              },
              child: state.analysisImage == null
                ? Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorStyles.gray2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt, size: 24, color: ColorStyles.gray4),
                  ),
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(state.analysisImage!.path),
                    width: 56, height: 56, fit: BoxFit.cover,
                  ),
                ),
            ),
            const SizedBox(height: 8),
      
            // 제출 버튼
            ElevatedButton(
              onPressed: state.canSubmitAnalysis
                ? () async {
                  await viewModel.submitAnalysis();
                  if (context.mounted) Navigator.of(context).pop();
                }
                : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: state.canSubmitAnalysis
                  ? ColorStyles.primaryColor
                  : ColorStyles.gray1,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '작성하기',
                style: TextStyles.normalTextBold.copyWith(
                  color: state.canSubmitAnalysis ? ColorStyles.white : ColorStyles.gray3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}