import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_screen.dart';
import 'package:dongsoop/presentation/timetable/widgets/create_timetable_button.dart';
import 'package:dongsoop/providers/timetable_providers.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimetableScreen extends HookConsumerWidget {
  final int? year;
  final Semester? semester;

  final VoidCallback onTapTimetableList;
  final VoidCallback onTapTimetableWrite;
  final Future<bool> Function(int, Semester, List<Lecture>?) onTapLectureWrite;

  const TimetableScreen({
    super.key,
    this.year,
    this.semester,
    required this.onTapTimetableList,
    required this.onTapTimetableWrite,
    required this.onTapLectureWrite,
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
        title: timetableState.lectureList == null || timetableState.lectureList!.isEmpty
          ? '시간표 관리'
          : '',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (timetableState.lectureList != null && timetableState.lectureList!.isNotEmpty)
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
              onPressed: onTapTimetableList,
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
              spacing: 24,
              children: [
                timetableState.lectureList == null || timetableState.lectureList!.isEmpty
                  ? CreateTimetableButton(onTapTimetableWrite: onTapTimetableWrite)
                  : TimetableDetailScreen(
                    lectureList: timetableState.lectureList,
                    onLectureChanged: () async {
                      await viewModel.getLecture();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}