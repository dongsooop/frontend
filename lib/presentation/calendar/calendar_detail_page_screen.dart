import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/presentation/calendar/temp/temp_calendar_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDetailPageScreen extends StatefulWidget {
  const CalendarDetailPageScreen({
    super.key,
    required this.selectedDate,
    this.event,
  });

  final DateTime selectedDate;
  final ScheduleEvent? event;

  @override
  State<CalendarDetailPageScreen> createState() =>
      _CalendarDetailPageScreenState();
}

class _CalendarDetailPageScreenState extends State<CalendarDetailPageScreen> {
  late final bool isSchoolSchedule;
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  late DateTime startDate;
  late DateTime endDate;
  bool showStartPicker = false;
  bool showEndPicker = false;

  @override
  void initState() {
    super.initState();
    isSchoolSchedule = widget.event?.type == ScheduleType.school;
    startDate = widget.event?.start ?? widget.selectedDate;
    endDate =
        widget.event?.end ?? widget.selectedDate.add(const Duration(hours: 1));

    if (widget.event?.title != null) {
      titleController.text = widget.event!.title;
    }
    if (isSchoolSchedule) {
      locationController.text = '동양미래대학교';
    } else if (widget.event?.location != null) {
      locationController.text = widget.event!.location ?? '';
    }
  }

  Widget _buildCupertinoDatePicker({
    required DateTime initialDateTime,
    required void Function(DateTime) onDateTimeChanged,
  }) {
    return SizedBox(
      height: 300,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        initialDateTime: initialDateTime,
        onDateTimeChanged: onDateTimeChanged,
        use24hFormat: true,
        minuteInterval: 5,
        itemExtent: 45.0,
      ),
    );
  }

  Widget _buildTimeRangeSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorStyles.white,
        border: Border.all(color: ColorStyles.gray2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: isSchoolSchedule
                ? null
                : () => setState(() {
                      showStartPicker = !showStartPicker;
                      showEndPicker = false;
                    }),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('시작', style: TextStyles.normalTextRegular),
                  Text(
                    isSchoolSchedule
                        ? DateFormat('y년 M월 d일 (E)', 'ko_KR').format(startDate)
                        : DateFormat('y년 M월 d일 (E) HH:mm', 'ko_KR')
                            .format(startDate),
                    style: TextStyles.normalTextRegular,
                  ),
                ],
              ),
            ),
          ),
          if (!isSchoolSchedule && showStartPicker)
            _buildCupertinoDatePicker(
              initialDateTime: startDate,
              onDateTimeChanged: (date) {
                setState(() => startDate = date);
              },
            ),
          const Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
          GestureDetector(
            onTap: isSchoolSchedule
                ? null
                : () => setState(() {
                      showEndPicker = !showEndPicker;
                      showStartPicker = false;
                    }),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('종료', style: TextStyles.normalTextRegular),
                  Text(
                    isSchoolSchedule
                        ? DateFormat('y년 M월 d일 (E)', 'ko_KR').format(endDate)
                        : DateFormat('y년 M월 d일 (E) HH:mm', 'ko_KR')
                            .format(endDate),
                    style: TextStyles.normalTextRegular,
                  ),
                ],
              ),
            ),
          ),
          if (!isSchoolSchedule && showEndPicker)
            _buildCupertinoDatePicker(
              initialDateTime: endDate,
              onDateTimeChanged: (date) {
                setState(() => endDate = date);
              },
            ),
        ],
      ),
    );
  }

  // 액션 시트
  void _showDeleteActionSheet(BuildContext context) {
    customActionSheet(
      context,
      onDelete: () {
        // 삭제 로직 추후에 구현
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.event != null;
    final isSchoolSchedule = widget.event?.type == ScheduleType.school;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppBar(
              backgroundColor: ColorStyles.gray1,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                isSchoolSchedule
                    ? '학사 일정'
                    : isEditMode
                        ? '일정 편집'
                        : '일정 추가',
                style: TextStyles.largeTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              centerTitle: true,
              leading: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '취소',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.primary100,
                  ),
                ),
              ),
              actions: [
                isSchoolSchedule
                    ? const SizedBox(width: 64)
                    : TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // 저장 로직
                          }
                        },
                        child: Text(
                          '저장',
                          style: TextStyles.normalTextBold.copyWith(
                            color: ColorStyles.primary100,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: isEditMode && !isSchoolSchedule
            ? PrimaryBottomButton(
                label: '일정 삭제',
                onPressed: () {
                  _showDeleteActionSheet(context);
                },
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: titleController,
                    enabled: !isSchoolSchedule,
                    style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                    // 유효성 검사
                    validator: (value) =>
                        value == null || value.isEmpty ? '제목을 입력해주세요' : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorStyles.white,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '일정 제목을 입력해주세요.',
                      hintStyle: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTimeRangeSection(),
                  const SizedBox(height: 24),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: locationController,
                    enabled: !isSchoolSchedule,
                    style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorStyles.white,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '장소를 입력해주세요',
                      hintStyle: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray3,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
