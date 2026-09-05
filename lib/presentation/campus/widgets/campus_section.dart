import 'package:dongsoop/core/presentation/components/section_header.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 캠퍼스 탭의 한 구획.
///
/// 레이아웃만 담당하고 헤더 표현은 공용 [SectionHeader]에 위임한다.
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
          SectionHeader(
            title: title,
            suffix: trailingDate == null
                ? null
                : Text(
                    '· ${DateFormat('M월 d일(E)', 'ko').format(trailingDate!)}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.largeTextBold.copyWith(
                      color: ColorStyles.gray6,
                    ),
                  ),
            action: trailingLabel == null || onTapTrailing == null
                ? null
                : SectionHeaderAction(
                    label: trailingLabel!,
                    onTap: onTapTrailing!,
                  ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
