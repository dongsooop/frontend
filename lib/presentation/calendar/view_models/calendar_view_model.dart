import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';
import 'package:dongsoop/domain/calendar/use_cases/calendar_use_case.dart';
import 'package:dongsoop/presentation/calendar/providers/calendar_use_case_provider.dart';
import 'package:dongsoop/presentation/calendar/state/calendar_state.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_view_model.g.dart';

@riverpod
class CalendarViewModel extends _$CalendarViewModel {
  CalendarUseCase get _useCase => ref.watch(calendarUseCaseProvider);

  @override
  Future<CalendarState> build() async {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);

    final isLoggedIn = ref.watch(userSessionProvider) != null;
    final initialTab = isLoggedIn ? CalendarType.member : CalendarType.official;
    final memberType = isLoggedIn ? MemberType.member : MemberType.guest;

    final all = await _fetchMonth(firstOfMonth, memberType: memberType);
    return CalendarState(
      focusedMonth: firstOfMonth,
      tab: initialTab,
      allEvents: all,
    );
  }

  void setTab(CalendarType tab) {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.tab == tab) return;

    final isLoggedIn = ref.read(userSessionProvider) != null;
    if (!isLoggedIn && tab == CalendarType.member) return;

    state = AsyncData(currentState.copyWith(tab: tab));
  }

  Future<void> goToPreviousMonth() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final prev = DateTime(currentState.focusedMonth.year, currentState.focusedMonth.month - 1, 1);
    await _loadMonth(prev);
  }

  Future<void> goToNextMonth() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final next = DateTime(currentState.focusedMonth.year, currentState.focusedMonth.month + 1, 1);
    await _loadMonth(next);
  }

  Future<void> jumpToMonth(DateTime month) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final target = DateTime(month.year, month.month, 1);
    if (_sameMonth(currentState.focusedMonth, target)) return;

    await _loadMonth(target);
  }

  Future<void> refresh() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    await _loadMonth(currentState.focusedMonth);
  }

  Future<void> _loadMonth(DateTime month) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    state = const AsyncLoading();

    final isLoggedIn = ref.read(userSessionProvider) != null;
    final memberType = isLoggedIn ? MemberType.member : MemberType.guest;

    final all = await _useCase.execute(
      currentMonth: month,
      type: memberType,
    );

    state = AsyncData(currentState.copyWith(focusedMonth: month, allEvents: all));
  }

  Future<List<CalendarListEntity>> _fetchMonth(
      DateTime month, {
        required MemberType memberType,
      }) async {
    return _useCase.execute(
      currentMonth: month,
      type: memberType,
    );
  }

  static bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}