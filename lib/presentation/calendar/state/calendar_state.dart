import 'package:collection/collection.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';

class CalendarState {
  final DateTime focusedMonth;
  final CalendarType tab;
  final List<CalendarListEntity> allEvents;

  const CalendarState({
    required this.focusedMonth,
    required this.tab,
    required this.allEvents,
  });

  CalendarState copyWith({
    DateTime? focusedMonth,
    CalendarType? tab,
    List<CalendarListEntity>? allEvents,
  }) {
    return CalendarState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      tab: tab ?? this.tab,
      allEvents: allEvents ?? this.allEvents,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarState &&
        other.focusedMonth == focusedMonth &&
        other.tab == tab &&
        const ListEquality<CalendarListEntity>().equals(other.allEvents, allEvents);
  }

  @override
  int get hashCode =>
      Object.hash(focusedMonth, tab, const ListEquality<CalendarListEntity>().hash(allEvents));
}