import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
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
    final user = ref.watch(userSessionProvider);

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
              Expanded(
                child: _QuickTile(
                  emoji: '🍽️',
                  label: '맛집',
                  background: ColorStyles.primary5,
                  onTap: () => context.pushNamed('restaurants'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickTile(
                  emoji: '📚',
                  label: '도서관',
                  background: ColorStyles.mintBg,
                  onTap: () => context.pushNamed('libraryWebView'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickTile(
                  emoji: '💬',
                  label: '챗봇',
                  background: ColorStyles.amberBg,
                  onTap: () async {
                    if (user == null) {
                      await LoginRequiredDialog(context);
                      return;
                    }
                    context.push(RoutePaths.chatbot);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickTile(
                  emoji: '🗓️',
                  label: '학사일정',
                  background: ColorStyles.gray1,
                  onTap: () => context.push(RoutePaths.schedule),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color background;
  final VoidCallback onTap;

  const _QuickTile({
    required this.emoji,
    required this.label,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorStyles.gray7,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 17)),
              ),
              const SizedBox(height: 7),
              Text(
                label,
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
