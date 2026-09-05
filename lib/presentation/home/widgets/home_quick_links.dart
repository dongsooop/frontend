import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 자주 쓰는 화면 네 개.
///
/// 아이콘을 새로 그리는 대신 배경 색 면과 이모지로 구분한다.
class HomeQuickLinks extends StatelessWidget {
  const HomeQuickLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_QuickItem>[
      _QuickItem('🍽️', '맛집', ColorStyles.primary5, RoutePaths.restaurants),
      _QuickItem('📚', '도서관', ColorStyles.mintBg, RoutePaths.libraryWebView),
      _QuickItem('💬', '챗봇', ColorStyles.amberBg, RoutePaths.chatbot),
      _QuickItem('🗓️', '학사일정', ColorStyles.gray1, RoutePaths.schedule),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '바로가기',
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _QuickTile(item: items[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickItem {
  final String emoji;
  final String label;
  final Color background;
  final String path;

  const _QuickItem(this.emoji, this.label, this.background, this.path);
}

class _QuickTile extends StatelessWidget {
  final _QuickItem item;

  const _QuickTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorStyles.gray7,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.push(item.path),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: item.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(item.emoji, style: const TextStyle(fontSize: 17)),
              ),
              const SizedBox(height: 7),
              Text(
                item.label,
                style: TextStyles.smallTextBold.copyWith(
                  color: ColorStyles.gray6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
