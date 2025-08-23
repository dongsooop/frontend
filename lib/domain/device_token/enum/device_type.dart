enum DeviceType { ANDROID, IOS, WEB, UNKNOWN }

extension DeviceTypeX on DeviceType {
  String get name {
    switch (this) {
      case DeviceType.ANDROID:
        return 'ANDROID';
      case DeviceType.IOS:
        return 'IOS';
      case DeviceType.WEB:
        return 'WEB';
      case DeviceType.UNKNOWN:
        return 'UNKNOWN';
    }
  }
}
