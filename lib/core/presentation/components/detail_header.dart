import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  const DetailHeader(
      {super.key, required this.title, this.onBack, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: AppBar(
        backgroundColor: ColorStyles.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            onBack ?? () => Navigator.pop(context);
          },
          icon: Icon(
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
    ));
  }
}
