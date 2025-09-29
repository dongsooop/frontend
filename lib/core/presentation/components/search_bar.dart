import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({
    super.key,
    this.controller,
    this.onTap,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final VoidCallback? onTap;
  final Future<void> Function(String value)? onSubmitted;

  Future<void> _handleSubmitted(BuildContext context, String raw) async {
    final value = raw.trim();
    if (value.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    await onSubmitted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (v) => _handleSubmitted(context, v),
        decoration: InputDecoration(
            filled: true,
            fillColor: ColorStyles.gray1,
            contentPadding: const EdgeInsets.all(8),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
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
