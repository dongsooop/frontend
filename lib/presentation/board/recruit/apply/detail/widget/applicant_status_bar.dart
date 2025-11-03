import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class ApplicantStatusBar extends StatelessWidget {
  final String status;

  const ApplicantStatusBar({super.key, required this.status});

  String _statusLabel(String string) {
    switch (string) {
      case 'PASS':
        return '축하합니다! 합격하셨습니다.';
      case 'FAIL':
        return '아쉽게도 불합격하셨습니다.';
      default:
        return '결과를 기다리는 중입니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _statusLabel(status);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        color: ColorStyles.white,
        width: double.infinity,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorStyles.gray1,
          ),
          child: Text(
            label,
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.gray4),
          ),
        ),
      ),
    );
  }
}
