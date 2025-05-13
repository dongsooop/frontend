import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomCustomTimeSpinner extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final bool isStart;

  const BottomCustomTimeSpinner({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
    required this.isStart,
  });

  @override
  State<BottomCustomTimeSpinner> createState() =>
      _BottomCustomTimeSpinnerState();
}

class _BottomCustomTimeSpinnerState extends State<BottomCustomTimeSpinner> {
  late FixedExtentScrollController _amPmController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  bool showTimePicker = false;

  @override
  void initState() {
    super.initState();
    final hour = widget.initialDateTime.hour;
    final minute = widget.initialDateTime.minute;

    final amPmIndex = hour < 12 ? 0 : 1;
    final hourIndex = _to12Hour(hour) - 1;
    final minuteIndex = (minute ~/ 10).clamp(0, 5);

    _amPmController = FixedExtentScrollController(initialItem: amPmIndex);
    _hourController = FixedExtentScrollController(initialItem: hourIndex);
    _minuteController = FixedExtentScrollController(initialItem: minuteIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isStart ? '시작 시간' : '마감 시간',
                    style: TextStyles.normalTextRegular
                        .copyWith(color: ColorStyles.black),
                  ),
                  Row(
                    children: [
                      Text(
                        '${_twoDigits(widget.initialDateTime.hour)}:${_twoDigits(widget.initialDateTime.minute)}',
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
            Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
          if (showTimePicker)
            SizedBox(
              height: 200,
              width: 280,
              child: _buildPickerUI(),
            ),
        ],
      ),
    );
  }

  Widget _buildPickerUI() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: ColorStyles.black.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Row(
          children: [
            _buildAmPmPicker(),
            _buildHourPicker(),
            _buildMinutePicker(),
          ],
        ),
      ],
    );
  }

  Widget _buildAmPmPicker() {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 44,
        scrollController: _amPmController,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: (_) => _emit(),
        children: [
          Center(child: Text('오전', style: TextStyles.titleTextRegular)),
          Center(child: Text('오후', style: TextStyles.titleTextRegular)),
        ],
      ),
    );
  }

  Widget _buildHourPicker() {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 44,
        scrollController: _hourController,
        looping: true,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: (_) => _emit(),
        children: List.generate(
          12,
          (i) => Center(
            child: Text('${i + 1}'.padLeft(2, '0'),
                style: TextStyles.titleTextRegular),
          ),
        ),
      ),
    );
  }

  Widget _buildMinutePicker() {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 44,
        scrollController: _minuteController,
        looping: true,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: (_) => _emit(),
        children: List.generate(
          6,
          (i) => Center(
            child: Text('${i * 10}'.padLeft(2, '0'),
                style: TextStyles.titleTextRegular),
          ),
        ),
      ),
    );
  }

  void _emit() {
    final amPmIndex = _amPmController.selectedItem;
    final hourIndex = _hourController.selectedItem % 12;
    final minuteIndex = _minuteController.selectedItem % 6;

    final hour12 = hourIndex + 1;
    final minute = minuteIndex * 10;
    final hour24 = amPmIndex == 0
        ? (hour12 == 12 ? 0 : hour12)
        : (hour12 == 12 ? 12 : hour12 + 12);

    final result = DateTime(
      widget.initialDateTime.year,
      widget.initialDateTime.month,
      widget.initialDateTime.day,
      hour24,
      minute,
    );

    widget.onDateTimeChanged(result);
  }

  int _to12Hour(int hour24) {
    final h = hour24 % 12;
    return h == 0 ? 12 : h;
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
