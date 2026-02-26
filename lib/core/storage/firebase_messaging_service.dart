import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dongsoop/core/routing/push_router.dart';
import 'package:dongsoop/core/storage/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef ReadFn = Future<void> Function(int id);
typedef RefreshBadgeFn = Future<void> Function();
typedef SetBadgeFn = void Function(int badge);

class FirebaseMessagingService {
  FirebaseMessagingService._internal();

  // 싱글톤 패턴 적용
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  factory FirebaseMessagingService.instance() => _instance;

  static const MethodChannel _pushChannel = MethodChannel('app/push');

  LocalNotificationsService? _localNotificationsService;
  bool _initialized = false;

  ReadFn? _read;
  RefreshBadgeFn? _refreshBadge;
  SetBadgeFn? _setBadge;
  Future<void> Function()? _forceLogout;

  int? _pendingReadId;

  String? _activeChatRoomId;
  String? get activeChatRoomId => _activeChatRoomId;

  Future<void> updateNativeBadge(int count) async {
    try {
      await _pushChannel.invokeMethod('setBadge', {'count': count});
      if (kDebugMode) debugPrint('[FMS] Native badge sync success: $count');
    } catch (e) {
      if (kDebugMode) debugPrint('[FMS] Native badge sync failed: $e');
    }
  }

  void setActiveChat(String roomId) {
    if (roomId.isEmpty) return;
    _activeChatRoomId = roomId;
    try { _pushChannel.invokeMethod('setActiveChat', {'roomId': _activeChatRoomId}); } catch (_) {}
  }

  void clearActiveChat() {
    _activeChatRoomId = null;
    try { _pushChannel.invokeMethod('clearActiveChat'); } catch (_) {}
  }

  void setReadCallback(ReadFn read) {
    _read = read;
    if (_pendingReadId != null) {
      if (kDebugMode) debugPrint('🚀 [FMS] Processing pending read ID: $_pendingReadId');
      _read?.call(_pendingReadId!);
      _pendingReadId = null;
    }
  }

  void setBadgeRefreshCallback(RefreshBadgeFn cb) => _refreshBadge = cb;
  void setBadgeCallback(SetBadgeFn cb) => _setBadge = cb;
  void setForceLogoutCallback(Future<void> Function() fn) => _forceLogout = fn;

  Timer? _badgeThrottle;
  void _scheduleBadgeRefresh() {
    if (_refreshBadge == null) return;
    if (_badgeThrottle?.isActive == true) return;
    _badgeThrottle = Timer(const Duration(milliseconds: 400), () async {
      try { await _refreshBadge!.call(); } catch (_) {}
    });
  }

  void _applyBadgeOrRefresh(RemoteMessage message) {
    final dataBadge = int.tryParse(message.data['badge']?.toString() ?? '');
    final apnsBadge = message.notification?.apple?.badge as int?;
    final int? badge = dataBadge ?? apnsBadge;

    if (badge != null) {
      try { _setBadge?.call(badge); } catch (_) { _scheduleBadgeRefresh(); }
    } else {
      _scheduleBadgeRefresh();
    }
  }

  void _applyBadgeFromNative(Map<String, dynamic> userInfo) {
    int? badge;
    final aps = userInfo['aps'];
    if (aps is Map) {
      final b = aps['badge'];
      badge = (b is int) ? b : int.tryParse(b?.toString() ?? '');
    }
    badge ??= int.tryParse(userInfo['badge']?.toString() ?? '');

    if (badge != null) {
      try { _setBadge?.call(badge); } catch (_) { _scheduleBadgeRefresh(); }
    } else {
      _scheduleBadgeRefresh();
    }
  }

  Future<void> _handleForceLogout({required String source}) async {
    try {
      if (_forceLogout != null) {
        await _forceLogout!.call();
      }
      await updateNativeBadge(0);
    } catch (e) {

    }
  }

  Future<void> _handleNativePush(dynamic args, {required bool isTap}) async {
    final map = _normalizeNativeArgs(args);
    if (map == null) return;

    final type = map['type']?.toString().trim().toUpperCase();
    final value = (map['value'] ?? map['roomId'])?.toString().trim() ?? '';

    final id = _extractValidId(map['id'] ?? map['notificationId'] ?? map['gcm.notification.id']);

    if (kDebugMode) debugPrint('🔎 [FMS] Extracted ID: $id (raw: ${map['id']})');

    _applyBadgeFromNative(map);

    if (type == 'FORCE_LOGOUT') {
      await _handleForceLogout(source: isTap ? 'ios:onPushTap' : 'ios:onPush');
      return;
    }

    if (!isTap) return;

    if (id != null) {
      if (_read != null) {
        await _read?.call(id);
      } else {
        _pendingReadId = id;
      }
    }

    try {
      await PushRouter.routeFromTypeValue(
        type: type ?? '',
        value: value,
        fromNotificationList: false,
        isColdStart: false,
      );
    } catch (_) {}
  }

