import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 자주 쓰는 화면 네 개.
class HomeQuickLinks extends StatelessWidget {
  const HomeQuickLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '바로가기',
            style: TextStyles.sectionTitleBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 98,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                _QuickTile(
                  icon: Icons.restaurant_rounded,
                  label: '맛집',
                  onTap: () => context.pushNamed('restaurants'),
                ),
                const SizedBox(width: 8),
                _QuickTile(
                  icon: Icons.menu_book_rounded,
                  label: '도서관',
                  onTap: () => context.pushNamed('libraryWebView'),
                ),
                const SizedBox(width: 8),
                _QuickTile(
                  icon: Icons.map_rounded,
                  label: '캠퍼스 지도',
                  isNew: true,
                  isHighlighted: true,
                  onTap: () => context.push(RoutePaths.campusMap),
                ),
                const SizedBox(width: 8),
                _QuickTile(
                  icon: Icons.calendar_month_rounded,
                  label: '학사일정',
                  onTap: () => context.push(RoutePaths.schedule),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isNew;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _QuickTile({
    required this.icon,
    required this.label,
    this.isNew = false,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 92,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3, 4, 3, 6),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? ColorStyles.primary5
                            : ColorStyles.gray7,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        icon,
                        size: 28,
                        color: isHighlighted
                            ? ColorStyles.primary100
                            : ColorStyles.gray6,
                      ),
                    ),
                    if (isNew)
                      Positioned(
                        top: -5,
                        right: -8,
                        child: Container(
                          height: 17,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorStyles.primary100,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: ColorStyles.white,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'NEW',
                            style: TextStyles.smallTextBold.copyWith(
                              color: ColorStyles.white,
                              fontSize: 8,
                              height: 1,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: TextStyles.smallTextBold.copyWith(
                    color: isHighlighted
                        ? ColorStyles.primaryGray
                        : ColorStyles.gray6,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
