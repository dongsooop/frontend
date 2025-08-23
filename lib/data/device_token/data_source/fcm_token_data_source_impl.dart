import 'dart:async';
import 'package:dongsoop/data/device_token/data_source/fcm_token_data_source.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';

class FcmTokenDataSourceImpl implements FcmTokenDataSource {
  FcmTokenDataSourceImpl(this._storage);

  final SecureStorageService _storage;
  final FirebaseMessaging _fm = FirebaseMessaging.instance;

  static const _kFcmToken = 'fcmToken';

  String? _cached;
  bool _initialized = false;
  StreamSubscription<String>? _sub;

  @override
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final token = await _fm.getToken();
      debugPrint('[FCM] init.getToken = $token');
      if (token != null && token.isNotEmpty && token != _cached) {
        _cached = token;
        await _storage.write(_kFcmToken, token);
        debugPrint('[FCM] saved initial token');
      }
    } catch (e) {
      debugPrint('[FCM] init.getToken error: $e');
    }

    _sub = _fm.onTokenRefresh.distinct().listen((token) async {
      if (token.isEmpty || token == _cached) return;
      _cached = token;
      await _storage.write(_kFcmToken, token);
      debugPrint('[FCM] onTokenRefresh -> $token (saved)');
    }, onError: (e) {
      debugPrint('[FCM] onTokenRefresh error: $e');
    });
  }

  @override
  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _initialized = false;
  }

  @override
  Future<String?> currentToken() async {
    if (_cached != null && _cached!.isNotEmpty) {
      debugPrint('[FCM] currentToken -> cached $_cached');
      return _cached;
    }

    try {
      final token = await _fm.getToken();
      if (token != null && token.isNotEmpty) {
        if (token != _cached) {
          _cached = token;
          await _storage.write(_kFcmToken, token);
          debugPrint('[FCM] currentToken -> getToken $token (saved)');
        }
        return token;
      }
    } catch (e) {
      debugPrint('[FCM] currentToken.getToken error: $e');
    }

    final stored = await _storage.read(_kFcmToken);
    _cached = stored;
    debugPrint('[FCM] currentToken -> stored $stored');
    return stored;
  }

  @override
  Stream<String> tokenStreamWithInitial() async* {
    final token = await currentToken();
    if (token != null && token.isNotEmpty) yield token;
    yield* _fm.onTokenRefresh.distinct();
  }
}
