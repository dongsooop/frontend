import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/routing/router.dart';

class PushRouter {
  static Future<void> routeFromTypeValue({
    required String type,
    required String value,
  }) async {
    final t = type.toUpperCase();

    switch (t) {
      case 'CHAT':
        await router.push(RoutePaths.chatDetail, extra: value);
        return;

      case 'NOTICE':
        final uri = router.namedLocation(
          'noticeWebView',
          queryParameters: {'path': value},
        );
        await router.push(uri);
        return;

      default:
      // 알 수 없는 타입이면 알림 리스트로 이동
        print('[PushRouter] unknown type=$type value=$value');
        await router.push(RoutePaths.notificationList);
    }
  }
}
