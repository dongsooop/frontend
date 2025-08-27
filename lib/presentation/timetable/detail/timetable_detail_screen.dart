import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimetableDetailScreen extends HookConsumerWidget {
  final List<Lecture>? lectureList;

  TimetableDetailScreen({
    required this.lectureList,
    super.key
  });

  static const double kFirstColumnHeight = 24;
  static const double kBoxSize = 48; // 30분 단위 높이

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
    // 시간표 최대 시간
    final kColumnLength = calculateColumnLength(lectureList);

    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: ColorStyles.gray2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      height: (kColumnLength / 2 * kBoxSize) + kFirstColumnHeight + 2,
      child: Row(
        children: [
          buildTimeColumn(kColumnLength),
          ...WeekDay.values.expand((day) => buildDayColumn(day, context, kColumnLength)),
        ],
      )
    );
  }

  SizedBox buildTimeColumn(int kColumnLength) {
    return SizedBox(
      width: 28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: kFirstColumnHeight),
          ...List.generate(kColumnLength, (index) {
            if (index % 2 == 0) {
              return const Divider(color: ColorStyles.gray2, height: 0);
            }
            return SizedBox(
              height: kBoxSize,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  '${index ~/ 2 + 9}',
                  style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                ),
              ),
            );
          },),
        ],
      ),
    );
  }

  List<Widget> buildDayColumn(WeekDay day, BuildContext context, int kColumnLength) {
    List<Widget> lecturesForTheDay = [];

    if (lectureList != null) {
      for (var lecture in lectureList!) {
        if (lecture.week == day) {
          double top = kFirstColumnHeight + (lecture.startAt.toMinutesFrom9AM() / 60.0) * kBoxSize;
          double height = ((lecture.endAt.toMinutesFrom9AM() - lecture.startAt.toMinutesFrom9AM()) / 60.0) * kBoxSize;

          final color = scheduleColors[lectureList!.indexOf(lecture) % scheduleColors.length];

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
                      if (lecture.location!.isNotEmpty)
                        Text(
                          lecture.location!,
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
                ),
                ...List.generate(
                  kColumnLength,
                  (i) => i % 2 == 0
                    ? const Divider(color: ColorStyles.gray2, height: 0)
                    : SizedBox(height: kBoxSize),
                ),
              ],
            ),
            // 맨 위 요일 라벨
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  day.korean,
                  style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ...lecturesForTheDay,
          ],
        ),
      ),
    ];
  }

  // 강의 터치 시 바텀시트
  Widget _buildLectureBottomSheet(BuildContext context, Lecture lecture) {
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
            '${lecture.week.korean}  '
                '${lecture.startAt}'
                ' ~ '
                '${lecture.endAt}',
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
          SizedBox(height: 8),
          // 강의실
          Text(
            lecture.location ?? '',
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
          SizedBox(height: 24),

          // 수정 버튼
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
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
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CustomConfirmDialog(
                  title: '강의 시간표 삭제',
                  content: '해당 강의를 삭제하시겠어요?',
                  onConfirm: () async {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              );
            },
            child: SizedBox(
              height: 44,
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: ColorStyles.gray4),
                  SizedBox(width: 8),
                  Text(
                    '강의 시간표 삭제',
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
}