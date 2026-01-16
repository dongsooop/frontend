import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onClear,
    this.hintText,
    this.autoFocus = false,
  });

  final TextEditingController controller;
  final Future<void> Function(String value)? onSubmitted;
  final VoidCallback? onClear;
  final String? hintText;
  final bool autoFocus;

  Future<void> _handleSubmitted(BuildContext context, String raw) async {
    final value = raw.trim();
    if (value.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    await onSubmitted?.call(value);
  }

  void _handleClear() {
    controller.clear();
    onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        textInputAction: TextInputAction.search,
        onSubmitted: (v) => _handleSubmitted(context, v),
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorStyles.white,
          isDense: true,
          hintText: hintText,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorStyles.gray3, width: 1.2),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorStyles.gray3, width: 1.2),
            borderRadius: BorderRadius.circular(24),
          ),

          prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          prefixIcon: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _handleSubmitted(context, controller.text),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search, size: 24, color: ColorStyles.gray3),
            ),
          ),

          suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          suffixIcon: hasText
              ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleClear,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.close, size: 20, color: ColorStyles.gray3),
            ),
          )
              : null,
        ),
      ),
    );
  }
}
