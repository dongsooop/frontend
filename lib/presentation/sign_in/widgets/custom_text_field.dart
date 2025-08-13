import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textAlignVertical: TextAlignVertical.center,
      enabled: enabled,
      onTap: onTap,
      onChanged: onChanged,
      style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        prefixIcon: prefix == null ? null : Padding(
          padding: const EdgeInsets.only(left: 8, right: 4),
          child: prefix,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffix == null ? null : Padding(
          padding: const EdgeInsets.only(right: 8, left: 4),
          child: suffix,
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}