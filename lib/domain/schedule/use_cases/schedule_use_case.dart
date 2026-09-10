import 'package:dongsoop/domain/schedule/entities/schedule_list_entity.dart';
import 'package:dongsoop/domain/schedule/repository/schedule_repository.dart';

enum MemberType { member, guest }

class ScheduleUseCase {
  final ScheduleRepository repository;

  ScheduleUseCase(this.repository);

  Future<List<ScheduleListEntity>> execute({
    required DateTime currentMonth,
    required MemberType type,
  }) async {
    final month = DateTime(currentMonth.year, currentMonth.month, 1);
    switch (type) {
      case MemberType.member:
        final results = await Future.wait([
          repository.fetchScheduleList(currentMonth: month),
          repository.fetchGuestSchedule(currentMonth: month),
        ]);
        return [...results[0], ...results[1]];
      case MemberType.guest:
        return repository.fetchGuestSchedule(currentMonth: month);
    }
  }
}