  Future<void> init({required LocalNotificationsService localNotificationsService}) async {
    _localNotificationsService = localNotificationsService;

    // iOS 전용 MethodChannel 핸들러 (중복 등록 방지를 위해 init 시마다 갱신)
    _pushChannel.setMethodCallHandler((call) async {
      if (kDebugMode) debugPrint('[PUSH][DART] method=${call.method}');
      switch (call.method) {
        case 'onPush':
          await _handleNativePush(call.arguments, isTap: false);
          break;
        case 'onPushTap':
          await _handleNativePush(call.arguments, isTap: true);
          break;
      }
    });

    if (_initialized) return;
    _initialized = true;

    _localNotificationsService?.onTap = (payloadJson) async {
      try {
        final map = jsonDecode(payloadJson) as Map<String, dynamic>;
        final type = map['type']?.toString().trim().toUpperCase();
        final value = map['value']?.toString();
        final id = _extractValidId(map['id'] ?? map['notificationId']);
        final payloadBadge = int.tryParse(map['badge']?.toString() ?? '');

        if (type == 'FORCE_LOGOUT') {
          await _handleForceLogout(source: 'localNotificationTap');
          return;
        }

        if (id != null) {
          if (_read != null) {
            await _read?.call(id);
          } else {
            _pendingReadId = id;
          }
        }

        if (type != null && value != null) {
          await PushRouter.routeFromTypeValue(
            type: type,
            value: value,
            fromNotificationList: false,
            isColdStart: false,
          );
        }

        if (payloadBadge != null) {
          try {
            _setBadge?.call(payloadBadge);
            updateNativeBadge(payloadBadge);
          } catch (_) {
            _scheduleBadgeRefresh();
          }
        } else {
          _scheduleBadgeRefresh();
        }
      } catch (_) {}
    };

    // 백그라운드 상태에서 메시지 수신 핸들러
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (Platform.isIOS) {
      debugPrint('[FCM] iOS: Using MethodChannel only (no FlutterFire listeners)');
      return;
    }

    // 포그라운드 상태 메시지
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _onMessageOpenedApp(m));

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onMessageOpenedApp(initialMessage, isColdStart: true);
      });
    }
  }

  // 포그라운드 상태에서 메시지 수신 시
  void _onForegroundMessage(RemoteMessage message) async {
    if (_isBadgeWithDataOnly(message)) {
      _applyBadgeOrRefresh(message);
      return;
    }

    final type = message.data['type']?.toString().trim().toUpperCase();
    final value = (message.data['value'] ?? message.data['roomId'])?.toString();

    if (type == 'FORCE_LOGOUT') {
      await _handleForceLogout(source: 'android:onMessage');
      return;
    }

    final isSameChat = (type == 'CHAT') &&
        (_activeChatRoomId != null && value == _activeChatRoomId);

    _applyBadgeOrRefresh(message);
    if (isSameChat) return;

    if (_isAndroidBadgeReset(message)) return;
    if (_isAndroidEmptyTitleBody(message)) return;

    _localNotificationsService?.showNotification(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      jsonEncode({
        'type': type,
        'value': value,
        'id': message.data['id'],
        'badge': message.data['badge'],
      }),
    );
  }
  // 백그라운드 or 종료 상태에서 알림 클릭으로 앱이 열렸을 떄
  Future<void> _onMessageOpenedApp(
      RemoteMessage message, {
        bool isColdStart = true,
      }) async {
    if (_isBadgeWithDataOnly(message)) {
      _applyBadgeOrRefresh(message);
      return;
    }

    final type = message.data['type']?.toString().trim().toUpperCase();
    final value = message.data['value']?.toString();
    final id = _extractValidId(message.data['id'] ?? message.data['notificationId']);

    if (type == 'FORCE_LOGOUT') {
      await _handleForceLogout(source: 'android:onMessageOpenedApp');
      return;
    }

    if (id != null) {
      if (_read != null) {
        await _read?.call(id);
      } else {
        _pendingReadId = id;
      }
    }

    if (type != null && value != null) {
      try {
        await PushRouter.routeFromTypeValue(
          type: type,
          value: value,
          fromNotificationList: true,
          isColdStart: isColdStart,
        );
      } catch (_) {}
    }

    _applyBadgeOrRefresh(message);
  }

  Map<String, dynamic>? _normalizeNativeArgs(dynamic args) {
    if (args is Map) {
      return args.entries.fold<Map<String, dynamic>>({}, (prev, e) {
        prev[e.key.toString()] = e.value;
        return prev;
      });
    }
    return null;
  }

  bool _isBadgeWithDataOnly(RemoteMessage m) => m.notification == null && m.data.containsKey('badge');
  bool _isAndroidBadgeReset(RemoteMessage m) => Platform.isAndroid && m.notification == null && (m.data['badge'] == '0' || m.data['badge'] == 0);
  bool _isAndroidEmptyTitleBody(RemoteMessage m) => Platform.isAndroid && (m.notification?.title ?? '').trim().isEmpty && (m.notification?.body ?? '').trim().isEmpty;

  int? _extractValidId(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) return raw > 0 ? raw : null;
    if (raw is String) {
      final v = int.tryParse(raw);
      return (v == null || v <= 0) ? null : v;
    }
    final s = raw.toString();
    final v = int.tryParse(s);
    return (v == null || v <= 0) ? null : v;
  }

  Stream<String> onTokenRefresh() => FirebaseMessaging.instance.onTokenRefresh.distinct();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) debugPrint('Background message received: ${message.data}');
}