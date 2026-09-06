import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

/// 오늘 카드와 학식 카드가 함께 쓰는 한 줄.
///
/// 왼쪽 색 면과 이모지로 종류를 구분한다. 아이콘을 새로 그리지 않는다.
class HomeTodayRow extends StatelessWidget {
  final String emoji;
  final Color background;
  final String title;
  final String? description;
  final bool showChevron;

  /// 비어 있음을 알리는 줄은 흐리게 둔다
  final bool isMuted;

  const HomeTodayRow({
    super.key,
    required this.emoji,
    required this.background,
    required this.title,
    this.description,
    this.showChevron = false,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 19)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.normalTextBold.copyWith(
                    color: isMuted ? ColorStyles.gray4 : ColorStyles.black,
                    height: 1.4,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    description!,
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray6,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: ColorStyles.gray4,
            ),
          ],
        ],
      ),
    );
  }
}
