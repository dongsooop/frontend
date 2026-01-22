import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CommonNoticeList<T> extends StatelessWidget {
  const CommonNoticeList({
    super.key,
    required this.items,
    required this.controller,
    required this.isLoading,
    required this.hasMore,
    required this.titleOf,
    required this.isDepartmentOf,
    required this.onTap,
  });

  final List<T> items;
  final ScrollController controller;
  final bool isLoading;
  final bool hasMore;
  final String Function(T) titleOf;
  final bool Function(T) isDepartmentOf;
  final void Function(T) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: items.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(
                color: ColorStyles.primaryColor,
              ),
            ),
          )
              : const SizedBox.shrink();
        }

        final item = items[index];
        final isDept = isDepartmentOf(item);

        final leftBadgeText = isDept ? '학과공지' : '동양공지';
        final rightBadgeText = isDept ? '학부' : '학교생활';

        return CommonNoticeListItem(
          title: titleOf(item),
          leftBadgeText: leftBadgeText,
          rightBadgeText: rightBadgeText,
          onTap: () => onTap(item),
          isLastItem: index == items.length - 1,
        );
      },
    );
  }
}

class CommonNoticeListItem extends StatelessWidget {
  const CommonNoticeListItem({
    super.key,
    required this.title,
    required this.leftBadgeText,
    required this.rightBadgeText,
    required this.onTap,
    required this.isLastItem,
  });

  final String title;
  final String leftBadgeText;
  final String rightBadgeText;
  final VoidCallback onTap;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.largeTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  children: [
                    CommonTag(label: leftBadgeText, index: 0),
                    CommonTag(label: rightBadgeText, index: 1),
                  ],
                ),
              ],
            ),
          ),
          if (!isLastItem)
            const Divider(
              color: ColorStyles.gray2,
              height: 1,
              thickness: 1,
            ),
        ],
      ),
    );
  }
}