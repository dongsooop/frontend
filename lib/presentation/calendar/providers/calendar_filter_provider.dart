import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_view_model.dart';
import 'package:dongsoop/presentation/calendar/util/calendar_utils.dart';
import 'package:dongsoop/presentation/calendar/util/calendar_date_utils.dart';

final filterProvider = Provider.autoDispose<List<CalendarListEntity>>((ref) {
  final asyncState = ref.watch(calendarViewModelProvider);

  return asyncState.maybeWhen(
    data: (state) {
      final month = state.focusedMonth;
      final tab = state.tab;
      final all = state.allEvents;

      List<CalendarListEntity> sortAndDedup(List<CalendarListEntity> events) {
        return deduplicateEvents(events)
          ..sort((a, b) {
            final c = a.startAt.compareTo(b.startAt);
            return c != 0 ? c : a.title.compareTo(b.title);
          });
      }

      if (tab == CalendarType.member) {
        final gridStart = sundayWeekStart(month);
        final gridEndEx = sundayWeekStart(
          DateTime(month.year, month.month + 1, 1).add(const Duration(days: 7)),
        );

        final filtered = all.where((e) {
          if (e.type != CalendarType.member) return false;
          return dateRangesOverlap(
            rangeAStart: e.startAt,
            rangeAEndInclusive: e.endAt,
            rangeBStart: gridStart,
            rangeBEndExclusive: gridEndEx,
          );
        }).toList();

        return sortAndDedup(filtered);
      } else {
        final official = all.where((e) => e.type == CalendarType.official).toList();
        final inMonth = eventsInMonth(official, month, onlyStartsInMonth: true);
        return sortAndDedup(inMonth);
      }
    },
    orElse: () => const [],
  );
});