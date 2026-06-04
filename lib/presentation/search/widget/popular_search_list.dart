import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class PopularSearchList extends StatelessWidget {
  final List<String> keywords;
  final bool isLoading;
  final bool isError;

  final void Function(String keyword) onTapKeyword;
  final int maxItems;

  const PopularSearchList({
    super.key,
    required this.keywords,
    required this.onTapKeyword,
    this.isLoading = false,
    this.isError = false,
    this.maxItems = 10,
  });

  @override
  Widget build(BuildContext context) {
    final items = keywords.take(maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '실시간 인기 검색어',
            style: TextStyles.normalTextBold.copyWith(color: ColorStyles.gray6),
          ),
        ),

        // 로딩
        if (isLoading)
          const SizedBox(
            height: 44,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorStyles.primaryColor,
                ),
              ),
            ),
          )

        // 에러
        else if (isError)
          SizedBox(
            height: 44,
            child: Center(
              child: Text(
                '인기 검색어를 불러오지 못했어요',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray6,
                ),
              ),
            ),
          )

        // 빈 값
        else if (items.isEmpty)
            SizedBox(
              height: 44,
              child: Center(
                child: Text(
                  '표시할 인기 검색어가 없어요',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.gray6,
                  ),
                ),
              ),
            )

          // 정상
          else
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final keyword = items[index];
                  return _KeywordChip(
                    keyword: keyword,
                    onTap: () => onTapKeyword(keyword),
                  );
                },
              ),
            ),
      ],
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String keyword;
  final VoidCallback onTap;

  const _KeywordChip({
    required this.keyword,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(16));

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: ColorStyles.gray7,
          borderRadius: radius,
        ),
        alignment: Alignment.center,
        child: Text(
          keyword,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.normalTextRegular.copyWith(
            color: ColorStyles.black,
          ),
        ),
      ),
    );
  }
}