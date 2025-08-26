import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_screen.dart';
import 'package:dongsoop/presentation/timetable/temp/schedule_data.dart';
import 'package:dongsoop/presentation/timetable/temp/timetable_model.dart';
import 'package:dongsoop/presentation/timetable/widgets/create_timetable_button.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimetableScreen extends HookConsumerWidget {
  final VoidCallback onTapTimetableList;
  final VoidCallback onTapTimetableWrite;
  final VoidCallback onTapLectureWrite;

  const TimetableScreen({
    super.key,
    this.yearSemester,
    required this.onTapTimetableList,
    required this.onTapTimetableWrite,
    required this.onTapLectureWrite,
  });

  final String? yearSemester;

  // 현재 학기 계산
  String getCurrentSemesterLabel(DateTime now) {
    final year = now.year;
    final month = now.month;

    if (month >= 3 && month <= 8) {
      return '$year학년도 1학기';
    } else {
      // 9~12월이면 올해 2학기, 1~2월이면 작년 2학기
      final academicYear = (month >= 9) ? year : year - 1;
      return '$academicYear학년도 2학기';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSemester = yearSemester ?? getCurrentSemesterLabel(DateTime.now());
    final hasTimetable = dummyTimetable.containsKey(selectedSemester);
    // 현재 학기 데이터
    final List<Schedule> scheduleData = dummyTimetable[selectedSemester]
        ?.map((e) => Schedule.fromJson(e))
        .toList() ??
        [];

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '시간표 관리',
        trailing: IconButton(
          onPressed: onTapTimetableList,
          icon: Icon(
            Icons.format_list_bulleted_outlined,
            size: 24,
            color: ColorStyles.black,
          ),
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
                hasTimetable
                  ? TimetableDetailScreen(scheduleData: scheduleData,)
                  : CreateTimetableButton(onTapTimetableWrite: onTapTimetableWrite),
              ],
            ),
          ),
        ),
      ),
    );
  }
}