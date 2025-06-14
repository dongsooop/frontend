import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/repository/calendar_repository.dart';
import 'package:dongsoop/main.dart';

class CalendarUseCase {
  final CalendarRepository repository;

  CalendarUseCase(this.repository);

  Future<List<CalendarListEntity>> execute({
    required int memberId,
    required DateTime currentMonth,
  }) {
    logger.i('[Calendar_List_UseCase] 호출됨');
    return repository.fetchCalendarList(
      memberId: memberId,
      currentMonth: currentMonth,
    );
  }
}
