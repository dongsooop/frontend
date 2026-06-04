import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

Future<WeekDay?> showWeekDayPicker(
  BuildContext context, {
    required WeekDay initial,
  }) async {
    final day = ValueNotifier<WeekDay>(initial);

    final result = await showCupertinoModalPopup<WeekDay>(
      context: context,
      builder: (_) => _WeekDayPickerSheet(day: day),
    );

    return result ?? day.value;
}

class _WeekDayPickerSheet extends StatelessWidget {
  final ValueNotifier<WeekDay> day;

  const _WeekDayPickerSheet({required this.day});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16), topRight: Radius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  child: Text('확인', style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.primaryColor,),),
                  onPressed: () => Navigator.pop(context, day.value),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 44,
                scrollController: FixedExtentScrollController(
                  initialItem: WeekDay.values.indexOf(day.value),
                ),
                onSelectedItemChanged: (i) => day.value = WeekDay.values[i],
                children: WeekDay.values.map((d) => Center(
                  child: Text(
                    '${d.korean}요일',
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
    );
  }
}