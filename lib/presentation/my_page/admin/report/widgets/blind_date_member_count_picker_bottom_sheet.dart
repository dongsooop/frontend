import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlindDateMemberCountPickerBottomSheet extends HookConsumerWidget {
  final int initial;
  final String title;
  final ValueChanged<int>? onChanged;

  const BlindDateMemberCountPickerBottomSheet({
    super.key,
    required this.initial,
    this.title = '한 과팅방의 모집 인원 수',
    this.onChanged,
  });

  static Future<DateTime?> show(
    BuildContext context, {
      int? initial,
      String title = '한 과팅방의 모집 인원 수',
      ValueChanged<int>? onChanged,
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
      builder: (_) => BlindDateMemberCountPickerBottomSheet(
        initial: (initial ?? 2).clamp(2, 20),
        title: title,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState<int>(initial.clamp(2, 20));
    final controller = useMemoized(
          () => FixedExtentScrollController(initialItem: selected.value - 2),
    );
    return FractionallySizedBox(
      heightFactor: 0.4,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker.builder(
                      scrollController: controller,
                      itemExtent: 44,
                      magnification: 1.08,
                      squeeze: 1.15,
                      childCount: 19, // 2~20
                      itemBuilder: (_, i) => Center(
                        child: Text(
                          '${i + 2}',
                          style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                        ),
                      ),
                      onSelectedItemChanged: (i) {
                        selected.value = i + 2;
                        onChanged?.call(selected.value);
                      },
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