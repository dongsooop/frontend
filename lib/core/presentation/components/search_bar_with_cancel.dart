import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class SearchBarWithCancel extends StatelessWidget {
  const SearchBarWithCancel({
    super.key,
    required this.controller,
    required this.isSearching,
    required this.onSearch,
    required this.onCancel,
  });

  final TextEditingController controller;
  final bool isSearching;
  final Future<void> Function(String keyword) onSearch;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBarComponent(
            controller: controller,
            onTap: () async {
              final kw = controller.text.trim();
              if (kw.isEmpty) return;
              await onSearch(kw);
            },
          ),
        ),
        SizedBox(width: 8),
        if (isSearching)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onCancel,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                '취소',
                style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray4),
              ),
            ),
          ),
      ],
    );
  }
}
