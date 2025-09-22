import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/core/presentation/components/common_tag.dart';

class NoticeListView<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoading;
  final bool isLastPage;
  final ScrollController controller;
  final void Function(T item)? onTap;
  final String Function(T) titleOf;
  final bool Function(T) isDepartmentOf;
  final String Function(T) linkOf;

  const NoticeListView({
    super.key,
    required this.items,
    required this.isLoading,
    required this.isLastPage,
    required this.controller,
    required this.titleOf,
    required this.isDepartmentOf,
    required this.linkOf,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      itemCount: items.length + (isLastPage ? 0 : 1),
      separatorBuilder: (_, __) => const Divider(height: 1, color: ColorStyles.gray2),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return isLoading
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(color: ColorStyles.primaryColor)),
          )
              : const SizedBox.shrink();
        }

        final item = items[index];
        final title = titleOf(item);
        final tags = isDepartmentOf(item) ? const ['학과공지', '학부'] : const ['동양공지', '학교생활'];

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap?.call(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black)),
                const SizedBox(height: 16),
                Wrap(
                  children: List.generate(tags.length, (i) => CommonTag(label: tags[i], index: i)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
