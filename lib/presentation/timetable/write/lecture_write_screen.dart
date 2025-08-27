import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/presentation/timetable/widgets/day_picker_bottom_sheet.dart';
import 'package:dongsoop/presentation/timetable/widgets/lecture_time_picker_bottom_sheet.dart';
import 'package:dongsoop/presentation/timetable/widgets/positioned_lecture_block.dart';
import 'package:dongsoop/presentation/timetable/widgets/timetable_grid.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LectureWriteScreen extends HookConsumerWidget {
  final List<Lecture>? lectureList;

  LectureWriteScreen({
    required this.lectureList,
    super.key
  });

  static const int kColumnLength = 28;
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

  WeekDay selectedDay = WeekDay.MONDAY;
  int startHour = 9;
  int startMinute = 0;
  int endHour = 10;
  int endMinute = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final lectureWriteState = ref.watch(timetableViewModelProvider);
    // final viewModel = ref.read(timetableViewModelProvider.notifier);

    final nameController = useTextEditingController();
    final professorController = useTextEditingController();
    final locationController = useTextEditingController();

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '강의 시간표 추가',
      ),
      bottomNavigationBar: PrimaryBottomButton(
        onPressed: () async {
          // 유효성 만족 시 강의 추가 API 요청
        },
        label: '완료',
        isLoading: false, // 로딩상태
        isEnabled: false, // 유효성
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 80),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      height: ((10 / 2) * kBoxSize) + kFirstColumnHeight + 2,
                      child: SingleChildScrollView(
                        child: TimetableGrid(
                          columnLength: kColumnLength,
                          firstRowHeight: kFirstColumnHeight,
                          slotHeight: kBoxSize,
                          dayChildrenBuilder: (day, dayWidth) {
                            final widgets = <Widget>[];

                            if (lectureList != null) {
                              for (final lecture in lectureList!) {
                                if (lecture.week != day) continue;
                                final color = lectureColors[lectureList!.indexOf(lecture) % lectureColors.length];
                                widgets.add(
                                  PositionedLectureBlock(
                                    lecture: lecture,
                                    firstRowHeight: kFirstColumnHeight,
                                    slotHeight: kBoxSize,
                                    dayWidth: dayWidth,
                                    color: color,
                                  ),
                                );
                              }
                            }

                            if (day == selectedDay) {
                              final startTotal = (startHour * 60 + startMinute) - 540; // 9*60
                              final endTotal   = (endHour * 60 + endMinute) - 540;

                              final double top = kFirstColumnHeight + (startTotal / 60.0) * kBoxSize;
                              final double height = ((endTotal - startTotal) / 60.0) * kBoxSize;

                              widgets.add(
                                Positioned(
                                  top: top,
                                  left: 0,
                                  child: Container(
                                    width: dayWidth,
                                    height: height,
                                    decoration: BoxDecoration(
                                      color: ColorStyles.gray2,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return widgets;
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        spacing: 16,
                        children: [
                          _buildTextField(
                            controller: nameController,
                            hintText: '강의명을 입력해 주세요',
                          ),
                          _buildTextField(
                            controller: professorController,
                            hintText: '교수님 성함을 입력해 주세요',
                          ),
                          _buildTextField(
                            controller: locationController,
                            hintText: '강의실을 입력해 주세요',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              OutlinedButton(
                                onPressed: () async {
                                  final picked = await showWeekDayPicker(context, initial: WeekDay.MONDAY);
                                  if (picked != null) {
                                    selectedDay = picked;
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  side: const BorderSide(color: ColorStyles.gray2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(0, 44),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 16,
                                  children: [
                                    Text(
                                      '${selectedDay.korean}요일',
                                      style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 24,
                                      color: ColorStyles.black,
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () async {
                                  final picked = await showTimeRangePicker(
                                    context,
                                    initial: TimeRange(
                                      startHour: startHour,
                                      startMinute: startMinute,
                                      endHour: endHour,
                                      endMinute: endMinute,
                                    ),
                                  );
                                  if (picked != null) {
                                    startHour = picked.startHour;
                                    startMinute = picked.startMinute;
                                    endHour = picked.endHour;
                                    endMinute = picked.endMinute;
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  side: const BorderSide(color: ColorStyles.gray2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  minimumSize: const Size(0, 44),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 16,
                                  children: [
                                    Text(
                                      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')} ~ '
                                          '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}',
                                      style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down_outlined, size: 24, color: ColorStyles.black),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    double height = 44,
  }) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray2, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray2),
          ),
        ),
      ),
    );
  }
}
