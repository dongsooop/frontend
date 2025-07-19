import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CommonRecruitListItem extends StatelessWidget {
  final String statusText;
  final String volunteerText;
  final String periodText;

  final String title;
  final String content;
  final List<String> tags;

  final VoidCallback onTap;
  final bool isLastItem;

  const CommonRecruitListItem({
    super.key,
    required this.statusText,
    required this.volunteerText,
    required this.periodText,
    required this.title,
    required this.content,
    required this.tags,
    required this.onTap,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    final hasRealTags = tags.any((tag) => tag.trim().isNotEmpty);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 정보
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.task_alt,
                            size: 16, color: ColorStyles.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                            statusText,
                            style: TextStyles.smallTextBold
                                .copyWith(color: ColorStyles.black)),
                        const SizedBox(width: 8),
                        Text(volunteerText,
                            style: TextStyles.smallTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                      ],
                    ),
                    Text(
                      periodText,
                      style: TextStyles.smallTextRegular
                          .copyWith(color: ColorStyles.gray4),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 제목
                Text(title,
                    style: TextStyles.largeTextBold
                        .copyWith(color: ColorStyles.black)),
                const SizedBox(height: 8),

                // 내용 한 줄
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Text(
                    content,
                    style: TextStyles.smallTextRegular
                        .copyWith(color: ColorStyles.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                if (hasRealTags) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    children: tags
                        .asMap()
                        .entries
                        .map((entry) => CommonTag(
                              label: entry.value,
                              index: entry.key,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          if (!isLastItem) const Divider(color: ColorStyles.gray2, height: 1),
        ],
      ),
    );
  }
}
