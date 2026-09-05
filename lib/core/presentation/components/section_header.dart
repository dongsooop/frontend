import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

/// 여러 화면에서 재사용하는 섹션 헤더.
///
/// 제목 옆 보조 정보와 우측 액션은 [Widget] 으로 받아,
/// 날짜·카운트·버튼 등 새로운 표현이 추가되어도 이 컴포넌트를 수정하지 않는다.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? suffix;
  final Widget? action;

  const SectionHeader({
    super.key,
    required this.title,
    this.suffix,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
    );
  }
}

/// 섹션 헤더의 표준 텍스트 액션.
class SectionHeaderAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SectionHeaderAction({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
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
      ),
    );
  }
}
