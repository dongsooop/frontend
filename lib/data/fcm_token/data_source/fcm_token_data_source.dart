import 'package:flutter/foundation.dart' show debugPrint;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';

class FcmTokenDataSource {
  FcmTokenDataSource(this._storage);

  final SecureStorageService _storage;
  final FirebaseMessaging _fm = FirebaseMessaging.instance;

  static const _kFcmToken = 'fcmToken';

  String? _cached;

  // 초기 토큰 1회 조회 및 변경 시 저장
  Future<void> init() async {
    final t = await _fm.getToken();
    debugPrint('[FCM] init.getToken = $t');
    if (t != null && t != _cached) {
      _cached = t;
      await _storage.write(_kFcmToken, t);
      debugPrint('[FCM] saved initial token');
    }

    _fm.onTokenRefresh.listen((t) async {
      if (t == _cached) return; // 중복 방지
      _cached = t;
      await _storage.write(_kFcmToken, t);
      debugPrint('[FCM] onTokenRefresh -> $t (saved)');
    }, onError: (e) {
      debugPrint('[FCM] onTokenRefresh error: $e');
    });
  }

  // 최신 토큰 반환(캐시 → getToken → 저장본 순)
  Future<String?> currentToken() async {
    if (_cached != null) {
      debugPrint('[FCM] currentToken -> cached $_cached');
      return _cached;
    }

    final t = await _fm.getToken();
    if (t != null) {
      if (t != _cached) {
        _cached = t;
        await _storage.write(_kFcmToken, t);
        debugPrint('[FCM] currentToken -> getToken $t (saved)');
      }
      return t;
    }

    final stored = await _storage.read(_kFcmToken);
    _cached = stored;
    debugPrint('[FCM] currentToken -> stored $stored');
    return stored;
  }

  /// 초기 토큰 1회 방출 + 이후 갱신을 이어서 제공
  Stream<String> tokenStreamWithInitial() async* {
    final t = await currentToken();
    if (t != null) yield t;
    yield* _fm.onTokenRefresh.distinct(); // 동일 토큰 중복 방출 방지
  }
}
