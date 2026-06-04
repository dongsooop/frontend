import 'dart:io';

String getUserAgent() {
  if (Platform.isAndroid) {
    return 'Android';
  } else if (Platform.isIOS) {
    return 'iOS';
  }
  return 'Dongsoop';
}