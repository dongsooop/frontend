import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutocompleteList extends StatelessWidget {
  final ScrollController scrollController;
  final List<String> items;
  final String query;
  final ValueChanged<String> onTapSuggestion;

  const AutocompleteList({
    super.key,
    required this.scrollController,
    required this.items,
    required this.query,
    required this.onTapSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    final q = query.trim();

    if (q.isEmpty) return const SizedBox.shrink();

    if (items.isEmpty) return const SizedBox.shrink();

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        ...items.map((keyword) {
          return _AutocompleteKeywordRow(
            key: ValueKey(keyword),
            keyword: keyword,
            onTap: () => onTapSuggestion(keyword),
          );
        }),
      ],
    );
  }
}

class _AutocompleteKeywordRow extends StatelessWidget {
  final String keyword;
  final VoidCallback onTap;

  const _AutocompleteKeywordRow({
    super.key,
    required this.keyword,
    required this.onTap,
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
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        ColorStyles.gray4,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

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

                const SizedBox(width: 44),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
