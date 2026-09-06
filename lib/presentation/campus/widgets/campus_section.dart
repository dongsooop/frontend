import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

/// 캠퍼스 탭의 한 구획.
class CampusSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? suffix;
  final Widget? action;

  const CampusSection({
    super.key,
    required this.title,
    required this.child,
    this.suffix,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.largeTextBold.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                    ),
                    if (suffix != null) ...[
                      const SizedBox(width: 4),
                      Flexible(child: suffix!),
                    ],
                  ],
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: 12),
                action!,
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
