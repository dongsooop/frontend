import 'package:dongsoop/providers/os_notification_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OsNotificationState {
  final bool? isAllowed;
  final bool isLoading;
  OsNotificationState({this.isAllowed, this.isLoading = false});

  OsNotificationState copyWith({bool? isAllowed, bool? isLoading}) =>
    OsNotificationState(
      isAllowed: isAllowed ?? this.isAllowed,
      isLoading: isLoading ?? this.isLoading,
    );
}

class OsNotificationViewModel extends StateNotifier<OsNotificationState> {
  final Ref _ref;
  OsNotificationViewModel(this._ref)
      : super(OsNotificationState(isAllowed: null, isLoading: false));

  Future<void> loadPermissionStatus() async {
    state = state.copyWith(isLoading: true);
    final allowed = await _ref.read(getOsAllowedUseCaseProvider).execute();
    state = state.copyWith(isAllowed: allowed, isLoading: false);
  }

  Future<void> turnOn() async {
    state = state.copyWith(isLoading: true);
    final granted = await _ref.read(requestOsPermissionUseCaseProvider).execute();
    state = state.copyWith(isAllowed: granted, isLoading: false);
  }

  Future<void> openSettings() async {
    await _ref.read(openOsSettingsUseCaseProvider).execute();
  }
}