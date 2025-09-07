import 'package:dongsoop/presentation/calendar/util/calendar_date_utils.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarDayPicker extends StatefulWidget {
  const CalendarDayPicker({
    super.key,
    required this.initialDateTime,
    required this.onChanged,
    this.minuteStep = 5,
    this.itemExtent = 56,
    this.visibleItemCount = 5,
    this.startDate,
    this.endDate,
    this.includeTodayLabel = true,
    this.daysBefore = 365,
    this.daysAfter = 365,
    this.looping = true,
  });

  final DateTime initialDateTime;
  final ValueChanged<DateTime> onChanged;

  final int minuteStep;
  final double itemExtent;
  final int visibleItemCount;

  final DateTime? startDate;
  final DateTime? endDate;
  final bool includeTodayLabel;

  final int daysBefore;
  final int daysAfter;
  final bool looping;

  @override
  State<CalendarDayPicker> createState() => _CupertinoDateTimeSpinnerState();
}

class _CupertinoDateTimeSpinnerState extends State<CalendarDayPicker> {
  late List<DateTime> _dates;
  late int _dateIndex;
  late int _hourIndex;
  late int _minuteIndex;

  late final FixedExtentScrollController _dateCtrl;
  late final FixedExtentScrollController _hourCtrl;
  late final FixedExtentScrollController _minCtrl;

  String _formatDate(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$m월 $day일 ${weekdayName(d)}';
  }

  bool _isToday(DateTime d) => isSameDay(d, DateTime.now());

  void _emit() {
    final date = _dates[_dateIndex];
    final hour = _hourIndex;
    final minute = _minuteIndex * widget.minuteStep;
    widget.onChanged(DateTime(date.year, date.month, date.day, hour, minute));
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required List<Widget> children,
    required ValueChanged<int> onSelected,
  }) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: widget.itemExtent,
      useMagnifier: true,
      magnification: 1.08,
      squeeze: 1.0,
      diameterRatio: 1.2,
      selectionOverlay: const SizedBox.shrink(),
      looping: widget.looping,
      onSelectedItemChanged: (i) {
        onSelected(i);
        _emit();
      },
      children: children,
    );
  }

  @override
  void initState() {
    super.initState();

    final startBase = widget.startDate ??
        widget.initialDateTime.subtract(Duration(days: widget.daysBefore));
    final endBase = widget.endDate ??
        widget.initialDateTime.add(Duration(days: widget.daysAfter));

    final start = dateOnly(startBase);
    final end = dateOnly(endBase);

    final days = end.difference(start).inDays + 1;
    _dates = List.generate(days, (i) => start.add(Duration(days: i)));

    _dateIndex = _dates.indexWhere((d) => isSameDay(d, widget.initialDateTime));
    if (_dateIndex < 0) _dateIndex = 0;

    _hourIndex = widget.initialDateTime.hour.clamp(0, 23);

    final stepCount = (60 / widget.minuteStep).floor();
    _minuteIndex = (widget.initialDateTime.minute ~/ widget.minuteStep)
        .clamp(0, stepCount - 1);

    _dateCtrl = FixedExtentScrollController(initialItem: _dateIndex);
    _hourCtrl = FixedExtentScrollController(initialItem: _hourIndex);
    _minCtrl  = FixedExtentScrollController(initialItem: _minuteIndex);
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _hourCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemExtent = widget.itemExtent;
    final pickerHeight = itemExtent * widget.visibleItemCount;

    const datePickerWidth = 180.0;
    const hourPickerWidth = 72.0;
    const minutePickerWidth = 72.0;
    final totalPickerWidth = datePickerWidth + hourPickerWidth + minutePickerWidth;

    return SizedBox(
      height: pickerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: datePickerWidth,
                  child: _wheel(
                    controller: _dateCtrl,
                    onSelected: (i) => setState(() => _dateIndex = i),
                    children: [
                      for (final d in _dates)
                        Center(
                          child: Text(
                            (widget.includeTodayLabel && _isToday(d))
                                ? '오늘'
                                : _formatDate(d),
                            style: TextStyles.largeTextRegular,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(
                  width: hourPickerWidth,
                  child: _wheel(
                    controller: _hourCtrl,
                    onSelected: (i) => setState(() => _hourIndex = i),
                    children: [
                      for (int h = 0; h < 24; h++)
                        Center(
                          child: Text(
                            h.toString().padLeft(2, '0'),
                            style: TextStyles.largeTextRegular,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(
                  width: minutePickerWidth,
                  child: _wheel(
                    controller: _minCtrl,
                    onSelected: (i) => setState(() => _minuteIndex = i),
                    children: [
                      for (int m = 0; m < 60; m += widget.minuteStep)
                        Center(
                          child: Text(
                            m.toString().padLeft(2, '0'),
                            style: TextStyles.largeTextRegular,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          IgnorePointer(
            child: Center(
              child: SizedBox(
                width: totalPickerWidth,
                child: Container(
                  height: itemExtent * 0.75,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((255 * 0.10).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
