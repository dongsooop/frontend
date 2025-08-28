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

    final nameStyle = TextStyles.smallTextBold.copyWith(
      color: ColorStyles.black,
      height: 1.2,
    );
    final subStyle = TextStyles.smallTextRegular.copyWith(
      color: ColorStyles.black,
      height: 1.2,
    );

    // 한 줄 높이(px) 계산
    final double nameLinePx = (nameStyle.fontSize ?? 12) * (nameStyle.height ?? 1.2);
    final double subLinePx  = (subStyle.fontSize  ?? 12) * (subStyle.height  ?? 1.2);

    // 패딩(상하 4 + 4) 제외한 실제 표시 가능 높이
    double availablePx = height - 8.0;
    if (availablePx < nameLinePx) {
      availablePx = nameLinePx;
    }

    bool hasLocation = (lecture.location ?? '').isNotEmpty;
    bool hasProfessor = (lecture.professor ?? '').isNotEmpty;

    // 하위 정보 1줄씩 먼저 예약, 공간 모자라면 하위 정보부터 숨김
    double neededSubs = (hasLocation ? subLinePx : 0) + (hasProfessor ? subLinePx : 0);
    // 제목 최소 1줄 확보 필요
    if (availablePx - neededSubs < nameLinePx) {
      if (hasProfessor) {
        hasProfessor = false;
        neededSubs -= subLinePx;
      }
      if (availablePx - neededSubs < nameLinePx && hasLocation) {
        hasLocation = false;
        neededSubs -= subLinePx;
      }
    }

    final double remainingForName = (availablePx - neededSubs).clamp(nameLinePx, availablePx);
    final int maxNameLines = remainingForName ~/ nameLinePx > 0
        ? remainingForName ~/ nameLinePx
        : 1;

    final child = Container(
      width: dayWidth,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
      // 1~2px 반올림 오차로 인한 overflow 방지
      child: ClipRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lecture.name,
              style: nameStyle,
              maxLines: maxNameLines,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),

            if (hasLocation)
              Text(
                lecture.location!,
                style: subStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            if (hasProfessor)
              Text(
                lecture.professor!,
                style: subStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
          ],
        ),
      ),
    );

    return Positioned(
      top: top,
      left: 0,
      child: onTap == null ? child : GestureDetector(onTap: onTap, child: child),
    );
  }
}