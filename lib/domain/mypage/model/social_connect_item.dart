import 'package:dongsoop/domain/auth/enum/login_platform.dart';

class SocialConnectItem {
  final LoginPlatform platform;
  final bool isConnected;
  final String? connectedDate;

  SocialConnectItem({
    required this.platform,
    required this.isConnected,
    this.connectedDate,
  });

  SocialConnectItem copyWith({
    LoginPlatform? platform,
    bool? isConnected,
    String? connectedDate,
  }) {
    return SocialConnectItem(
      platform: platform ?? this.platform,
      isConnected: isConnected ?? this.isConnected,
      connectedDate: connectedDate,
    );
  }
}