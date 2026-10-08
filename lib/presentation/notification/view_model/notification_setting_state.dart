class NotificationSettingState {
  final Map<String, bool> enabled;
  final Map<String, bool> loading;
  final String? error;

  const NotificationSettingState({
    this.enabled = const {},
    this.loading = const {},
    this.error,
  });

  bool isEnabled(String type) => enabled[type] ?? false;
  bool isLoading(String type) => loading[type] ?? false;

  NotificationSettingState copyWith({
    Map<String, bool>? enabled,
    Map<String, bool>? loading,
    String? error,
  }) {
    return NotificationSettingState(
      enabled: enabled ?? this.enabled,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  NotificationSettingState clearError() => NotificationSettingState(
    enabled: enabled,
    loading: loading,
    error: null,
  );
}
