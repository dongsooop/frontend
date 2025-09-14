import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_list_entity.dart';
import 'package:dongsoop/domain/schedule/enum/schedule_type.dart';
import 'package:dongsoop/presentation/schedule/view_models/schedule_view_model.dart';
import 'package:dongsoop/presentation/schedule/util/schedule_utils.dart';
import 'package:dongsoop/presentation/schedule/util/schedule_date_utils.dart';

final filterProvider = Provider.autoDispose<List<ScheduleListEntity>>((ref) {
  final asyncState = ref.watch(scheduleViewModelProvider);

  return asyncState.maybeWhen(
    data: (state) {
      final month = state.focusedMonth;
      final tab = state.tab;
      final all = state.allEvents;

      List<ScheduleListEntity> sortAndDedup(List<ScheduleListEntity> events) {
        return deduplicateEvents(events)
          ..sort((a, b) {
            final c = a.startAt.compareTo(b.startAt);
            return c != 0 ? c : a.title.compareTo(b.title);
          });
      }

      if (tab == ScheduleType.member) {
        final gridStart = sundayWeekStart(month);
        final gridEndEx = sundayWeekStart(
          DateTime(month.year, month.month + 1, 1).add(const Duration(days: 7)),
        );

        final filtered = all.where((e) {
          if (e.type != ScheduleType.member) return false;
          return dateRangesOverlap(
            rangeAStart: e.startAt,
            rangeAEndInclusive: e.endAt,
            rangeBStart: gridStart,
            rangeBEndExclusive: gridEndEx,
          );
        }).toList();

        return sortAndDedup(filtered);
      } else {
        final official = all.where((e) => e.type == ScheduleType.official).toList();
        final inMonth = eventsInMonth(official, month, onlyStartsInMonth: true);
        return sortAndDedup(inMonth);
      }
    },
    orElse: () => const [],
  );
});