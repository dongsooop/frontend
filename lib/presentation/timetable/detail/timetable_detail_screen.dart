import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/presentation/timetable/widgets/lecture_detail_bottom_sheet.dart';
import 'package:dongsoop/presentation/timetable/widgets/positioned_lecture_block.dart';
import 'package:dongsoop/presentation/timetable/widgets/timetable_analysis_botton_sheet.dart';
import 'package:dongsoop/presentation/timetable/widgets/timetable_grid.dart';
import 'package:dongsoop/providers/timetable_providers.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimetableDetailScreen extends HookConsumerWidget {
  final List<Lecture>? lectureList;
  final VoidCallback? onLectureChanged;

  final Future<bool> Function(Lecture editingLecture)? onEditLecture;

  TimetableDetailScreen({
    required this.lectureList,
    this.onLectureChanged,
    this.onEditLecture,
    super.key
  });

  static const double kFirstColumnHeight = 24;
  static const double kBoxSize = 48; // 30분 단위 높이

  // 시간표 색상
  final List<Color> lectureColors = [
    const Color(0xFFDCE1F0),
    const Color(0xFFF1D2D2),
    const Color(0xFFD2F3D4),
    const Color(0xFFE4DCFC),
    const Color(0xFFD5F1F3),
    const Color(0xFFF8DEEF),
    const Color(0xFFF9F2DE),
  ];

  // 시간표 최대 시간
  int calculateColumnLength(List<Lecture>? lectureList) {
    // 기본 종료 시각 블록 수: 14시까지 → (14 - 9) * 2 = 10블럭
    const int defaultBlockCount = (14 - 9) * 2;
    if (lectureList == null || lectureList.isEmpty) return defaultBlockCount;
    // endTime은 9시 기준 상대 분. 30분 단위 블록 개수로 변환해서 최대값 구함
    final int maxBlock = lectureList
        .map((e) => (e.endAt.toMinutesFrom9AM() / 30).ceil())
        .reduce((a, b) => a > b ? a : b);
    return maxBlock < defaultBlockCount ? defaultBlockCount : maxBlock;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableState = ref.watch(timetableViewModelProvider);
    final timetableDetailState = ref.watch(timetableDetailViewModelProvider);
    final viewModel = ref.read(timetableDetailViewModelProvider.notifier);

    final columnLength = calculateColumnLength(lectureList);

    useEffect(() {
      if (timetableDetailState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '시간표 오류',
              content: timetableDetailState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [timetableDetailState.errorMessage]);

    useEffect(() {
      if (timetableDetailState.analysisErrorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '시간표 자동 작성 실패',
              isSingleAction: true,
              content: timetableDetailState.analysisErrorMessage!,
              onConfirm: () async {

              },
            ),
          );
        });
      }
      return null;
    }, [timetableDetailState.analysisErrorMessage]);

    if (timetableDetailState.isLoading) {
      return Container(
        color: ColorStyles.white,
        child: Center(child: CircularProgressIndicator(color: ColorStyles.primaryColor,)),
      );
    }

    if (timetableDetailState.isAnalyzing) {
      final size = MediaQuery.sizeOf(context);
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: size.height),
        child: Container(
          color: ColorStyles.white,
          child: Center(
            child: Column(
              spacing: 24,
              children: [
                CircularProgressIndicator(
                  color: ColorStyles.primaryColor,
                ),
                Text(
                  timetableDetailState.analysisLoadingMessage!,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black,
                  ),
                )
              ],
            )
          ),
        ),
      );
    }

    return Column(
      spacing: 24,
      children: [
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: ColorStyles.gray2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          height: (columnLength / 2 * kBoxSize) + kFirstColumnHeight + 2,
          child: TimetableGrid(
            columnLength: columnLength,
            firstRowHeight: kFirstColumnHeight,
            slotHeight: kBoxSize,
            dayChildrenBuilder: (day, dayWidth) {
              if (lectureList == null) return const [];
              final colorList = lectureColors;
              final items = <Widget>[];
              for (final lecture in lectureList!) {
                if (lecture.week != day) continue;
                final color = colorList[lectureList!.indexOf(lecture) % colorList.length];
                items.add(
                  PositionedLectureBlock(
                    lecture: lecture,
                    firstRowHeight: kFirstColumnHeight,
                    slotHeight: kBoxSize,
                    dayWidth: dayWidth,
                    color: color,
                    onTap: () {
                      showLectureDetailBottomSheet(
                        context,
                        lecture: lecture,
                        onEdit: () async {
                          final ok = await onEditLecture?.call(lecture) ?? false;
                          if (ok) onLectureChanged?.call();
                        },
                        onDelete: () async {
                          await viewModel.deleteLecture(lecture.id);
                          onLectureChanged?.call();
                        },
                      );
                    },
                  ),
                );
              }
              return items;
            },
          ),
        ),
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: ColorStyles.gray2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                '시간표를 사진으로 자동 작성해 봐요',
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.black
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final year = timetableState.year!;
                  final semester = timetableState.semester!;
                  TimetableAnalysisBottomSheet(
                    context,
                      onSubmit: () async {
                        final ok = await viewModel.submitAnalysis(year, semester);
                        onLectureChanged?.call();

                        final msg = ref.read(timetableDetailViewModelProvider).analysisErrorMessage;
                        final notifier = ref.read(timetableDetailViewModelProvider.notifier);
                        if (!ok && msg != null && context.mounted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => CustomConfirmDialog(
                              title: '시간표 자동 작성 실패',
                              isSingleAction: true,
                              content: msg,
                              onConfirm: () {},
                            ),
                          );

                          if (!context.mounted) return;
                          notifier.clearAnalysisError();
                        }
                      }
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: ColorStyles.primaryColor,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '시간표 자동 작성하기',
                  style: TextStyles.normalTextBold.copyWith(color: ColorStyles.white),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}