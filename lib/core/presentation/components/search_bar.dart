import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({
    super.key,
    this.controller,
    this.onTap,
  });

  final TextEditingController? controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: ColorStyles.gray1,
            contentPadding: EdgeInsets.all(8),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8)),
            suffixIcon: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                onTap?.call();
              },
              child: const Icon(Icons.search, size: 24.0, color: ColorStyles.gray3),
            )),
      ),
    );
  }
}
