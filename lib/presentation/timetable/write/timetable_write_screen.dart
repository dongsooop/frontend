import 'package:dongsoop/presentation/timetable/temp/schedule_data.dart';
import 'package:dongsoop/presentation/timetable/temp/timetable_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class TimetableWriteScreen extends StatefulWidget {
  const TimetableWriteScreen({required this.scheduleData, super.key});

  final List<Schedule> scheduleData;

  @override
  State<TimetableWriteScreen> createState() => _TimetableWriteScreenState();
}

class _TimetableWriteScreenState extends State<TimetableWriteScreen> {
  final _formKey = GlobalKey<FormState>();

  // 시간표
  final List<String> week = ['월', '화', '수', '목', '금'];
  int kColumnLength = 28;
  double kFirstColumnHeight = 24;
  double kBoxSize = 48;
  late List<Schedule> selectedLectures;

  final List<Color> scheduleColors = [
    const Color(0xFFDCE1F0),
    const Color(0xFFF1D2D2),
    const Color(0xFFD2F3D4),
    const Color(0xFFE4DCFC),
    const Color(0xFFD5F1F3),
    const Color(0xFFF8DEEF),
    const Color(0xFFF9F2DE),
  ];
  int colorIndex = 0;

  int selectedDayIndex = 0;
  int startHour = 9;
  int startMinute = 0;
  int endHour = 10;
  int endMinute = 0;
  final List<String> days = ['월요일', '화요일', '수요일', '목요일', '금요일'];

