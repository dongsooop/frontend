import 'package:dongsoop/presentation/board/recruit/write/view_models/date_time_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/bottom_custom_calendar.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/bottom_custom_time_spinner.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DateTimeBottomSheet extends ConsumerStatefulWidget {
  final bool isStart;
  const DateTimeBottomSheet({super.key, required this.isStart});

  @override
  ConsumerState<DateTimeBottomSheet> createState() =>
      _DateTimeBottomSheetState();
}

class _DateTimeBottomSheetState extends ConsumerState<DateTimeBottomSheet> {
  String? _errorMessage;
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dateTimeViewModelProvider);
    final viewModel = ref.read(dateTimeViewModelProvider.notifier);

    final selectedDateTime =
        widget.isStart ? state.startDateTime : state.endDateTime;

    return SafeArea(
      child: SizedBox(
        height: 584,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isStart ? '모집 시작일 선택하기' : '모집 마감일 선택하기',
                    style: TextStyles.titleTextBold,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: ColorStyles.gray5, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.isStart
                            ? '오늘 기준 3개월 이내의 날짜만 선택 가능해요'
                            : '시작일 기준 최소 24시간, 최대 27일 이내로 선택 가능해요',
                        style: TextStyles.smallTextRegular
                            .copyWith(color: ColorStyles.gray4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                child: Column(
                  children: [
                    BottomCustomCalendar(
                      selectedDate: selectedDateTime,
                      currentMonth: state.currentMonth,
                      onMonthChanged: (month) {
                        viewModel.tryMoveToMonth(month, widget.isStart);
                      },
                      onDateSelected: (date) {
                        setState(() => _errorMessage = null);
                        viewModel.updateSelectedDate(date, widget.isStart);
                      },
                      isDateEnabled: (date) =>
                          viewModel.isDateEnabled(date, widget.isStart),
                      canMoveToPreviousMonth: viewModel.canMoveToPreviousMonth,
                      canMoveToNextMonth: (month) =>
                          viewModel.canMoveToNextMonth(month, widget.isStart),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BottomCustomTimeSpinner(
                          initialDateTime: selectedDateTime,
                          isStart: widget.isStart,
                          onDateTimeChanged: (picked) {
                            setState(() => _errorMessage = null);
                            viewModel.updateSelectedTime(
                                picked.hour, picked.minute, widget.isStart);
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_errorMessage != null)
                          Row(
                            children: [
                              Icon(Icons.warning_amber,
                                  color: ColorStyles.warning100, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyles.smallTextRegular.copyWith(
                                    color: ColorStyles.warning100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  final isValid = viewModel.confirmDateTime(widget.isStart);
                  if (!isValid) {
                    setState(() {
                      _errorMessage = '모집 기간은 최소 1일(24시간) 이상이어야 해요';
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });

                    return;
                  }

                  context.pop();
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
