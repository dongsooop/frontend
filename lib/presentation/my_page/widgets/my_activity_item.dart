import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class MyActivityItem extends StatelessWidget {
  final String label;
  final String? description;
  final String? iconAsset;
  final VoidCallback onTap;

  const MyActivityItem({
    super.key,
    required this.label,
    this.description,
    this.iconAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (iconAsset == null) {
      return InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 24,
                color: ColorStyles.black,
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorStyles.gray7,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                iconAsset!,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: description == null
                  ? Text(
                      label,
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.black,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: TextStyles.normalTextBold.copyWith(
                            color: ColorStyles.black,
                          ),
                        ),
                        Text(
                          description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray4,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
