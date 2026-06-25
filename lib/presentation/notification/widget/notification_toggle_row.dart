import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class NotificationToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final bool loading;
  final ValueChanged<bool> onChanged;

  const NotificationToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.loading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : () => onChanged(!value),
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
            ),
            Row(
              children: [
                if (loading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                const SizedBox(width: 8),
                SwitchTheme(
                  data: SwitchThemeData(
                    trackOutlineColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.transparent,
                    ),
                  ),
                  child: Transform.scale(
                    scale: 0.85,
                    child: Switch(
                      value: value,
                      onChanged: loading ? null : onChanged,
                      inactiveTrackColor: ColorStyles.gray2,
                      inactiveThumbColor: ColorStyles.white,
                      activeTrackColor: ColorStyles.primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
