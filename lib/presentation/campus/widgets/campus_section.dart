import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 캠퍼스 탭의 한 구획.
///
/// 제목 오른쪽에는 `전체 ›` 같은 이동 링크나 날짜 중 하나만 붙는다.
/// 날짜는 제목 옆 중점으로 붙여 홈의 학식 표기와 같은 꼴을 유지한다.
class CampusSection extends StatelessWidget {
  final String title;
  final Widget child;
  final String? trailingLabel;
  final VoidCallback? onTapTrailing;
  final DateTime? trailingDate;

  const CampusSection({
    super.key,
    required this.title,
    required this.child,
    this.trailingLabel,
    this.onTapTrailing,
    this.trailingDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: _buildTitle()),
              if (trailingLabel != null)
                GestureDetector(
                  onTap: onTapTrailing,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Text(
                        trailingLabel!,
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.gray5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: ColorStyles.gray5,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final titleStyle = TextStyles.largeTextBold.copyWith(
      color: ColorStyles.black,
    );

    if (trailingDate == null) {
      return Text(title, style: titleStyle);
    }

    return Text.rich(
      TextSpan(
        style: titleStyle,
        children: [
          TextSpan(text: title),
          TextSpan(
            text: ' · ',
            style: titleStyle.copyWith(color: ColorStyles.gray3),
          ),
          TextSpan(
            text: DateFormat('M월 d일(E)', 'ko').format(trailingDate!),
            style: titleStyle.copyWith(color: ColorStyles.gray6),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
