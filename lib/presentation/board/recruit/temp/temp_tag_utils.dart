import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

// _buildTag 함수
Widget buildTag(String tag) {
  Color backColor;
  TextStyle textStyle;

  if (tag == "컴퓨터소프트웨어공학과") {
    backColor = ColorStyles.primary5;
    textStyle =
        TextStyles.smallTextBold.copyWith(color: ColorStyles.primary100);
  } else if (tag == "DB" ||
      tag == "JAVA" ||
      tag == "Linux" ||
      tag == "자격증" ||
      tag == "Figma" ||
      tag == "프로젝트" ||
      tag == "앱") {
    backColor = ColorStyles.labelColorRed10;
    textStyle =
        TextStyles.smallTextBold.copyWith(color: ColorStyles.labelColorRed100);
  } else if (tag == "김희숙교수님" ||
      tag == "장용미교수님" ||
      tag == "전종로교수님" ||
      tag == "백엔드" ||
      tag == "풀스택" ||
      tag == "프론트엔드" ||
      tag == "리눅스" ||
      tag == "SQLD" ||
      tag == "컴활2급") {
    backColor = ColorStyles.labelColorYellow10;
    textStyle = TextStyles.smallTextBold
        .copyWith(color: ColorStyles.labelColorYellow100);
  } else {
    backColor = ColorStyles.gray2;
    textStyle = TextStyles.smallTextBold.copyWith(color: ColorStyles.gray4);
  }

  return Container(
    margin: EdgeInsets.only(right: 8),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: backColor,
      borderRadius: BorderRadius.circular(32),
    ),
    child: Text(
      tag,
      style: textStyle,
    ),
  );
}
