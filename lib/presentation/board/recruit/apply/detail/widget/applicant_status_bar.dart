import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class ApplicantStatusBar extends StatelessWidget {
  final String status;

  const ApplicantStatusBar({super.key, required this.status});

  String _statusLabel(String string) {
    switch (string) {
      case 'PASS':
        return '합격';
      case 'FAIL':
        return '불합격';
      default:
        return '결과 대기';
    }
  }

  (Color background, Color foreground) _colorsOf(String string) {
    switch (string) {
      case 'PASS':
        return (ColorStyles.primaryColor, ColorStyles.white);
      case 'FAIL':
        return (ColorStyles.warning10, ColorStyles.warning100);
      default:
        return (ColorStyles.gray1, ColorStyles.gray4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _colorsOf(status);
    final label = _statusLabel(status);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: ColorStyles.white,
        width: double.infinity,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            label,
            style: TextStyles.largeTextBold.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}
