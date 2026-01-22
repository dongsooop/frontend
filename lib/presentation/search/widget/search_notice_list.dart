import 'package:dongsoop/core/presentation/components/common_notice_list_item.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';

class SearchNoticeList extends StatelessWidget {
  final List<SearchNoticeEntity> items;
  final bool isLoading;
  final bool hasMore;
  final ScrollController controller;
  final void Function(SearchNoticeEntity e)? onTap;

  const SearchNoticeList({
    super.key,
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: ColorStyles.primaryColor),
        );
      }
      return Center(
        child: Text(
          '검색 결과가 없어요!',
          style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray4),
        ),
      );
    }

    return ListView.builder(
      controller: controller,
      itemCount: items.length + (hasMore ? 1 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(
                color: ColorStyles.primaryColor,
              ),
            ),
          )
              : const SizedBox.shrink();
        }

        final e = items[index];
        final leftBadgeText = e.isDepartment ? '학과공지' : '동양공지';
        final rightBadgeText = e.isDepartment ? '학부' : '학교생활';

        return CommonNoticeListItem(
          title: e.title,
          leftBadgeText: leftBadgeText,
          rightBadgeText: rightBadgeText,
          isLastItem: index == items.length - 1,
          onTap: () => onTap?.call(e),
        );
      },
    );
  }
}