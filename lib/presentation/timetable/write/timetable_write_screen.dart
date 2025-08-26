import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/presentation/timetable/widgets/show_picker_bottom_sheet.dart';
import 'package:dongsoop/providers/timetable_providers.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';

class TimetableWriteScreen extends HookConsumerWidget {

  const TimetableWriteScreen({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(timetableWriteViewModelProvider.notifier);
    final state = ref.watch(timetableWriteViewModelProvider);

    final selectedYear = useState<int?>(null);
    final selectedSemester = useState<Semester?>(null);

    // 오류
    useEffect(() {
      if (state.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '시간표 오류',
              content: state.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [state.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '시간표 만들기',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 48,
            children: [
              _buildYearSection(context, selectedYear, ref),
              _buildSemesterSection(context, selectedSemester, ref),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PrimaryBottomButton(
        onPressed: () async {
          if (state.year == null || state.semester == null) return;
          final isSuccessed = await viewModel.createTimetable();
          if (!context.mounted) return;

          if (isSuccessed) {
            context.pop();
          }
        },
        label: '완료',
        isLoading: state.isLoading,
        isEnabled: (state.year != null && state.semester != null),
      ),
    );
  }

  // 필드 구분 & 입력 상태 메시지
  Widget _sectionLabel(String label) {
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
      ],
    );
  }

  Widget _buildYearSection(BuildContext context, ValueNotifier<int?> selectedYear, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 필드 구분 & 입력 체크 메시지
          _sectionLabel('시간표 학년도'),
          // 텍스트 필드 & 버튼
          GestureDetector(
            onTap: () {
              showYearPickerBottomSheet(
                context,
                currentYear: DateTime.now().year,
                onDone: (year) {
                  selectedYear.value = year;
                  ref.read(timetableWriteViewModelProvider.notifier).setYear(year);
                },
              );
            },
            child: Container(
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: selectedYear.value == null
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
                      selectedYear.value != null
                        ? '${selectedYear.value}년'
                        : '연도 선택',
                      style: TextStyles.normalTextRegular.copyWith(
                        color: selectedYear.value == null
                          ? ColorStyles.gray4
                          : ColorStyles.primaryColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_outlined,
                    size: 24,
                    color: selectedYear.value == null
                        ? ColorStyles.gray5
                        : ColorStyles.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterSection(BuildContext context, ValueNotifier<Semester?> selectedSemester, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 16,
        children: [
          // 필드 구분 & 입력 체크 메시지
          _sectionLabel('시간표 학기'),
          // 텍스트 필드 & 버튼
          GestureDetector(
            onTap: () {
              showSemesterPickerBottomSheet(
                context,
                items: Semester.values,
                onDone: (sem) {
                  selectedSemester.value = sem;
                  ref.read(timetableWriteViewModelProvider.notifier).setSemester(sem);
                },
              );
            },
            child: Container(
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: selectedSemester.value == null
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
                      selectedSemester.value?.label ?? '학기 선택',
                      style: TextStyles.normalTextRegular.copyWith(
                        color: selectedSemester.value == null
                          ? ColorStyles.gray4
                          : ColorStyles.primaryColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_outlined,
                    size: 24,
                    color: selectedSemester.value == null
                        ? ColorStyles.gray5
                        : ColorStyles.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
