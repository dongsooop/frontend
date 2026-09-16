import 'package:dongsoop/domain/eclass/entity/eclass_assignment_entity.dart';
import 'package:dongsoop/presentation/eclass/assignment/eclass_assignment_formatters.dart';
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
    final badgeColors = eclassDDayColors(assignment.dDay);

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
}
