import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

String deviceType() {
  if (kIsWeb) {
    return 'WEB';
  } else if (Platform.isIOS) {
    return 'IOS';
  } else if (Platform.isAndroid) {
    return 'ANDROID';
  }
  return 'UNKNOWN';
}
