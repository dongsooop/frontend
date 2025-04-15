import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPageScreen extends StatefulWidget {
  const CalendarPageScreen({super.key});

  @override
  State<CalendarPageScreen> createState() => _CalendarPageScreenState();
}

class _CalendarPageScreenState extends State<CalendarPageScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _goToPreviousMonth() => setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
      });

  void _goToNextMonth() => setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
      });

  Widget _buildDayBox({
    required DateTime day,
    required Color textColor,
    Color? backgroundColor,
    BoxBorder? border,
  }) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${day.day}',
            style: TextStyles.smallTextRegular.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(DateTime day) {
    if (day.weekday == DateTime.saturday) return ColorStyles.primary100;
    if (day.weekday == DateTime.sunday) return ColorStyles.warning100;
    return ColorStyles.black;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            centerTitle: false,
            backgroundColor: ColorStyles.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateTime.now().year}년',
                    style: TextStyles.smallTextBold
                        .copyWith(color: ColorStyles.primaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '캘린더',
                    style: TextStyles.titleTextBold
                        .copyWith(color: ColorStyles.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed:
                        _focusedDay.month == 1 ? null : _goToPreviousMonth,
                    icon: const Icon(Icons.chevron_left, size: 24),
                    color: _focusedDay.month == 1
                        ? Colors.transparent
                        : ColorStyles.black,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  Text(
                    '${_focusedDay.month}월',
                    style: TextStyles.largeTextBold
                        .copyWith(color: ColorStyles.black),
                  ),
                  IconButton(
                    onPressed: _focusedDay.month == 12 ? null : _goToNextMonth,
                    icon: const Icon(Icons.chevron_right, size: 24),
                    color: _focusedDay.month == 12
                        ? Colors.transparent
                        : ColorStyles.black,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorStyles.gray2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TableCalendar(
                  rowHeight: 88,
                  daysOfWeekHeight: 44,
                  focusedDay: _focusedDay,
                  firstDay: DateTime(_focusedDay.year - 1, 12, 1),
                  lastDay: DateTime(_focusedDay.year + 1, 1, 31),
                  locale: 'ko-KR',
                  headerVisible: false,
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  calendarStyle: const CalendarStyle(),
                  calendarBuilders: CalendarBuilders(
                    // 요일 표시
                    dowBuilder: (context, day) {
                      final text =
                          ['일', '월', '화', '수', '목', '금', '토'][day.weekday % 7];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            text,
                            style: TextStyles.smallTextRegular.copyWith(
                              color: _getTextColor(day),
                            ),
                          ),
                        ),
                      );
                    },

                    // 오늘 날짜 (선택되지 않은 경우)
                    todayBuilder: (context, day, _) => _buildDayBox(
                      day: day,
                      textColor: _getTextColor(day),
                      backgroundColor: ColorStyles.gray1,
                    ),

                    // 선택한 날짜 (오늘 포함)
                    selectedBuilder: (context, day, _) => _buildDayBox(
                      day: day,
                      textColor: _getTextColor(day),
                      border: Border.all(color: ColorStyles.black),
                      backgroundColor: isSameDay(day, DateTime.now())
                          ? ColorStyles.gray1
                          : null,
                    ),

                    // 지난달/다음달 날짜
                    outsideBuilder: (context, day, _) => _buildDayBox(
                      day: day,
                      textColor: ColorStyles.gray3,
                    ),

                    // 기본 날짜
                    defaultBuilder: (context, day, _) => _buildDayBox(
                      day: day,
                      textColor: _getTextColor(day),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
