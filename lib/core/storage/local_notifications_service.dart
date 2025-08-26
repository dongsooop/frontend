import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 로컬 알림 서비스 클래스
class LocalNotificationsService {
  // 싱글톤 구현
  LocalNotificationsService._internal();

  static final LocalNotificationsService _instance = LocalNotificationsService._internal();

  factory LocalNotificationsService.instance() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // ios 알림 초기화 설정
  final _iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // 초기화 여부 플래그
  bool _isFlutterLocalNotificationInitialized = false;

  // 각 알림에 부여할 id
  int _notificationIdCounter = 0;

  // 로컬 알림 서비스 초기화 메서드
  Future<void> init() async {
    if (_isFlutterLocalNotificationInitialized) {
      return;
    }
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final initializationSettings = InitializationSettings(
      iOS: _iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          print('Foreground notification has been tapped: ${response.payload}');
        });

    _isFlutterLocalNotificationInitialized = true;
  }

  // 로컬 알림 표시 메서드
  Future<void> showNotification(
      String? title,
      String? body,
      String? payload,
      ) async {
    // ios 알림 세부 설정(기본 값 사용)
    const iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      _notificationIdCounter++, // 고유 알림 id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}