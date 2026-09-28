import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

/// 식당이 그 주에 붙인 공지.
///
/// 주마다 있는 것이 아니라서 없으면 이 자리가 통째로 빠진다. 빈 판을 두고
/// `공지 없음` 이라고 적으면 매주 읽을 것이 없는 자리가 하나 생긴다.
class MealNoticeCard extends StatelessWidget {
  final String notice;

  const MealNoticeCard(this.notice, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorStyles.primary5,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '공지',
            style: TextStyles.smallTextBold.copyWith(
              color: ColorStyles.primary100,
              height: 1.5,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              notice,
              style: TextStyles.smallTextRegular.copyWith(
                color: ColorStyles.black,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
