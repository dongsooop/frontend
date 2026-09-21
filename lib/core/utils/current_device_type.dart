import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

String currentDeviceType() {
  if (kIsWeb) return 'WEB';
  if (Platform.isIOS) return 'IOS';
  if (Platform.isAndroid) return 'ANDROID';
  return 'UNKNOWN';
}
