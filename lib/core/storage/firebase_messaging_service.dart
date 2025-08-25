import 'dart:async';
import 'package:dongsoop/core/storage/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._internal();

  // 싱글톤 패턴 적용
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  factory FirebaseMessagingService.instance() => _instance;

  LocalNotificationsService? _localNotificationsService;
  bool _initialized = false;

  // FCM 초기화 메서드
  Future<void> init({required LocalNotificationsService localNotificationsService}) async {
    if (_initialized) return;
    _initialized = true;

    _localNotificationsService = localNotificationsService;

    // 백그라운드 상태에서 메시지 수신 핸들러
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 포그라운드 상태 메시지 수신 리스터
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // 백그라운드 -> 앱 진입 시 알림 클릭 이벤트 리스너
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // 앱이 완전히 종료된 상태에서 알림 클릭하여 실행된 경우 처리
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  Stream<String> onTokenRefresh() =>
      FirebaseMessaging.instance.onTokenRefresh.distinct();

  // 포그라운드 상태에서 메시지 수신 시
  void _onForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      _localNotificationsService?.showNotification(
          notificationData.title, notificationData.body, message.data.toString());
    }
  }

  // 백그라운드 or 종료 상태에서 알림 클릭으로 앱이 열렸을 떄
  void _onMessageOpenedApp(RemoteMessage message) {
    // TODO: 메시지 데이터 기반 라우팅
  }
}

// 백그라운드 상태에서 메시지를 수신했을 때 실행되는 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data.toString()}');
}
