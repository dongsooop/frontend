import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dongsoop/core/presentation/components/common_tag.dart';

class HomePopularRecruits extends StatelessWidget {
  const HomePopularRecruits({super.key, required this.recruits});

  final List<Recruit> recruits;

  @override
  Widget build(BuildContext context) {
    final items = recruits;

    return Container(
      color: ColorStyles.gray1,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '인기 모집',
                style: TextStyles.titleTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.go(RoutePaths.board);
                },
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.gray3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: ColorStyles.gray3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorStyles.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 40),
            child: (items.isEmpty)
                ? Center(
              child: Text(
                '지금은 인기 모집 게시글이 없어요',
                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final tags = _splitTags(item.tags);
                final volunteerCount = item.volunteer;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '$volunteerCount명이 지원했어요',
                          style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.content,
                      style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black),
                    ),
                    const SizedBox(height: 16),
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags
                            .asMap()
                            .entries
                            .map((e) => CommonTag(label: e.value, index: e.key))
                            .toList(),
                      ),
                    if (index != items.length - 1)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        width: double.infinity,
                        height: 1,
                        color: ColorStyles.gray2,
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _splitTags(String raw) => raw
      .trim()
      .split(RegExp(r'[,，]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList(growable: false);
}
