import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

/// 캠퍼스 생활 구획의 배너 한 장.
///
/// 아이콘을 새로 그리는 대신 배경 색 면과 이모지로 서로를 구분한다.
class CampusLinkCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final Color background;
  final VoidCallback onTap;

  const CampusLinkCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.gray6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
