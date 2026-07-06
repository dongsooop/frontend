import 'dart:io';

import 'package:flutter/services.dart';

class AppDistribution {
  static const MethodChannel _channel = MethodChannel('dongsoop/app_distribution');

  static Future<bool> isTestFlight() async {
    if (!Platform.isIOS) return false;

    try {
      final result = await _channel.invokeMethod<bool>('isTestFlight');
      return result ?? false;
    } catch (e) {
      print('[isTestFlight Error] Failed to detect TestFlight: $e');
      return false;
    }
  }
}