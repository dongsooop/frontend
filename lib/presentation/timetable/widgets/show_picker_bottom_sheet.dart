import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showYearPickerBottomSheet(
    BuildContext context, {
      required int currentYear,
      required ValueChanged<int> onDone,
    }) async {
  final years = List<int>.generate(11, (i) => currentYear - i);
  final controller = FixedExtentScrollController(initialItem: 0);

  int selected = years[0];

  final result = await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SizedBox(
        height: 300,
        child: Column(
          children: [
            _pickerHeader(
              onCancel: () => Navigator.pop(context),
              onDone: () {
                Navigator.pop(context);
                onDone(selected);
              },
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 44,
                useMagnifier: true,
                magnification: 1.1,
                scrollController: controller,
                onSelectedItemChanged: (index) => selected = years[index],
                children: years.map((y) => Center(
                  child: Text(
                    '$y',
                    style: TextStyles.largeTextBold.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                ),).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
  onDone(result ?? selected);
}

Widget _pickerHeader({required VoidCallback onCancel, required VoidCallback onDone}) {
  return SizedBox(
    height: 44,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onCancel,
          child: Text('취소', style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.warning100,),),
        ),
        TextButton(
          onPressed: onDone,
          child: Text('완료', style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.primaryColor,),),
        ),
      ],
    ),
  );
}

Future<void> showSemesterPickerBottomSheet(
    BuildContext context, {
      required List<Semester> items,
      required ValueChanged<Semester> onDone,
    }) async {
  final controller = FixedExtentScrollController(initialItem: 0);
  Semester selected = items[0];

  final result = await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SizedBox(
        height: 300,
        child: Column(
          children: [
            _pickerHeader(
              onCancel: () => Navigator.pop(context),
              onDone: () {
                Navigator.pop(context);
                onDone(selected);
              },
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 44,
                useMagnifier: true,
                magnification: 1.1,
                scrollController: controller,
                onSelectedItemChanged: (index) => selected = items[index],
                children: items.map((s) => Center(
                  child: Text(
                    s.label,
                    style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black,),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );

  onDone(result ?? selected);
}