import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? trailing;
  final Color? backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBack;
  final PreferredSizeWidget? bottom;

  const DetailHeader({
    super.key,
    this.title,
    this.trailing,
    this.backgroundColor,
    this.showBackButton = true,
    this.onBack,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 44,
      backgroundColor: backgroundColor ?? ColorStyles.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      leading: showBackButton
          ? IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              visualDensity: VisualDensity.compact,
              onPressed: onBack ?? () => context.pop(),
              highlightColor: Colors.transparent,
              icon: const Icon(
                Icons.navigate_before,
                size: 24,
              ),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
            )
          : null,
      centerTitle: true,
      actions: trailing != null ? [trailing!] : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44 + (bottom?.preferredSize.height ?? 0));
}
