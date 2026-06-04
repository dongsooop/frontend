import 'dart:async';
import 'package:dongsoop/data/device_token/data_source/fcm_token_data_source.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';

class FcmTokenDataSourceImpl implements FcmTokenDataSource {
  FcmTokenDataSourceImpl(this._storage);

  final SecureStorageService _storage;
  final FirebaseMessaging _fm = FirebaseMessaging.instance;

  static const _fcmToken = 'fcmToken';

  String? _cached;
  bool _initialized = false;
  StreamSubscription<String>? _sub;

  @override
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final token = await _fm.getToken();
      if (token != null && token.isNotEmpty && token != _cached) {
        _cached = token;
        await _storage.write(_fcmToken, token);
      }
    } catch (_) {}

    _sub = _fm.onTokenRefresh.distinct().listen((token) async {
      if (token.isEmpty || token == _cached) return;
      _cached = token;
      await _storage.write(_fcmToken, token);
    }, onError: (_) {});
  }

  @override
  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _initialized = false;
  }

  @override
  Future<bool> hasPermission() async {
    final settings = await _fm.getNotificationSettings();
    final authStatus = settings.authorizationStatus;
    return authStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<bool> requestPermissionIfNeeded() async {
    final settings = await _fm.getNotificationSettings();
    var authStatus = settings.authorizationStatus;

    if (authStatus == AuthorizationStatus.notDetermined) {
      final result = await _fm.requestPermission(alert: true, badge: true, sound: true);
      authStatus = result.authorizationStatus;
    }

    return authStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<String?> currentToken() async {
    if (_cached != null && _cached!.isNotEmpty) {
      return _cached;
    }

    try {
      final token = await _fm.getToken();
      if (token != null && token.isNotEmpty) {
        if (token != _cached) {
          _cached = token;
          await _storage.write(_fcmToken, token);
        }
        return token;
      }
    } catch (_) {}

    final stored = await _storage.read(_fcmToken);
    _cached = stored;
    return stored;
  }

  @override
  Stream<String> tokenStreamWithInitial() async* {
    final token = await currentToken();
    if (token != null && token.isNotEmpty) yield token;
    yield* _fm.onTokenRefresh.distinct();
  }
}
