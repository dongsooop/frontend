import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class PositionedLectureBlock extends StatelessWidget {
  const PositionedLectureBlock({
    super.key,
    required this.lecture,
    required this.firstRowHeight,
    required this.slotHeight,
    required this.dayWidth,
    required this.color,
    this.onTap,
  });

  final Lecture lecture;
  final double firstRowHeight;
  final double slotHeight;
  final double dayWidth;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final start = lecture.startAt.toMinutesFrom9AM();
    final end = lecture.endAt.toMinutesFrom9AM();

    final double top = firstRowHeight + (start / 60.0) * slotHeight;
    final double height = ((end - start) / 60.0) * slotHeight;

    final child = Container(
      width: dayWidth,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lecture.name, style: TextStyles.smallTextBold.copyWith(color: ColorStyles.black)),
          if ((lecture.location ?? '').isNotEmpty)
            Text(lecture.location!, style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black)),
          if ((lecture.professor ?? '').isNotEmpty)
            Text(lecture.professor!, style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black)),
        ],
      ),
    );

    return Positioned(
      top: top,
      left: 0,
      child: onTap == null ? child : GestureDetector(onTap: onTap, child: child),
    );
  }
}