import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_screen.dart';
import 'package:dongsoop/presentation/timetable/widgets/create_timetable_button.dart';
import 'package:dongsoop/providers/timetable_providers.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimetableScreen extends HookConsumerWidget {
  final int? year;
  final Semester? semester;

  final Future<({int year, Semester semester})?> Function() onTapTimetableList;
  final Future<({int year, Semester semester})?> Function() onTapTimetableWrite;
  final Future<bool> Function(int, Semester, List<Lecture>?) onTapLectureWrite;
  final Future<bool> Function(int, Semester, List<Lecture>?, Lecture) onTapLectureUpdate;

  const TimetableScreen({
    super.key,
    this.year,
    this.semester,
    required this.onTapTimetableList,
    required this.onTapTimetableWrite,
    required this.onTapLectureWrite,
    required this.onTapLectureUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableState = ref.watch(timetableViewModelProvider);
    final viewModel = ref.read(timetableViewModelProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (year != null && semester != null) {
          viewModel.setYearSemester(year!, semester!);
          await viewModel.getLecture();
        } else {
          viewModel.getCurrentSemester(DateTime.now());
          await viewModel.getLecture();
        }
      });
      return null;
    }, [year, semester]);

    if (timetableState.isLoading) {
      return Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(),
        body: Center(child: CircularProgressIndicator(color: ColorStyles.primaryColor,))
      );
    }

    useEffect(() {
      if (timetableState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '시간표 오류',
              content: timetableState.errorMessage!,
              onConfirm: () {
                context.pop();
                context.pop();
              },
              confirmText: '확인',
              dismissOnConfirm: false,
              isSingleAction: true,
            ),
          );
        });
      }
      return null;
    }, [timetableState.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: timetableState.exists == false
          ? '시간표 관리'
          : '',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (timetableState.exists == true)
              IconButton(
                onPressed: () async {
                  final isSucceed = await onTapLectureWrite(timetableState.year!, timetableState.semester!, timetableState.lectureList);
                  if (isSucceed) {
                    // refresh
                    await viewModel.getLecture();
                  }
                },
                icon: SvgPicture.asset(
                  'assets/icons/add_lecture.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    ColorStyles.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            IconButton(
              onPressed: () async {
                final result = await onTapTimetableList();
                if (result != null) {
                  if (!context.mounted) return;
                  viewModel.setYearSemester(result.year, result.semester);
                }
                await viewModel.getLecture();
              },
              icon: Icon(
                Icons.format_list_bulleted_outlined,
                size: 24,
                color: ColorStyles.black,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                if (timetableState.exists != false) ...[
                  Text(
                    '${timetableState.year ?? 'null'}년 ${timetableState.semester?.label ?? 'null'}',
                    style: TextStyles.smallTextBold.copyWith(color: ColorStyles.primaryColor),
                  ),
                  Text(
                    '강의 시간표',
                    style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
                  ),
                  const SizedBox(height: 24),
                ],

                timetableState.exists == false && !timetableState.isLoading
                  ? CreateTimetableButton(
                    year: timetableState.year!,
                    semester: timetableState.semester!,
                    onTapTimetableWrite: onTapTimetableWrite,
                    onCreated: (result) async {
                      viewModel.setYearSemester(result!.year, result.semester);
                      await viewModel.getLecture();
                    },
                  )
                  : TimetableDetailScreen(
                    lectureList: timetableState.lectureList,
                    onLectureChanged: () async {
                      if (!context.mounted) return;
                      await viewModel.getLecture();
                    },
                    onEditLecture: (editing) async {
                      final year = timetableState.year;
                      final semester = timetableState.semester;
                      if (year == null || semester == null) return false;

                      final ok = await onTapLectureUpdate(
                        year,
                        semester,
                        timetableState.lectureList,
                        editing,
                      );
                      if (ok) {
                        if (!context.mounted) return false;
                        await viewModel.getLecture();
                      }
                      return ok;
                    }
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}