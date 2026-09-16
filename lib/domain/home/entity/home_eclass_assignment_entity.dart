import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';

class HomeEclassUpcomingAssignmentEntity {
  final String courseName;
  final String title;
  final DateTime dueAt;
  final int dDay;
  final bool submitted;

  const HomeEclassUpcomingAssignmentEntity({
    required this.courseName,
    required this.title,
    required this.dueAt,
    required this.dDay,
    required this.submitted,
  });
}

class HomeEclassAssignmentEntity {
  final bool linked;
  final EclassLinkStatus? status;
  final int upcomingCount;
  final List<HomeEclassUpcomingAssignmentEntity> upcoming;
  final HomeEclassUpcomingAssignmentEntity? primaryAssignment;

  const HomeEclassAssignmentEntity({
    required this.linked,
    required this.status,
    required this.upcomingCount,
    required this.upcoming,
    required this.primaryAssignment,
  });

  bool get isUnlinked => !linked;

  bool get isExpired => linked && status == EclassLinkStatus.expired;

  bool get hasAssignments =>
      linked && status == EclassLinkStatus.active && upcomingCount > 0;

  bool get hasNoAssignments =>
      linked && status == EclassLinkStatus.active && upcomingCount == 0;
}
