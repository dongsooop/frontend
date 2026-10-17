import 'dart:async';

import 'package:dongsoop/domain/auth/enum/session_end_reason.dart';

typedef SessionCleanupAction = FutureOr<void> Function();
typedef SessionEndCallback = void Function(SessionEndReason reason);

class SessionManager {
  SessionManager({
    required SessionCleanupAction disconnectChatSockets,
    required SessionCleanupAction disconnectBlindDateSocket,
    required SessionCleanupAction clearSecureStorage,
    required SessionCleanupAction clearPreferences,
    required SessionEndCallback onSessionEnded,
    required void Function() onSessionActivated,
  })  : _disconnectChatSockets = disconnectChatSockets,
        _disconnectBlindDateSocket = disconnectBlindDateSocket,
        _clearSecureStorage = clearSecureStorage,
        _clearPreferences = clearPreferences,
        _onSessionEnded = onSessionEnded,
        _onSessionActivated = onSessionActivated;

  final SessionCleanupAction _disconnectChatSockets;
  final SessionCleanupAction _disconnectBlindDateSocket;
  final SessionCleanupAction _clearSecureStorage;
  final SessionCleanupAction _clearPreferences;
  final SessionEndCallback _onSessionEnded;
  final void Function() _onSessionActivated;

  Future<void>? _endInFlight;
  SessionEndReason? _pendingReason;
  bool _hasEnded = false;

  Future<void> end(SessionEndReason reason) {
    if (_hasEnded) return Future<void>.value();

    if (reason == SessionEndReason.sanctioned || _pendingReason == null) {
      _pendingReason = reason;
    }

    final inFlight = _endInFlight;
    if (inFlight != null) return inFlight;

    late final Future<void> operation;
    operation = _performEnd().whenComplete(() {
      if (identical(_endInFlight, operation)) {
        _endInFlight = null;
      }
    });
    _endInFlight = operation;
    return operation;
  }

  void activateSession() {
    _hasEnded = false;
    _pendingReason = null;
    _onSessionActivated();
  }

  Future<void> _performEnd() async {
    await _runSafely(_disconnectChatSockets);
    await _runSafely(_disconnectBlindDateSocket);
    await _runSafely(_clearSecureStorage);
    await _runSafely(_clearPreferences);

    final reason = _pendingReason ?? SessionEndReason.expired;
    _hasEnded = true;
    _onSessionEnded(reason);
  }

  Future<void> _runSafely(SessionCleanupAction action) async {
    try {
      await action();
    } catch (_) {
      // 한 정리 작업이 실패해도 나머지 세션 종료 작업은 계속한다.
    }
  }
}
