import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dongsoop/ui/color_styles.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({
    super.key,
    required this.onTapAlarm,
    this.unreadCount = 0,
  });

  final VoidCallback onTapAlarm;
  final int unreadCount;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    final showBadge = unreadCount > 0;
    final badgeText = unreadCount > 99 ? '99+' : '$unreadCount';

    return SafeArea(
      bottom: false,
      child: Container(
        height: 44,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('assets/icons/logo.svg', width: 28, height: 28),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTapAlarm,
                borderRadius: BorderRadius.circular(64),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset('assets/icons/alarm.svg', width: 28, height: 28),
                        if (showBadge)
                          Positioned(
                            top: -4,
                            right: -6,
                            child: _Badge(text: badgeText),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final isSingle = text.length == 1;

    return Container(
      padding: isSingle
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 4),
      width: isSingle ? 16 : null,
      height: 16,
      decoration: BoxDecoration(
        color: ColorStyles.warning100,
        borderRadius: BorderRadius.circular(64),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyles.smallTextRegular.copyWith(
          color: ColorStyles.white,
        ),
      ),
    );
  }
}
