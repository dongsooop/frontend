import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

/// 공지 알림 설정으로 가는 작은 아이콘 버튼.
///
/// 배경 칩을 깔아 제목 옆이나 헤더에 놓아도 눈에 띄되, 본문을 누르지는 않는 크기로 둔다.
class NoticeSettingIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const NoticeSettingIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: ColorStyles.primary5,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: ColorStyles.primary100,
          ),
        ),
      ),
    );
  }
}
