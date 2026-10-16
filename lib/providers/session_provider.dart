import 'package:dongsoop/core/session/session_manager.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/auth/enum/session_end_reason.dart';
import 'package:dongsoop/providers/realtime_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionEndReasonProvider =
    StateProvider<SessionEndReason?>((ref) => null);

final sessionManagerProvider = Provider<SessionManager>((ref) {
  final stompService = ref.watch(stompServiceProvider);
  final blindDateStompService = ref.watch(blindDateStompServiceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final preferences = ref.watch(preferencesProvider);

  return SessionManager(
    disconnectChatSockets: stompService.disconnectAll,
    disconnectBlindDateSocket: blindDateStompService.disconnect,
    clearSecureStorage: secureStorage.delete,
    clearPreferences: preferences.clearUser,
    onSessionEnded: (reason) {
      ref.read(sessionEndReasonProvider.notifier).state = reason;
    },
    onSessionActivated: () {
      ref.read(sessionEndReasonProvider.notifier).state = null;
    },
  );
});
