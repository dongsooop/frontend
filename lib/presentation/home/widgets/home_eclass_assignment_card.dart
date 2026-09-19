import 'package:dongsoop/domain/home/entity/home_eclass_assignment_entity.dart';
import 'package:dongsoop/presentation/eclass/assignment/eclass_assignment_formatters.dart';
import 'package:dongsoop/presentation/eclass/assignment/widget/eclass_submission_badge.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class HomeEclassAssignmentCard extends StatelessWidget {
  final HomeEclassAssignmentEntity assignment;
  final VoidCallback onTap;

  const HomeEclassAssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorStyles.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: ColorStyles.primary100.withValues(alpha: 0.11),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF21395C).withValues(alpha: 0.09),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: const Key('home-eclass-assignment-card'),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '과제',
                          style: TextStyles.largeTextBold.copyWith(
                            color: ColorStyles.black,
                          ),
                        ),
                      ),
                      if (assignment.hasAssignments) ...[
                        Text(
                          '${assignment.assignmentCount}건',
                          key: const Key('home-eclass-assignment-count'),
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray4,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: ColorStyles.gray5,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (assignment.isUnlinked) {
      return const _HomeEclassMessage(
        message: '이클래스를 연동하면 과제 마감을 챙겨드려요',
        action: '이클래스 연동하기',
      );
    }
    if (assignment.isExpired) {
      return const _HomeEclassMessage(
        message: '연동이 끊겨 과제를 가져오지 못했어요',
        action: '다시 연동하기',
        isWarning: true,
      );
    }
    if (assignment.hasNoAssignments) {
      return Text(
        '제출할 과제가 없어요',
        key: const Key('home-eclass-assignment-empty'),
        style: TextStyles.normalTextRegular.copyWith(
          color: ColorStyles.gray6,
        ),
      );
    }

    final primaryAssignment = assignment.primaryAssignment;
    if (primaryAssignment == null) {
      return Text(
        '남은 과제 ${assignment.upcomingCount}개',
        style: TextStyles.normalTextRegular.copyWith(
          color: ColorStyles.gray6,
        ),
      );
    }

    return _HomeEclassAssignmentSummary(assignment: primaryAssignment);
  }
}

class _HomeEclassAssignmentSummary extends StatelessWidget {
  final HomeEclassUpcomingAssignmentEntity assignment;

  const _HomeEclassAssignmentSummary({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final badgeColors = eclassDDayColors(assignment.dDay);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 52),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: badgeColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            formatEclassDDay(assignment.dDay),
            key: const Key('home-eclass-assignment-dday'),
            style: TextStyles.smallTextBold.copyWith(
              color: badgeColors.foreground,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatEclassDueAt(assignment.dueAt, assignment.dDay),
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.gray4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              EclassSubmissionBadge(
                submitted: assignment.submitted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeEclassMessage extends StatelessWidget {
  final String message;
  final String action;
  final bool isWarning;

  const _HomeEclassMessage({
    required this.message,
    required this.action,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          key: Key(
            isWarning
                ? 'home-eclass-assignment-expired'
                : 'home-eclass-assignment-unlinked',
          ),
          style: TextStyles.normalTextRegular.copyWith(
            color: isWarning ? ColorStyles.warning100 : ColorStyles.gray6,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              action,
              style: TextStyles.smallTextBold.copyWith(
                color: ColorStyles.primary100,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: ColorStyles.primary100,
            ),
          ],
        ),
      ],
    );
  }
}
