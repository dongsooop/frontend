import 'package:dongsoop/presentation/timetable/timetable_screen.dart';
import 'package:dongsoop/presentation/timetable/temp/schedule_data.dart';
import 'package:dongsoop/presentation/timetable/temp/timetable_model.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class TimetableListScreen extends StatefulWidget {
  const TimetableListScreen({super.key});

  @override
  State<TimetableListScreen> createState() => _TimetableListScreenState();
}

class _TimetableListScreenState extends State<TimetableListScreen> {
  Map<String, List<Map<String, dynamic>>> timetableData = Map.from(dummyTimetable);

  void _deleteTimetable(String semester) {
    setState(() {
      timetableData.remove(semester);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: AppBar(
          title: Text(
            '강의 시간표 목록',
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          backgroundColor: ColorStyles.white,
          foregroundColor: ColorStyles.black,
          elevation: 0,
        ),
        body: ListView.separated(
          itemCount: timetableData.keys.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: ColorStyles.gray2),
          itemBuilder: (context, index) {
            final semester = timetableData.keys.elementAt(index);
            return ListTile(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => TimetableScreen(yearSemester: semester),
                //   ),
                // );
              },
              title: Text(
                semester,
                style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black),
              ),
              trailing: GestureDetector(
                onTap: () {
                  _showDeleteDialog(semester);
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

  void _showDeleteDialog(String semester) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          '해당 시간표를 삭제하시겠어요?',
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소', style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.warning100)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTimetable(semester);
            },
            child: Text('삭제', style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.primaryColor)),
          ),
        ],
      ),
    );
  }
}