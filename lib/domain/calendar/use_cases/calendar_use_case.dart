import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/repository/calendar_repository.dart';

class CalendarUseCase {
  final CalendarRepository repository;

  CalendarUseCase(this.repository);

  Future<List<CalendarListEntity>> execute({
    required int memberId,
    required DateTime currentMonth,
  }) {
    return repository.fetchCalendarList(
      memberId: memberId,
      currentMonth: currentMonth,
    );
  }
}
