import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class NotificationSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const NotificationSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: ColorStyles.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
          ),
          const SizedBox(height: 12),
          ...children,
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}