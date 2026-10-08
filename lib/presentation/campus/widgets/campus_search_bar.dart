import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 캠퍼스 탭 상단 검색 진입점. 실제 입력은 검색 화면에서 받는다.
class CampusSearchBar extends StatelessWidget {
  const CampusSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.push(RoutePaths.search),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: ColorStyles.gray1,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: ColorStyles.gray5),
              const SizedBox(width: 8),
              Text(
                '공지 검색',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
