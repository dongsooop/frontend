import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dongsoop/core/routing/push_router.dart';
import 'package:dongsoop/core/storage/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef ReadFn = Future<void> Function(int id);
typedef RefreshBadgeFn = Future<void> Function();
typedef SetBadgeFn = void Function(int badge);
typedef OnPushSyncFn = Future<void> Function(Map<String, dynamic> data);

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

  String? _activeChatRoomId;
  String? get activeChatRoomId => _activeChatRoomId;

  void setActiveChat(String roomId) {
    if (roomId.isEmpty) return;
    _activeChatRoomId = roomId;
    try { _pushChannel.invokeMethod('setActiveChat', {'roomId': _activeChatRoomId}); } catch (_) {}
  }

  void clearActiveChat() {
    _activeChatRoomId = null;
    try { _pushChannel.invokeMethod('clearActiveChat'); } catch (_) {}
  }

  void setReadCallback(ReadFn read) => _read = read;
  void setBadgeRefreshCallback(RefreshBadgeFn cb) => _refreshBadge = cb;
  void setBadgeCallback(SetBadgeFn cb) => _setBadge = cb;

  Timer? _badgeThrottle;
  void _scheduleBadgeRefresh() {
    if (_refreshBadge == null) return;
    if (_badgeThrottle?.isActive == true) return;
    _badgeThrottle = Timer(const Duration(milliseconds: 400), () async {
      try {
        await _refreshBadge!.call();
      } catch (_) {}
    });
  }

  void _applyBadgeOrRefresh(RemoteMessage message) {
    final dataBadge = int.tryParse(message.data['badge']?.toString() ?? '');
    final apnsBadge = message.notification?.apple?.badge as int?;
    final int? badge = dataBadge ?? apnsBadge;

    if (badge != null) {
      try {
        _setBadge?.call(badge);
      } catch (_) {
        _scheduleBadgeRefresh();
      }
    } else {
      _scheduleBadgeRefresh();
    }
  }

  bool _isAndroidBadgeReset(RemoteMessage m) {
    if (!Platform.isAndroid) return false;
    final b = m.data['badge'];
    return m.notification == null && (b == '0' || b == 0);
  }

  bool _isAndroidEmptyTitleBody(RemoteMessage m) {
    if (!Platform.isAndroid) return false;
    final t = (m.notification?.title ?? '').trim();
    final b = (m.notification?.body ?? '').trim();
    return t.isEmpty && b.isEmpty;
  }

  Future<void> init({required LocalNotificationsService localNotificationsService}) async {
    if (_initialized) return;
    _initialized = true;

    _localNotificationsService = localNotificationsService;

    // 로컬 알림 탭 시 라우팅 처리
    _localNotificationsService?.onTap = (payloadJson) async {
      try {
        final map = jsonDecode(payloadJson) as Map<String, dynamic>;
        final type = map['type']?.toString();
        final value = map['value']?.toString();
        final id = _extractValidId(map['id']);
        final payloadBadge = int.tryParse(map['badge']?.toString() ?? '');

        if (type != null && value != null) {
          try {
            await PushRouter.routeFromTypeValue(
              type: type,
              value: value,
              fromNotificationList: false,
              isColdStart: false,
            );
          } catch (_) {}
        }
        if (id != null) {
          try {
            await _read?.call(id);
          } catch (_) {}
        }

        if (payloadBadge != null) {
          try {
            _setBadge?.call(payloadBadge);
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

    // 백그라운드 -> 앱 진입 시 알림 클릭 이벤트 리스너
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _onMessageOpenedApp(message);
    });

    // 앱이 완전히 종료된 상태에서 알림 클릭하여 실행된 경우 처리
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onMessageOpenedApp(
          initialMessage,
          isColdStart: true,
        );
      });
    }
  }

  Stream<String> onTokenRefresh() =>
      FirebaseMessaging.instance.onTokenRefresh.distinct();

  bool _isBadgeWithDataOnly(RemoteMessage m) {
    if (m.notification != null) return false;
    return m.data.containsKey('badge');
  }

  // 포그라운드 상태에서 메시지 수신 시
  void _onForegroundMessage(RemoteMessage message) {
    if (_isBadgeWithDataOnly(message)) {
      _applyBadgeOrRefresh(message);
      return;
    }

    final type = message.data['type']?.toString();
    final value = (message.data['value'] ?? message.data['roomId'])?.toString();

    final isSameChat = (type != null && type == 'CHAT') &&
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

    final type = message.data['type']?.toString();
    final value = message.data['value']?.toString();
    final id = _extractValidId(message.data['id']);

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

    if (id != null) {
      try {
        await _read?.call(id);
      } catch (_) {}
    }

    _applyBadgeOrRefresh(message);
  }

  int? _extractValidId(dynamic raw) {
    final s = raw?.toString();
    if (s == null) return null;
    final v = int.tryParse(s);
    if (v == null || v <= 0) return null;
    return v;
  }
}

// 백그라운드 상태에서 메시지를 수신했을 때 실행되는 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification == null && message.data.containsKey('badge')) {
  return;
  }
  print('Background message received: ${message.data.toString()}');
}
