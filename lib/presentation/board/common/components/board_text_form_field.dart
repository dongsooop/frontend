import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoardTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  // 모집 작성화면 때문에 임시 추가 -> 모집 리팩토링시 삭제 예정
  final ValueChanged<String>? onChanged;

  const BoardTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        hintText: hintText,
        hintStyle: TextStyles.normalTextRegular.copyWith(
          color: ColorStyles.gray3,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorStyles.gray2),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorStyles.primary100),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
