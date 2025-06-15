import 'package:dongsoop/domain/calendar/use_cases/calendar_delete_use_case.dart';
import 'package:dongsoop/presentation/calendar/providers/calendar_use_case_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_delete_view_model.g.dart';

class CalendarDeleteState {
  final bool isLoading;
  final String? error;

  CalendarDeleteState({this.isLoading = false, this.error});

  CalendarDeleteState copyWith({bool? isLoading, String? error}) {
    return CalendarDeleteState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class CalendarDeleteViewModel extends _$CalendarDeleteViewModel {
  CalendarDeleteUseCase get _useCase =>
      ref.watch(calendarDeleteUseCaseProvider);

  @override
  CalendarDeleteState build() => CalendarDeleteState();

  Future<void> delete({required int calendarId}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      await _useCase.execute(calendarId: calendarId);
    } catch (e) {
      debugPrint('[Delete Error] $e');
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
