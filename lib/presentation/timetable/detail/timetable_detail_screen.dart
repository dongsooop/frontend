import 'package:dongsoop/presentation/timetable/temp/timetable_model.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class TimetableDetailScreen extends StatefulWidget {
  const TimetableDetailScreen({required this.scheduleData, super.key});

  final List<Schedule> scheduleData;

  @override
  State<TimetableDetailScreen> createState() => _TimetableDetailScreenState();
}

class _TimetableDetailScreenState extends State<TimetableDetailScreen> {
  // 시간표
  final List<String> week = ['월', '화', '수', '목', '금'];
  int kColumnLength = 28;
  double kFirstColumnHeight = 24;
  double kBoxSize = 48; // 30분 단위 높이
  late List<Schedule> selectedLectures;

  // 시간표 색상
  final List<Color> scheduleColors = [
    const Color(0xFFDCE1F0),
    const Color(0xFFF1D2D2),
    const Color(0xFFD2F3D4),
    const Color(0xFFE4DCFC),
    const Color(0xFFD5F1F3),
    const Color(0xFFF8DEEF),
    const Color(0xFFF9F2DE),
  ];
  int colorIndex = 0; // 강의 색상 인덱스

  // 시간표 최대 시간
  int calculateColumnLength(List<Schedule> scheduleData) {
    // 기본 종료 시각 블록 수: 14시까지 → (14 - 9) * 2 = 10블럭
    const int defaultBlockCount = (14 - 9) * 2;

    if (scheduleData.isEmpty) return defaultBlockCount;

    // endTime은 9시 기준 상대 분. 30분 단위 블록 개수로 변환해서 최대값 구함
    int maxBlock = scheduleData
        .map((e) => (e.endTime / 30).ceil())
        .reduce((a, b) => a > b ? a : b);

    return maxBlock < defaultBlockCount ? defaultBlockCount : maxBlock;
  }

  @override
  Widget build(BuildContext context) {
    selectedLectures = widget.scheduleData;

    // 시간표 최대 시간
    kColumnLength = calculateColumnLength(widget.scheduleData);

    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: ColorStyles.gray2
          ),
          borderRadius: BorderRadius.circular(8)
        )
      ),
      height: (kColumnLength / 2 * kBoxSize) + kFirstColumnHeight + 2,
      child: Row(
        children: [
          buildTimeColumn(),
          ...buildDayColumn(0),
          ...buildDayColumn(1),
          ...buildDayColumn(2),
          ...buildDayColumn(3),
          ...buildDayColumn(4),
        ],
      ),
    );
  }

  SizedBox buildTimeColumn() {
    return SizedBox(
      width: 28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: kFirstColumnHeight),
          ...List.generate(
            kColumnLength,
                (index) {
              if (index % 2 == 0) {
                return const Divider(color: ColorStyles.gray2, height: 0);
              }
              return SizedBox(
                height: kBoxSize,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    '${index ~/ 2 + 9}',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray4
                    )
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildDayColumn(int index) {
    String currentDay = week[index];
    List<Widget> lecturesForTheDay = [];

    for (var lecture in widget.scheduleData) {
      if (lecture.day == currentDay) {
        double top = kFirstColumnHeight + (lecture.startTime / 60.0) * kBoxSize;
        double height = ((lecture.endTime - lecture.startTime) / 60.0) * kBoxSize;

        final color = scheduleColors[
          widget.scheduleData.indexOf(lecture) % scheduleColors.length
        ];
        colorIndex++;

        lecturesForTheDay.add(
          Positioned(
            top: top,
            left: 0,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => _buildLectureBottomSheet(context, lecture),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      lecture.name,
                      style: TextStyles.smallTextBold.copyWith(
                        color: ColorStyles.black
                      ),
                    ),
                    if (lecture.classroom!.isNotEmpty)
                      Text(
                        lecture.classroom!,
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                    if (lecture.professor!.isNotEmpty)
                      Text(
                        lecture.professor!,
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    return [
      const VerticalDivider(color: ColorStyles.gray2, width: 0),
      Expanded(
        flex: 4,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: kFirstColumnHeight,
                  child: Text(
                    textAlign: TextAlign.center,
                    currentDay,
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray4
                    )
                  ),
                ),
                ...List.generate(
                  kColumnLength,
                    (i) => i % 2 == 0
                    ? const Divider(color: ColorStyles.gray2, height: 0)
                    : SizedBox(height: kBoxSize),
                ),
              ],
            ),
            ...lecturesForTheDay,
          ],
        ),
      ),
    ];
  }

  // 강의 터치 시 바텀시트
  Widget _buildLectureBottomSheet(BuildContext context, Schedule lecture) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      height: 320,
      decoration: const BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 강의명 + 교수명
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lecture.name,
                style: TextStyles.titleTextBold.copyWith(color: ColorStyles.black),
              ),
              SizedBox(width: 8),
              Text(
                lecture.professor ?? '',
                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
              ),
            ],
          ),
          SizedBox(height: 16),
          // 요일 + 시간
          Text(
            '${lecture.day}  '
                '${(lecture.startTime ~/ 60).toString().padLeft(2, '0')}:${(lecture.startTime % 60).toString().padLeft(2, '0')}'
                ' ~ '
                '${(lecture.endTime ~/ 60).toString().padLeft(2, '0')}:${(lecture.endTime % 60).toString().padLeft(2, '0')}',
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
          SizedBox(height: 8),
          // 강의실
          Text(
            lecture.classroom ?? '',
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
          SizedBox(height: 24),

          // 수정 버튼
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // 강의 수정 로직 추가
            },
            child: SizedBox(
              height: 44,
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, color: ColorStyles.gray4),
                  SizedBox(width: 8),
                  Text(
                    '강의 정보 수정',
                    style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // 삭제 버튼
          GestureDetector(
            onTap: () => _showDeleteDialog(context, lecture),
            child: SizedBox(
              height: 44,
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: ColorStyles.gray4),
                  SizedBox(width: 8),
                  Text(
                    '강의 정보 삭제',
                    style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 삭제 다이얼로그
  void _showDeleteDialog(BuildContext context, Schedule lecture) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorStyles.gray1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          '해당 강의를 삭제하실 건가요?',
          style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.warning100),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.scheduleData.remove(lecture);
              });
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 바텀시트 닫기
            },
            child: Text(
              '삭제',
              style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}