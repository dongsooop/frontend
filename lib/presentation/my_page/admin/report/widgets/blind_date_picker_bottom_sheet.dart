import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlindDatePickerBottomSheet extends HookConsumerWidget {
  final DateTime initial;
  final String title;
  final ValueChanged<DateTime>? onChanged;

  const BlindDatePickerBottomSheet({
    super.key,
    required this.initial,
    this.title = '마감 시간 선택',
    this.onChanged,
  });

  static Future<DateTime?> show(
    BuildContext context, {
      DateTime? initial,
      String title = '마감 시간 선택',
      ValueChanged<DateTime>? onChanged,
    }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: ColorStyles.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlindDatePickerBottomSheet(
        initial: initial ?? DateTime.now(),
        title: title,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tmp = useState<DateTime>(initial);
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          spacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black,),
                ),
              ],
            ),
            const Divider(height: 1, color: ColorStyles.gray2,),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: initial,
                onDateTimeChanged: (value) {
                  final now = DateTime.now();
                  final next = DateTime(now.year, now.month, now.day, value.hour, value.minute);
                  tmp.value = next;
                  onChanged?.call(next);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}