import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/presentation/timetable/widgets/day_picker_bottom_sheet.dart';
import 'package:dongsoop/presentation/timetable/widgets/lecture_time_picker_bottom_sheet.dart';
import 'package:dongsoop/presentation/timetable/widgets/positioned_lecture_block.dart';
import 'package:dongsoop/presentation/timetable/widgets/timetable_grid.dart';
import 'package:dongsoop/providers/timetable_providers.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LectureWriteScreen extends HookConsumerWidget {
  final int year;
  final Semester semester;
  final List<Lecture>? lectureList;
  final Lecture? editingLecture;

  LectureWriteScreen({
    required this.year,
    required this.semester,
    required this.lectureList,
    this.editingLecture,
    super.key
  });

  bool get isEditing => editingLecture != null;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lectureWriteState = ref.watch(lectureWriteViewModelProvider);
    final viewModel = ref.read(lectureWriteViewModelProvider.notifier);

    final nameController = useTextEditingController();
    final professorController = useTextEditingController();
    final locationController = useTextEditingController();

    useListenable(nameController);

    final isNameFilled = nameController.text.trim().isNotEmpty && nameController.text != '';
    final isTimeValid = (lectureWriteState.endHour * 60 + lectureWriteState.endMinute) > (lectureWriteState.startHour * 60 + lectureWriteState.startMinute);

    useEffect(() {
      if (isEditing) {
        final lecture = editingLecture!;

        nameController.text = lecture.name;
        professorController.text = lecture.professor ?? '';
        locationController.text = lecture.location ?? '';

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;

          final sp = lecture.startAt.split(':');
          final ep = lecture.endAt.split(':');

          final sh = int.tryParse(sp[0]) ?? 9;
          final sm = int.tryParse(sp[1]) ?? 0;
          final eh = int.tryParse(ep[0]) ?? (sh + 1);
          final em = int.tryParse(ep[1]) ?? sm;

          viewModel.setDay(lecture.week);
          viewModel.setTimeRange(
            startHour: sh, startMinute: sm,
            endHour: eh, endMinute: em,
          );
        });
      }
      return null;
    }, const []);

    // 오류
    useEffect(() {
      if (lectureWriteState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '시간표 작성 오류',
              content: lectureWriteState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [lectureWriteState.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: isEditing ? '강의 시간표 수정' : '강의 시간표 추가',
      ),
      bottomNavigationBar: PrimaryBottomButton(
        onPressed: () async {
          if (!isNameFilled || !isTimeValid) return;

          final others = (lectureList ?? [])
              .where((e) => e.id != editingLecture?.id)
              .toList();

          final canCreate = viewModel.canCreateLecture(others);

          if (!canCreate) {
            showDialog(
              context: context,
              builder: (_) => CustomConfirmDialog(
                title: '시간표 작성 실패',
                content: '해당 시간에 이미 강의가 있어요',
                onConfirm: () => Navigator.of(context).pop(),
              ),
            );
            return;
          }

          final name = nameController.text.trim();
          final prof = professorController.text.trim().isEmpty
              ? null : professorController.text.trim();
          final loc  = locationController.text.trim().isEmpty
              ? null : locationController.text.trim();

          bool ok;
          if (isEditing) {
            ok = await viewModel.updateLecture(
              id: editingLecture!.id,
              name: name,
              professor: prof,
              location: loc,
            );
          } else {
            ok = await viewModel.createLecture(
              year: year,
              semester: semester,
              name: name,
              professor: prof,
              location: loc,
            );
          }

          if (ok) {
            context.pop(true);
          } else {
            showDialog(
              context: context,
              builder: (_) => CustomConfirmDialog(
                title: isEditing ? '시간표 수정 실패' : '시간표 작성 실패',
                content: isEditing ? '시간표 수정에 실패했어요' : '시간표 작성에 실패했어요',
                onConfirm: () => Navigator.of(context).pop(),
              ),
            );
          }
        },
        label: isEditing ? '수정 완료' : '완료',
        isLoading: lectureWriteState.isLoading,
        isEnabled: isNameFilled && isTimeValid,
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

                            if (day == lectureWriteState.day) {
                              final startTotal = (lectureWriteState.startHour * 60 + lectureWriteState.startMinute) - 540; // 9*60
                              final endTotal   = (lectureWriteState.endHour * 60 + lectureWriteState.endMinute) - 540;
                              final int diff   = endTotal - startTotal;

                              if (diff > 0) {
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
                                        color: const Color(0x40252525),
                                      ),
                                    ),
                                  ),
                                );
                              }
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
                                  if (picked != null) viewModel.setDay(picked);
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
                                      '${lectureWriteState.day.korean}요일',
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
                                      startHour: lectureWriteState.startHour,
                                      startMinute: lectureWriteState.startMinute,
                                      endHour: lectureWriteState.endHour,
                                      endMinute: lectureWriteState.endMinute,
                                    ),
                                  );
                                  if (picked != null) {
                                    viewModel.setTimeRange(
                                      startHour: picked.startHour,
                                      startMinute: picked.startMinute,
                                      endHour: picked.endHour,
                                      endMinute: picked.endMinute,
                                    );
                                    final isValid = viewModel.validateTimeRange();

                                    if (!isValid) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => CustomConfirmDialog(
                                          title: '시간 설정',
                                          content: '시작 시간이 종료 시간보다 빨라야 해요',
                                          onConfirm: () async {
                                          },
                                        ),
                                      );
                                    }
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
                                      '${lectureWriteState.startHour.toString().padLeft(2, '0')}:${lectureWriteState.startMinute.toString().padLeft(2, '0')} ~ '
                                          '${lectureWriteState.endHour.toString().padLeft(2, '0')}:${lectureWriteState.endMinute.toString().padLeft(2, '0')}',
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
