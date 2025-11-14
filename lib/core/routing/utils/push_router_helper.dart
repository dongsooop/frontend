import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/routing/push_router.dart';

class PushRouterHelper {
  static void goNextOrHome(BuildContext context) {
    final pending = PushRouter.takeNextRoute();

    if (pending == null) {
      context.go(RoutePaths.home);
      return;
    }

    // 채팅: chat → chatDetail
    if (pending.path == RoutePaths.chat && pending.extra is String) {
      final roomId = pending.extra as String;

      context.go(RoutePaths.chat);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.push(RoutePaths.chatDetail, extra: roomId);
      });

      return;
    }

    // 공지: home → noticeWebView
    if (pending.name == 'noticeWebView') {
      final raw = pending.queryParameters;
      final Map<String, dynamic> qp = {};
      if (raw != null) qp.addAll(raw);

      context.go(RoutePaths.home);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.pushNamed(
          'noticeWebView',
          queryParameters: qp,
          extra: pending.extra,
        );
      });

      return;
    }

    // 모집: board → recruitDetail → recruitApplicantList / recruitApplicantDetail
    if (pending.path == RoutePaths.recruitDetail && pending.extra is Map) {
      final extra = pending.extra as Map;
      final first = extra['first'];
      final firstPath = first is Map ? first['path'] : null;
      final firstExtra = first is Map ? first['extra'] : null;

      context.go(RoutePaths.board);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        context.push(
          RoutePaths.recruitDetail,
          extra: {
            'id': extra['id'],
            'type': extra['type'],
          },
        );

        if (firstPath is String) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            context.push(firstPath, extra: firstExtra);
          });
        }
      });

      return;
    }

    // 일정, 시간표: home → schedule / timetable
    if (pending.path == RoutePaths.schedule ||
        pending.path == RoutePaths.timetable) {
      final path = pending.path!;
      final extra = pending.extra;

      context.go(RoutePaths.home);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.push(path, extra: extra);
      });

      return;
    }

    // 그 외
    if (pending.path != null) {
      final path = pending.path!;
      final extra = pending.extra;

      context.go(RoutePaths.home);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.push(path, extra: extra);
      });

      return;
    }

    context.go(RoutePaths.home);
  }
}
