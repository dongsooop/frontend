import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show MissingPluginException;

import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OsNotificationDataSource {
  Future<bool> isAllowed() async {
    if (kIsWeb) return false;
    if (Platform.isIOS) {
      final s = await FirebaseMessaging.instance.getNotificationSettings();
      return s.authorizationStatus == AuthorizationStatus.authorized ||
          s.authorizationStatus == AuthorizationStatus.provisional;
    } else {
      return (await Permission.notification.status).isGranted;
    }
  }

  // 권한 요청 (스위치 ON)
  Future<bool> request() async {
    if (kIsWeb) return false;
    if (Platform.isIOS) {
      final s = await FirebaseMessaging.instance.requestPermission();
      return s.authorizationStatus == AuthorizationStatus.authorized ||
          s.authorizationStatus == AuthorizationStatus.provisional;
    } else {
      return (await Permission.notification.request()).isGranted;
    }
  }

  // OS 설정 화면으로 이동 (스위치 OFF 또는 iOS 거부 시)
  Future<void> openSettings() async {
    if (kIsWeb) return;
    try {
      if (Platform.isIOS) {
        await AppSettings.openAppSettings(type: AppSettingsType.settings);
      } else if (Platform.isAndroid) {
        await AppSettings.openAppSettings(type: AppSettingsType.notification);
      }
    } on MissingPluginException {
      await openAppSettings(); // permission_handler fallback
    }
  }
}
