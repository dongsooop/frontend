import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

class CalculatorGpaButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: ColorStyles.gray2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '학점 계산기',
                style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  // 학점 계산기 세부 페이지 이동
                },
                icon: Icon(
                  Icons.mode_edit_outlined,
                  size: 24,
                  color: ColorStyles.gray4,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              Text(
                '평균 학점',
                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '4.43',
                      style: TextStyles.normalTextBold.copyWith(color: ColorStyles.primaryColor),
                    ),
                    TextSpan(
                      text: ' / 4.5',
                      style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                    ),
                  ]
                ),
              ),
              SizedBox(width: 40,),
              Text(
                '취득 학점',
                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '98',
                      style: TextStyles.normalTextBold.copyWith(color: ColorStyles.primaryColor),
                    ),
                    TextSpan(
                      text: ' / 120',
                      style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                    ),
                  ]
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}