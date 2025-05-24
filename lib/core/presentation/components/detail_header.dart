import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;

  const DetailHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(44),
      child: SafeArea(
        child: AppBar(
          backgroundColor: ColorStyles.white,
          surfaceTintColor: ColorStyles.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            visualDensity: VisualDensity.compact,
            onPressed: () => context.pop(),
            highlightColor: Colors.transparent,
            icon: const Icon(
              Icons.navigate_before,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          centerTitle: true,
          actions: trailing != null ? [trailing!] : null,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}
