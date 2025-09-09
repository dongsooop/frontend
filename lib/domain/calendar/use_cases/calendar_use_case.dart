import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/repository/calendar_repository.dart';

enum MemberType { member, guest }

class CalendarUseCase {
  final CalendarRepository repository;

  CalendarUseCase(this.repository);

  Future<List<CalendarListEntity>> execute({
    required DateTime currentMonth,
    required MemberType type,
  }) async {
    final month = DateTime(currentMonth.year, currentMonth.month, 1);
    switch (type) {
      case MemberType.member:
        return repository.fetchCalendarList(currentMonth: month);
      case MemberType.guest:
        return repository.fetchGuestCalendar(currentMonth: month);
    }
  }
}
