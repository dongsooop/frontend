import 'package:flutter/cupertino.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class TimeRange {
  final int startHour, startMinute, endHour, endMinute;
  const TimeRange({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
  });

  String get label =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')} ~ '
          '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
}

Future<TimeRange?> showTimeRangePicker(
    BuildContext context, {
      required TimeRange initial,
    }) async {
  final temp = ValueNotifier<TimeRange>(initial);

  final result = await showCupertinoModalPopup<TimeRange>(
    context: context,
    builder: (_) => _LectureTimePickerBottomSheet(temp: temp),
  );

  return result ?? temp.value;
}

class _LectureTimePickerBottomSheet extends StatelessWidget {
  const _LectureTimePickerBottomSheet({required this.temp});
  final ValueNotifier<TimeRange> temp;

  @override
  Widget build(BuildContext context) {
    // 초기값을 9:00 ~ 22:55 범위로 보정
    final startH = temp.value.startHour.clamp(9, 22);
    final startM = ((temp.value.startMinute ~/ 5).clamp(0, 11)) * 5;
    final endH   = temp.value.endHour.clamp(9, 22);
    final endM   = ((temp.value.endMinute ~/ 5).clamp(0, 11)) * 5;

    temp.value = TimeRange(
      startHour: startH,
      startMinute: startM,
      endHour: endH,
      endMinute: endM,
    );

    final startHourController =
    FixedExtentScrollController(initialItem: temp.value.startHour - 9);
    final startMinuteController =
    FixedExtentScrollController(initialItem: temp.value.startMinute ~/ 5);
    final endHourController =
    FixedExtentScrollController(initialItem: temp.value.endHour - 9);
    final endMinuteController =
    FixedExtentScrollController(initialItem: temp.value.endMinute ~/ 5);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16), topRight: Radius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: ColorStyles.white,
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '확인',
                    style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.primaryColor,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, temp.value),
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 시작 시 (9~22)
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 44,
                      scrollController: startHourController,
                      onSelectedItemChanged: (index) {
                        temp.value = TimeRange(
                          startHour: 9 + index,
                          startMinute: temp.value.startMinute,
                          endHour: temp.value.endHour,
                          endMinute: temp.value.endMinute,
                        );
                      },
                      // 9..22 => 14개
                      children: List.generate(14, (i) {
                        final v = (9 + i).toString().padLeft(2, '0');
                        return Center(
                          child: Text(
                            v,
                            style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                          ),
                        );
                      }),
                    ),
                  ),
                  // 시작 분 (0,5,...,55)
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 44,
                      scrollController: startMinuteController,
                      onSelectedItemChanged: (index) {
                        temp.value = TimeRange(
                          startHour: temp.value.startHour,
                          startMinute: index * 5,
                          endHour: temp.value.endHour,
                          endMinute: temp.value.endMinute,
                        );
                      },
                      children: List.generate(12, (i) {
                        final v = (i * 5).toString().padLeft(2, '0');
                        return Center(
                          child: Text(
                            v,
                            style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 종료 시 (9~22)  ← 여기 15 → 14로 수정 (9..22)
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 44,
                      scrollController: endHourController,
                      onSelectedItemChanged: (index) {
                        temp.value = TimeRange(
                          startHour: temp.value.startHour,
                          startMinute: temp.value.startMinute,
                          endHour: 9 + index,
                          endMinute: temp.value.endMinute,
                        );
                      },
                      children: List.generate(14, (i) {
                        final v = (9 + i).toString().padLeft(2, '0');
                        return Center(
                          child: Text(
                            v,
                            style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                          ),
                        );
                      }),
                    ),
                  ),
                  // 종료 분 (0,5,...,55)
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 44,
                      scrollController: endMinuteController,
                      onSelectedItemChanged: (index) {
                        temp.value = TimeRange(
                          startHour: temp.value.startHour,
                          startMinute: temp.value.startMinute,
                          endHour: temp.value.endHour,
                          endMinute: index * 5,
                        );
                      },
                      children: List.generate(12, (i) {
                        final v = (i * 5).toString().padLeft(2, '0');
                        return Center(
                          child: Text(
                            v,
                            style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}