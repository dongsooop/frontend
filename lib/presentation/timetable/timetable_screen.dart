import 'package:dongsoop/presentation/timetable/write/timetable_write_screen.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_screen.dart';
import 'package:dongsoop/presentation/timetable/list/timetable_list_screen.dart';
import 'package:dongsoop/presentation/timetable/temp/schedule_data.dart';
import 'package:dongsoop/presentation/timetable/temp/timetable_model.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:go_router/go_router.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({this.yearSemester, super.key});

  final String? yearSemester;

  @override
  State<TimetableScreen> createState() => TimetableScreenState();
}

class TimetableScreenState extends State<TimetableScreen> {
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
  Widget build(BuildContext context) {
    final selectedSemester = widget.yearSemester ?? getCurrentSemesterLabel(DateTime.now());
    final hasTimetable = dummyTimetable.containsKey(selectedSemester);
    // 현재 학기 데이터
    final List<Schedule> scheduleData = dummyTimetable[selectedSemester]
        ?.map((e) => Schedule.fromJson(e))
        .toList() ??
      [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: AppBar(
            backgroundColor: ColorStyles.white,
            title: Text(
              selectedSemester,
              style: TextStyles.largeTextBold.copyWith(
                color: ColorStyles.black
              ),
            ),
            leading: IconButton(
              onPressed: () {
                // 뒤로 가기
                context.pop();
              },
              icon: Icon(
                Icons.chevron_left_outlined,
                size: 24,
                color: ColorStyles.black,
              ),
            ),
            centerTitle: true,
            actions: [
              if(hasTimetable)
                IconButton(
                  onPressed: () async {
                    // 강의 추가
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TimetableWriteScreen(scheduleData: scheduleData),
                      ),
                    );

                    if (result == true) {
                      setState(() {
                        // 데이터 새로고침 또는 상태 업데이트
                      });
                    }
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    size: 24,
                    color: ColorStyles.black,
                  )
                ),
              IconButton(
                onPressed: () {
                  // 메뉴 선택
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TimetableListScreen()),
                  );
                },
                icon: Icon(
                  Icons.format_list_bulleted_outlined,
                  size: 24,
                  color: ColorStyles.black,
                )
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                // 이번 학기 데이터가 있다면 시간표를, 없다면 생성 버튼을 보여줌
                hasTimetable
                ? TimetableDetailScreen(scheduleData: scheduleData,)
                : buildEmptyTimetableBox(selectedSemester, () {
                    setState(() {});
                  }),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: ColorStyles.gray2
                      ),
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '학점 계산기',
                            style: TextStyles.largeTextRegular.copyWith(
                              color: ColorStyles.black
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              // 학점 계산기 세부 페이지 이동
                            },
                            icon: Icon(
                              Icons.mode_edit_outlined,
                              size: 24,
                              color: ColorStyles.gray4,
                            )
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            '평균 학점',
                            style: TextStyles.normalTextRegular.copyWith(
                              color: ColorStyles.black
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '4.43',
                                  style: TextStyles.normalTextBold.copyWith(
                                    color: ColorStyles.primaryColor
                                  )
                                ),
                                TextSpan(
                                  text: ' / 4.5',
                                  style: TextStyles.normalTextRegular.copyWith(
                                    color: ColorStyles.gray4
                                  )
                                )
                              ]
                            )
                          ),
                          SizedBox(width: 40,),
                          Text(
                            '취득 학점',
                            style: TextStyles.normalTextRegular.copyWith(
                                color: ColorStyles.black
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '98',
                                  style: TextStyles.normalTextBold.copyWith(
                                    color: ColorStyles.primaryColor
                                  )
                                ),
                                TextSpan(
                                  text: ' / 120',
                                  style: TextStyles.normalTextRegular.copyWith(
                                    color: ColorStyles.gray4
                                  )
                                )
                              ]
                            )
                          ),
                        ]
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 시간표 생성
  Widget buildEmptyTimetableBox(String currentSemester,VoidCallback onRefresh) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: ColorStyles.gray2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이번 학기 시간표를 만들어 주세요',
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // 시간표 생성
              // 현재 학기 리스트가 없으면 생성
              if (!dummyTimetable.containsKey(currentSemester)) {
                dummyTimetable[currentSemester] = [];
                onRefresh(); // setState() 트리거용 콜백
              }
            },
            child: Container(
              width: double.infinity,
              height: 44,
              decoration: ShapeDecoration(
                color: ColorStyles.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '시간표 만들기',
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
