import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 로컬 알림 서비스 클래스
class LocalNotificationsService {
  // 싱글톤 구현
  LocalNotificationsService._internal();

  static final LocalNotificationsService _instance = LocalNotificationsService._internal();

  factory LocalNotificationsService.instance() => _instance;

  late final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

  void Function(String payloadJson)? onTap;

  bool _isFlutterLocalNotificationInitialized = false;

  int _notificationIdCounter = 0;

  // ios 알림 초기화 설정
  static const DarwinInitializationSettings _iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  static const AndroidInitializationSettings _androidInit =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  static const String kAndroidChannelId   = 'channel_id';
  static const String kAndroidChannelName = 'Channel name';
  static const String kAndroidChannelDesc = 'Android push notification channel';

  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    kAndroidChannelId,
    kAndroidChannelName,
    description: kAndroidChannelDesc,
    importance: Importance.max,
  );

  static const MethodChannel _channel = MethodChannel('app/push');

  Future<void> init() async {
    if (_isFlutterLocalNotificationInitialized) return;

    final initSettings = InitializationSettings(
      android: Platform.isAndroid ? _androidInit : null,
      iOS: _iosInit,
    );

    await _fln.initialize(initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          onTap?.call(payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    if (Platform.isAndroid) {
      final androidFln = _fln
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidFln?.requestNotificationsPermission();

      await androidFln?.createNotificationChannel(_androidChannel);
    }

    _isFlutterLocalNotificationInitialized = true;
  }

  // 로컬 알림 표시 메서드
  Future<void> showNotification(
      String? title,
      String? body,
      String? payload,
      ) async {
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      kAndroidChannelId,
      kAndroidChannelName,
      channelDescription: kAndroidChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails details = NotificationDetails(
      iOS: iosDetails,
      android: androidDetails,
    );

    await _fln.show(
      _notificationIdCounter++, // 고유 알림 id,
      title,
      body,
      details,
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