import 'package:dongsoop/presentation/board/recruit/write/providers/date_time_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/bottom_custom_calendar.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/bottom_custom_time_spinner.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
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
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dateTimeSelectorProvider);
    final notifier = ref.read(dateTimeSelectorProvider.notifier);
    final selectedDateTime =
        widget.isStart ? state.startDateTime : state.endDateTime;

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
                      currentMonth: state.currentMonth,
                      onMonthChanged: (month) {
                        notifier.tryMoveToMonth(month, widget.isStart);
                      },
                      onDateSelected: (date) {
                        setState(() => _errorMessage = null);
                        notifier.updateSelectedDate(date, widget.isStart);
                      },
                      isDateEnabled: (date) =>
                          notifier.isDateEnabled(date, widget.isStart),
                      canMoveToPreviousMonth: (month) =>
                          notifier.canMoveToPreviousMonth(month),
                      canMoveToNextMonth: (month) =>
                          notifier.canMoveToNextMonth(month, widget.isStart),
                    ),
                    const SizedBox(height: 24),

                    // 커스텀 타임 스피너
                    BottomCustomTimeSpinner(
                      initialDateTime: selectedDateTime,
                      isStart: widget.isStart,
                      onDateTimeChanged: (picked) {
                        setState(() => _errorMessage = null);
                        notifier.updateSelectedTime(
                          picked.hour,
                          picked.minute,
                          widget.isStart,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_errorMessage != null) ...[
                      Row(
                        children: [
                          Icon(Icons.warning_amber,
                              color: ColorStyles.warning100, size: 20),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(_errorMessage!,
                                style: TextStyles.normalTextRegular
                                    .copyWith(color: ColorStyles.warning100)),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _errorMessage = null);

                  if (widget.isStart && !notifier.validateStartTime()) {
                    setState(() {
                      _errorMessage = '지금보다 이른 시간은 선택할 수 없어요';
                    });
                    return;
                  }

                  if (!widget.isStart && !notifier.validateEndTime()) {
                    setState(() {
                      _errorMessage = '모집 기간은 최소 1일(24시간) 이상이어야 해요';
                    });
                    return;
                  }

                  Navigator.pop(context);

                  if (widget.isStart) {
                    notifier.confirmStartTime();
                  } else {
                    notifier.confirmEndTime();
                  }
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
}
