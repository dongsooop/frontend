import 'dart:async';
import 'dart:convert';
import 'package:dongsoop/core/routing/push_router.dart';
import 'package:dongsoop/core/storage/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

typedef ReadFn = Future<void> Function(int id);
typedef RefreshBadgeFn = Future<void> Function();

class FirebaseMessagingService {
  FirebaseMessagingService._internal();

  // 싱글톤 패턴 적용
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  factory FirebaseMessagingService.instance() => _instance;

  LocalNotificationsService? _localNotificationsService;
  bool _initialized = false;

  ReadFn? _read;
  RefreshBadgeFn? _refreshBadge;

  void setReadCallback(ReadFn read) => _read = read;
  void setBadgeRefreshCallback(RefreshBadgeFn cb) => _refreshBadge = cb;


  Timer? _badgeThrottle;
  void _scheduleBadgeRefresh() {
    final throttled = _badgeThrottle?.isActive == true;
    if (_refreshBadge == null) return;
    if (throttled) return;
    _badgeThrottle = Timer(const Duration(milliseconds: 400), () async {
      try {
        await _refreshBadge!.call();
      } catch (_) {}
    });
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

        if (type != null && value != null) {
          try {
            await PushRouter.routeFromTypeValue(type: type, value: value);
          } catch (_) {}
        }
        if (id != null) {
          try {
            await _read?.call(id);
          } catch (_) {}
        }

        _scheduleBadgeRefresh();
      } catch (_) {}
    };

    // 백그라운드 상태에서 메시지 수신 핸들러
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 포그라운드 상태 메시지 수신 리스터
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // 백그라운드 -> 앱 진입 시 알림 클릭 이벤트 리스너
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // 앱이 완전히 종료된 상태에서 알림 클릭하여 실행된 경우 처리
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onMessageOpenedApp(initialMessage);
      });
    }
  }

  Stream<String> onTokenRefresh() =>
      FirebaseMessaging.instance.onTokenRefresh.distinct();

  // 포그라운드 상태에서 메시지 수신 시
  void _onForegroundMessage(RemoteMessage message) {
    final notificationData = message.notification;
    if (notificationData != null) {
      final payload = jsonEncode(message.data);
      try {
        _localNotificationsService?.showNotification(
          notificationData.title,
          notificationData.body,
          payload,
        );
      } catch (_) {}
    }
    _scheduleBadgeRefresh();
  }
  // 백그라운드 or 종료 상태에서 알림 클릭으로 앱이 열렸을 떄
  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    final type = message.data['type']?.toString();
    final value = message.data['value']?.toString();
    final id = _extractValidId(message.data['id']);

    if (type != null && value != null) {
      try {
        await PushRouter.routeFromTypeValue(type: type, value: value);
      } catch (_) {}
    }

    if (id != null) {
      try {
        await _read?.call(id);
      } catch (_) {}
    }

    _scheduleBadgeRefresh();
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
  print('Background message received: ${message.data.toString()}');
}
