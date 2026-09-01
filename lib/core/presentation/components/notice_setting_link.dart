import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

/// 공지 카드 맨 아래에 놓는 설정 줄.
///
/// 목록과 같은 여백 안에서 배경을 깔아 한 덩어리로 보이게 한다.
/// 아이콘·문구·화살표를 가운데로 모으고, 공지 항목보다 눈에 덜 띄도록
/// 배경과 글자는 회색 계열로 두되 아이콘만 강조색을 준다.
class NoticeSettingLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const NoticeSettingLink({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  static final BorderRadius _radius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorStyles.gray1,
      borderRadius: _radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: _radius,
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: ColorStyles.primary100),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.gray6,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: ColorStyles.gray4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
