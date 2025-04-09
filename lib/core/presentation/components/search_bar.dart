import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      child: (TextField(
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
            suffixIcon: Icon(
              Icons.search,
              size: 24.00,
              color: ColorStyles.gray3,
            )),
      )),
    );
  }
}
