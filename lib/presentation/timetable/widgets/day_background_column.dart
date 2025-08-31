import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class DayBackgroundColumn extends StatelessWidget {
  const DayBackgroundColumn({
    super.key,
    required this.day,
    required this.columnLength,
    required this.firstRowHeight,
    required this.slotHeight,
    this.children = const <Widget>[],
    this.showLeftDivider = true,
  });

  final WeekDay day;
  final int columnLength;
  final double firstRowHeight;
  final double slotHeight;
  final List<Widget> children;
  final bool showLeftDivider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: firstRowHeight),
              ...List.generate(
                columnLength,
                    (i) => i.isEven
                    ? const Divider(color: ColorStyles.gray2, height: 0)
                    : SizedBox(height: slotHeight),
              ),
            ],
          ),
          // 요일 라벨
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                day.korean,
                style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
              ),
            ),
          ),
          ...children,
          if (showLeftDivider)
            const Positioned(left: 0, top: 0, bottom: 0,
                child: VerticalDivider(color: ColorStyles.gray2, width: 0)),
        ],
      ),
    );
  }
}