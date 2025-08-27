import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/presentation/timetable/temp/schedule_data.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimetableListScreen extends HookConsumerWidget {
  final void Function(int, Semester) onTapTimetable;
  final VoidCallback onTapTimetableWrite;

  const TimetableListScreen({
    super.key,
    required this.onTapTimetable,
    required this.onTapTimetableWrite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, List<Map<String, dynamic>>> timetableData = Map.from(dummyTimetable);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '시간표 목록',
        trailing: IconButton(
          onPressed: onTapTimetableWrite,
          icon: Icon(
            Icons.add_box_outlined,
            size: 24,
            color: ColorStyles.gray4,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.only(top: 24),
          itemCount: timetableData.keys.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: ColorStyles.gray2),
          itemBuilder: (context, index) {
            final semester = timetableData.keys.elementAt(index);
            return ListTile(
              onTap: () {
                print('시간표 이동');
              },
              title: Text(
                semester,
                style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black),
              ),
              trailing: GestureDetector(
                onTap: () {
                  // 시간표 삭제 기능
                  print('시간표 삭제');
                },
                child: Text(
                  '삭제',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}