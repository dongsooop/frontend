import 'package:dongsoop/domain/eclass/entity/eclass_assignment_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class EclassAssignmentCard extends StatelessWidget {
  final EclassAssignmentEntity assignment;
  final VoidCallback onTap;

  const EclassAssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColors = _badgeColors(assignment.dDay);

    return Material(
      color: ColorStyles.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        key: Key('eclass-assignment-${assignment.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formatEclassDDay(assignment.dDay),
                  style: TextStyles.normalTextBold.copyWith(
                    color: badgeColors.foreground,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.courseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.gray4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assignment.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatEclassDueAt(
                        assignment.dueAt,
                        assignment.dDay,
                      ),
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.gray6,
                      ),
                    ),
                    if (_shouldShowCutoff(assignment)) ...[
                      const SizedBox(height: 3),
                      Text(
                        '지각 제출: ${formatEclassDateTime(assignment.cutoffAt!)}까지',
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.gray4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                size: 22,
                color: ColorStyles.gray4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowCutoff(EclassAssignmentEntity assignment) {
    final cutoffAt = assignment.cutoffAt;
    return cutoffAt != null && cutoffAt != assignment.dueAt;
  }

  ({Color background, Color foreground}) _badgeColors(int dDay) {
    if (dDay <= 0) {
      return (
        background: ColorStyles.warning10,
        foreground: ColorStyles.warning100,
      );
    }
    if (dDay == 1) {
      return (
        background: ColorStyles.labelColorYellow10,
        foreground: ColorStyles.labelColorYellow100,
      );
    }
    return (
      background: ColorStyles.primary5,
      foreground: ColorStyles.primary100,
    );
  }
}

String formatEclassDDay(int dDay) {
  if (dDay <= 0) return 'D-DAY';
  return 'D-$dDay';
}

String formatEclassDueAt(DateTime value, int dDay) {
  final time = _formatTime(value);
  if (dDay == 0) return '오늘 $time 마감';
  if (dDay == 1) return '내일 $time 마감';
  return '${value.month}월 ${value.day}일 (${_weekday(value)}) $time 마감';
}

String formatEclassDateTime(DateTime value) {
  return '${value.month}월 ${value.day}일 ${_formatTime(value)}';
}

String _formatTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _weekday(DateTime value) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return weekdays[value.weekday - 1];
}
