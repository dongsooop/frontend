import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';
import 'package:dongsoop/domain/calendar/use_cases/calendar_use_case.dart';
import 'package:dongsoop/presentation/calendar/providers/calendar_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_view_model.g.dart';

@riverpod
class CalendarViewModel extends _$CalendarViewModel {
  CalendarUseCase get _useCase => ref.watch(calendarUseCaseProvider);

  @override
  Future<List<CalendarListEntity>> build(
    int memberId,
    DateTime currentMonth,
  ) async {
    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);

    final results = await Future.wait([
      _useCase.execute(memberId: memberId, currentMonth: previousMonth),
      _useCase.execute(memberId: memberId, currentMonth: currentMonth),
      _useCase.execute(memberId: memberId, currentMonth: nextMonth),
    ]);

    final combined = results.expand((r) => r).toList();

    combined.sort((a, b) {
      if (a.type == CalendarType.official && b.type != CalendarType.official) {
        return -1;
      } else if (a.type != CalendarType.official &&
          b.type == CalendarType.official) {
        return 1;
      } else {
        return a.startAt.compareTo(b.startAt);
      }
    });

    return combined;
  }
}