  late TextEditingController nameController;
  late TextEditingController professorController;
  late TextEditingController classroomController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    professorController = TextEditingController();
    classroomController = TextEditingController();
  }
  @override
  void dispose() {
    nameController.dispose();
    professorController.dispose();
    classroomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedLectures = widget.scheduleData;

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(
            '강의 추가',
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          backgroundColor: ColorStyles.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              size: 24,
              color: ColorStyles.black,
            ),
          ),
          centerTitle: true,
        ),
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
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: 16,
                          children: [
                            SizedBox(
                              height: 44,
                              child: TextFormField(
                                controller: nameController,
                                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                                decoration: InputDecoration(
                                  hintText: '강의명을 입력해 주세요',
                                  hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: ColorStyles.gray2, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: ColorStyles.gray2),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 44,
                              child: TextFormField(
                                controller: professorController,
                                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                                decoration: InputDecoration(
                                  hintText: '교수님 성함을 입력해 주세요',
                                  hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: ColorStyles.gray2, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: ColorStyles.gray2),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 44,
                              child: TextFormField(
                                controller: classroomController,
                                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                                decoration: InputDecoration(
                                  hintText: '강의실을 입력해 주세요',
                                  hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: ColorStyles.gray2, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: ColorStyles.gray2),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _showDayPicker(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    side: const BorderSide(color: ColorStyles.gray2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 16,
                                    children: [
                                      Text(
                                        '${week[selectedDayIndex]}요일',
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
                                SizedBox(
                                  height: 44,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _showTimePicker(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      side: const BorderSide(color: ColorStyles.gray2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 16,
                                      children: [
                                        Text(
                                          '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')} ~ '
                                              '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}',
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
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 하단 완료 버튼
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                  onTap: isFormValid()
                  ? () {
                      // 완료 동작 실행(리스트 add)
                      _onSubmit();
                    }
                  : null, // 비활성 상태에서는 아무 동작 없음
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isFormValid() ? ColorStyles.primaryColor : ColorStyles.gray1,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '완료',
                      style: TextStyles.largeTextBold.copyWith(
                        color: isFormValid() ? ColorStyles.white : ColorStyles.gray3,
                      ),
                    ),
                  ),
                ),
            ),
          ]
        ),
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

  // 폼 유효성
  bool isFormValid() {
    final startTotal = startHour * 60 + startMinute;
    final endTotal = endHour * 60 + endMinute;

    return nameController.text.trim().isNotEmpty && endTotal > startTotal;
  }

  // 다이얼로그
  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          backgroundColor: ColorStyles.white,
          content: Text(
            message,
            style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
          ),
          actions: [
            TextButton(
              child: Text(
                '확인',
                style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 요일 선택 바텀시트
  void _showDayPicker(BuildContext context) {
    int temp = selectedDayIndex;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // 확인 버튼만 우측 정렬
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      '확인',
                      style: TextStyles.largeTextRegular.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedDayIndex = temp;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 44,
                  scrollController: FixedExtentScrollController(initialItem: temp),
                  onSelectedItemChanged: (value) {
                    temp = value;
                  },
                  children: week.map((e) => Center(
                    child: Text(
                      '$e요일',
                      style: TextStyles.largeTextRegular.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      setState(() {
        selectedDayIndex = temp;
      });
    });
  }

  // 시간 선택 바텀시트
  void _showTimePicker(BuildContext context) {
    int tempStartHour = startHour;
    int tempStartMinute = startMinute;
    int tempEndHour = endHour;
    int tempEndMinute = endMinute;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            color: ColorStyles.white,
            height: 300,
            child: GestureDetector(
              onTap: () {}, // 내부 클릭 시 바깥 클릭 방지
              child: Column(
                children: [
                  // 상단 확인 버튼
                  Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          startHour = tempStartHour;
                          startMinute = tempStartMinute;
                          endHour = tempEndHour;
                          endMinute = tempEndMinute;
                        });
                      },
                      child: Text(
                        '확인',
                        style: TextStyles.largeTextRegular.copyWith(
                          color: ColorStyles.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  // 피커
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 시작 시간
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 44,
                            scrollController: FixedExtentScrollController(initialItem: tempStartHour - 9),
                            onSelectedItemChanged: (index) {
                              tempStartHour = 9 + index;
                            },
                            children: List.generate(15, (i) {
                              return Center(
                                child: Text(
                                  (9 + i).toString().padLeft(2, '0'),
                                  style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                                ),
                              );
                            }),
                          ),
                        ),
                        // 시작 분
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 44,
                            scrollController: FixedExtentScrollController(initialItem: tempStartMinute ~/ 5),
                            onSelectedItemChanged: (index) {
                              tempStartMinute = index * 5;
                            },
                            children: List.generate(12, (i) {
                              return Center(
                                child: Text(
                                  (i * 5).toString().padLeft(2, '0'),
                                  style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(width: 24,),
                        // 종료 시간
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 44,
                            scrollController: FixedExtentScrollController(initialItem: tempEndHour - 9),
                            onSelectedItemChanged: (index) {
                              tempEndHour = 9 + index;
                            },
                            children: List.generate(15, (i) {
                              return Center(
                                child: Text(
                                  (9 + i).toString().padLeft(2, '0'),
                                  style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                                ),
                              );
                            }),
                          ),
                        ),
                        // 종료 분
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 44,
                            scrollController: FixedExtentScrollController(initialItem: tempEndMinute ~/ 5),
                            onSelectedItemChanged: (index) {
                              tempEndMinute = index * 5;
                            },
                            children: List.generate(12, (i) {
                              return Center(
                                child: Text(
                                  (i * 5).toString().padLeft(2, '0'),
                                  style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    ).whenComplete(() {
      // 외부 터치 시 값 반영
      setState(() {
        startHour = tempStartHour;
        startMinute = tempStartMinute;
        endHour = tempEndHour;
        endMinute = tempEndMinute;
        if ((endHour * 60 + endMinute) <= (startHour * 60 + startMinute)) {
          startHour = 9;
          startMinute = 0;
          endHour = 10;
          endMinute = 0;
          _showAlertDialog(context, '종료 시간이 시작 시간보다 늦어야 합니다.');
          return;
        }
      });
    });
  }

  // 저장
  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // 시간 문자열로 변환
      final startTime = '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
      final endTime = '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

      final lectureData = {
        '강의명': nameController.text.trim(),
        '교수': professorController.text.trim(),
        '강의실': classroomController.text.trim(),
        '요일': week[selectedDayIndex],
        '시작시간': startTime,
        '종료시간': endTime,
      };

      setState(() {
        dummyTimetable['2025학년도 1학기']!.add(lectureData);
      });

      Navigator.pop(context, true); // ← 여기서 true 넘겨줌 상태 관리 필요
    }
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
        );
      }
    }
    // 시간표 미리보기 블럭 (요일 일치 시)
    if (currentDay == week[selectedDayIndex]) {
      int startTotal = (startHour * 60 + startMinute) - 540;
      int endTotal = (endHour * 60 + endMinute) - 540;

      double previewTop = kFirstColumnHeight + (startTotal / 60.0) * kBoxSize;
      double previewHeight = ((endTotal - startTotal) / 60.0) * kBoxSize;

      lecturesForTheDay.add(
        Positioned(
          top: previewTop,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width / 5,
            height: previewHeight,
            decoration: BoxDecoration(
              color: const Color(0x40252525), // 25% 불투명한 #252525
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(4),
          ),
        ),
      );
    }

    return [
      Container(
        width: 1,
        height: (kColumnLength / 2 * kBoxSize) + kFirstColumnHeight + 2,
        color: ColorStyles.gray2,
      ),
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
}
