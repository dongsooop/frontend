import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _RecentMenu { clearAll, cancel }

class SearchRecentList extends HookConsumerWidget {
  final ScrollController scrollController;
  final Future<void> Function(String keyword) onTapRecentDetail;
  final String query;

  const SearchRecentList({
    super.key,
    required this.scrollController,
    required this.onTapRecentDetail,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);

    final q = query.trim();
    final recent = useState<List<String>>([]);

    final loadRecent = useCallback(() async {
      recent.value = await prefs.getRecentSearches();
    }, [prefs]);

    final removeOne = useCallback((String keyword) async {
      await prefs.removeRecentSearch(keyword);
      await loadRecent();
    }, [prefs, loadRecent]);

    final clearAll = useCallback(() async {
      await prefs.clearRecentSearches();
      await loadRecent();
    }, [prefs, loadRecent]);

    useEffect(() {
      if (q.isEmpty) {
        loadRecent();
      }
      return null;
    }, [q, loadRecent]);

    if (q.isNotEmpty) return const SizedBox.shrink();

    final items = recent.value.take(5).toList();

    Widget header() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '최근 검색',
            style: TextStyles.normalTextBold.copyWith(color: ColorStyles.gray6),
          ),
          PopupMenuButton<_RecentMenu>(
            enabled: items.isNotEmpty,
            icon: const Icon(Icons.more_horiz, color: ColorStyles.gray4),
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onSelected: (value) async {
              switch (value) {
                case _RecentMenu.clearAll:
                  await clearAll();
                  break;
                case _RecentMenu.cancel:
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<_RecentMenu>(
                value: _RecentMenu.clearAll,
                child: Text(
                  '전체 삭제',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
              ),
              PopupMenuItem<_RecentMenu>(
                value: _RecentMenu.cancel,
                child: Text(
                  '취소',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            header(),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Text(
                  '최근 검색어가 없어요',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        header(),
        const SizedBox(height: 8),
        ...items.map((keyword) {
          return _RecentKeywordRow(
            key: ValueKey(keyword),
            keyword: keyword,
            onTap: () => onTapRecentDetail(keyword),
            onRemove: () => removeOne(keyword),
          );
        }),
      ],
    );
  }
}

class _RecentKeywordRow extends StatelessWidget {
  final String keyword;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentKeywordRow({
    super.key,
    required this.keyword,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    keyword,
                    style: TextStyles.largeTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close, color: ColorStyles.gray4),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}