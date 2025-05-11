import 'package:dongsoop/presentation/board/recruit/write/viewmodels/data_time_viemodel.dart';
import 'package:dongsoop/presentation/board/recruit/write/viewmodels/providers/date_time_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/bottom_custom_calendar.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateTimeBottomSheet extends ConsumerStatefulWidget {
  final bool isStart;
  const DateTimeBottomSheet({super.key, required this.isStart});

  @override
  ConsumerState<DateTimeBottomSheet> createState() =>
      _DateTimeBottomSheetState();
}

class _DateTimeBottomSheetState extends ConsumerState<DateTimeBottomSheet> {
  late DateTime selectedDateTime;
  bool showTimePicker = false;
  DateTime currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    final state = ref.read(dateTimeSelectorProvider);
    selectedDateTime = widget.isStart ? state.startDateTime : state.endDateTime;
    currentMonth = DateTime(selectedDateTime.year, selectedDateTime.month);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(dateTimeSelectorProvider.notifier);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final roundedNow = DateTimeSelectorViewModel.roundUpTo10(now);

    return SafeArea(
      child: SizedBox(
        height: 584,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isStart ? '모집 시작일 선택하기' : '모집 마감일 선택하기',
                      style: TextStyles.titleTextBold,
                    ),
                    const SizedBox(height: 24),
                    // 커스텀 캘린더
                    BottomCustomCalendar(
                      selectedDate: selectedDateTime,
                      currentMonth: currentMonth,
                      onMonthChanged: (month) {
                        setState(() => currentMonth = month);
                      },
                      onDateSelected: (date) {
                        setState(() {
                          selectedDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            selectedDateTime.hour,
                            selectedDateTime.minute,
                          );
                        });
                        if (widget.isStart) {
                          notifier.updateStartDate(selectedDateTime);
                        } else {
                          notifier.updateEndDate(selectedDateTime);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() => showTimePicker = !showTimePicker);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.isStart ? '시작 시간' : '마감 시간',
                                    style: TextStyles.normalTextRegular
                                        .copyWith(color: ColorStyles.black),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${_twoDigits(selectedDateTime.hour)}:${_twoDigits(selectedDateTime.minute)}',
                                        style: TextStyles.normalTextRegular
                                            .copyWith(color: ColorStyles.black),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        showTimePicker
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: ColorStyles.gray4,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (showTimePicker)
                            const Divider(
                                height: 1,
                                thickness: 1,
                                color: ColorStyles.gray2),
                          if (showTimePicker)
                            SizedBox(
                              height: 200,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                use24hFormat: true,
                                initialDateTime: selectedDateTime,
                                minuteInterval: 10,
                                itemExtent: 45.0,
                                minimumDate: selectedDateTime.day == today.day
                                    ? roundedNow
                                    : null,
                                onDateTimeChanged: (picked) {
                                  setState(() {
                                    selectedDateTime = DateTime(
                                      selectedDateTime.year,
                                      selectedDateTime.month,
                                      selectedDateTime.day,
                                      picked.hour,
                                      picked.minute,
                                    );
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.isStart
                      ? notifier.updateStartTime(selectedDateTime)
                      : notifier.updateEndTime(selectedDateTime);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  backgroundColor: ColorStyles.primary100,
                  foregroundColor: ColorStyles.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('선택하기', style: TextStyles.largeTextBold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
