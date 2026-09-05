import 'package:dongsoop/core/presentation/components/authenticated_action.dart';
import 'package:dongsoop/core/presentation/components/section_header.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 자주 쓰는 화면 네 개.
class HomeQuickLinks extends ConsumerWidget {
  const HomeQuickLinks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(
      userSessionProvider.select((user) => user != null),
    );

    final items = <_QuickItem>[
      const _QuickItem(
        emoji: '🍽️',
        label: '맛집',
        background: ColorStyles.primary5,
        path: RoutePaths.restaurants,
      ),
      const _QuickItem(
        emoji: '📚',
        label: '도서관',
        background: ColorStyles.mintBg,
        path: RoutePaths.libraryWebView,
      ),
      const _QuickItem(
        emoji: '💬',
        label: '챗봇',
        background: ColorStyles.amberBg,
        path: RoutePaths.chatbot,
        requiresAuth: true,
      ),
      const _QuickItem(
        emoji: '🗓️',
        label: '학사일정',
        background: ColorStyles.gray1,
        path: RoutePaths.schedule,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: '바로가기'),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: _QuickTile(
                    item: items[i],
                    isAuthenticated: isAuthenticated,
                  ),
                ),
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
  final bool requiresAuth;

  const _QuickItem({
    required this.emoji,
    required this.label,
    required this.background,
    required this.path,
    this.requiresAuth = false,
  });
}

class _QuickTile extends StatelessWidget {
  final _QuickItem item;
  final bool isAuthenticated;

  const _QuickTile({
    required this.item,
    required this.isAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorStyles.gray7,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          if (!item.requiresAuth) {
            context.push(item.path);
            return;
          }

          runAuthenticatedAction(
            context,
            isAuthenticated: isAuthenticated,
            action: () => context.push(item.path),
          );
        },
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
