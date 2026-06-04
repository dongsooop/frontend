import 'package:collection/collection.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_list_entity.dart';
import 'package:dongsoop/domain/schedule/enum/schedule_type.dart';

class ScheduleState {
  final DateTime focusedMonth;
  final ScheduleType tab;
  final List<ScheduleListEntity> allEvents;

  const ScheduleState({
    required this.focusedMonth,
    required this.tab,
    required this.allEvents,
  });

  ScheduleState copyWith({
    DateTime? focusedMonth,
    ScheduleType? tab,
    List<ScheduleListEntity>? allEvents,
  }) {
    return ScheduleState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      tab: tab ?? this.tab,
      allEvents: allEvents ?? this.allEvents,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScheduleState &&
        other.focusedMonth == focusedMonth &&
        other.tab == tab &&
        const ListEquality<ScheduleListEntity>().equals(other.allEvents, allEvents);
  }

  @override
  int get hashCode =>
      Object.hash(focusedMonth, tab, const ListEquality<ScheduleListEntity>().hash(allEvents));
}