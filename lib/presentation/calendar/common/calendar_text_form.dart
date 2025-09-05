import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalendarTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CalendarTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
       fillColor: ColorStyles.white,
        contentPadding: const EdgeInsets.all(16),
        hintText: hintText,
        hintStyle: TextStyles.normalTextRegular.copyWith(
          color: ColorStyles.gray3,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(8)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
