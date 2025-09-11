import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 로컬 알림 서비스 클래스
class LocalNotificationsService {
  // 싱글톤 구현
  LocalNotificationsService._internal();

  static final LocalNotificationsService _instance = LocalNotificationsService._internal();

  factory LocalNotificationsService.instance() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  void Function(String payloadJson)? onTap;

  bool _isFlutterLocalNotificationInitialized = false;

  int _notificationIdCounter = 0;

  // ios 알림 초기화 설정
  final _iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  static const MethodChannel _channel = MethodChannel('app/push');

  Future<void> init() async {
    if (_isFlutterLocalNotificationInitialized) return;

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final initializationSettings = InitializationSettings(
      iOS: _iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          onTap?.call(payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    _isFlutterLocalNotificationInitialized = true;
  }

  // 로컬 알림 표시 메서드
  Future<void> showNotification(
      String? title,
      String? body,
      String? payload,
      ) async {
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      _notificationIdCounter++, // 고유 알림 id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  Future<void> setBadgeCount(int count) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod('setBadge', {'count': count});
    } catch (_) {}
  }

  Future<void> clearBadge() => setBadgeCount(0);

  bool get isInitialized => _isFlutterLocalNotificationInitialized;
}

@pragma('vm:entry-point')
void _notificationTapBackground(NotificationResponse response) {
  try {
    final payload = response.payload;
    if (payload != null) {
      LocalNotificationsService.instance().onTap?.call(payload);
    }
  } catch (e, st) {
    print('[LocalNotifications] _notificationTapBackground error: $e\n$st');
  }
}
